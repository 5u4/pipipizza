package modules;

class Gravity extends Component
{
	var grav:Float;
	var maxGrav:Float = 1500;

	public function new(grav:Float = 400)
	{
		super();
		this.grav = grav;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		entity.velocity.y = Math.min(entity.velocity.y + grav * elapsed, maxGrav);
	}
}
