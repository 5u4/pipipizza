package states;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxTransitionableState
{
	var initialized = false;
	var titleText:FlxText;
	var lv1Button:FlxButton;
	var lv2Button:FlxButton;
	var lv3Button:FlxButton;

	function init()
	{
		if (initialized)
			return;
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK);
		initialized = true;
	}

	override function create()
	{
		init();

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

		lv3Button = new FlxButton(0, 0, "Level 3", () -> FlxG.switchState(new CheeseState()));
		lv3Button.screenCenter();
		lv3Button.y = lv2Button.y + lv3Button.height + 10;
		add(lv3Button);

		super.create();
	}
}
