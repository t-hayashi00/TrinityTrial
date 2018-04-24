package scene.ingame.actor.object;
import openfl.geom.Point;
import scene.ingame.actor.Actor;

/**
 * 踏むと高く飛び上がる
 * @author sigmal00
 */
class Trampoline extends Object
{
	public override function new(x:Float, y:Float)
	{
		cr = 0xEEEE00;
		super(x, y, 16, 16);
	}

	public override function hitAffect(e:Actor):Void
	{
//		e.shellCount = 10;
		e.addForce(new Point(0, -8), true);
	}

}