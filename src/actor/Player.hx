package actor;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author sigmal00
 */
class Player extends Actor
{
	public var leader:Player = null;
	
	public function new(x:Float, y:Float, w:Float,h:Float) 
	{
		super(x, y, w, h);
	}
}