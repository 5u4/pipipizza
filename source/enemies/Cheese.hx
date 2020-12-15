package enemies;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import modules.Entity;
import modules.brains.statemachine.State;
import modules.brains.statemachine.StateMachine;

class Cheese extends Enemy
{
	var target:Entity;
	var brain = new StateMachine();
	var margin = 60.0;
	var flyTo:FlxPoint = new FlxPoint();
	var getBullet:() -> FlxSprite;

	public function new(target:Entity, getBullet:() -> FlxSprite)
	{
		super();
		hp = 100;
		this.target = target;
		this.getBullet = getBullet;
		grav.grav = 0.0;

		brain.states.push(MakeChangeLocationState());
		brain.states.push(MakeFireState());
		brain.states.push(MakeIdleState());
	}

	override function render()
	{
		makeGraphic(64, 64, FlxColor.RED);
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
		var speed = 50.0;
		var deg = 360.0 / amount;
		for (_ in 0...amount)
		{
			var bullet = getBullet();
			if (bullet == null)
				return;
			bullet.reset(center.x - bullet.width / 2, center.y - bullet.height / 2);
			bullet.velocity.x = speed * v.x;
			bullet.velocity.y = speed * v.y;
			v.rotateByDegrees(deg);
		}
	}

	function MakeChangeLocationState()
	{
		var state = new State();
		var timer = new FlxTimer();
		timer.start(3.0);
		state.shouldEnable = () -> timer.finished;
		state.enable = () ->
		{
			flyTo.x = x > FlxG.width / 2 ? margin : FlxG.width - margin - width;
			flyTo.y = Math.random() * 240.0 + 64.0;
		};
		state.handle = elapsed ->
		{
			x = FlxMath.lerp(x, flyTo.x, elapsed * 0.7);
			y = FlxMath.lerp(y, flyTo.y, elapsed * 0.7);
		};
		state.shouldDisable = () -> new FlxVector(x, y).distanceTo(flyTo) < 10;
		state.disable = () -> timer.start(3.0);
		return state;
	}

	function MakeFireState()
	{
		var state = new State();
		var timer = new FlxTimer();
		timer.start(0);
		state.shouldEnable = () -> timer.finished;
		state.enable = () ->
		{
			fireCircular(10);
			timer.start(0.1);
		};

		return state;
	}

	function MakeIdleState()
	{
		var state = new State();
		var timer = new FlxTimer();
		state.shouldEnable = () -> true;
		state.enable = () -> timer.start();
		state.shouldDisable = () -> timer.finished;
		return state;
	}
}
