package enemies;

import flixel.FlxObject;
import flixel.math.FlxVector;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
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

	public function new(target:Entity)
	{
		super();
		this.target = target;
		hp = 45;

		brain.states.push(MakeJumpAttackState());
		brain.states.push(MakeIdleState());
	}

	override function render()
	{
		makeGraphic(88, 88, FlxColor.RED);
	}

	override function update(elapsed:Float)
	{
		brain.update(elapsed);
		super.update(elapsed);
	}

	override function onHitWall(wall:FlxTilemap)
	{
		super.onHitWall(wall);

		var front = getMidpoint();
		front.x += (width / 2.0 + 16.0) * (facing == FlxObject.LEFT ? -1.0 : 1.0);

		var hit = !wall.ray(getMidpoint(), front);

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
			norm.x *= Math.random() > 0.3 ? 1.0 : -0.7;
			velocity.x = norm.x * force;
			velocity.y = norm.y * force - 1200.0;
			lastXVelocity = velocity.x;
			if (norm.x < 0)
				facing = FlxObject.LEFT;
			else if (norm.x > 0)
				facing = FlxObject.RIGHT;
		};
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
		state.enable = () -> timer.start(Math.random());
		state.shouldDisable = () -> timer.finished;
		return state;
	}
}
