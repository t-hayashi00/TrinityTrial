package stage;

import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ステージの基底クラス
 * @author sigmal00
 */
class Stage_ 
{
	public var container:Sprite = new Sprite();
	public var bmp:Bitmap;
	public var showX:Float = 0;
	public var showY:Float = 0;
	public var map:Array<Array<String>> = new Array<Array<String>>();
	private var w:Int;
	private var h:Int;
	private var mapChip:BitmapData;
	
	private var chipKey:Map<Int,Int> = new Map<Int,Int>();

	public function new(stage:Int, floor:Int, fileName:String) {
		mapChip = Assets.getBitmapData("img/chip.png");
		var input:String;
		try{
			input = Assets.getText("img/stage" + stage+"-" + floor + ".csv");
		}catch(msg:String){
			input = "0";
			trace(msg);
		}		
		var tmp:Array<String> = input.split("\r\n");
		h = tmp.length;
		w = tmp[0].split(",").length;
		for(i in 0...tmp.length){
			map.push(cast(tmp[i].split(",")));
		}
		
		bmp = new Bitmap(new BitmapData(Game.GRID_SIZE * w, Game.GRID_SIZE * h));
		var cnt:Int = 0;
		var c:Int = 0x00CC00;
		for (y in 0...h){
			for (x in 0...w){
				var rect:Rectangle = new Rectangle(0, 0, Game.GRID_SIZE, Game.GRID_SIZE);
				chipKey.set(x+y*w,cnt++);
				switch(map[y][x]){
				case "1":
					rect.x = 16;
				default:
					rect.x = 0;
				}
				bmp.bitmapData.copyPixels(mapChip,rect,new Point (x*16,y*16));
			}
		}
		container.addChild(bmp);
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
	
	public function getPlayerPos():Point{
		for (y in 0...h){
			for (x in 0...w){
				if (map[y][x] == "10"){
					map[y][x] = "0";
					return new Point(x * 16, y * 16);
				}
			}
		}
		return new Point(16, 16);
	}
	
	public function getWidth():Int{
		return w;
	}
	
	public function getHeight():Int{
		return h;
	}
}