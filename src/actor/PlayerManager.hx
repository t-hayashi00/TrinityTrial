package actor;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * 自機の操作を管理するクラス
 * @author sigmal00
 */
class PlayerManager 
{
	private var container:Sprite;
	private var isExtincted:Bool = false;
	private var bullet:Actor = null;
	private var aiming:Aiming = new Aiming();
	private var deadMan:List<Actor>;

	public var subject:Point = new Point();
	public var pc:Actor;
	public var npc:List<Actor> = new List<Actor>();

	public function new(parent:Sprite, deadMan:List<Actor>) 
	{
		this.deadMan = deadMan;
		container = parent;
		Game.display.addEventListener(MouseEvent.CLICK, throwing);
		for(i in 0...3){
			var p = new Player(16 * (i + 2), 16, 12, 16);
			container.addChild(p.container);
			npc.add(p);
		}
		pc = npc.pop();	
	}
	
	public function playerControl():Bool{
		if(!isExtincted){
			pcControl();
			npcControl();
			subjectUpdate();
		}
		return isExtincted;
	}

	private function pcControl(){
		pc.command = Module.command.FREE;
		if (Module.isKeyPressed(Keyboard.Q)){
			changeControl(false,true);
		}
		if (Module.isKeyPressed(Keyboard.E)){
			changeControl(false,false);
		}
		if (Module.isKeyPressed(Keyboard.SHIFT)){
			generatePlayer();
		}
		if (Module.isKeyPressed(Keyboard.W)){
			gather();
		}
		else if (Module.isKeyPressed(Keyboard.S)){
			disband();
		}
		if (Module.isKeyDown(Keyboard.A)){
			pc.command += Module.command.LEFT;
		}
		if (Module.isKeyDown(Keyboard.D)){
			pc.command += Module.command.RIGHT;
		}
		if (Module.isKeyPressed(Keyboard.SPACE)){
			pc.command += Module.command.UP;
		}
		if (pc.state == DEAD)pc.command = Module.command.FREE;
		pc.update();
		if (pc.isLost()){
			container.removeChild(pc.container);
			changeControl(true,false);
		}
	}
	
	private function npcControl(){
		var it:Iterator<Actor> = npc.iterator();
		var previous = pc;
		while (it.hasNext()){
			var p = it.next();
			p.update();
			p.command = Module.command.FREE;
			if (p.state == DEAD){
				deadMan.add(p);
				npc.remove(p);
			}
			if(p.state == TRAIL){
				if (previous.container.y - p.container.y <= -24) p.command += Module.command.UP;
				if (previous.container.x - p.container.x >= 16) p.command += Module.command.RIGHT;
				if (previous.container.x - p.container.x <= -16) p.command += Module.command.LEFT;
				previous = p;
			}
		}
		if (bullet != null){
			bullet.container.x = pc.container.x;
			bullet.container.y = pc.container.y;
		}
	}
	
	private function subjectUpdate(){
		if (pc.isLost()) return;
		subject.setTo(pc.container.x, pc.container.y - 48);
		if (bullet != null){
			var radius:Point = new Point(container.parent.mouseX - pc.container.x, container.parent.mouseY - pc.container.y);
			radius.normalize(96);
			aiming.container.x = pc.container.x + radius.x;
			aiming.container.y = pc.container.y + radius.y;
		}
		if (subject.x < (Game.width/2) / container.parent.scaleX){
			subject.x = (Game.width/2) / container.parent.scaleX;
		}
		if (subject.x > (Game.stage.getWidth()*16) - (Game.width/2 / container.parent.scaleX)){
			subject.x = (Game.stage.getWidth()*16) - (Game.width/2 / container.parent.scaleX);
		}
		if (subject.y < Game.height/2 / container.parent.scaleY){
			subject.y = Game.height/2 / container.parent.scaleY;
		}
		if (subject.y > (Game.stage.getHeight()*16) - (Game.height/2 / container.parent.scaleY)){
			subject.y = (Game.stage.getHeight()*16) - (Game.height/2 / container.parent.scaleY);
		}
	}
		
	private function throwing(e:MouseEvent):Void{
		if(bullet == null){
			var it:Iterator<Actor> = npc.iterator();
			while (it.hasNext()){
				var p = it.next();
				var inside:Point = new Point(pc.container.x - p.container.x, pc.container.y - p.container.y);
				if ((-20 < inside.x && inside.x < 20)&&(-20 < inside.y && inside.y < 20)){
					bullet = p;
					container.addChild(aiming.container);
					break;
				}
			}
		}
		else{
			bullet.state = WAIT;
			var v:Point = new Point(container.parent.mouseX - bullet.container.x, container.parent.mouseY - bullet.container.y);
			v.normalize(Game.FC_VELOCITY + 1);
			v.add(pc.getVelocity());
			bullet.addForce(v,true);
			bullet = null;
			container.removeChild(aiming.container);
		}
	}
	
	private function gather(){
		var it:Iterator<Actor> = npc.iterator();
		while (it.hasNext()){
			var p = it.next();
			p.state = TRAIL;
		}
	}
	
	private function disband(){
		var it:Iterator<Actor> = npc.iterator();
		while (it.hasNext()){
			var p = it.next();
			p.state = WAIT;
		}
	}
	
	private function changeControl(dead:Bool, reverse:Bool){
		if (npc.length == 0){
			if (dead){
				isExtincted = true;
				trace("game over!");
			}
			return;
		}
		bullet = null;
		container.removeChild(aiming.container);
		if (!dead){
			pc.state = WAIT;
			if (reverse) npc.push(pc);
			else npc.add(pc);
		}
		if (reverse){
			pc = npc.last();
			npc.remove(pc);
		}
		else pc = npc.pop();
		pc.addForce(new Point(0, -1), false);
		var it:Iterator<Actor> = npc.iterator();
		while (it.hasNext()){
			var p = it.next();
			p.state = WAIT;
			if (pc.inRange(p.container.x, p.container.y, 32)){
				p.state = TRAIL;
			}
		}
	}
	
	private function generatePlayer(){
		if(npc.length >= 2){
			return ;
		}
		var p = new Player(pc.container.x, pc.container.y, 12, 16);
		container.addChild(p.container);
		p.addForce(new Point(0, -1), true);
		npc.add(p);
	}
}