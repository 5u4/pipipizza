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

		var xpos = FlxG.width / 3.0 * 2.0 + 24;
		var margin = 16;
		var red:FlxColor = 0xFFE24D39, green:FlxColor = 0xFF4E9E36;

		ingredient = new FlxText(xpos, 0, 0, "(Ingredients)");
		ingredient.setFormat(AssetPaths.christmas_bell__otf, 128, FlxColor.WHITE, CENTER);
		ingredient.setBorderStyle(FlxTextBorderStyle.OUTLINE, red, 2);
		ingredient.screenCenter(Y);
		ingredient.x -= ingredient.frameWidth / 2;
		ingredient.y -= 256;
		add(ingredient);

		lv1Button = new Btn(xpos, 0, "Sausage", () -> FlxG.switchState(new HogState()), green);
		lv1Button.updateParam(b ->
		{
			b.y += ingredient.y + ingredient.height + margin * 4;
		});
		add(lv1Button);

		if (progression.canAccessLevel(2))
		{
			lv2Button = new Btn(xpos, 0, "Tomato Sauce", () -> FlxG.switchState(new TomatoState()), red);
			lv2Button.updateParam(b ->
			{
				b.y = lv1Button.text.y + lv1Button.text.height + margin;
			});
			add(lv2Button);
		}

		if (progression.canAccessLevel(3))
		{
			lv3Button = new Btn(xpos, 0, "Cheese", () -> FlxG.switchState(new CheeseState()), green);
			lv3Button.updateParam(b ->
			{
				b.y = lv2Button.text.y + lv2Button.text.height + margin;
			});
			add(lv3Button);
		}

		super.create();

		if (FlxG.sound.music == null)
			FlxG.sound.playMusic(progression.canAccessLevel(4) ? AssetPaths.this_is_christmas__mp3 : AssetPaths.a_peaceful_winter__mp3);
	}
}
