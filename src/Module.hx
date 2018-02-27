package;

import openfl.events.KeyboardEvent;

/**
 * ...
 * @author t-hayashi00
 */
class Module 
{
	static public var command = {
		FREE:0x0,
		RIGHT:0x1,
		LEFT:0x2,
		UP:0x4
	};
	static var keyPressBuffer:Array<Bool> = new Array<Bool>();
	static var keyInputBuffer:Array<Bool> = new Array<Bool>();
	static var prePressed:Bool = false;

	static public function setup(){
		Game.display.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		Game.display.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
	static private function keyDown(e:KeyboardEvent):Void{
		try{
			keyInputBuffer[e.keyCode] = true;
		}
		catch (msg:String){
		}
	}
	
	static private function keyUp(e:KeyboardEvent):Void{
		try{
			keyInputBuffer[e.keyCode] = false;
		}
		catch (msg:String){
		}
	}
	
	static public function isKeyDown(keyCode:UInt):Bool{
		return keyInputBuffer[keyCode];
	}

	static public function isKeyPressed(keyCode:UInt):Bool{
		var result:Bool = keyInputBuffer[keyCode] && !keyPressBuffer[keyCode];
		keyPressBuffer[keyCode] = keyInputBuffer[keyCode];
		return result;
	}
}
