package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

class EndingState extends FlxTransitionableState
{
	var i = 0;
	var sprites:Array<FlxSprite>;
	var timer:FlxTimer;
	var duration = 3.0;

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

		timer = new FlxTimer();
		timer.start(duration);

		showSprite();

		super.create();

		var music = #if js AssetPaths.this_is_christmas__mp3; #else AssetPaths.this_is_christmas__ogg; #end

		FlxG.sound.music.fadeOut(0.5, 0, _ -> FlxG.sound.playMusic(music));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.firstJustPressed() == -1 && !timer.finished)
			return;

		i++;
		if (i == sprites.length)
			FlxG.switchState(new MenuState());
		showSprite();
		timer.start(duration);
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
