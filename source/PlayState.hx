package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import modules.Gravity;

class PlayState extends FlxState
{
	var player:Player;
	var bullets:FlxTypedGroup<Bullet>;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	override public function create()
	{
		map = new FlxOgmo3Loader(AssetPaths.PlatformerShooter__ogmo, AssetPaths.room1__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "floor");
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		add(walls);

		var grav = map.getLevelValue("gravity");
		var maxGrav = map.getLevelValue("max_gravity");

		bullets = new FlxTypedGroup<Bullet>(100);
		for (_ in 1...100)
		{
			var bullet = new Bullet();
			bullet.kill();
			bullets.add(bullet);
		}
		add(bullets);

		player = new Player(bullets);
		player.addComponent(new Gravity(grav, maxGrav));
		add(player);

		map.loadEntities(onLoadEntity, "entities");

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, walls);
		FlxG.collide(bullets, walls, (b:Bullet, w) -> b.kill());
	}

	function onLoadEntity(entity:EntityData)
	{
		trace(entity);

		switch (entity.name)
		{
			case "player":
				player.setPosition(entity.x, entity.y);
				player.hspeed = entity.values.movespeed;
				player.jumpSpeed = entity.values.jump_height;
		}
	}
}
