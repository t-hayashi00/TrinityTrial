package scene.ingame.actor.object;

/**
 * ...
 * @author sigmal00
 */
class Object extends Actor
{
	public override function update():Bool
	{
		knockBack = 0;
		invincible = 0;
		shellCount = 0;
		hitStop = 0;
		return true;
	}	
}