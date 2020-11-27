package modules;

import flixel.FlxSprite;

class Entity extends FlxSprite
{
	var components:Array<Component> = new Array<Component>();
	var entities:Array<Entity> = new Array<Entity>();

	public function addEntity(entity:Entity)
	{
		entities.push(entity);
	}

	public function removeEntity(entity:Entity)
	{
		entities.remove(entity);
	}

	public function addComponent(component:Component)
	{
		component.entity = this;
		components.push(component);
	}

	public function removeComponent(component:Component)
	{
		component.entity = null;
		components.remove(component);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		for (entity in entities)
			entity.update(elapsed);
		for (component in components)
			component.update(elapsed);
	}
}
