package modules;

import flixel.FlxSprite;

class Entity extends FlxSprite
{
	var components:Array<Component> = new Array<Component>();

	public function addComponent(component:Component)
	{
		component.setEntity(this);
		components.push(component);
	}

	public function addComponents(cs:Array<Component>)
	{
		for (component in cs)
			addComponent(component);
	}

	public function removeComponent(component:Component)
	{
		component.setEntity(null);
		components.remove(component);
	}

	override function update(elapsed:Float)
	{
		for (component in components)
			component.update(elapsed);
		super.update(elapsed);
	}
}
