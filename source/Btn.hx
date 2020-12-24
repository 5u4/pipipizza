package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.filters.GlowFilter;

class Btn extends FlxTypedGroup<FlxSprite>
{
	var tween:FlxTween;
	var glowTween:FlxTween;

	public var text:FlxText;
	public var outline:FlxText;
	public var glow:FlxSprite;
	public var glow2:FlxSprite;

	public var onMouseDown = () -> {};
	public var onMouseUp = () -> {};
	public var onMouseOver = () -> {};
	public var onMouseOut = () -> {};

	public function new(?X:Float = 0, ?Y:Float = 0, ?Text:String, ?onClick:() -> Void)
	{
		super();

		text = new FlxText(X, Y, 0, Text);
		text.setFormat(AssetPaths.fresh_lychee__ttf, 64, FlxColor.WHITE, CENTER);

		outline = new FlxText(X, Y, 0, Text);
		outline.setFormat(AssetPaths.fresh_lychee__ttf, 64, FlxColor.WHITE, CENTER);
		outline.setBorderStyle(OUTLINE, 0xFF327345, 3);
		outline.alpha = 0.0;

		glow = new FlxSprite(X, Y).makeGraphic(cast(text.width / 2), cast(text.height / 2), FlxColor.WHITE);
		glow2 = new FlxSprite(X, Y).makeGraphic(cast(text.width / 2), cast(text.height / 2), FlxColor.WHITE);
		glow2.alpha = 0.0;

		var glowFilter = new GlowFilter(0xFFFFFF, 1, 400, 35, 100, 1, true, true);
		var filterFrames = FlxFilterFrames.fromFrames(text.frames, 400, 35, [glowFilter]);
		filterFrames.applyToSprite(glow, false, true);
		filterFrames.applyToSprite(glow2, false, true);
		FlxMouseEventManager.add(glow, OnMouseDown, OnMouseUp, OnMouseOver, OnMouseOut);

		add(glow2);
		add(glow);
		add(outline);
		add(text);

		var offsetx = text.frameWidth / 2;
		text.x -= offsetx;
		outline.x -= offsetx;
		glow.x -= offsetx;
		glow2.x -= offsetx;

		if (onClick != null)
			onMouseUp = onClick;
	}

	public function updateParam(Update:(obj:FlxSprite) -> Void)
	{
		Update(glow2);
		Update(glow);
		Update(text);
		Update(outline);
	}

	function OnMouseDown(_:FlxObject)
	{
		onMouseDown();
	}

	function OnMouseUp(_:FlxObject)
	{
		onMouseUp();
	}

	function OnMouseOver(_:FlxObject)
	{
		if (tween != null)
		{
			tween.cancel();
			tween = null;
		}
		tween = FlxTween.tween(outline, {alpha: 1.0}, 0.3);
		if (glowTween != null)
		{
			glowTween.cancel();
			glowTween = null;
		}
		glowTween = FlxTween.tween(glow2, {alpha: 1.0}, 0.3);
		FlxG.sound.play(AssetPaths.pickup__wav);
		onMouseOver();
	}

	function OnMouseOut(_:FlxObject)
	{
		if (tween != null)
		{
			tween.cancel();
			tween = null;
		}
		tween = FlxTween.tween(outline, {alpha: 0.0}, 0.3);
		if (glowTween != null)
		{
			glowTween.cancel();
			glowTween = null;
		}
		glowTween = FlxTween.tween(glow2, {alpha: 0.0}, 0.3);
		onMouseOut();
	}
}
