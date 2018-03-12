package actor;

import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * 自機や敵などの基底クラス
 * 地形や加わっている力に沿って動作する
 * @author sigmal00
 */
class Actor 
{
	public var container:Sprite = new Sprite();
	public var hitBox:Sprite = new Sprite();
	
	private var v:Point = new Point(0, 0);
	private var a:Float = 0;
	private var t:Float = 0;
	private var cr:UInt;
	
	private var divW:Int;
	private var divH:Int;
	private var jumped:Int = 2;
	private var lostCount:Int = 60;

	public var state:State = new State();
	
	public var HP:Int = 1;
	public var ATK:Int = 0;
	public var knockBack:Int = 0;
	public var invincible:Int = 0;
	public var shellCount:Int = 0;
	public var hitStop:Int = 0;
	
	public function new(x:Float, y:Float, w:Float, h:Float) 
	{
		container.x = x;
		container.y = y;
		container.addChild(hitBox);
		hitBox.graphics.beginFill(cr,1);
		hitBox.graphics.drawRect(0, 0, w, h);
		divW = Math.floor((hitBox.width-1) / Game.GRID_SIZE) + 2;
		divH = Math.floor((hitBox.height-1) / Game.GRID_SIZE) + 2;
	}

	public function update():Bool{
		if (hitStop > 0){
			hitStop--;
			return true;
		}
		if (HP <= 0){
			if (lostCount == 60) hitStop = 15;
			state.act = State.actions.DEAD;
			lostCount--;
		}
		invincible--;
		
		a = if (isLimitBreak()) 0.001 else 0.02;
		t++;
		v.y += a*t;
		
		if (isLimitBreak() || knockBack > 0) state.command = State.commands.FREE;
		if (knockBack > 0) knockBack--;
		
		if (state.act == State.actions.DEAD)state.command = State.commands.FREE;
		if(checkCommand(State.commands.RIGHT)){
			var tmp:Float = v.x;
			v.x = 1;
			v.x += tmp;
		}
		if(checkCommand(State.commands.LEFT)){
			var tmp:Float = v.x;
			v.x = -1;
			v.x += tmp;
		}
		if(checkCommand(State.commands.UP)){
			if(jumped > 0){
				t = 0;
				v.y = -4.5;
			}
			state.command = state.command&(~State.commands.UP);
		}
		
		if (v.y > Game.MAX_SPEED) v.y -= a*t;
		
		hitTerrain();
		
		if(checkCommand(State.commands.RIGHT)){
			v.x *= 0.5;
		}
		if(checkCommand(State.commands.LEFT)){
			v.x *= 0.5;
		}
		v.x *= 0.99;
		if (0.001 <= v.x && v.x < 0.001) v.x = 0;
		if (0.001 <= v.y && v.y < 0.001) v.y = 0;
		
		if (isLimitBreak()){
			shellCount--;
		}
		return lostCount > 0;
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

	public function getAirTime():Float{
		return t;
	}	
	
	public function hitAffect(e:Actor):Void{
		var f = new Point(e.container.x - container.x, e.container.y - container.y);
		var v = e.getVelocity();
		f.normalize(3);		
		f.add(v);
		e.addForce(f, isLimitBreak());
		e.knockBack = 6;
		e.hitStop = 6;
		e.invincible = 30;
		e.HP -= if (!isLimitBreak()) ATK else ATK + 1;
	}

	public function isLimitBreak():Bool{
		return shellCount > 0;
		//return Math.sqrt(v.x * v.x + v.y * v.y) >= Game.FC_VELOCITY;
	}
	
	public function inRange(x:Float, y:Float, radius:Float):Bool{
		return (x - container.x) * (x - container.x) + (y - container.y) * (y - container.y) <= radius*radius;
	}
	
	private function checkCommand(check:UInt):Bool{
		return (state.command & check == check);
	}
	
	private function hitTerrain(){
		var isBuried:Bool = true;
		while (isBuried){
			isBuried = false;
			for (j in 0...divW){
				var under:String = Game.stage.getIDByFloat(container.x, container.y + hitBox.height);
				if (under != "0"){
					container.y -= 0.1;
					isBuried = true;
					break;
				}
			}
		}

		var isBuried:Bool = true;
		while (isBuried){
			isBuried = false;
			for (j in 0...divW){
				var over:String = Game.stage.getIDByFloat(container.x, container.y);
				if (over != "0"){
					container.y += 0.2;
					isBuried = true;
					break;
				}
			}
		}
		
		var divV:Int = 8;
		var tmp:Point = new Point(v.x / divV, v.y / divV);
		var hitX:Bool = false;
		var hitY:Bool = false;
		for (i in 0...divV){
			if (!hitY){
				container.y += tmp.y;
				for(j in 0...divW){
					var over:String = Game.stage.getIDByFloat(container.x + j * hitBox.width/ (divW-1) , container.y);
					var under:String = Game.stage.getIDByFloat(container.x + j * hitBox.width / (divW - 1) , container.y + hitBox.height);
					if (under == "-1"){
						trace("dead");
						HP = 0;
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
					var left:String = Game.stage.getIDByFloat(container.x , container.y + j * hitBox.height / (divH - 1) );
					var right:String = Game.stage.getIDByFloat(container.x + hitBox.width , container.y + j * hitBox.height / (divH-1) );
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
}