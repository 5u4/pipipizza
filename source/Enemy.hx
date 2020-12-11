package;

import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import modules.Entity;
import modules.platformer.Gravity;

class Enemy extends Entity
{
	var grav = 800.0;
	var maxGrav = 1500.0;
	var hp = 100.0;

	public function new()
	{
		super();
		render();
		addComponent(new Gravity());
	}

	public function render()
	{
		makeGraphic(56, 56, FlxColor.RED);
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

	public function onHitWall(wall:FlxTilemap) {}

	function deathCheck()
	{
		if (health > 0)
			return;
		kill();
	}
}
