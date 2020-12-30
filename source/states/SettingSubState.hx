package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SettingSubState extends FlxSubState
{
	var settings:FlxText;
	var controlBtn:Btn;
	var closeBtn:Btn;

	public function new(BGColor:FlxColor = 0xFF000000)
	{
		super(BGColor);
	}

	override function create()
	{
		var red:FlxColor = 0xFFE24D39, green:FlxColor = 0xFF4E9E36;
		var margin = 16;

		settings = new FlxText(0, 128, 0, "<Settings>");
		settings.setFormat(AssetPaths.christmas_bell__otf, 128, FlxColor.WHITE, CENTER);
		settings.setBorderStyle(FlxTextBorderStyle.OUTLINE, red, 2);
		settings.screenCenter(X);
		add(settings);

		controlBtn = new Btn(FlxG.width / 2, settings.y + settings.height + margin * 6, "Bind Controls", () -> openSubState(new ControlSubState()), green);
		add(controlBtn);

		closeBtn = new Btn(FlxG.width / 2, controlBtn.text.y + controlBtn.text.height + margin, "Close", () -> close(), red);
		add(closeBtn);

		super.create();
	}
}
