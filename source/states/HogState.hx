package states;

import enemies.Hog;
import flixel.FlxObject;

class HogState extends BattleState
{
	override function update(elapsed:Float)
	{
		for (bg in movableBgs)
			updateBgX(bg, -0.02);
		for (fg in movableFgs)
			updateBgX(fg, 0.05);
		super.update(elapsed);
	}

	override function handleWin()
	{
		progression.finishLevel(1);
		super.handleWin();
	}

	override function getEnemy()
	{
		var enemy = new Hog();
		enemy.facing = enemy.facing = FlxObject.LEFT;
		return enemy;
	}

	override function getRoom()
	{
		return AssetPaths.room1__json;
	}
}
