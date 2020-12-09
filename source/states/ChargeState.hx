package states;

import enemies.Hog;
import flixel.FlxObject;
import modules.brains.statemachine.State;

class ChargeState implements State
{
	public var enemy:Hog;
	public var accel:Float;

	public function new() {}

	public function shouldEnable()
	{
		return enemy.canCharge();
	}

	public function enable()
	{
		var xface = if (enemy.facing == FlxObject.LEFT) -1.0 else 1.0;
		enemy.acceleration.x = xface * accel;
	}

	public function shouldDisable()
	{
		return !enemy.canCharge();
	}

	public function disable()
	{
		enemy.acceleration.x = 0;
	}

	public function update(elapsed:Float) {}
}
