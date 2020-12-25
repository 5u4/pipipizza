package;

import flixel.system.FlxBasePreloader;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;

@:bitmap("assets/images/icon.png") class LoadImage extends BitmapData {}
@:font("assets/fonts/fresh_lychee.ttf") class LoadFont extends Font {}

class Preloader extends FlxBasePreloader
{
	var sprite:Sprite;
	var text:TextField;

	public function new()
	{
		super(2.0);
	}

	override function create()
	{
		this._width = Lib.current.stage.stageWidth;
		this._height = Lib.current.stage.stageHeight;

		var dim = 128;
		var margin = 88;
		sprite = new Sprite();
		sprite.addChild(new Bitmap(new LoadImage(dim, dim)));
		sprite.alpha = 0.0;
		sprite.x = this._width - dim - margin;
		sprite.y = this._height - dim - margin;
		addChild(sprite);

		Font.registerFont(LoadFont);
		text = new TextField();
		text.defaultTextFormat = new TextFormat("Fresh Lychee", 48, 0xFFFFFF);
		text.x = sprite.x + text.width / 2;
		text.y = sprite.y + dim + 24;
		addChild(text);

		super.create();
	}

	override function update(Percent:Float)
	{
		sprite.alpha = Percent;
		text.x = sprite.x + text.width / 2;
		text.text = '${Std.int(Percent * 100)}';
		super.update(Percent);
	}
}
