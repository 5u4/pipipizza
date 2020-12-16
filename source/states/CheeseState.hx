package states;

import enemies.Cheese;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import modules.Entity;

class CheeseState extends BattleState
{
	var bricks:FlxTypedGroup<Entity>;
	var enemyBullets:FlxTypedGroup<FlxSprite>;
	var damageZone:FlxSprite;
	var spawnInterval = 3.5;
	var _spawnInterval = 2.8;
	var brickSpeed = 75.0;
	var lastSpawnX = 0.0;

	override function create()
	{
		bricks = new FlxTypedGroup<Entity>();
		for (_ in 0...100)
		{
			var g = makeBrick();
			g.kill();
			bricks.add(g);
		}

		enemyBullets = new FlxTypedGroup<FlxSprite>();
		for (_ in 0...400)
		{
			var bullet = new FlxSprite();
			bullet.makeGraphic(32, 32, FlxColor.PINK);
			bullet.kill();
			enemyBullets.add(bullet);
		}

		damageZone = new FlxSprite();
		damageZone.makeGraphic(FlxG.width, 1, FlxColor.TRANSPARENT);
		damageZone.screenCenter(X);
		damageZone.y = FlxG.height - 1;

		add(bricks);
		add(enemyBullets);
		add(damageZone);

		super.create();
		lastSpawnX = FlxG.width / 2;
	}

	override function update(elapsed:Float)
	{
		brickSpawner(elapsed);

		super.update(elapsed);

		FlxG.collide(player, bricks);
		FlxG.overlap(player, enemyBullets, (p:Player, b) -> p.onHitBullet(b));
		FlxG.collide(enemyBullets, bricks, (b:Bullet, w) -> b.kill());
		FlxG.collide(enemyBullets, walls, (b:Bullet, w) -> b.kill());
		FlxG.collide(bullets, bricks, (b:Bullet, w) -> b.kill());
		FlxG.overlap(player, damageZone, (p, d) -> reSpawnPlayer());
	}

	override function onLoadEntity(entity:EntityData)
	{
		super.onLoadEntity(entity);

		if (entity.name != "Brick")
			return;
		createBrick(entity.x, entity.y);
	}

	override function getEnemy():Enemy
	{
		return new Cheese(player, () -> enemyBullets.getFirstAvailable());
	}

	override function getRoom():String
	{
		return AssetPaths.room3__json;
	}

	function makeBrick()
	{
		var brick = new Entity();
		brick.makeGraphic(224, 32, FlxColor.GREEN);
		brick.immovable = true;
		return brick;
	}

	function createBrick(x:Float, y:Float)
	{
		var brick = getBrick();
		brick.reset(x, y);
		brick.centerOrigin();
		brick.velocity.y = brickSpeed;
		return brick;
	}

	function getBrick()
	{
		var brick = bricks.getFirstAvailable();
		if (brick == null)
		{
			var count = 20;
			do
			{
				brick = bricks.getRandom();
				count--;
			}
			while (brick.isOnScreen() && count > 0);
		}
		return brick;
	}

	function brickSpawner(elapsed:Float)
	{
		_spawnInterval -= elapsed;
		if (_spawnInterval > 0)
			return;
		_spawnInterval = spawnInterval + Math.random() * 0.8;
		spawnBrick();
		if (Math.random() > 0.4)
			spawnBrick(true);
	}

	function spawnBrick(isSecond = false)
	{
		var brick = createBrick(0, 0);
		if (brick == null)
			return;
		brick.screenCenter(X);
		var offset = (Math.random() * 2 - 1) * 110 + 100;
		if (isSecond)
			offset += (offset > 0 ? 1 : -1) * (Math.random() * 130 + 150);
		brick.x = lastSpawnX + offset;
		if ((brick.x + brick.width) >= FlxG.width || brick.x <= 0)
			brick.x -= 2 * offset;
		lastSpawnX = brick.x;
	}

	function reSpawnPlayer()
	{
		player.onReceiveDamage(true);
		player.x = lastSpawnX;
		player.y = 0;
		player.velocity.y = 0;
	}
}
