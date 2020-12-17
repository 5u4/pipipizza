package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class BattleState extends FlxState
{
	var player:Player;
	var enemies:FlxTypedGroup<Enemy>;
	var bullets:FlxTypedGroup<Bullet>;
	var emitters:FlxTypedGroup<FlxEmitter>;
	var hpHuds:Array<FlxSprite>;

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
		for (_ in 0...100)
		{
			var bullet = new Bullet();
			bullet.kill();
			bullets.add(bullet);
		}

		player = new Player(bullets);
		enemies = new FlxTypedGroup<Enemy>();

		emitters = new FlxTypedGroup<FlxEmitter>();
		for (_ in 0...100)
		{
			var emitter = new FlxEmitter(0, 0, 10);
			emitter.makeParticles(2, 2, FlxColor.WHITE, 10);
			emitter.launchMode = FlxEmitterMode.SQUARE;
			emitter.allowCollisions = FlxObject.ANY;
			// emitter.alpha.start.set(1);
			// emitter.alpha.end.set(0.3);
			emitter.acceleration.start.min.y = -100;
			emitter.acceleration.end.min.y = 500;
			emitter.acceleration.end.max.y = 800;
			emitter.velocity.set(-400, -100, 400, 200, 0, 0, 0, 0);
			emitter.elasticity.set(0.5, 0.7, 0.1, 0.1);
			emitter.lifespan.set(0.5, 0.8);
			emitter.scale.set(8, 8, 6, 6, 0, 0, 0, 0);
			emitters.add(emitter);
		}

		hpHuds = new Array<FlxSprite>();
		var hpHudX = 24.0;
		for (_ in 0...player.hp)
		{
			var heart = new FlxSprite();
			heart.makeGraphic(48, 48, FlxColor.LIME);
			heart.setPosition(hpHudX, 12);
			hpHudX += heart.width + 12;
			hpHuds.push(heart);
		}

		map.loadEntities(onLoadEntity, "entities");

		add(emitters);
		add(bullets);
		add(enemies);
		add(player);
		for (h in hpHuds)
			add(h);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls, (e:Enemy, w) -> e.onHitWall(w));
		FlxG.overlap(player, enemies, (p:Player, e:Enemy) -> p.onHitEnemy(e));
		FlxG.collide(bullets, walls, (b:Bullet, w:FlxTilemap) ->
		{
			spawnParticleAt(b.x, b.y);
			b.kill();
		});
		FlxG.overlap(bullets, enemies, (b:Bullet, e:Enemy) ->
		{
			spawnParticleAt(b.x, b.y);
			e.onHitBullet(b);
		});
		FlxG.collide(emitters, walls);

		if (FlxG.keys.anyJustPressed([ESCAPE]))
			FlxG.switchState(new MenuState());
	}

	public function playerHpChange()
	{
		drawHp();
		if (player.hp > 0)
			return;
		lost();
	}

	function lost()
	{
		FlxG.switchState(new MenuState());
	}

	function drawHp()
	{
		for (i => h in hpHuds)
			h.color = i < player.hp ? FlxColor.LIME : FlxColor.GRAY;
	}

	function spawnParticleAt(x:Float, y:Float)
	{
		var emitter = emitters.recycle();
		emitter.setPosition(x, y);
		emitter.start(true, 0.1, 10);
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
