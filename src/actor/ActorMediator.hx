package actor;
import openfl.geom.Point;
import openfl.display.Sprite;

/**
 * Actorの操作を行うクラス
 * @author sigmal00
 */
class ActorMediator
{
	public var container:Sprite = new Sprite();
	private var pm:PlayerManager;
	private var enemies:List<Actor> = new List<Actor>();
	private var deadMan:List<Actor> = new List<Actor>();
	private var bullets:List<Bullet> = new List<Bullet>();

	
	public function new() 
	{
		BulletProducer.setup(bullets, container);
		for(y in 0...Game.stage.getHeight()){
			for(x in 0...Game.stage.getWidth()){
				switch(Game.stage.map[y][x]){
				case "11":
					var e = new Enemy2(Game.GRID_SIZE*x,Game.GRID_SIZE*y, bullets);
					container.addChild(e.container);
					enemies.add(e);
					Game.stage.map[y][x] = "0";
				default:
				}
			}
		}
		pm = new PlayerManager(container, deadMan);
	}
	
	public function update(){
		enemyControl();
		bulletControl();
		var end = pm.playerControl();
		var it:Iterator<Actor> = deadMan.iterator();
		while (it.hasNext()){
			var d = it.next();
			if(!d.update()){
				container.removeChild(d.container);
				deadMan.remove(d);
			}
		}
	}
	
	public function getSubject():Point{
		return pm.subject;
	}

	private function bulletControl(){
		var it:Iterator<Bullet> = bullets.iterator();
		while (it.hasNext()){
			var b = it.next();
			b.update();
			
			var p:Actor = pm.pc;
			var it:Iterator<Actor> = pm.npc.iterator();
			while(true){
				if ((!b.dead) && b.container.hitTestObject(p.container)){
					b.hitAffect(p);
				}
				if (!it.hasNext()) break;
				p = it.next();
			}
			
			if(b.dead){
				container.removeChild(b.container);
				bullets.remove(b);
			}
		}
	}
	
	private function enemyControl(){
		var eIt:Iterator<Actor> = enemies.iterator();
		while (eIt.hasNext()){
			var e = eIt.next();
			if (Math.abs(e.container.x - pm.subject.x) > Game.width/2) continue;
			
			var p:Actor = pm.pc;
			var pIt:Iterator<Actor> = pm.npc.iterator();
			while(!(e.invincible > 0 || e.state.act == State.actions.DEAD)){
				if (e.container.hitTestObject(p.container)){
					p.hitAffect(e);
					e.hitAffect(p);
				}
				if (!pIt.hasNext()) break;
				p = pIt.next();
			}

			e.update();
			if(e.state.act == State.actions.DEAD){
				deadMan.add(e);
				enemies.remove(e);
			}
		}
	}
	
}