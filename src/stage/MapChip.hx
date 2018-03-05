package stage;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.Assets;

/**
 * ...
 * @author sigmal00
 */
class MapChip 
{
	public var container:Sprite = new Sprite();
	public var image:Bitmap;

	public function new (fileName:String, x:Int, y:Int) {
		if(fileName != ""){
			image = new Bitmap(Assets.getBitmapData("img/chip.png"));
//			image = new Bitmap(Assets.getBitmapData("img/"+fileName));
			var drawArea:Rectangle = new Rectangle (0,0,Game.GRID_SIZE,Game.GRID_SIZE);
			drawArea.x = Game.GRID_SIZE*x;
			drawArea.y = Game.GRID_SIZE*y;
			image.scrollRect = drawArea;
			container.addChild(image);
		}else{
			var c:Int = if (x == 1)0x00FF00; else 0x00FF00;
			container.graphics.beginFill(c,1.0);
			container.graphics.drawRect(0,0,16,16);
		}
	}
}