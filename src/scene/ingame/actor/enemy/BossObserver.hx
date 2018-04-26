package scene.ingame.actor.enemy;
import scene.ingame.actor.Actor;

/**
 * ...
 * @author sigmal00
 */
class BossObserver extends Actor
{
	private var target:Actor;
	private var count:Int = 180;
	
	public override function new(target:Actor)
	{
		this.target = target;
		cr = 0x000000;
		super(0, 0, 1, 1);
		hitBox.alpha = 0;
	}

	public override function update():Bool
	{
		HP = 1;
		if (target.lostCount > 0) return true;
		count--;
		if(count == 0){
			InGame.gameEnd = true;
		}
		return true;
	}

	public override function hitAffect(e:Actor):Void
	{
	}

}