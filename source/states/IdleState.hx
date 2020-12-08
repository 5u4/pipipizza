package states;

import flixel.util.FlxTimer;
import modules.brains.statemachine.State;

class IdleState implements State
{
	var timer = new FlxTimer();

	public function new() {}

	public function shouldEnable()
	{
		return true;
	}

	public function enable()
	{
		timer.start();
	}

	public function shouldDisable()
	{
		return timer.finished;
	}

	public function disable() {}

	public function update(elapsed:Float) {}
}
