package modules.brains.statemachine;

interface State
{
	function shouldEnable():Bool;
	function enable():Void;
	function shouldDisable():Bool;
	function disable():Void;
	function update(elapsed:Float):Void;
}
