package enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.system.FlxSound;
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
	var isStun = false;
	var hitWallSound:FlxSound;

	public function new()
	{
		super();

		hp = 100;
		maxVelocity.x = 6000.0;
		brain.states.push(MakeStunState());
		brain.states.push(MakeChargeState());
		brain.states.push(MakeIdleState());

		hitWallSound = FlxG.sound.load(AssetPaths.hog_hit_wall__mp3);
	}

	override function render()
	{
		loadGraphic(AssetPaths.hog__png, true, 176, 176);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("idle", [0, 1], 6, true);
		animation.add("run", [2, 3, 4], 15, true);
		animation.add("hit", [5], 6, false);
		animation.add("pause", [6, 7, 8], 6, true);
	}

	override function update(elapsed:Float)
	{
		if (!isCharging && isTouching(FlxObject.FLOOR))
		{
			velocity.x = 0;
			velocity.y = 0;
		}
		brain.update(elapsed);
		super.update(elapsed);
		handleChargeCoolDown(elapsed);
	}

	override function onHitWall(wall:FlxSprite)
	{
		super.onHitWall(wall);

		var hit = isTouching(FlxObject.WALL);
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

	function MakeStunState()
	{
		var state = new State();
		var timer = new FlxTimer();
		state.shouldEnable = () -> isStun;
		state.enable = () -> timer.start(Math.random() + 1);
		state.handle = _ -> animation.play(isTouching(FlxObject.FLOOR) ? "pause" : "hit");
		state.shouldDisable = () -> timer.finished;
		state.disable = () ->
		{
			facing = if (facing == FlxObject.LEFT) FlxObject.RIGHT else FlxObject.LEFT;
			isStun = false;
		}
		return state;
	}

	function MakeIdleState()
	{
		var state = new State();
		var timer = new FlxTimer();
		state.shouldEnable = () -> true;
		state.enable = () ->
		{
			animation.play("idle");
			timer.start(2);
		};
		state.shouldDisable = () -> timer.finished;
		return state;
	}

	function MakeChargeState(accel = 2400.0)
	{
		var state = new State();
		state.shouldEnable = () -> canCharge();
		state.enable = () ->
		{
			animation.play("run");
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
		isStun = true;
		FlxG.state.camera.shake(0.005, 0.1);
		_chargeCoolDown = chargeCoolDown;
		acceleration.x = 0;

		var dir = if (facing == FlxObject.LEFT) -1.0 else 1.0;

		velocity.x = -impulse.x * dir;
		velocity.y = -impulse.y;
		hitWallSound.play(true);
	}
}
