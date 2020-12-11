package modules.brains.statemachine;

class State implements IState
{
	public function new() {}

	public dynamic function shouldEnable()
	{
		return false;
	}

	public dynamic function enable() {}

	public dynamic function shouldDisable()
	{
		return true;
	}

	public dynamic function disable() {}

	public dynamic function handle(elapsed:Float) {}
}
