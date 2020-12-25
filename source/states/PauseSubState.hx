package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PauseSubState extends FlxSubState
{
	var paused:FlxText;
	var quit:Btn;

	public function new(BGColor:FlxColor = 0xAA000000)
	{
		super(BGColor);
	}

	override function create()
	{
		var red:FlxColor = 0xFFE24D39, green:FlxColor = 0xFF4E9E36;
		var margin = 16;

		paused = new FlxText(0, 256, 0, "<Paused>");
		paused.setFormat(AssetPaths.christmas_bell__otf, 128, FlxColor.WHITE, CENTER);
		paused.setBorderStyle(FlxTextBorderStyle.OUTLINE, red, 2);
		paused.screenCenter(X);
		add(paused);

		quit = new Btn(FlxG.width / 2, paused.y + paused.height + margin * 6, "Quit", () -> FlxG.switchState(new MenuState()), green);
		add(quit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed([ESCAPE]))
			close();

		super.update(elapsed);
	}
}
