package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ControlSubState extends FlxSubState
{
	var title:FlxText;
	var registering = false;
	var names = ["Left", "Right"];
	var i = 0;

	public function new(BGColor:FlxColor = 0xFF000000)
	{
		super(BGColor);
	}

	override function create()
	{
		var red:FlxColor = 0xFFE24D39;

		title = new FlxText();
		title.setFormat(AssetPaths.fresh_lychee__ttf, 128, FlxColor.WHITE, CENTER);
		title.setBorderStyle(FlxTextBorderStyle.OUTLINE, red, 2);
		title.screenCenter();
		add(title);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!registering)
			regKey();
		listenKey();
	}

	function regKey()
	{
		if (i >= names.length)
			close();
		title.text = 'Press a key for ${names[i]}';
		title.screenCenter();
		registering = true;
	}

	function listenKey()
	{
		var key = FlxG.keys.firstJustReleased();
		if (key == -1)
			return;
		registering = false;
		i++;
	}
}
