package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import flixel.system.FlxSound;
import flixel.ui.FlxVirtualPad;
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
	public var dpad:FlxVirtualPad;

	var chargeSound:FlxSound;
	var chargedSound:FlxSound;
	var hitSound:FlxSound;
	var shootSound:FlxSound;
	var chargedShootSound:FlxSound;
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

		#if !desktop
		if (!Reg.hasKeyboard)
		{
			dpad = new FlxVirtualPad(LEFT_RIGHT, A_B);
			var dpadScale = 3.5;
			dpad.buttonLeft.scale.set(dpadScale, dpadScale);
			dpad.buttonRight.scale.set(dpadScale, dpadScale);
			dpad.buttonA.scale.set(dpadScale, dpadScale);
			dpad.buttonB.scale.set(dpadScale, dpadScale);
			dpad.buttonLeft.updateHitbox();
			dpad.buttonRight.updateHitbox();
			dpad.buttonA.updateHitbox();
			dpad.buttonB.updateHitbox();
			var dpadMargin = 96.0;
			var dpadBtnMargin = 48.0;
			var y = FlxG.height - dpad.buttonLeft.height - dpadMargin;
			dpad.buttonLeft.setPosition(dpadMargin, y);
			dpad.buttonRight.setPosition(dpad.buttonLeft.width + dpadMargin + dpadBtnMargin, y);
			dpad.buttonA.setPosition(FlxG.width - dpad.buttonA.width - dpadMargin, y);
			dpad.buttonB.setPosition(dpad.buttonA.x - dpadBtnMargin - dpad.buttonB.width, y);
		}
		#end

		controller = new PlatformerController(dpad);
		addComponent(controller);
		solid = true;
		invincibleEffect = new InvincibleEffect();
		shader = invincibleEffect.shader;
		this.onHitEmitter = onHitEmitter;
		this.framePauser = framePauser;

		chargeSound = FlxG.sound.load(#if html5 AssetPaths.charging__mp3 #else AssetPaths.charging__wav #end);
		chargedSound = FlxG.sound.load(#if html5 AssetPaths.charged__mp3 #else AssetPaths.charged__wav #end);
		hitSound = FlxG.sound.load(#if html5 AssetPaths.player_hit__mp3 #else AssetPaths.player_hit__wav #end);
		shootSound = FlxG.sound.load(#if html5 AssetPaths.shoot__mp3 #else AssetPaths.shoot__wav #end);
		chargedShootSound = FlxG.sound.load(#if html5 AssetPaths.charged_shoot__mp3 #else AssetPaths.charged_shoot__wav #end);

		chargeSound.volume = Reg.sfxVolume;
		chargedSound.volume = Reg.sfxVolume;
		hitSound.volume = Reg.sfxVolume;
		shootSound.volume = Reg.sfxVolume;
		chargedShootSound.volume = Reg.sfxVolume;
	}

	override function update(elapsed:Float)
	{
		updateDPadExistance();
		attackFrames -= elapsed;
		_invincible -= elapsed;
		super.update(elapsed);
		handleInvincibleEffect();
		handleShoot(elapsed);
	}

	override function destroy()
	{
		if (dpad != null)
		{
			dpad.destroy();
			dpad = null;
		}
		super.destroy();
	}

	function updateDPadExistance()
	{
		if (Reg.hasKeyboard || FlxG.keys.getIsDown().length == 0)
			return;
		Reg.hasKeyboard = true;
		if (dpad == null)
			return;
		dpad.kill();
		dpad = null;
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

	public function onHitBullet(bullet:FlxSprite)
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
		hitSound.play(true);
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
		if (FlxG.keys.anyJustPressed([X, K]) || (dpad != null && dpad.buttonA.justPressed))
		{
			animation.play("charge");
			if (!chargeSound.playing)
				chargeSound.play(true);
		}
		if (FlxG.keys.anyPressed([X, K]) || (dpad != null && dpad.buttonA.pressed))
		{
			charge += elapsed;
			if (charge > chargeAttackThreshold)
				chargedSound.play();
		}
		controller.movement.speedScale = charge > chargeInitiateThreshold ? chargeSpeedScale : 1;
		controller.jump.jumpScale = charge > chargeInitiateThreshold ? chargeJumpScale : 1;

		if (!FlxG.keys.anyJustReleased([X, K]) && !(dpad != null && dpad.buttonA.justReleased))
			return;

		if (chargeSound.playing)
			chargeSound.stop();

		var isChargedAttack = charge > chargeAttackThreshold;
		charge = 0;

		var bullet = bullets.getFirstAvailable();
		if (bullet == null)
			return;

		attackFrames = 0.2;
		animation.play(isChargedAttack ? "chargeAttack" : "shoot");
		bullet.fire(x + width / 2, y + height / 2, facing == FlxObject.LEFT ? -1 : 1, isChargedAttack ? 1300 : 750);
		if (isChargedAttack)
			chargedShootSound.play(true);
		else
			shootSound.play(true);

		bullet.setEnlarge(isChargedAttack);
	}
}
