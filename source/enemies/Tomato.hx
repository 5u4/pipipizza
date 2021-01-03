package enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import modules.Entity;
import modules.brains.statemachine.State;
import modules.brains.statemachine.StateMachine;

class Tomato extends Enemy
{
	var target:Entity;
	var brain = new StateMachine();
	var lastXVelocity = 0.0;
	var jumpForce = 900.0;
	var jumpSound:FlxSound;

	public function new(target:Entity)
	{
		super();
		this.target = target;
		hp = 50;

		brain.states.push(MakeJumpAttackState());
		brain.states.push(MakeIdleState());

		jumpSound = FlxG.sound.load(#if html5 AssetPaths.tomato_jump__mp3 #else AssetPaths.tomato_jump__wav #end);
		jumpSound.volume = Reg.sfxVolume;
	}

	override function render()
	{
		loadGraphic(AssetPaths.tomato__png, true, 88, 88);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("idle", [0, 1], 6, true);
		animation.add("jump", [2, 3, 4, 5], 6, false);
		animation.add("fall", [6, 7], 6, false);
	}

	override function update(elapsed:Float)
	{
		brain.update(elapsed);
		super.update(elapsed);
	}

	override function onHitWall(wall:FlxSprite)
	{
		super.onHitWall(wall);

		var hit = isTouching(FlxObject.WALL);

		if (hit)
		{
			velocity.x = -lastXVelocity * 0.7;
			facing = facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
		}
	}

	function MakeJumpAttackState()
	{
		var state = new State();
		var timer = new FlxTimer();
		timer.start(Math.random() * 2);
		state.shouldEnable = () -> timer.finished && isTouching(FlxObject.FLOOR);
		state.enable = () ->
		{
			var pos = getMidpoint();
			var tarPos = target.getMidpoint();
			var norm = new FlxVector(tarPos.x - pos.x, tarPos.y - pos.y).normalize();
			var force = jumpForce + 100.0 * Math.random();
			norm.x *= Math.random() > 0.2 ? 1.0 : -0.7;
			velocity.x = norm.x * force;
			velocity.y = norm.y * force - 1200.0;
			lastXVelocity = velocity.x;
			if (norm.x < 0)
				facing = FlxObject.LEFT;
			else if (norm.x > 0)
				facing = FlxObject.RIGHT;
			jumpSound.play(true);
		};
		state.handle = _ -> animation.play(velocity.y < 0 ? "jump" : "fall");
		state.shouldDisable = () -> isTouching(FlxObject.FLOOR);
		state.disable = () ->
		{
			timer.start(Math.random() * 0.5 + 0.5);
			velocity.x = 0;
			velocity.y = 0;
		};
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
			timer.start(Math.random());
		}
		state.shouldDisable = () -> timer.finished;
		return state;
	}
}
