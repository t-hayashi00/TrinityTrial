package scene.ingame.actor.enemy;
import scene.ingame.actor.enemy.Bullet;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * Bulletの生成を管理するクラス
 * bulletsに参照を渡すとメソッドを呼ぶ度にListにBulletを追加する。
 * @author sigmal00
 */
class BulletGenerator extends Generator
{

	public function set(pattern:Int, fromX:Float, fromY:Float, toX:Float, toY:Float, thrust:Float):Bool
	{
		if (target == null || container == null) return false;
		return switch (pattern)
		{
			case 1:
				addBullet1(fromX, fromY, toX, toY, thrust);
			case 2:
				addBullet2(fromX, fromY, toX, toY, thrust);
			default:
				false;
		}
	}

	private function addBullet1(fromX:Float, fromY:Float, toX:Float, toY:Float, thrust:Float):Bool
	{
		var v:Point = new Point (toX - fromX, toY - fromY);
		v.normalize(thrust);
		var b:Bullet = new Bullet(fromX, fromY + 3, v.x, v.y, 0, 0, 1, 180, false, false);
		return add(b);
	}

	private function addBullet2(fromX:Float, fromY:Float, toX:Float, toY:Float, thrust:Float):Bool
	{
		var v:Point = new Point (toX - fromX, toY - fromY);
		var result:Bool = true;
		v.normalize(thrust);
		var v2 = Module.rotateVector2D(v, -10);
		var b:Bullet = new Bullet(fromX, fromY+3, v2.x, v2.y, 0, 0, 1, 180, false, false);
		result = add(b);
		var b:Bullet = new Bullet(fromX, fromY+3, v.x, v.y, 0, 0, 1, 180, false, false);
		result = add(b);
		v2 = Module.rotateVector2D(v, 10);
		var b:Bullet = new Bullet(fromX, fromY+3, v2.x, v2.y, 0, 0, 1, 180, false, false);
		result = add(b);
		return result;
	}
	
	private function aimForYourself(fromX:Float, fromY:Float, thrust:Float):Bool
	{
		var v:Point = new Point (PlayerManager.pcPos.x - fromX, PlayerManager.pcPos.y - fromY);
		v.normalize(thrust);
		var b:Bullet = new Bullet(fromX, fromY+3, v.x, v.y, 0, 0, 1, 180, false, false);
		return add(b);
	}
}