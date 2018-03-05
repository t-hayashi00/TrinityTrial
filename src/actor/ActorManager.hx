package actor;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * Playerの操作を行うクラス
 * @author sigmal00
 */
class ActorManager
{
	public var container:Sprite = new Sprite();
	private var pm:PlayerManager;
	private var enemies:List<Actor> = new List<Actor>();
	private var deadMan:List<Actor> = new List<Actor>();
	
	public function new() 
	{
		for(y in 0...Game.stage.getHeight()){
			for(x in 0...Game.stage.getWidth()){
				if(Game.stage.map[y][x] == "10"){
					var e = new Enemy(Game.GRID_SIZE*x,Game.GRID_SIZE*y,12,16);
					container.addChild(e.container);
					enemies.add(e);
					Game.stage.map[y][x] = "0";
				}
			}
		}
		pm = new PlayerManager(container, deadMan);
	}
	
	public function update(){
		enemyControl();
		var a = pm.playerControl();
		var it:Iterator<Actor> = deadMan.iterator();
		while (it.hasNext()){
			var d = it.next();
			d.update();
			if(d.isLost()){
				container.removeChild(d.container);
				deadMan.remove(d);
			}
		}
	}
	
	public function getSubject():Point{
		return pm.subject;
	}


	private function enemyControl(){
		var eIt:Iterator<Actor> = enemies.iterator();
		while (eIt.hasNext()){
			var e = eIt.next();
			if (Math.abs(e.container.x - pm.subject.x) > Game.width) continue;
			
			var p:Actor = pm.pc;
			var pIt:Iterator<Actor> = pm.npc.iterator();
			while(!(e.knockBack > 0 || e.state == DEAD)){
				if (e.container.hitTestObject(p.container)){
					e.hitAffect(p);
					p.hitAffect(e);
					Game.setShake(1,1,1);
				}
				if (!pIt.hasNext()) break;
				p = pIt.next();
			}

			e.update();
			if(e.state == DEAD){
				deadMan.add(e);
				enemies.remove(e);
			}
		}
	}
	
}