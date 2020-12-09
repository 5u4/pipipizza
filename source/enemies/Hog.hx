package enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxVector;
import flixel.tile.FlxTilemap;
import modules.brains.statemachine.StateMachine;
import states.ChargeState;
import states.IdleState;

class Hog extends Enemy
{
	var chargeCoolDown = 0.3;
	var _chargeCoolDown = 1.0;
	var brain = new StateMachine();
	var impulse = new FlxVector(100.0, 300.0);

	public function new()
	{
		super();

		var chargeState = new ChargeState();
		chargeState.enemy = this;
		chargeState.accel = 300.0;
		maxVelocity.x = 1000.0;

		brain.states.push(chargeState);
		brain.states.push(new IdleState());
	}

	override function update(elapsed:Float)
	{
		if (!Std.is(brain.state, ChargeState) && isTouching(FlxObject.FLOOR))
		{
			velocity.x = 0;
			velocity.y = 0;
		}
		super.update(elapsed);
		brain.update(elapsed);
		handleChargeCoolDown(elapsed);
	}

	override function onHitWall(wall:FlxTilemap)
	{
		super.onHitWall(wall);

		var front = getMidpoint();
		front.x += (width + 1.0) * if (facing == FlxObject.LEFT) -1.0 else 1.0;

		var hit = !wall.ray(getMidpoint(), front);

		if (hit)
			bounce();
	}

	public function handleChargeCoolDown(elapsed:Float)
	{
		if (!Std.is(brain.state, ChargeState))
			_chargeCoolDown -= elapsed;
	}

	public function canCharge()
	{
		return _chargeCoolDown <= 0.0;
	}

	function bounce()
	{
		FlxG.state.camera.shake(0.005, 0.1);
		_chargeCoolDown = chargeCoolDown;
		acceleration.x = 0;

		var dir = if (facing == FlxObject.LEFT) -1.0 else 1.0;

		velocity.x = -impulse.x * dir;
		velocity.y = -impulse.y;

		facing = if (facing == FlxObject.LEFT) FlxObject.RIGHT else FlxObject.LEFT;
	}
}
