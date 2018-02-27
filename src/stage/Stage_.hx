package stage;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

/**
 * ...
 * @author sigmal00
 */
class Stage_ 
{
	public var container:Sprite = new Sprite();
	public var showX:Float = 0;
	public var showY:Float = 0;
	private var map:Array<Array<String>> = new Array<Array<String>>();
	private var w:Int;
	private var h:Int;
	private var fileName:String = "chip.png";
	
	private var chipKey:Map<Int,Int> = new Map<Int,Int>();

	public function new(stage:Int, floor:Int, fileName:String) {
		this.fileName = fileName;
		var input:String;
		try{
			input = Assets.getText("img/stage" + stage+"-" + floor + ".txt");
		}catch(msg:String){
			input = "0";
			trace(msg);
		}		
		var tmp:Array<String> = input.split("\r\n");
		h = tmp.length;
		w = tmp[0].split(" ").length;
		for(i in 0...tmp.length){
			map.push(cast(tmp[i].split(" ")));
		}
		
		var cnt:Int = 0;
		var c:Int = 0xFF0000;
		container.graphics.beginFill(c,1.0);
		for (y in 0...h){
			for (x in 0...w){
				switch(map[y][x]){
/*				case "2":
					chipKey.set(x+y*w,cnt++);
					var mapchip = new Bitmap(Assets.getBitmapData("img/chip.png"));
					container.addChild(mapchip);
					mapchip.x = 16*x;
					mapchip.y = 16*y;
*/				case "1":
					chipKey.set(x+y*w,cnt++);
					container.graphics.drawRect(16 * x, 16 * y, 16, 16);
				default:
				}
			}
		}
		trace("stage constructed");
	}

	public function getMapChip(x_:Float, y_:Float):DisplayObject{
		var x:Int = Math.floor(x_/ Game.GRID_SIZE);
		var y:Int = Math.floor(y_ / Game.GRID_SIZE);
		if (!(0 <= x && x < w) && (0 <= y && y <= h)){
			return null;
		}
		return container.getChildAt(chipKey.get(x + y * w));
	}
	
	public function getID(x:Int, y:Int):String{
		try{
			if ((0 <= x && x < w) && (0 <= y && y < h)){
				return map[y][x];
			}
			if(y > h+1){
				return "-1";
			}
			return "0";
		}
		catch (msg:String){
			trace(msg);
			return "-1";
		}
	}

	public function getIDByFloat(x_:Float, y_:Float):String{
		var x:Int = Math.floor(x_/ Game.GRID_SIZE);
		var y:Int = Math.floor(y_ / Game.GRID_SIZE);
		return getID(x,y);
	}
	
	public function getWidth():Int{
		return w;
	}
	
	public function getHeight():Int{
		return h;		
	}
	
	public function getFileName():String{
		return fileName;
	}
}