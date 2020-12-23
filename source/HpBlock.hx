package;

import flixel.FlxSprite;

class HpBlock extends FlxSprite
{
	public var isUp(default, null) = true;

	public function new()
	{
		super();
		loadGraphic(AssetPaths.hp__png, true, 48, 48);
		animation.add("down", [0, 1, 2, 3, 4], 7, false);
		scrollFactor.set(0, 0);
	}

	public function down()
	{
		if (!isUp)
			return;
		isUp = false;
		animation.play("down");
	}
}
