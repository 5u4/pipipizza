package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import modules.Entity;

class Player extends Entity
{
	var bullets:FlxTypedGroup<Bullet>;
	var grav = 800.0;
	var maxGrav = 1500.0;
	var hspeed = 100.0;
	var jumpSpeed = 200.0;
	var jumpEnergy = 0.2;
	var _jumpEnergy = 0.2;

	public function new(bullets:FlxTypedGroup<Bullet>)
	{
		super();
		this.bullets = bullets;
		makeGraphic(32, 32, FlxColor.BLUE);
	}

	override function update(elapsed:Float)
	{
		handleGravity(elapsed);
		handleHMovement();
		handleVMovement(elapsed);
		handleShoot();

		super.update(elapsed);
	}

	function handleGravity(elapsed:Float)
	{
		velocity.y = Math.min(velocity.y + grav * elapsed, maxGrav);
	}

	function handleHMovement()
	{
		var x = 0;

		if (FlxG.keys.anyPressed([A, LEFT]))
			x -= 1;
		if (FlxG.keys.anyPressed([D, RIGHT]))
			x += 1;

		if (x > 0)
			facing = FlxObject.RIGHT;
		else if (x < 0)
			facing = FlxObject.LEFT;

		velocity.x = hspeed * x;
	}

	function handleVMovement(elapsed:Float)
	{
		var onFloor = isTouching(FlxObject.FLOOR);
		var jump = false;

		if (!onFloor)
		{
			if (!FlxG.keys.anyPressed([SPACE, W, UP, J, Z]))
				_jumpEnergy = 0.0;
			else if (_jumpEnergy > 0.0)
				jump = true;
			_jumpEnergy -= elapsed;
		}
		else
		{
			_jumpEnergy = 0.0;
			if (FlxG.keys.anyJustPressed([SPACE, W, UP, J, Z]))
			{
				_jumpEnergy = jumpEnergy;
				jump = true;
			}
		}

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
