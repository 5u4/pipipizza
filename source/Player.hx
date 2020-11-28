package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import modules.Entity;

class Player extends Entity
{
	var bullets:FlxTypedGroup<Bullet>;
	var grav = 800.0;
	var maxGrav = 1500.0;
	var hspeed = 150.0;
	var jumpSpeed = 200.0;
	var jumpEnergy = 0.2;
	var _jumpEnergy = 0.2;
	var coyote = 0.1;
	var _coyote = 0.1;
	var jumpBuffer = 0.1;
	var _jumpBuffer = 0.1;
	var xweight = 0.2;
	var invincible = 1.0;
	var _invincible = 0.0;
	var impulse = new FlxVector(1200.0, 400.0);

	public function new(bullets:FlxTypedGroup<Bullet>)
	{
		super();
		this.bullets = bullets;
		makeGraphic(32, 32, FlxColor.BLUE);
	}

	override function update(elapsed:Float)
	{
		_invincible -= elapsed;
		handleGravity(elapsed);
		handleHMovement(elapsed);
		handleVMovement(elapsed);
		handleShoot();

		super.update(elapsed);
	}

	public function onHitEnemy(enemy:Enemy)
	{
		if (_invincible > 0)
			return;
		_invincible = invincible;
		FlxG.state.camera.shake(0.005, 0.1);
		var norm = new FlxVector(x - enemy.x, y - enemy.y).normalize();
		velocity.x = norm.x * impulse.x;
		velocity.y = norm.y * impulse.y;
	}

	function handleGravity(elapsed:Float)
	{
		velocity.y = Math.min(velocity.y + grav * elapsed, maxGrav);
	}

	function handleHMovement(elapsed:Float)
	{
		var xmove = 0;

		if (FlxG.keys.anyPressed([A, LEFT]))
			xmove -= 1;
		if (FlxG.keys.anyPressed([D, RIGHT]))
			xmove += 1;

		if (xmove > 0)
			facing = FlxObject.RIGHT;
		else if (xmove < 0)
			facing = FlxObject.LEFT;

		velocity.x = FlxMath.lerp(velocity.x, hspeed * xmove, xweight);
	}

	function handleVMovement(elapsed:Float)
	{
		var onFloor = isTouching(FlxObject.FLOOR);
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
			velocity.y = -jumpSpeed;
	}

	function handleShoot()
	{
		if (!FlxG.keys.anyJustReleased([X, K]))
			return;

		var bullet = bullets.getFirstAvailable();
		if (bullet == null)
			return;

		bullet.fire(x + width / 2, y + height / 2, if (facing == FlxObject.LEFT) -1 else 1);
	}
}
