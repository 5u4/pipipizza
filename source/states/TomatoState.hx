package states;

import enemies.Tomato;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class TomatoState extends BattleState
{
	override function update(elapsed:Float)
	{
		for (bg in movableBgs)
			updateBgX(bg, -0.02);
		for (fg in movableFgs)
			updateBgX(fg, 0.05);
		super.update(elapsed);
	}

	override function itemGraphic():FlxGraphicAsset
	{
		return AssetPaths.tomato_sause__png;
	}

	override function getHealthColor():FlxColor
	{
		return 0xFFFF8F88;
	}

	override function getTitleText():String
	{
		return "Garden";
	}

	override function handleWin()
	{
		progression.finishLevel(2);
		super.handleWin();
	}

	override function getEnemy()
	{
		var enemy = new Tomato(player);
		enemy.facing = enemy.facing = FlxObject.LEFT;
		return enemy;
	}

	override function getRoom()
	{
		return AssetPaths.room2__json;
	}
}
