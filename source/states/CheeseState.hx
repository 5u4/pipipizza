package states;

import enemies.Cheese;
import flixel.FlxG;
import flixel.FlxSprite;
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
	var spawnCenter = true;

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
		createInitialBricks();

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
		FlxG.collide(enemyBullets, collisions, (b:Bullet, w) -> b.kill());
		FlxG.collide(bullets, bricks, (b:Bullet, w) -> b.kill());
		FlxG.overlap(player, damageZone, (p, d) -> reSpawnPlayer());
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
		brick.reset(x - brick.width / 2, y);
		brick.velocity.y = brickSpeed;
		return brick;
	}

	function createInitialBricks()
	{
		var y:Float = FlxG.height;
		while (y >= 0)
		{
			spawnBrick(y);
			y -= FlxG.height / 4;
		}
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
	}

	function spawnBrick(y = 0.0)
	{
		if (spawnCenter)
		{
			createBrick(FlxG.width / 2, y);
		}
		else
		{
			var oneThird = FlxG.width / 3;
			createBrick(oneThird, y);
			createBrick(oneThird * 2, y);
		}

		spawnCenter = !spawnCenter;
	}

	function reSpawnPlayer()
	{
		player.onReceiveDamage(true);
		player.x = FlxG.width / 2;
		player.y = 0;
		player.velocity.y = 0;
	}
}
