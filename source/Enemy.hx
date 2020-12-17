package;

import flixel.tile.FlxTilemap;
import modules.Entity;
import modules.platformer.Gravity;

class Enemy extends Entity
{
	var grav = new Gravity();
	var hp = 100.0;

	public function new()
	{
		super();
		render();
		solid = true;
		addComponent(grav);
	}

	public function render() {}

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

	public function onHitWall(wall:FlxTilemap) {}

	function deathCheck()
	{
		if (health > 0)
			return;
		kill();
	}
}
