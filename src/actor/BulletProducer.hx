package actor;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * Bulletの生成を管理するクラス
 * bulletsに参照を渡すとメソッドを呼ぶ度にListにBulletを追加する。
 * @author sigmal00
 */
class BulletProducer 
{
	static public var bullets:List<Bullet>;
	static public var container:Sprite;
	
	static public function setup(bullets_:List<Bullet>, container_:Sprite){
		bullets = bullets_;
		container = container_;
	}
	
	static public function setBullet1(fromX:Float, fromY:Float, toX:Float, toY:Float, thrust:Float){
		if (bullets == null || container == null) return;
		var v:Point = new Point (toX - fromX, toY - fromY);
		v.normalize(thrust);
		var b:Bullet = new Bullet(fromX, fromY+3, v.x, v.y, 0, 0, 1, 180, false, false);
		bullets.add(b);
		container.addChild(b.container);
	}
	
	static public function setBullet2(fromX:Float, fromY:Float, toX:Float, toY:Float, thrust:Float){
		if (bullets == null || container == null) return;
		var v:Point = new Point (toX - fromX, toY - fromY);
		v.normalize(thrust);
		var v2 = Module.rotateVector2D(v, -10);
		var b:Bullet = new Bullet(fromX, fromY+3, v2.x, v2.y, 0, 0, 1, 180, true, false);
		bullets.add(b);
		container.addChild(b.container);
		var b:Bullet = new Bullet(fromX, fromY+3, v.x, v.y, 0, 0, 1, 180, true, false);
		bullets.add(b);
		container.addChild(b.container);
		v2 = Module.rotateVector2D(v, 10);
		var b:Bullet = new Bullet(fromX, fromY+3, v2.x, v2.y, 0, 0, 1, 180, true, false);
		bullets.add(b);
		container.addChild(b.container);
	}	
}