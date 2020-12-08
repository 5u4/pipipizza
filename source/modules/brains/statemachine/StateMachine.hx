package modules.brains.statemachine;

class StateMachine extends Component implements State
{
	var state:State;

	public var states = new Array<State>();

	public function new()
	{
		super();
	}

	public function shouldEnable()
	{
		return false;
	}

	public function enable() {}

	public function shouldDisable()
	{
		return false;
	}

	public function disable() {}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (state == null)
		{
			state = decideState();
			if (state != null)
				state.enable();
			return;
		}

		state.update(elapsed);

		if (state != null && state.shouldDisable())
		{
			state.disable();
			state = null;
			return;
		}
	}

	function decideState()
	{
		for (s in states)
			if (s.shouldEnable())
				return s;
		return null;
	}
}
