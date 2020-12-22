package;

import flixel.FlxSprite;
import modules.Entity;
import modules.platformer.Gravity;
import openfl8.FlashEffect;

class Enemy extends Entity
{
	var grav = new Gravity();
	var hp = 100.0;
	var flashEffect:FlashEffect;

	public var onHit:Void->Void;

	public function new()
	{
		super();
		render();
		solid = true;
		addComponent(grav);
		flashEffect = new FlashEffect();
		shader = flashEffect.shader;
	}

	public function render() {}

	override function update(elapsed:Float)
	{
		flashEffect.update();
		super.update(elapsed);
	}

	public function receiveDamage(amount = 1)
	{
		health = Math.max(0, health - amount / hp);
		flashEffect.apply();
		onHit();
		deathCheck();
	}

	public function onHitBullet(bullet:Bullet)
	{
		bullet.kill();
		receiveDamage(bullet.scale.x == 1 ? 1 : 15);
	}

	public function onHitWall(wall:FlxSprite) {}

	function deathCheck()
	{
		if (health > 0)
			return;
		kill();
	}
}
