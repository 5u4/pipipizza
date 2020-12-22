package modules.platformer;

import flixel.FlxObject;
import flixel.math.FlxMath;

// TODO: Integrate impulse
class PlatformerMovement extends Component
{
	public var speedScale = 1.0;
	public var hspeed = 350.0;
	public var xweight = 0.2;
	public var moveIntention = () -> 0;

	var _speedScale = 1.0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var e = entity();

		if (e.isTouching(FlxObject.FLOOR))
			_speedScale = speedScale;

		var moveIntent = moveIntention();
		var move:Float = if (moveIntent > 0) 1 else if (moveIntent < 0) -1 else 0;

		if (move > 0)
			e.facing = FlxObject.RIGHT;
		else if (move < 0)
			e.facing = FlxObject.LEFT;

		e.velocity.x = FlxMath.lerp(e.velocity.x, hspeed * move * _speedScale, xweight);
		var p = cast(e, Player);
		if (e.isTouching(FlxObject.FLOOR) && p.charge <= 0 && p.attackFrames <= 0)
			e.animation.play(Math.abs(move) > 0 ? "run" : "idle");
	}
}
