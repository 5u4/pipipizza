package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxTransitionableState
{
	var progression:Progression;
	var initialized = false;
	var bg:FlxSprite;
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
		FlxG.mouse.visible = true;

		init();

		progression = new Progression();

		bg = new FlxSprite();
		bg.loadGraphic(progression.canAccessLevel(4) ? AssetPaths.menu2__jpg : AssetPaths.menu1__jpg);
		add(bg);

		// titleText = new FlxText(0, 0, 0, "GAME", 22);
		// titleText.alignment = CENTER;
		// titleText.screenCenter(X);
		// add(titleText);

		var xpos = FlxG.width / 3.0 * 2.0;
		lv1Button = new FlxButton(xpos, 0, "Level 1", () -> FlxG.switchState(new HogState()));
		lv1Button.screenCenter(Y);
		add(lv1Button);

		if (progression.canAccessLevel(2))
		{
			lv2Button = new FlxButton(xpos, 0, "Level 2", () -> FlxG.switchState(new TomatoState()));
			lv2Button.screenCenter(Y);
			lv2Button.y += lv2Button.height + 10;
			add(lv2Button);
		}

		if (progression.canAccessLevel(3))
		{
			lv3Button = new FlxButton(xpos, 0, "Level 3", () -> FlxG.switchState(new CheeseState()));
			lv3Button.screenCenter(Y);
			lv3Button.y = lv2Button.y + lv3Button.height + 10;
			add(lv3Button);
		}

		super.create();
	}
}
