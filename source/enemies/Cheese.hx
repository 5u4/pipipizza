package enemies;

import flixel.FlxG;
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

	public function new(target:Entity)
	{
		super();
		hp = 100;
		this.target = target;
		grav.grav = 0.0;

		brain.states.push(MakeChangeLocationState());
		brain.states.push(MakeIdleState());
	}

	override function render()
	{
		makeGraphic(48, 48, FlxColor.RED);
	}

	override function update(elapsed:Float)
	{
		brain.update(elapsed);
		super.update(elapsed);
	}

	function MakeChangeLocationState()
	{
		var state = new State();
		var timer = new FlxTimer();
		timer.start();
		state.shouldEnable = () -> timer.finished;
		state.enable = () ->
		{
			flyTo.x = x > FlxG.width / 2 ? margin : FlxG.width - margin - width;
			flyTo.y = Math.random() * 240.0 + 64.0;
		};
		state.handle = elapsed ->
		{
			x = FlxMath.lerp(x, flyTo.x, elapsed);
			y = FlxMath.lerp(y, flyTo.y, elapsed);
		};
		state.shouldDisable = () -> new FlxVector(x, y).distanceTo(flyTo) < 1;
		state.disable = () -> timer.start(1.0);
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
