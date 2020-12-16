package enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxVector;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import modules.brains.statemachine.State;
import modules.brains.statemachine.StateMachine;

class Hog extends Enemy
{
	var isCharging = false;
	var chargeCoolDown = 0.3;
	var _chargeCoolDown = 1.0;
	var brain = new StateMachine();
	var impulse = new FlxVector(300.0, 900.0);

	public function new()
	{
		super();

		maxVelocity.x = 6000.0;
		brain.states.push(MakeChargeState());
		brain.states.push(MakeIdleState());
	}

	override function render()
	{
		makeGraphic(176, 176, FlxColor.RED);
	}

	override function update(elapsed:Float)
	{
		if (!isCharging && isTouching(FlxObject.FLOOR))
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
		front.x += (width / 2.0 + 16.0) * if (facing == FlxObject.LEFT) -1.0 else 1.0;

		var hit = !wall.ray(getMidpoint(), front);

		if (hit)
			bounce();
	}

	public function handleChargeCoolDown(elapsed:Float)
	{
		if (!isCharging)
			_chargeCoolDown -= elapsed;
	}

	public function canCharge()
	{
		return _chargeCoolDown <= 0.0;
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

	function MakeChargeState(accel = 2400.0)
	{
		var state = new State();
		state.shouldEnable = () -> canCharge();
		state.enable = () ->
		{
			acceleration.x = accel * (facing == FlxObject.LEFT ? -1.0 : 1.0);
			isCharging = true;
		}
		state.shouldDisable = () -> !canCharge();
		state.disable = () ->
		{
			acceleration.x = 0;
			isCharging = false;
		}
		return state;
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
