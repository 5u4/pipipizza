package modules;

class Component
{
	public var parent:Component;

	private var _entity:Entity;

	public function new() {}

	public function entity()
	{
		if (_entity != null)
			return _entity;
		if (parent == null)
			throw "Component missing parent node";
		setEntity(parent.entity());
		return _entity;
	}

	public function setEntity(entity:Entity)
	{
		_entity = entity;
	}

	public function update(elapsed:Float) {}
}
