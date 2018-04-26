package animator.animation;

import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author sigmal00
 */
class Particle
{
	public var container:Sprite = new Sprite();
	private var v:Point;
	private var a:Point;
	private var t:Int = 0;
	

	public function new(vx:Float = 0, vy:Float = 0, ax:Float = 0, ay:Float = 0, size:Float = 1, type:String = "circle", color:UInt = 0x000000)
	{
		v = new Point(vx, vy);
		a = new Point(ax, ay);
		container.graphics.beginFill(color, 1.0);
		if (type == "rect")
		{
			container.graphics.drawRect(0, 0, size, size);
		}
		else
		{
			container.graphics.drawCircle(0, 0, size);
		}
	}
	public function update()
	{
		v.x += a.x * t * 0.01;
		v.y += a.y * t * 0.01;
		container.x += v.x;	
		container.y += v.y;
		t++;
	}
}