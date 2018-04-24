package scene.ingame.actor.enemy;
import openfl.geom.Point;
import scene.ingame.actor.Actor;

/**
 * 敵のスーパークラス
 * @author sigmal00
 */
class Enemy extends Actor
{
	public function new(x:Float, y:Float, w:Float, h:Float)
	{
		super(x, y, w, h);
		TYPE = "Enemy";
		ATK = 0;
	}

	public override function hitAffect(e:Actor):Void
	{
		var v = e.getVelocity();
		if (container.y - (e.container.y + e.hitBox.height) > -4 && v.y > 0){
			e.addForce(new Point(v.x, -3), true);
			HP -= 1;
		}else{
			var f = new Point(e.container.x - container.x, e.container.y - container.y);
			f.normalize(3);
			f.add(v);
			e.addForce(f, isLimitBreak());
			e.knockBack = 6;
			e.hitStop = 6;
			e.invincible = 30;
			e.HP -= if (!isLimitBreak()) ATK else ATK + 1;
		}
	}
}