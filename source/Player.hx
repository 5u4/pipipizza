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
