package states;

import enemies.Tomato;
import flixel.FlxObject;

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
