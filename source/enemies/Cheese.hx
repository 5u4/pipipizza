package enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import modules.Entity;
import modules.brains.statemachine.State;
import modules.brains.statemachine.StateMachine;

class Cheese extends Enemy
{
	var target:Entity;
	var brain = new StateMachine();
	var margin = 240.0;
	var flyTo:FlxPoint = new FlxPoint();
	var getBullet:() -> FlxSprite;
	var attackPattern = Math.random();
	var aimCooldown = 0.3;
	var _aimCooldown = 0.0;
	var fireCooldown = 0.8;
	var _fireCooldown = 0.0;
	var charged = false;
	var shootSound:FlxSound;

	public function new(target:Entity, getBullet:() -> FlxSprite)
	{
		super();
		hp = 200;
		this.target = target;
		this.getBullet = getBullet;
		grav.grav = 0.0;

		brain.states.push(MakeChangeLocationState());
		brain.states.push(MakeChargeState());
		brain.states.push(MakeFireState());
		brain.states.push(MakeAimState());

		shootSound = FlxG.sound.load(AssetPaths.cheese_shoot__mp3);
	}

	override function render()
	{
		loadGraphic(AssetPaths.cheese__png, true, 192, 192);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("idle", [0, 1, 2], 6, true);
		animation.add("charge", [3, 4, 5], 3, false);
		animation.add("attack", [6, 7], 6, true);
		animation.finishCallback = (name:String) ->
		{
			if (name == "charge")
				charged = true;
		}
	}

	override function update(elapsed:Float)
	{
		brain.update(elapsed);
		super.update(elapsed);
	}

	function fireCircular(amount:Int)
	{
		var center = getMidpoint();
		var targetCenter = target.getMidpoint();
		var v = new FlxVector(targetCenter.x - center.x, targetCenter.y - center.y).normalize();
		var speed = 100.0;
		var deg = 360.0 / amount;
		for (_ in 0...amount)
		{
			var bullet = getBullet();
			if (bullet == null)
				return;
			bullet.reset(center.x - bullet.width / 2, center.y - bullet.height / 2);
			bullet.velocity.x = speed * v.x;
			bullet.velocity.y = speed * v.y;
			bullet.animation.play("fire", true);
			bullet.angle = v.angleBetween(new FlxVector()) + 90;
			v.rotateByDegrees(deg);
		}
		shootSound.play(true);
	}

	function fireDirectly()
	{
		var bullet = getBullet();
		if (bullet == null)
			return;

		var center = getMidpoint();
		var targetCenter = target.getMidpoint();
		var v = new FlxVector(targetCenter.x - center.x, targetCenter.y + 75 - center.y).normalize();
		var speed = 400.0;

		bullet.reset(center.x - bullet.width / 2, center.y - bullet.height / 2);
		bullet.velocity.x = speed * v.x;
		bullet.velocity.y = speed * v.y;
		bullet.animation.play("fire", true);
		bullet.angle = v.angleBetween(new FlxVector()) + 90;
		shootSound.play(true);
	}

	function MakeChangeLocationState()
	{
		var state = new State();
		var timer = new FlxTimer();
		timer.start(3.0);
		state.shouldEnable = () -> timer.finished;
		state.enable = () ->
		{
			animation.play("idle");
			flyTo.x = x > FlxG.width / 2 ? margin : FlxG.width - margin - width;
			flyTo.y = Math.random() * 480.0 + 64.0;
		};
		state.handle = elapsed ->
		{
			x = FlxMath.lerp(x, flyTo.x, elapsed * 0.7);
			y = FlxMath.lerp(y, flyTo.y, elapsed * 0.7);
			facing = x < FlxG.width / 2 ? FlxObject.RIGHT : FlxObject.LEFT;
		};
		state.shouldDisable = () -> new FlxVector(x, y).distanceTo(flyTo) < 30;
		state.disable = () ->
		{
			attackPattern = Math.random();
			timer.start(3.0);
		}
		return state;
	}

	function MakeChargeState()
	{
		var state = new State();
		var timer = new FlxTimer();
		timer.start(0);
		state.shouldEnable = () -> timer.finished && !charged;
		state.enable = () ->
		{
			animation.play("charge");
			timer.start(1);
		}
		return state;
	}

	function MakeFireState()
	{
		var state = new State();
		var timer = new FlxTimer();
		timer.start(0);
		state.shouldEnable = () -> charged && attackPattern >= 0.5;
		state.enable = () ->
		{
			animation.play("attack");
			timer.start(3);
		}
		state.handle = elapsed ->
		{
			_fireCooldown -= elapsed;
			if (_fireCooldown > 0)
				return;
			fireCircular(10);
			_fireCooldown = fireCooldown;
		}
		state.shouldDisable = () -> timer.finished;
		state.disable = () -> charged = false;

		return state;
	}

	function MakeAimState()
	{
		var state = new State();
		var timer = new FlxTimer();
		timer.start(0);
		state.shouldEnable = () -> charged && attackPattern < 0.5;
		state.enable = () ->
		{
			animation.play("attack");
			timer.start(3);
		}
		state.handle = elapsed ->
		{
			_aimCooldown -= elapsed;
			if (_aimCooldown > 0)
				return;
			fireDirectly();
			_aimCooldown = aimCooldown;
		}
		state.shouldDisable = () -> timer.finished;
		state.disable = () -> charged = false;

		return state;
	}
}
