package modules.platformer;

import flixel.FlxObject;
import flixel.math.FlxMath;

class PlatformerMovement extends Component
{
	public var hspeed = 150.0;
	public var xweight = 0.2;
	public var moveIntention = () -> 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var moveIntent = moveIntention();
		var move = if (moveIntent > 0) 1 else if (moveIntent < 0) -1 else 0;

		if (move > 0)
			entity().facing = FlxObject.RIGHT;
		else if (move < 0)
			entity().facing = FlxObject.LEFT;

		entity().velocity.x = FlxMath.lerp(entity().velocity.x, hspeed * move, xweight);
	}
}
