package modules;

class ComponentGroup extends Component
{
	public var components:Array<Component> = new Array<Component>();

	public function addComponent(component:Component)
	{
		component.parent = this;
		components.push(component);
	}

	public function addComponents(cs:Array<Component>)
	{
		for (component in cs)
			addComponent(component);
	}

	override function update(elapsed:Float)
	{
		for (component in components)
			component.update(elapsed);
		super.update(elapsed);
	}
}
