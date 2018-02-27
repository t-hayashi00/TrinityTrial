package actor;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author sigmal00
 */
class Actor 
{
	public var container:Sprite = new Sprite();
	private var v:Point = new Point(0, 0);
	private var t:Float = 0;
	
	private var divW:Int;
	private var divH:Int;
	private var jumped:Int = 2;

	public var command:UInt = Module.command.FREE;
	public var state:State = TRAIL;
	
	public function new(x:Float, y:Float, w:Float, h:Float) 
	{
		container.x = x;
		container.y = y;
		container.graphics.beginFill(0xFFF00F,1.0);
		container.graphics.drawRect(0, 0, w, h);
		divW = Math.floor((container.width-1) / Game.GRID_SIZE) + 2;
		divH = Math.floor((container.height-1) / Game.GRID_SIZE) + 2;
	}

	public function update(){
		if (state == DEAD) return;
		t += if (isLimitBreak()) 0.01 else 0.02;
		v.y += t;
		
		if (isLimitBreak()) command = Module.command.FREE;
		
		if(checkCommand(Module.command.RIGHT)){
			var tmp:Float = v.x;
			v.x = 1;
			v.x += tmp;
		}
		if(checkCommand(Module.command.LEFT)){
			var tmp:Float = v.x;
			v.x = -1;
			v.x += tmp;
		}
		if(checkCommand(Module.command.UP)){
			if(jumped > 0){
				t = 0;
				v.y = -4;
			}
			command = command&(~Module.command.UP);
		}
		
		if (v.y > Game.MAX_SPEED) v.y -= t;
		
		hitTerrain();
		
		if(checkCommand(Module.command.RIGHT)){
			v.x *= 0.5;
		}
		if(checkCommand(Module.command.LEFT)){
			v.x *= 0.5;
		}
		v.x *= 0.99;
		if (0.001 <= v.x && v.x < 0.001) v.x = 0;
		if (0.001 <= v.y && v.y < 0.001) v.y = 0;
	}
	
	private function checkCommand(check:UInt):Bool{
		return (command & check == check);
	}
	
	
	public function addForce(f:Point, reset:Bool):Void{
		if (reset){
			v = new Point(0, 0);
			t = 0;
		}
		v = v.add(f);
	}
	
	public function getVelocity():Point{
		return v;
	}
	
	public function inRange(x:Float, y:Float, radius:Float):Bool{
		return (x - container.x) * (x - container.x) + (y - container.y) * (y - container.y) <= radius*radius;
	}
	
	private function hitTerrain(){
		var divV:Int = 8;
		var tmp:Point = new Point(v.x / divV, v.y / divV);
		var hitX:Bool = false;
		var hitY:Bool = false;
		for (i in 0...divV){
			if (!hitY){
				container.y += tmp.y;
				for(j in 0...divW){
					var over:String = Game.stage.getIDByFloat(container.x + j * container.width/ (divW-1) , container.y);
					var under:String = Game.stage.getIDByFloat(container.x + j * container.width / (divW - 1) , container.y + container.height);
					if (under == "-1"){
						trace("dead");
						state = DEAD;
						return;
					}
					if(under != "0"){
						jumped = 2;
					}else{
						jumped = -1;
					}
					if (over != "0" || under != "0"){
						container.y -= tmp.y;
						v.x *= if (isLimitBreak())0.999 else 0.8;
						v.y *= if (isLimitBreak()) -0.99 else 0;
						t = 0;
						hitY = true;
						break;
					}
				}
			}
			if(!hitX){
				container.x += tmp.x;
				for(j in 0...divH){
					var left:String = Game.stage.getIDByFloat(container.x , container.y + j * container.height / (divH - 1) );
					var right:String = Game.stage.getIDByFloat(container.x + container.width , container.y + j * container.height / (divH-1) );
					if (left != "0" || right != "0"){
						container.x -= tmp.x;
						v.x *= if (isLimitBreak()) -0.99 else -0.1;
						hitX = true;
						break;
					}
				}
			}
			if(hitX && hitY){
				break;
			}
		}
	}

	private function isLimitBreak():Bool{
		return Math.sqrt(v.x * v.x + v.y * v.y) >= Game.FC_VELOCITY;
	}
}