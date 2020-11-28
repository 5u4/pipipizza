package modules;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxMath;

class PlatformerController extends Component
{
	public var grav = 800.0;
	public var maxGrav = 1500.0;
	public var hspeed = 150.0;
	public var jumpSpeed = 200.0;
	public var jumpEnergy = 0.2;
	public var _jumpEnergy = 0.2;
	public var coyote = 0.1;
	public var _coyote = 0.1;
	public var jumpBuffer = 0.1;
	public var _jumpBuffer = 0.1;
	public var xweight = 0.2;

	override function update(elapsed:Float)
	{
		handleGravity(elapsed);
		handleHMovement(elapsed);
		handleVMovement(elapsed);

		super.update(elapsed);
	}

	function handleGravity(elapsed:Float)
	{
		entity.velocity.y = Math.min(entity.velocity.y + grav * elapsed, maxGrav);
	}

	function handleHMovement(elapsed:Float)
	{
		var xmove = 0;

		if (FlxG.keys.anyPressed([A, LEFT]))
			xmove -= 1;
		if (FlxG.keys.anyPressed([D, RIGHT]))
			xmove += 1;

		if (xmove > 0)
			entity.facing = FlxObject.RIGHT;
		else if (xmove < 0)
			entity.facing = FlxObject.LEFT;

		entity.velocity.x = FlxMath.lerp(entity.velocity.x, hspeed * xmove, xweight);
	}

	function handleVMovement(elapsed:Float)
	{
		var onFloor = entity.isTouching(FlxObject.FLOOR);
		var jump = false;
		var intentJumpHigher = FlxG.keys.anyPressed([SPACE, W, UP, J, Z]);
		var intentJump = FlxG.keys.anyJustPressed([SPACE, W, UP, J, Z]);

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
			entity.velocity.y = -jumpSpeed;
	}
}
