package actor;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * マウスに沿って動く照準
 * @author sigmal00
 */
class Aiming 
{
	public var container:Sprite = new Sprite();
	private var degree:Float = 0;
	public var controlAng:Float = 60;
	
	public function new()
	{
		var bitmap:Bitmap = new Bitmap(Assets.getBitmapData("img/c_cursor.png"));
		bitmap.x -= 2;
		container.addChild(bitmap);
	}
	public function update(x:Float, y:Float, dir:Int){
		degree = 270 + controlAng * dir;
		container.x = x + Math.cos(Math.PI / 180 * degree)*64;
		container.y = y + Math.sin(Math.PI / 180 * degree)*64;
	}
}