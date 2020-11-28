package modules.platformer;

class Gravity extends Component
{
	public var grav = 800.0;
	public var maxGrav = 1500.0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		entity().velocity.y = Math.min(entity().velocity.y + grav * elapsed, maxGrav);
	}
}
