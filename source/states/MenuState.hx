package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxTransitionableState
{
	var progression:Progression;
	var initialized = false;
	var bg:FlxSprite;
	var titleText:FlxText;
	var titleText2:FlxText;
	var ingredient:FlxText;
	var lv1Button:Btn;
	var lv2Button:Btn;
	var lv3Button:Btn;

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

		titleText = new FlxText(0, 0, 0, "Ho Ho Holiday,");
		titleText.setFormat(AssetPaths.fresh_lychee__ttf, 128, FlxColor.WHITE, CENTER);
		titleText.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFF327345, 4);
		titleText.screenCenter(X);
		titleText.x -= 256;
		titleText.y = 48;
		add(titleText);

		titleText2 = new FlxText(0, 0, 0, "Pi Pi PIZZA NIGHT 🍕");
		titleText2.setFormat(AssetPaths.fresh_lychee__ttf, 128, FlxColor.WHITE, CENTER);
		titleText2.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFF327345, 4);
		titleText2.screenCenter(X);
		titleText2.x += 128;
		titleText2.y = titleText.y + titleText.height + 12;
		add(titleText2);

		var xpos = FlxG.width / 3.0 * 2.0 + 24;
		var margin = 16;

		ingredient = new FlxText(xpos, 0, 0, "Ingredients");
		ingredient.setFormat(AssetPaths.fresh_lychee__ttf, 88, FlxColor.WHITE, CENTER);
		ingredient.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFF327345, 3);
		ingredient.screenCenter(Y);
		ingredient.x -= ingredient.frameWidth / 2;
		ingredient.y -= 88;
		add(ingredient);

		lv1Button = new Btn(xpos, 0, "Sausage", () -> FlxG.switchState(new HogState()));
		lv1Button.updateParam(b ->
		{
			b.y += ingredient.y + ingredient.height + margin * 2;
		});
		add(lv1Button);

		if (progression.canAccessLevel(2))
		{
			lv2Button = new Btn(xpos, 0, "Tomato Sauce", () -> FlxG.switchState(new TomatoState()));
			lv2Button.updateParam(b ->
			{
				b.y = lv1Button.text.y + lv1Button.text.height + margin;
			});
			add(lv2Button);
		}

		if (progression.canAccessLevel(3))
		{
			lv3Button = new Btn(xpos, 0, "Cheese", () -> FlxG.switchState(new CheeseState()));
			lv3Button.updateParam(b ->
			{
				b.y = lv2Button.text.y + lv2Button.text.height + margin;
			});
			add(lv3Button);
		}

		super.create();

		if (FlxG.sound.music == null)
		{
			#if js
			FlxG.sound.playMusic(progression.canAccessLevel(4) ? AssetPaths.this_is_christmas__mp3 : AssetPaths.a_peaceful_winter__mp3);
			#else
			FlxG.sound.playMusic(progression.canAccessLevel(4) ? AssetPaths.this_is_christmas__ogg : AssetPaths.a_peaceful_winter__ogg);
			#end
		}
	}
}
