package modules.platformer;

import flixel.FlxObject;

class PlatformerJump extends Component
{
	public var jumpSpeed = 200.0;
	public var jumpEnergy = 0.2;
	public var _jumpEnergy = 0.2;
	public var coyote = 0.1;
	public var _coyote = 0.1;
	public var jumpBuffer = 0.1;
	public var _jumpBuffer = 0.1;
	public var jumpIntention = () -> false;
	public var jumpHoldIntention = () -> false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var onFloor = entity().isTouching(FlxObject.FLOOR);
		var jump = false;
		var intentJump = jumpIntention();
		var intentJumpHigher = jumpHoldIntention();

		if (!onFloor)
		{
			if (intentJump)
			{
				if (_coyote > 0)
				{
					_coyote = 0.0;
					_jumpEnergy = jumpEnergy;
					jump = true;
				}
				_jumpBuffer = jumpBuffer;
			}
			else if (!intentJumpHigher)
				_jumpEnergy = 0.0;
			else if (_jumpEnergy > 0.0)
				jump = true;
			_jumpEnergy -= elapsed;
			_coyote -= elapsed;
		}
		else
		{
			_coyote = coyote;
			_jumpEnergy = 0.0;
			if (intentJump || _jumpBuffer > 0)
			{
				_coyote = 0.0;
				_jumpEnergy = jumpEnergy;
				jump = true;
			}
		}

		_jumpBuffer -= elapsed;

		if (jump)
			entity().velocity.y = -jumpSpeed;
	}
}
