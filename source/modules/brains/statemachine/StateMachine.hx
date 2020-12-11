package modules.brains.statemachine;

class StateMachine extends Component implements IState
{
	public var state:IState;
	public var states = new Array<IState>();

	public function new()
	{
		super();
	}

	public dynamic function shouldEnable()
	{
		return false;
	}

	public dynamic function enable() {}

	public dynamic function shouldDisable()
	{
		return false;
	}

	public dynamic function disable() {}

	public dynamic function handle(elapsed:Float)
	{
		if (state == null)
		{
			state = decideState();
			if (state != null)
				state.enable();
			return;
		}

		state.handle(elapsed);

		if (state != null && state.shouldDisable())
		{
			state.disable();
			state = null;
			return;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		handle(elapsed);
	}

	function decideState()
	{
		for (s in states)
			if (s.shouldEnable())
				return s;
		return null;
	}
}
