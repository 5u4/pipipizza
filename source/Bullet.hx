package;

import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;
import modules.Entity;

class Bullet extends Entity
{
	public function new()
	{
		super();
		makeGraphic(16, 16, FlxColor.YELLOW);
	}

	public function fire(x:Float, y:Float, direction:Int, speed:Float = 750)
	{
		reset(x, y);
		velocity.x = direction * speed;
		velocity.y = 0;
	}
}
