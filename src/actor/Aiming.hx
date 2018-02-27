package actor;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author sigmal00
 */
class Aiming 
{
	public var container:Sprite = new Sprite();
	public function new() 
	{
		var bitmap:Bitmap = new Bitmap(Assets.getBitmapData("img/c_cursor.png"));
		bitmap.x = -bitmap.width / 2;
		bitmap.y = -bitmap.height / 2;
		container.addChild(bitmap);
	}	
}