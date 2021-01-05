package enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxSound;
import modules.Entity;

class Cheese extends Enemy
{
	public var tick = 0.5;
	public var target:Entity;
	public var getBullet:() -> FlxSprite;
	public var flyTo:FlxPoint = new FlxPoint();
	public var shootSound:FlxSound;
	public var attackPattern = Math.random();

	var fsm:FlxFSM<Cheese>;

	public function new(target:Entity, getBullet:() -> FlxSprite)
	{
		super();
		hp = 200;
		this.target = target;
		this.getBullet = getBullet;
		grav.grav = 0.0;

		shootSound = FlxG.sound.load(#if html5 AssetPaths.cheese_shoot__mp3 #else AssetPaths.cheese_shoot__wav #end);
		shootSound.volume = Reg.sfxVolume;

		fsm = new FlxFSM<Cheese>(this);
		fsm.transitions.add(Idle, Charge, c -> c.tick <= 0)
			.add(Charge, FireAround, c -> c.tick <= 0 && attackPattern > 0.5)
			.add(Charge, FireAim, c -> c.tick <= 0 && attackPattern <= 0.5)
			.add(FireAround, ChangeLocation, c -> c.tick <= 0)
			.add(FireAim, ChangeLocation, c -> c.tick <= 0)
			.add(ChangeLocation, Idle, c -> new FlxVector(c.x, c.y).distanceTo(c.flyTo) < 30)
			.start(Idle);
	}

	override function render()
	{
		loadGraphic(AssetPaths.cheese__png, true, 192, 192);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("idle", [0, 1, 2], 6, true);
		animation.add("charge", [3, 4, 5], 3, false);
		animation.add("attack", [6, 7], 6, true);
	}

	override function update(elapsed:Float)
	{
		tick -= elapsed;
		fsm.update(elapsed);
		super.update(elapsed);
	}

	override function destroy()
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
}

class Idle extends FlxFSMState<Cheese>
{
	override function enter(owner:Cheese, fsm:FlxFSM<Cheese>)
	{
		owner.tick = 0.5;
		owner.animation.play("idle");
	}
}

class Charge extends FlxFSMState<Cheese>
{
	override function enter(owner:Cheese, fsm:FlxFSM<Cheese>)
	{
		owner.tick = 0.5;
		owner.attackPattern = Math.random();
		owner.animation.play("charge");
	}
}

class FireAround extends FlxFSMState<Cheese>
{
	var cd = 0.8;
	var _cd = 0.0;

	override function enter(owner:Cheese, fsm:FlxFSM<Cheese>)
	{
		owner.tick = 3;
		owner.animation.play("attack");
	}

	override function update(elapsed:Float, owner:Cheese, fsm:FlxFSM<Cheese>)
	{
		_cd -= elapsed;
		if (_cd > 0)
			return;
		fire(owner, 10);
		_cd = cd;
	}

	function fire(owner:Cheese, amount:Int)
	{
		var center = owner.getMidpoint();
		var targetCenter = owner.target.getMidpoint();
		var v = new FlxVector(targetCenter.x - center.x, targetCenter.y - center.y).normalize();
		var speed = 100.0;
		var deg = 360.0 / amount;
		for (_ in 0...amount)
		{
			var bullet = owner.getBullet();
			if (bullet == null)
				return;
			bullet.reset(center.x - bullet.width / 2, center.y - bullet.height / 2);
			bullet.velocity.x = speed * v.x;
			bullet.velocity.y = speed * v.y;
			bullet.animation.play("fire", true);
			bullet.angle = v.angleBetween(new FlxVector()) + 90;
			v.rotateByDegrees(deg);
		}
		owner.shootSound.play(true);
	}
}

class FireAim extends FlxFSMState<Cheese>
{
	var cd = 0.3;
	var _cd = 0.0;

	override function enter(owner:Cheese, fsm:FlxFSM<Cheese>)
	{
		owner.tick = 3;
		owner.animation.play("attack");
	}

	override function update(elapsed:Float, owner:Cheese, fsm:FlxFSM<Cheese>)
	{
		_cd -= elapsed;
		if (_cd > 0)
			return;
		fire(owner);
		_cd = cd;
	}

	function fire(owner:Cheese)
	{
		var bullet = owner.getBullet();
		if (bullet == null)
			return;
		var center = owner.getMidpoint();
		var targetCenter = owner.target.getMidpoint();
		var v = new FlxVector(targetCenter.x - center.x, targetCenter.y + 75 - center.y).normalize();
		var speed = 400.0;
		bullet.reset(center.x - bullet.width / 2, center.y - bullet.height / 2);
		bullet.velocity.x = speed * v.x;
		bullet.velocity.y = speed * v.y;
		bullet.animation.play("fire", true);
		bullet.angle = v.angleBetween(new FlxVector()) + 90;
		owner.shootSound.play(true);
	}
}

class ChangeLocation extends FlxFSMState<Cheese>
{
	var margin = 240.0;

	override function enter(owner:Cheese, fsm:FlxFSM<Cheese>)
	{
		owner.animation.play("idle");
		owner.flyTo.x = owner.x > FlxG.width / 2 ? margin : FlxG.width - margin - owner.width;
		owner.flyTo.y = Math.random() * 480.0 + 64.0;
	}

	override function update(elapsed:Float, owner:Cheese, fsm:FlxFSM<Cheese>)
	{
		owner.x = FlxMath.lerp(owner.x, owner.flyTo.x, elapsed * 0.7);
		owner.y = FlxMath.lerp(owner.y, owner.flyTo.y, elapsed * 0.7);
		owner.facing = owner.x < FlxG.width / 2 ? FlxObject.RIGHT : FlxObject.LEFT;
	}
}
