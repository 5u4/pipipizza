package modules.brains.statemachine;

interface IState
{
	public dynamic function shouldEnable():Bool;
	public dynamic function enable():Void;
	public dynamic function shouldDisable():Bool;
	public dynamic function disable():Void;
	public dynamic function handle(elapsed:Float):Void;
}
