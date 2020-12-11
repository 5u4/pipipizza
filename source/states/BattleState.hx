package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

class BattleState extends FlxState
{
	var player:Player;
	var enemies:FlxTypedGroup<Enemy>;
	var bullets:FlxTypedGroup<Bullet>;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	override public function create()
	{
		map = new FlxOgmo3Loader(AssetPaths.PlatformerShooter__ogmo, getRoom());
		walls = map.loadTilemap(AssetPaths.tiles__png, "floor");
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		add(walls);

		bullets = new FlxTypedGroup<Bullet>(100);
		for (_ in 1...100)
		{
			var bullet = new Bullet();
			bullet.kill();
			bullets.add(bullet);
		}
		add(bullets);

		player = new Player(bullets);
		enemies = new FlxTypedGroup<Enemy>();

		add(enemies);
		add(player);

		map.loadEntities(onLoadEntity, "entities");

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls, (e:Enemy, w) -> e.onHitWall(w));
		FlxG.overlap(player, enemies, (p:Player, e:Enemy) -> p.onHitEnemy(e));
		FlxG.collide(bullets, walls, (b:Bullet, w) -> b.kill());
		FlxG.overlap(bullets, enemies, (b:Bullet, e:Enemy) -> e.onHitBullet(b));
	}

	function onLoadEntity(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				player.setPosition(entity.x, entity.y);
			case "enemy":
				var enemy = getEnemy();
				enemy.setPosition(entity.x, entity.y);
				enemies.add(enemy);
		}
	}

	function getRoom()
	{
		return AssetPaths.room1__json;
	}

	function getEnemy()
	{
		return new Enemy();
	}
}
