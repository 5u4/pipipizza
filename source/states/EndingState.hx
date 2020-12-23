package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.FlxAssets.FlxGraphicAsset;

class EndingState extends FlxTransitionableState
{
	var i = 0;
	var sprites:Array<FlxSprite>;

	public function new()
	{
		super();
	}

	override function create()
	{
		FlxG.mouse.visible = false;

		sprites = new Array<FlxSprite>();
		sprites.push(loadImage(AssetPaths.end1__jpg));
		sprites.push(loadImage(AssetPaths.end2__jpg));

		showSprite();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.firstJustPressed() == -1)
			return;

		i++;
		if (i == sprites.length)
			FlxG.switchState(new MenuState());
		showSprite();
	}

	function loadImage(Graphic:FlxGraphicAsset)
	{
		var sprite = new FlxSprite();
		sprite.loadGraphic(Graphic);
		sprite.visible = false;
		add(sprite);
		return sprite;
	}

	function showSprite()
	{
		if (i > 0)
			sprites[i - 1].visible = false;
		if (i < sprites.length)
			sprites[i].visible = true;
	}
}
