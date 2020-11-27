package modules;

class Gravity extends Component
{
	var grav:Float;
	var maxGrav:Float;

	public function new(grav:Float = 400, maxGrav:Float = 1500)
	{
		super();
		this.grav = grav;
		this.maxGrav = maxGrav;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		entity.velocity.y = Math.min(entity.velocity.y + grav * elapsed, maxGrav);
	}
}
