package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import modules.Entity;
import modules.platformer.Gravity;
import openfl8.FlashEffect;

class Enemy extends Entity
{
	var grav = new Gravity();
	var hp = 100.0;
	var flashEffect:FlashEffect;
	var hitSound:FlxSound;

	public var onHit:Void->Void;

	public function new()
	{
		super();
		render();
		solid = true;
		addComponent(grav);
		flashEffect = new FlashEffect();
		shader = flashEffect.shader;
		hitSound = FlxG.sound.load(#if html5 AssetPaths.hit__mp3 #else AssetPaths.hit__wav #end);
		hitSound.volume = Reg.sfxVolume;
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
		hitSound.play(true);
		onHit();
		deathCheck();
	}

	public function onHitBullet(bullet:Bullet)
	{
		bullet.kill();
		receiveDamage(bullet.isEnlarged() ? 15 : 1);
	}

	public function onHitWall(wall:FlxSprite) {}

	function deathCheck()
	{
		if (health > 0)
			return;
		kill();
	}
}
