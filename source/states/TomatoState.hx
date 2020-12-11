package states;

import enemies.Tomato;
import flixel.FlxObject;

class TomatoState extends BattleState
{
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
