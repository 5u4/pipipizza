package;

import flixel.FlxG;
import flixel.util.FlxColor;
import modules.Entity;

class Enemy extends Entity
{
	var grav = 800.0;
	var maxGrav = 1500.0;

	public function new()
	{
		super();
		makeGraphic(32, 32, FlxColor.RED);
	}

	override function update(elapsed:Float)
	{
		handleGravity(elapsed);

		super.update(elapsed);
	}

	function handleGravity(elapsed:Float)
	{
		velocity.y = Math.min(velocity.y + grav * elapsed, maxGrav);
	}

	public function onHitBullet(bullet:Bullet)
	{
		bullet.kill();
	}
}
