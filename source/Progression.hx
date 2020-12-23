package;

import flixel.util.FlxSave;

class Progression
{
	public var progress(default, null):FlxSave;

	public function new()
	{
		progress = new FlxSave();
		progress.bind("progress");
		if (progress.data.progress != null)
			return;
		progress.data.progress = 0;
		progress.flush();
	}

	public function canAccessLevel(lv:Int)
	{
		return progress.data.progress + 1 >= lv;
	}

	public function finishLevel(lv:Int)
	{
		progress.data.progress = Math.max(progress.data.progress, lv);
		progress.flush();
	}
}
