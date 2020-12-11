package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	var titleText:FlxText;
	var lv1Button:FlxButton;
	var lv2Button:FlxButton;
	var lv3Button:FlxButton;

	override function create()
	{
		titleText = new FlxText(0, 0, 0, "GAME", 22);
		titleText.alignment = CENTER;
		titleText.screenCenter(X);
		add(titleText);

		lv1Button = new FlxButton(0, 0, "Level 1", () -> FlxG.switchState(new HogState()));
		lv1Button.screenCenter();
		add(lv1Button);

		lv2Button = new FlxButton(0, 0, "Level 2", () -> FlxG.switchState(new TomatoState()));
		lv2Button.screenCenter();
		lv2Button.y += lv2Button.height + 10;
		add(lv2Button);

		lv3Button = new FlxButton(0, 0, "Level 3");
		lv3Button.screenCenter();
		lv3Button.y = lv2Button.y + lv3Button.height + 10;
		add(lv3Button);

		super.create();
	}
}
