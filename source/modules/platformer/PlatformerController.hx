package modules.platformer;

import flixel.FlxG;
import modules.platformer.PlatfomerMovement;

class PlatformerController extends ComponentGroup
{
	public var gravity:Gravity;
	public var jump:PlatformerJump;
	public var movement:PlatformerMovement;

	public function new()
	{
		super();

		gravity = new Gravity();

		jump = new PlatformerJump();
		jump.jumpIntention = () -> FlxG.keys.anyJustPressed([SPACE, W, UP, J, Z]);
		jump.jumpHoldIntention = () -> FlxG.keys.anyPressed([SPACE, W, UP, J, Z]);

		movement = new PlatformerMovement();
		movement.moveIntention = () ->
		{
			var move = 0;
			if (FlxG.keys.anyPressed([A, LEFT]))
				move -= 1;
			if (FlxG.keys.anyPressed([D, RIGHT]))
				move += 1;
			return move;
		}

		addComponents([gravity, jump, movement]);
	}
}
