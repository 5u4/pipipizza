package states;

import flixel.FlxObject;
import modules.brains.statemachine.State;

class ChargeState implements State
{
	public var enemy:Enemy;
	public var accel:Float;

	public function new() {}

	public function shouldEnable()
	{
		return true;
	}

	public function enable()
	{
		var xface = if (enemy.facing == FlxObject.LEFT) -1.0 else 1.0;
		enemy.acceleration.x = xface * accel;
	}

	public function shouldDisable()
	{
		return false;
	}

	public function disable()
	{
		enemy.acceleration.x = 0;
	}

	public function update(elapsed:Float) {}
}
