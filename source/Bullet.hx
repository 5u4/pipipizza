package;

import flixel.util.FlxColor;
import modules.Entity;

class Bullet extends Entity
{
	public function new()
	{
		super();
		makeGraphic(4, 4, FlxColor.YELLOW);
	}

	public function fire(x:Float, y:Float, direction:Int, speed:Float = 150)
	{
		reset(x, y);
		velocity.x = direction * speed;
		velocity.y = 0;
	}
}
