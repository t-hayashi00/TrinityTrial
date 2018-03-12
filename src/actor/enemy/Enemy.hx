package actor.enemy;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * 敵のスーパークラス
 * @author sigmal00
 */
class Enemy extends Actor
{
	public function new(x:Float, y:Float, w:Float, h:Float) 
	{
		cr = 0xFF0000;
		super(x, y, w, h);
		ATK = 0;
	}
}