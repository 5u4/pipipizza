package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import modules.Entity;
import modules.platformer.PlatformerController;

class Player extends Entity
{
	var bullets:FlxTypedGroup<Bullet>;
	var invincible = 1.0;
	var _invincible = 0.0;
	var stompAngleThreshold = 130.0;
	var impulse = new FlxVector(1200.0, 400.0);
	var charge = 0.0;
	var chargeAttackThreshold = 1.0;
	var chargeInitiateThreshold = 0.2;
	var chargeSpeedScale = 0.2;
	var chargeJumpScale = 0.5;
	var controller:PlatformerController;

	public function new(bullets:FlxTypedGroup<Bullet>)
	{
		super();
		this.bullets = bullets;
		makeGraphic(32, 32, FlxColor.BLUE);
		controller = new PlatformerController();
		addComponent(controller);
	}

	override function update(elapsed:Float)
	{
		_invincible -= elapsed;

		super.update(elapsed);
		handleShoot(elapsed);
	}

	public function onHitEnemy(enemy:Enemy)
	{
		if (_invincible > 0)
			return;

		var pos = getMidpoint();
		var targetPos = enemy.getMidpoint();
		var norm = new FlxVector(pos.x - targetPos.x, pos.y - targetPos.y - 50).normalize();
		var angle = new FlxVector(pos.x, pos.y).angleBetween(targetPos);

		if (Math.abs(angle) >= stompAngleThreshold)
		{
			enemy.receiveDamage();
		}
		else
		{
			// Damage
			FlxG.state.camera.shake(0.01, 0.1);
			_invincible = invincible;
		}

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
