package scene.ingame.actor.object;
import scene.ingame.actor.Actor;

/**
 * 次のフロアへ進む扉
 * @author sigmal00
 */
class Door extends Object
{
	public override function new(x:Float, y:Float)
	{
		cr = 0x000000;
		super(x, y, 16, 24);
		container.y -= 8;
	}

	public override function hitAffect(e:Actor):Void
	{
		state.act = State.actions.DEAD;
		InGame.goToNextFloor();
	}

}