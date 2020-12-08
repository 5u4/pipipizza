package;

import flixel.util.FlxColor;
import modules.Entity;
import modules.brains.statemachine.StateMachine;
import modules.platformer.Gravity;

class Enemy extends Entity
{
	var grav = 800.0;
	var maxGrav = 1500.0;
	var hp = 10.0;
	var brain:StateMachine;

	public function new(brain:StateMachine)
	{
		super();
		makeGraphic(32, 32, FlxColor.RED);
		addComponent(new Gravity());
		this.brain = brain;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		brain.update(elapsed);
	}

	public function receiveDamage()
	{
		health -= 1 / hp;
		deathCheck();
	}

	public function onHitBullet(bullet:Bullet)
	{
		bullet.kill();
		receiveDamage();
	}

	function deathCheck()
	{
		if (health > 0)
			return;
		kill();
	}
}
