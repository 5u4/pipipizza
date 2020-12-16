package modules.platformer;

class Gravity extends Component
{
	public var grav = 2800.0;
	public var maxGrav = 6000.0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		entity().velocity.y = Math.min(entity().velocity.y + grav * elapsed, maxGrav);
	}
}
