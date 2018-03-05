package actor;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * Actorの操作を行うクラス
 * @author sigmal00
 */
class ActorManager
{
	public var container:Sprite = new Sprite();
	private var pm:PlayerManager;
	private var enemies:List<Actor> = new List<Actor>();
	private var deadMan:List<Actor> = new List<Actor>();
	private var bullets:List<Bullet> = new List<Bullet>();

	
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
		BulletGenerator.setup(bullets, container);
	}
	
	var time:Int = 0;
	public function update(){
		time++;
		if(time%180==0){
			BulletGenerator.setBullet1(0, 0, pm.pc.container.x, pm.pc.container.y, 3);
		}
		enemyControl();
		bulletControl();
		var end = pm.playerControl();
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
					trace("check");
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