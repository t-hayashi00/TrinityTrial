package scene.ingame.stage;

import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ステージを表すクラス
 * このクラスの保持する情報は色々なクラスから要求されるのでpublicフィールドのメンバが多い
 * @author sigmal00
 */
class Stage_
{
	public var container:Sprite = new Sprite();
	public var upper:Bitmap;
	public var lower:Bitmap;
	public var showX:Float = 0;
	public var showY:Float = 0;
	private var map:Array<Array<String>> = new Array<Array<String>>();
	private var w:Int;
	private var h:Int;
	private var mapChip:BitmapData;

//	private var chipKey:Map<Int,Int> = new Map<Int,Int>();

	public function new(stage:Int, floor:Int, fileName:String)
	{
		mapChip = Assets.getBitmapData("img/chip.png");
		var input:String;
		try
		{
			input = Assets.getText("img/stage/stage" + stage+"-" + floor + ".csv");
		}
		catch (msg:String)
		{
			input = "0,10,0";
			trace(msg);
		}
		var tmp:Array<String> = input.split("\r\n");
		h = tmp.length;
		w = tmp[0].split(",").length;
		for (i in 0...tmp.length)
		{
			map.push(cast(tmp[i].split(",")));
		}

		
		lower = new Bitmap(new BitmapData(Game.GRID_SIZE * w, Game.GRID_SIZE * h, true, 0x00000000));
		container.addChild(lower);
		
		upper = new Bitmap(new BitmapData(Game.GRID_SIZE * w, Game.GRID_SIZE * h, true, 0x00000000));
		container.addChild(upper);

		var cnt:Int = 0;
		var c:Int = 0x00CC00;
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var rect:Rectangle = new Rectangle(0, 0, Game.GRID_SIZE, Game.GRID_SIZE);
//				chipKey.set(x+y*w,cnt++);
				switch (getID(x, y))
				{
					case "1":
						rect.x = 16;
						rect.x += if (getID(x - 1, y) != "1")16 else 0;
						rect.x += if (getID(x + 1, y) != "1")32 else 0;
						if (getID(x, y-1) != "1")
						{
							rect.y = 64;
							lower.bitmapData.copyPixels(mapChip,rect,new Point (x*16,(y-1)*16));
							rect.y = 16;
						}
						rect.y += if (getID(x, y+1) != "1") 32 else 0;
					case "2":
						rect.x = 80;
						rect.x += if (getID(x - 1, y) != "2")16 else 0;
						rect.x += if (getID(x + 1, y) != "2")32 else 0;
						rect.y = if (getID(x, y - 1) != "2") 0 else 32;
						lower.bitmapData.copyPixels(mapChip, rect, new Point (x * 16, (y - 1) * 16));
						rect.y = 16;
					case "100":
						var w = new Window(x * 16, y * 16, 100, 28, "Z ... Jump\nLEFT , RIGHT ... Move", false);
						container.addChild(w.container);
						map[y][x] = "0";
					case "101":
						var w = new Window(x * 16, y * 16, 150, 28, "SHIFT Hold ... Growth\nSHIFT Doudle ... Change Control", false);
						container.addChild(w.container);
						map[y][x] = "0";
					case "102":
						var w = new Window(x * 16, y * 16, 150, 28, "X Hold -> Release ... Throw\nUP , DOWN ... Aiming", false);
						container.addChild(w.container);
						map[y][x] = "0";
					case "103":
						var w = new Window(x * 16, y * 16, 100, 28, "A ... Gather\nS ... Disband", false);
						container.addChild(w.container);
						map[y][x] = "0";
					default:
						rect.x = 0;
						rect.y = 0;
				}
				lower.bitmapData.copyPixels(mapChip,rect,new Point (x*16,y*16));
			}
		}
		trace("stage constructed");
	}
/*
	public function getMapChip(x_:Float, y_:Float):DisplayObject
	{
		var x:Int = Math.floor(x_/ Game.GRID_SIZE);
		var y:Int = Math.floor(y_ / Game.GRID_SIZE);
		if (!(0 <= x && x < w) && (0 <= y && y <= h))
		{
			return null;
		}
		return container.getChildAt(chipKey.get(x + y * w));
	}
*/
	public function getID(x_:Float, y_:Float):String
	{
		var x:Int = Math.floor(x_);
		var y:Int = Math.floor(y_);
		try{
			if ((0 <= x && x < w) && (0 <= y && y < h))
			{
				return map[y][x];
			}
			if (y > h+2)
			{
				return "-1";
			}
			if (!(0 <= x && x < w)) return "1";
			return "0";
		}
		catch (msg:String)
		{
			trace(msg);
			return "-1";
		}
	}
	
	public function setID(x_:Float, y_:Float, ID:String):Bool
	{
		var x:Int = Math.floor(x_);
		var y:Int = Math.floor(y_);
		try{
			if ((0 <= x && x < w) && (0 <= y && y < h))
			{
				map[y][x] = ID;
				return true;
			}
			return false;
		}
		catch (msg:String)
		{
			trace(msg);
			return false;
		}
	}
	
	public function getIDByFloat(x_:Float, y_:Float):String
	{
		return getID(x_/ Game.GRID_SIZE, y_ / Game.GRID_SIZE);
	}

	public function setIDByFloat(x_:Float, y_:Float, ID:String):Bool
	{
		return setID(x_/ Game.GRID_SIZE, y_ / Game.GRID_SIZE, ID);
	}

	public function getPlayerPos():Point
	{
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				if (map[y][x] == "10")
				{
					map[y][x] = "0";
					return new Point(x * 16, y * 16);
				}
			}
		}
		return new Point(16, 16);
	}

	public function getWidth():Int
	{
		return w;
	}

	public function getHeight():Int
	{
		return h;
	}
}