package actor.enemy;
import openfl.geom.Point;

/**
 * ...
 * @author sigmal00
 */
class Trampoline extends Enemy
{
	public override function new(x:Float, y:Float)
	{
		cr = 0xEEEE00;
		super(x, y, 16, 16);
		ATK = 0;
	}

	public override function update():Bool
	{
		knockBack = 0;
		invincible = 0;
		shellCount = 0;
		hitStop = 0;
		return true;
	}

	public override function hitAffect(e:Actor):Void
	{
//		e.shellCount = 10;
		e.addForce(new Point(0, -8), true);
	}

}