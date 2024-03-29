package states;

import enemies.Cheese;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
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
	var bgTile1:FlxSprite;
	var bgTile2:FlxSprite;
	var bgTile3:FlxSprite;

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
		for (_ in 0...100)
		{
			var bullet = new FlxSprite();
			bullet.loadGraphic(AssetPaths.cheese_bullet__png, true, 80, 53);
			bullet.animation.add("fire", [0, 1], 2, false);
			bullet.animation.add("fly", [2, 3, 4], 10, true);
			bullet.animation.finishCallback = (name:String) ->
			{
				if (name == "fire")
					bullet.animation.play("fly", true);
			}
			bullet.kill();
			enemyBullets.add(bullet);
		}

		damageZone = new FlxSprite();
		damageZone.makeGraphic(FlxG.width, 1, FlxColor.TRANSPARENT);
		damageZone.screenCenter(X);
		damageZone.y = FlxG.height - 1;

		makeBgTiles();

		super.create();

		createInitialBricks();

		lastSpawnX = FlxG.width / 2;
	}

	override function addLayers()
	{
		add(damageZone);
		add(backgrounds);
		add(bgTile1);
		add(bgTile2);
		add(bgTile3);
		add(collisions);
		add(bricks);
		add(enemyBullets);
		add(bullets);
		add(enemies);
		add(item);
		add(player);
		add(emitters);
		add(largeEmitters);
		add(onHitEmitter);
		add(foregrounds);
		add(enemyHp);
		for (h in hpHuds)
			add(h);
		add(title);
		add(player.dpad);
	}

	override function update(elapsed:Float)
	{
		brickSpawner(elapsed);
		updateBgTiles();

		super.update(elapsed);

		FlxG.collide(player, bricks);
		FlxG.overlap(player, enemyBullets, (p:Player, b) -> p.onHitBullet(b));
		FlxG.collide(enemyBullets, bricks, (b:FlxSprite, w) -> b.kill());
		FlxG.collide(enemyBullets, collisions, (b:FlxSprite, w) -> b.kill());
		FlxG.collide(bullets, bricks, (b:Bullet, w) ->
		{
			spawnParticleAt(b);
			b.kill();
		});
		FlxG.overlap(player, damageZone, (p, d) -> reSpawnPlayer());
	}

	override function onLevelFinish()
	{
		for (e in enemies)
		{
			if (e.health > 0)
				super.onLevelFinish();
		}
		FlxG.switchState(new EndingState());
	}

	override function getHealthColor():FlxColor
	{
		return 0xFFFFDD9C;
	}

	override function getTitleText():String
	{
		return "Stove";
	}

	override function itemGraphic():FlxGraphicAsset
	{
		return AssetPaths.cheese_ingredient__png;
	}

	override function handleWin()
	{
		progression.finishLevel(3);
		super.handleWin();
	}

	override function getEnemy():Enemy
	{
		return new Cheese(player, () -> enemyBullets.recycle());
	}

	override function getRoom():String
	{
		return AssetPaths.room3__json;
	}

	function makeBgTiles()
	{
		bgTile1 = new FlxSprite(0, -864);
		bgTile1.loadGraphic(AssetPaths.stove_tiles__png, 1920, 864);
		bgTile1.velocity.y = brickSpeed * 0.5;
		bgTile2 = new FlxSprite(0, 0);
		bgTile2.loadGraphic(AssetPaths.stove_tiles__png, 1920, 864);
		bgTile2.velocity.y = brickSpeed * 0.5;
		bgTile3 = new FlxSprite(0, 864);
		bgTile3.loadGraphic(AssetPaths.stove_tiles__png, 1920, 864);
		bgTile3.velocity.y = brickSpeed * 0.5;
	}

	function updateBgTiles()
	{
		for (t in [bgTile1, bgTile2, bgTile3])
		{
			if (t.y <= FlxG.height)
				continue;
			t.y -= 864 * 3;
			return;
		}
	}

	function makeBrick()
	{
		var brick = new Entity();
		brick.loadGraphic(AssetPaths.stove_platform__png);
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

	function spawnBrick(y = -67.0)
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
