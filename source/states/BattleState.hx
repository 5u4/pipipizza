package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class BattleState extends FlxState
{
	var player:Player;
	var enemies:FlxTypedGroup<Enemy>;
	var bullets:FlxTypedGroup<Bullet>;
	var emitters:FlxTypedGroup<FlxEmitter>;
	var onHitEmitter:FlxEmitter;
	var hpHuds:Array<FlxSprite>;

	var map:FlxOgmo3Loader;
	var foregrounds:FlxTypedGroup<FlxSprite>;
	var collisions:FlxTypedGroup<FlxSprite>;
	var backgrounds:FlxTypedGroup<FlxSprite>;
	var movableBgs:FlxTypedGroup<FlxSprite>;
	var movableFgs:FlxTypedGroup<FlxSprite>;
	var prevPx:Float;
	var _pause = 0.0;

	override public function create()
	{
		map = new FlxOgmo3Loader(AssetPaths.PlatformerShooter__ogmo, getRoom());
		foregrounds = new FlxTypedGroup<FlxSprite>();
		collisions = new FlxTypedGroup<FlxSprite>();
		backgrounds = new FlxTypedGroup<FlxSprite>();
		movableBgs = new FlxTypedGroup<FlxSprite>();
		movableFgs = new FlxTypedGroup<FlxSprite>();

		bullets = new FlxTypedGroup<Bullet>(100);
		for (_ in 0...100)
		{
			var bullet = new Bullet();
			bullet.kill();
			bullets.add(bullet);
		}

		onHitEmitter = new FlxEmitter(0, 0, 30);
		onHitEmitter.makeParticles(2, 2, FlxColor.BLACK, 30);
		// onHitEmitter.launchMode = FlxEmitterMode.SQUARE;
		// onHitEmitter.velocity.set(-1600, -400, 1600, 400, 0, 0, 0, 0);
		onHitEmitter.launchMode = FlxEmitterMode.CIRCLE;
		onHitEmitter.speed.set(-3000, 3000, 0, 0);
		onHitEmitter.angle.start.min = -90;
		onHitEmitter.angle.start.max = 90;
		onHitEmitter.lifespan.set(0.7, 0.9);
		onHitEmitter.scale.set(48, 48, 64, 64, 0, 0);

		player = new Player(bullets, d -> _pause = d, onHitEmitter);
		enemies = new FlxTypedGroup<Enemy>();

		emitters = new FlxTypedGroup<FlxEmitter>();
		for (_ in 0...100)
		{
			var emitter = new FlxEmitter(0, 0, 15);
			emitter.makeParticles(2, 2, FlxColor.WHITE, 15);
			emitter.launchMode = FlxEmitterMode.SQUARE;
			emitter.allowCollisions = FlxObject.ANY;
			// emitter.alpha.start.set(1);
			// emitter.alpha.end.set(0.3);
			emitter.angle.start.min = -90;
			emitter.angle.start.max = 90;
			emitter.acceleration.start.min.y = -100;
			emitter.acceleration.end.min.y = 500;
			emitter.acceleration.end.max.y = 800;
			emitter.velocity.set(-250, -400, 250, 300, 0, 0, 0, 0);
			emitter.elasticity.set(0.5, 0.7, 0.1, 0.1);
			emitter.lifespan.set(0.5, 0.8);
			emitter.scale.set(8, 8, 16, 16, 0, 0);
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

		map.loadEntities(onLoadEntity, "backgrounds");
		map.loadEntities(onLoadEntity, "collisions");
		map.loadEntities(onLoadEntity, "entities");
		map.loadEntities(onLoadEntity, "foregrounds");
		addBounds();
		prevPx = player.x;

		addLayers();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		_pause -= elapsed;
		if (_pause > 0)
			return;

		prevPx = player.x;
		super.update(elapsed);

		FlxG.collide(player, collisions);
		FlxG.collide(enemies, collisions, (e:Enemy, w) -> e.onHitWall(w));
		FlxG.overlap(player, enemies, (p:Player, e:Enemy) -> p.onHitEnemy(e));
		FlxG.collide(bullets, collisions, (b:Bullet, w:FlxSprite) ->
		{
			spawnParticleAt(b.x, b.y);
			b.kill();
		});
		FlxG.overlap(bullets, enemies, (b:Bullet, e:Enemy) ->
		{
			spawnParticleAt(b.x, b.y);
			e.onHitBullet(b);
		});
		FlxG.collide(emitters, collisions);

		if (FlxG.keys.anyJustPressed([ESCAPE]))
			FlxG.switchState(new MenuState());
	}

	function addLayers()
	{
		add(backgrounds);
		add(collisions);
		add(bullets);
		add(enemies);
		add(player);
		add(emitters);
		add(onHitEmitter);
		add(foregrounds);
		for (h in hpHuds)
			add(h);
	}

	function updateBgX(bg:FlxSprite, weight = -0.1)
	{
		if (bg == null)
			return;
		bg.x = bg.x + (player.x - prevPx) * weight;
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
		emitter.start(true, 0.1, 15);
	}

	function addBounds()
	{
		var extraHeight = 300;
		var w = 8;
		var left = new FlxSprite(-w, -extraHeight);
		left.makeGraphic(w, FlxG.height + extraHeight, FlxColor.TRANSPARENT);
		left.solid = true;
		left.immovable = true;

		var right = new FlxSprite(FlxG.width + 1, -extraHeight);
		right.makeGraphic(w, FlxG.height + extraHeight, FlxColor.TRANSPARENT);
		right.solid = true;
		right.immovable = true;

		collisions.add(left);
		collisions.add(right);
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
			case "barn_bg":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.barn_bg__jpg, false, entity.width, entity.height);
				e.scrollFactor.set(0.5, 0);
				backgrounds.add(e);
				movableBgs.add(e);
			case "barn_floor":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.barn_floor__png, false, entity.width, entity.height);
				e.solid = true;
				e.immovable = true;
				collisions.add(e);
			case "hay":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.hay__png, false, entity.width, entity.height);
				foregrounds.add(e);
				movableFgs.add(e);
			case "pillar":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.pillar__png, false, entity.width, entity.height);
				e.flipX = entity.flippedX;
				foregrounds.add(e);
			case "barn_platform":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.barn_platform__png, false, entity.width, entity.height);
				e.solid = true;
				e.immovable = true;
				collisions.add(e);
			case "barn_platform_deco":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.barn_platform_deco__png, false, entity.width, entity.height);
				backgrounds.add(e);
			case "fire":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.fire__png, false, entity.width, entity.height);
				foregrounds.add(e);
			case "stove_bg":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.stove_bg__png, false, entity.width, entity.height);
				backgrounds.add(e);
			case "stove_fg":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.stove_fg__png, false, entity.width, entity.height);
				foregrounds.add(e);
			case "stove_platform":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.stove_platform__png, false, entity.width, entity.height);
				e.solid = true;
				e.immovable = true;
				collisions.add(e);
			case "stove_wall":
				var e = new FlxSprite(entity.x, entity.y);
				e.loadGraphic(AssetPaths.stove_wall__png, false, entity.width, entity.height);
				e.flipX = entity.flippedX;
				foregrounds.add(e);
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
