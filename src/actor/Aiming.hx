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
	public var degree:Float = 270;
	
	public function new() 
	{
		var bitmap:Bitmap = new Bitmap(Assets.getBitmapData("img/c_cursor.png"));
		bitmap.x -= 2;
		container.addChild(bitmap);
	}
	
	public function getRad():Float{
		return Math.PI / 180 * degree;
	}
	
}