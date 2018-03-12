package actor.enemy;
import actor.enemy.Bullet;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * Bulletの生成を管理するクラス
 * bulletsに参照を渡すとメソッドを呼ぶ度にListにBulletを追加する。
 * @author sigmal00
 */
class BulletGenerator
{
	private var bullets:List<Bullet>;
	private var container:Sprite;

	public function new ()
	{
	}

	public function setup(bullets_:List<Bullet>, container_:Sprite)
	{
		this.bullets = bullets_;
		this.container = container_;
	}

	public function addBullet(pattern:Int, fromX:Float, fromY:Float, toX:Float, toY:Float, thrust:Float)
	{
		switch (pattern)
		{
			case 1:
				addBullet1(fromX, fromY, toX, toY, thrust);
			case 2:
				addBullet2(fromX, fromY, toX, toY, thrust);
			default:
		}
	}

	private function addBullet1(fromX:Float, fromY:Float, toX:Float, toY:Float, thrust:Float)
	{
		if (bullets == null || container == null) return;
		var v:Point = new Point (toX - fromX, toY - fromY);
		v.normalize(thrust);
		var b:Bullet = new Bullet(fromX, fromY+3, v.x, v.y, 0, 0, 1, 180, false, false);
		bullets.add(b);
		container.addChild(b.container);
	}

	private function addBullet2(fromX:Float, fromY:Float, toX:Float, toY:Float, thrust:Float)
	{
		if (bullets == null || container == null) return;
		var v:Point = new Point (toX - fromX, toY - fromY);
		v.normalize(thrust);
		var v2 = Module.rotateVector2D(v, -10);
		var b:Bullet = new Bullet(fromX, fromY+3, v2.x, v2.y, 0, 0, 1, 180, false, false);
		bullets.add(b);
		container.addChild(b.container);
		var b:Bullet = new Bullet(fromX, fromY+3, v.x, v.y, 0, 0, 1, 180, false, false);
		bullets.add(b);
		container.addChild(b.container);
		v2 = Module.rotateVector2D(v, 10);
		var b:Bullet = new Bullet(fromX, fromY+3, v2.x, v2.y, 0, 0, 1, 180, false, false);
		bullets.add(b);
		container.addChild(b.container);
	}
}