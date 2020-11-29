package modules.platformer;

import flixel.FlxObject;

class PlatformerJump extends Component
{
	public var jumpScale = 1.0;
	public var jumpSpeed = 200.0;
	public var jumpEnergy = 0.2;
	public var _jumpEnergy = 0.2;
	public var coyote = 0.1;
	public var _coyote = 0.1;
	public var jumpBuffer = 0.1;
	public var _jumpBuffer = 0.1;
	public var jumpIntention = () -> false;
	public var jumpHoldIntention = () -> false;
	public var isJumping = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var onFloor = entity().isTouching(FlxObject.FLOOR);
		isJumping = false;
		var intentJump = jumpIntention();
		var intentJumpHigher = jumpHoldIntention();

		if (!onFloor)
		{
			if (intentJump)
			{
				if (_coyote > 0)
					initiateJump();
				_jumpBuffer = jumpBuffer;
			}
			else if (!intentJumpHigher)
				_jumpEnergy = 0.0;
			else if (_jumpEnergy > 0.0)
				isJumping = true;
			_jumpEnergy -= elapsed;
			_coyote -= elapsed;
		}
		else
		{
			_coyote = coyote;
			_jumpEnergy = 0.0;
			if (intentJump || _jumpBuffer > 0)
				initiateJump();
		}

		_jumpBuffer -= elapsed;

		if (isJumping)
			entity().velocity.y = -jumpSpeed * jumpScale;
	}

	function initiateJump()
	{
		_coyote = 0.0;
		_jumpEnergy = jumpEnergy * jumpScale;
		isJumping = true;
	}
}
