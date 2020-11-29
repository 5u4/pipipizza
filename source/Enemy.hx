package;

import flixel.util.FlxColor;
import modules.Entity;
import modules.platformer.Gravity;

class Enemy extends Entity
{
	var grav = 800.0;
	var maxGrav = 1500.0;
	var hp = 10.0;

	public function new()
	{
		super();
		makeGraphic(32, 32, FlxColor.RED);
		addComponent(new Gravity());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function receiveDamage()
	{
		health -= 1 / hp;
		deathCheck();
	}

	public function onHitBullet(bullet:Bullet)
	{
		bullet.kill();
		receiveDamage();
	}

	function deathCheck()
	{
		if (health > 0)
			return;
		kill();
	}
}
