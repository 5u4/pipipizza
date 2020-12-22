package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class HpHud extends FlxTypedGroup<FlxSprite>
{
	var hpValue = 1.0;
	var bg:FlxSprite;
	var drop:FlxSprite;
	var hp:FlxSprite;
	var enemies:FlxTypedGroup<Enemy>;
	var hpChangeCooldown = 0.5;
	var _hpChangeCooldown = 0.0;

	public function new(enemies:FlxTypedGroup<Enemy>)
	{
		super();
		bg = makeBar(FlxColor.BLACK);
		drop = makeBar(FlxColor.RED);
		hp = makeBar(FlxColor.GREEN);
		this.enemies = enemies;
		add(bg);
		add(drop);
		add(hp);
	}

	override function update(elapsed:Float)
	{
		_hpChangeCooldown -= elapsed;
		super.update(elapsed);
		if (_hpChangeCooldown > 0)
			return;
		drop.scale.x = FlxMath.lerp(drop.scale.x, hpValue, 0.1);
	}

	public function damaged()
	{
		updateValue();
		hp.scale.x = hpValue;
		_hpChangeCooldown = hpChangeCooldown;
	}

	function updateValue()
	{
		hpValue = 0.0;
		for (e in enemies)
			hpValue += e.health;
		hpValue /= enemies.length;
	}

	function makeBar(color:FlxColor)
	{
		var b = new FlxSprite();
		b.makeGraphic(FlxG.width - 240, 64, color);
		b.screenCenter(X);
		b.y = FlxG.height - b.height - 24;
		b.origin.set(0, 0);
		return b;
	}
}
