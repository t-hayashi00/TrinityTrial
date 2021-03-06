package;

import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Matrix;

/**
 * キー入力などのゲーム全般で使用する機能をまとめたクラス
 * @author sigmal00
 */
class Module 
{
	static var keyPressBuffer:Array<Bool> = new Array<Bool>();
	static var keyInputBuffer:Array<Bool> = new Array<Bool>();
	static var keyHoldBuffer:Array<Int> = new Array<Int>();
	static var keyDoubleClick:Array<Int> = new Array<Int>();
	static var prePressed:Bool = false;

	static public function setup()
	{
		Game.display.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		Game.display.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}

	static public function isKeyDown(keyCode:UInt):Bool
	{
		return keyInputBuffer[keyCode];
	}

	static public function isKeyPressed(keyCode:UInt):Bool
	{
		var result:Bool = keyInputBuffer[keyCode] && !keyPressBuffer[keyCode];
		keyPressBuffer[keyCode] = keyInputBuffer[keyCode];
		return result;
	}
	
	static public function isKeyReleased(keyCode:UInt):Bool
	{
		var result:Bool = !keyInputBuffer[keyCode] && keyPressBuffer[keyCode];
		keyPressBuffer[keyCode] = keyInputBuffer[keyCode];
		return result;
	}
	
	static public function getKeyHoldTime(keyCode:UInt):Int
	{
		keyHoldBuffer[keyCode] = if (isKeyDown(keyCode)) keyHoldBuffer[keyCode] + 1 else 0;
		return keyHoldBuffer[keyCode];
	}

	static public function isKeyDoubleClick(keyCode:UInt):Bool
	{
		if(isKeyPressed(keyCode)){
			if (keyDoubleClick[keyCode] > 0)
			{
				keyDoubleClick[keyCode] = 0;
				return true;
			}
			else{
				keyDoubleClick[keyCode] = 20;
				return false;
			}
		}else if (keyDoubleClick[keyCode] > 0){
			keyDoubleClick[keyCode]--;
		}
		return false;
	}
	
	static public function toRad(degree:Float):Float{
		return Math.PI / 180 * degree;
	}

	static public function rotateVector2D(v:Point, degree:Float):Point{
		var mat:Matrix = new Matrix();
		mat.rotate(toRad(degree));
		return mat.deltaTransformPoint(v);
	}
	
	static private function keyDown(e:KeyboardEvent):Void
	{
		try{
			keyInputBuffer[e.keyCode] = true;
		}
		catch (msg:String)
		{
		}
	}

	static private function keyUp(e:KeyboardEvent):Void
	{
		try{
			keyInputBuffer[e.keyCode] = false;
		}
		catch (msg:String)
		{
		}
	}
}