package actor.enemy;
import openfl.geom.Point;

/**
 * 敵のスーパークラス
 * @author sigmal00
 */
class Enemy extends Actor
{
	public function new(x:Float, y:Float, w:Float, h:Float)
	{
		super(x, y, w, h);
		ATK = 0;
	}

	public override function hitAffect(e:Actor):Void
	{
		var f = new Point(e.container.x - container.x, e.container.y - container.y);
		var v = e.getVelocity();
		f.normalize(3);
		f.add(v);
		e.addForce(f, isLimitBreak());
		e.knockBack = 6;
		e.hitStop = 6;
		e.invincible = 30;
		e.HP -= if (!isLimitBreak()) ATK else ATK + 1;
	}
}