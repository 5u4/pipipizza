package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import modules.Entity;
import modules.platformer.PlatformerController;
import openfl8.InvincibleEffect;
import states.BattleState;

class Player extends Entity
{
	public var hp = 5;
	public var charge = 0.0;
	public var attackFrames = 0.0;
	public var controller:PlatformerController;

	var bullets:FlxTypedGroup<Bullet>;
	var invincible = 1.0;
	var _invincible = 0.0;
	var stompAngleThreshold = 130.0;
	var impulse = new FlxVector(4800.0, 1200.0);
	var chargeAttackThreshold = 1.0;
	var chargeInitiateThreshold = 0.2;
	var chargeSpeedScale = 0.2;
	var chargeJumpScale = 0.5;
	var invincibleEffect:InvincibleEffect;
	var onHitEmitter:FlxEmitter;
	var framePauser:(duration:Float) -> Void;

	public function new(bullets:FlxTypedGroup<Bullet>, framePauser:(duration:Float) -> Void, onHitEmitter:FlxEmitter)
	{
		super();
		this.bullets = bullets;
		loadGraphic(AssetPaths.player__png, true, 88, 88);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("idle", [0, 1], 6, true);
		animation.add("run", [2, 3, 4, 5, 6], 10, true);
		animation.add("jump", [7], 6, false);
		animation.add("shoot", [8], 6, false);
		animation.add("charge", [9, 10, 11, 12], 4, false);
		animation.add("chargeAttack", [13], 6, false);

		controller = new PlatformerController();
		addComponent(controller);
		solid = true;
		invincibleEffect = new InvincibleEffect();
		shader = invincibleEffect.shader;
		this.onHitEmitter = onHitEmitter;
		this.framePauser = framePauser;
	}

	override function update(elapsed:Float)
	{
		attackFrames -= elapsed;
		_invincible -= elapsed;
		super.update(elapsed);
		handleInvincibleEffect();
		handleShoot(elapsed);
	}

	public function onHitEnemy(enemy:Enemy)
	{
		if (_invincible > 0)
			return;

		var pos = getMidpoint(), targetPos = enemy.getMidpoint();
		var angle = new FlxVector(pos.x, pos.y).angleBetween(targetPos);

		if (Math.abs(angle) >= stompAngleThreshold)
			enemy.receiveDamage();
		else
			onReceiveDamage();

		getImpulse(enemy);
	}

	public function onHitBullet(bullet:Bullet)
	{
		if (_invincible > 0)
			return;
		onReceiveDamage();
		bullet.kill();
	}

	public function onReceiveDamage(ignoreInvincible = false)
	{
		if (_invincible > 0 && !ignoreInvincible)
			return;
		var center = getMidpoint();
		onHitEmitter.launchAngle.min = facing == FlxObject.RIGHT ? 0 : -45;
		onHitEmitter.launchAngle.max = facing == FlxObject.RIGHT ? 45 : 0;
		onHitEmitter.setPosition(center.x, center.y);
		onHitEmitter.start(true, 0.1, 30);
		FlxG.state.camera.flash(0x88888888, 0.1);
		FlxG.state.camera.shake(0.01, 0.1);
		framePauser(0.15);
		_invincible = invincible;
		hp -= 1;
		cast(FlxG.state, BattleState).playerHpChange();
	}

	function handleInvincibleEffect()
	{
		if (_invincible > 0)
			invincibleEffect.apply();
		else
			invincibleEffect.reset();
	}

	function getImpulse(target:Entity)
	{
		var pos = getMidpoint();
		var targetPos = target.getMidpoint();
		var norm = new FlxVector(pos.x - targetPos.x, pos.y - targetPos.y - 200).normalize();
		velocity.x = norm.x * impulse.x;
		velocity.y = norm.y * impulse.y;
	}

	function handleShoot(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed([X, K]))
			animation.play("charge");
		if (FlxG.keys.anyPressed([X, K]))
			charge += elapsed;
		controller.movement.speedScale = if (charge > chargeInitiateThreshold) chargeSpeedScale else 1;
		controller.jump.jumpScale = if (charge > chargeInitiateThreshold) chargeJumpScale else 1;

		if (!FlxG.keys.anyJustReleased([X, K]))
			return;

		var isChargedAttack = charge > chargeAttackThreshold;
		charge = 0;

		var bullet = bullets.getFirstAvailable();
		if (bullet == null)
			return;

		attackFrames = 0.2;
		animation.play(isChargedAttack ? "chargeAttack" : "shoot");
		bullet.fire(x + width / 2, y + height / 2, facing == FlxObject.LEFT ? -1 : 1, isChargedAttack ? 1300 : 750);

		// TODO: Change to lazer
		bullet.setEnlarge(isChargedAttack);
	}
}
