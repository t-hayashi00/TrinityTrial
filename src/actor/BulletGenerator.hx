package actor;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * Bulletの生成を管理するクラス
 * bulletsに参照を渡すとメソッドを呼ぶ度にListにBulletを追加する。
 * @author sigmal00
 */
class BulletGenerator 
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
		trace(v);
		var b:Bullet = new Bullet(fromX, fromY, v.x, v.y, 0, 0, 1, 120, false, false);
		bullets.add(b);
		container.addChild(b.container);
	}	
}