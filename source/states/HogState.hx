package states;

import enemies.Hog;
import flixel.FlxObject;

class HogState extends BattleState
{
	override function getEnemy()
	{
		var enemy = new Hog();
		enemy.facing = enemy.facing = FlxObject.LEFT;
		return enemy;
	}
}
