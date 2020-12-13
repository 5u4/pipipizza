package states;

import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import modules.Entity;

class CheeseState extends BattleState
{
	var bricks:FlxTypedGroup<Entity>;
	var spawnInterval = 3.0;
	var _spawnInterval = 3.0;
	var brickSpeed = 25.0;
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

		add(bricks);
		lastSpawnX = FlxG.width / 2;

		super.create();
	}

	override function update(elapsed:Float)
	{
		brickSpawner(elapsed);

		super.update(elapsed);

		FlxG.collide(player, bricks);
		FlxG.collide(bullets, bricks, (b:Bullet, w) -> b.kill());
	}

	override function onLoadEntity(entity:EntityData)
	{
		super.onLoadEntity(entity);

		if (entity.name != "Brick")
			return;
		createBrick(entity.x, entity.y);
	}

	override function getRoom():String
	{
		return AssetPaths.room3__json;
	}

	function makeBrick()
	{
		var brick = new Entity();
		brick.makeGraphic(56, 16, FlxColor.GREEN);
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
		var offset = (Math.random() * 2 - 1) * 70;
		if (isSecond)
			offset += (offset > 0 ? 1 : -1) * (Math.random() * 30 + 100);
		brick.x = lastSpawnX + offset;
		if ((brick.x + brick.width) >= FlxG.width)
			brick.x -= 2 * offset;
		else if (brick.x <= 0)
			brick.x -= 2 * offset;
		lastSpawnX = brick.x;
	}
}
