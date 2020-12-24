package modules.platformer;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxSound;

// TODO: Integrate impulse
class PlatformerJump extends Component
{
	var sound:FlxSound;

	public var jumpScale = 1.0;
	public var jumpSpeed = 940.0;
	public var jumpEnergy = 0.2;
	public var _jumpEnergy = 0.2;
	public var coyote = 0.1;
	public var _coyote = 0.1;
	public var jumpBuffer = 0.1;
	public var _jumpBuffer = 0.1;
	public var jumpIntention = () -> false;
	public var jumpHoldIntention = () -> false;
	public var isJumping = false;

	public function new()
	{
		super();
		sound = FlxG.sound.load(AssetPaths.jump__mp3);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var e = entity();
		var onFloor = e.isTouching(FlxObject.FLOOR);
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
			var p = cast(e, Player);
			if (p.charge <= 0 && p.attackFrames <= 0)
				e.animation.play("jump");
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
			e.velocity.y = -jumpSpeed * jumpScale;
	}

	function initiateJump()
	{
		_coyote = 0.0;
		_jumpEnergy = jumpEnergy * jumpScale;
		isJumping = true;
		sound.play(true);
	}
}
