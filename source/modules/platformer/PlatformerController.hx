package modules.platformer;

import flixel.FlxG;
import flixel.ui.FlxVirtualPad;
import modules.platformer.PlatfomerMovement;

class PlatformerController extends ComponentGroup
{
	public var gravity:Gravity;
	public var jump:PlatformerJump;
	public var movement:PlatformerMovement;

	var dpad:FlxVirtualPad;

	public function new(?dpad:FlxVirtualPad = null)
	{
		super();

		gravity = new Gravity();

		jump = new PlatformerJump();
		jump.jumpIntention = () -> FlxG.keys.anyJustPressed([SPACE, W, UP, J, Z]) || (dpad != null && dpad.buttonB.justPressed);
		jump.jumpHoldIntention = () -> FlxG.keys.anyPressed([SPACE, W, UP, J, Z]) || (dpad != null && dpad.buttonB.pressed);

		movement = new PlatformerMovement();
		movement.moveIntention = () ->
		{
			var move = 0;
			if (FlxG.keys.anyPressed([A, LEFT]) || (dpad != null && dpad.buttonLeft.pressed))
				move -= 1;
			if (FlxG.keys.anyPressed([D, RIGHT]) || (dpad != null && dpad.buttonRight.pressed))
				move += 1;
			return move;
		}

		addComponents([gravity, jump, movement]);
	}
}
