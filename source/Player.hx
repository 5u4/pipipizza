package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import modules.Entity;

class Player extends Entity
{
	var bullets:FlxTypedGroup<Bullet>;
	var hspeed = 75;
	var jumpSpeed = 200;

	public function new(bullets:FlxTypedGroup<Bullet>)
	{
		super();
		this.bullets = bullets;
		makeGraphic(32, 32, FlxColor.BLUE);
	}

	override function update(elapsed:Float)
	{
		handleHMovement();
		handleVMovement();
		handleShoot();

		super.update(elapsed);
	}

	function handleHMovement()
	{
		var x = 0;

		if (FlxG.keys.anyPressed([A, LEFT]))
		{
			x -= 1;
			facing = FlxObject.LEFT;
		}
		if (FlxG.keys.anyPressed([D, RIGHT]))
		{
			x += 1;
			facing = FlxObject.RIGHT;
		}

		velocity.x = hspeed * x;
	}

	function handleVMovement()
	{
		if (!FlxG.keys.anyPressed([SPACE, W, UP, J, Z]) || !isTouching(FlxObject.FLOOR))
			return;

		velocity.y -= jumpSpeed;
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
