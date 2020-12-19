package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import modules.Entity;
import modules.platformer.PlatformerController;
import openfl8.InvincibleEffect;
import states.BattleState;

class Player extends Entity
{
	public var hp = 5;

	var bullets:FlxTypedGroup<Bullet>;
	var invincible = 1.0;
	var _invincible = 0.0;
	var stompAngleThreshold = 130.0;
	var impulse = new FlxVector(4800.0, 1200.0);
	var charge = 0.0;
	var chargeAttackThreshold = 1.0;
	var chargeInitiateThreshold = 0.2;
	var chargeSpeedScale = 0.2;
	var chargeJumpScale = 0.5;
	var controller:PlatformerController;
	var invincibleEffect:InvincibleEffect;
	var onHitEmitter:FlxEmitter;
	var framePauser:(duration:Float) -> Void;

	public function new(bullets:FlxTypedGroup<Bullet>, framePauser:(duration:Float) -> Void, onHitEmitter:FlxEmitter)
	{
		super();
		this.bullets = bullets;
		makeGraphic(88, 88, FlxColor.BLUE);
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
		_invincible -= elapsed;
		handleInvincibleEffect();
		handleShoot(elapsed);
		super.update(elapsed);
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

		bullet.fire(x + width / 2, y + height / 2, if (facing == FlxObject.LEFT) -1 else 1);

		// TODO: Change to lazer
		var size = isChargedAttack ? 4.0 : 1.0;
		bullet.setSize(size, size);
		bullet.scale.x = size;
		bullet.scale.y = size;
	}
}
