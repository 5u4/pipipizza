package;

import flixel.FlxObject;
import modules.Entity;

class Bullet extends Entity
{
	public function new()
	{
		super();
		loadGraphic(AssetPaths.bullet__png, true, 120, 42);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("fire", [0, 1], 6, false);
		animation.add("fly", [2, 3, 4], 8, true);
		animation.finishCallback = (name:String) ->
		{
			if (name == "fire")
				animation.play("fly");
		}
	}

	public function fire(x:Float, y:Float, direction:Int, speed:Float = 750)
	{
		reset(x - width / 2 + direction * 40, y);
		facing = direction > 0 ? FlxObject.RIGHT : FlxObject.LEFT;
		velocity.x = direction * speed;
		velocity.y = 0;
		animation.play("fire", true);
	}

	public function isEnlarged()
	{
		return scale.x == 1.5;
	}

	public function setEnlarge(e:Bool)
	{
		var size = e ? 1.5 : 0.5;
		scale.x = size;
		scale.y = size;
	}
}
