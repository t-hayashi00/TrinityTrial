package scene.ingame.actor;
import openfl.geom.Point;
import openfl.display.Sprite;
import scene.ingame.actor.enemy.Bullet;
import scene.ingame.actor.enemy.BulletGenerator;
import scene.ingame.actor.enemy.EnemyGenerator;
import scene.ingame.actor.object.ObjectGenerator;

/**
 * Actorの操作を行うクラス
 * @author sigmal00
 */
class ActorMediator
{
	public var container:Sprite = new Sprite();
	private var pm:PlayerManager;
	private var ui:UserInterface;
	private var actors:List<Actor> = new List<Actor>();
	private var deadMan:List<Actor> = new List<Actor>();
	private var bullets:List<Bullet> = new List<Bullet>();
	public static var bulletGenerator:BulletGenerator = new BulletGenerator();
	public static var objectGenerator:ObjectGenerator = new ObjectGenerator();
	public static var enemyGenerator:EnemyGenerator = new EnemyGenerator();
	
	public function new(party:Int) 
	{
		bulletGenerator.setup(bullets, container);
		enemyGenerator.setup(actors, container);
		objectGenerator.setup(actors, container);
		for(y in 0...InGame.stage.getHeight()){
			for(x in 0...InGame.stage.getWidth()){
				enemyGenerator.set(Std.parseInt(InGame.stage.getID(x, y)), Game.GRID_SIZE * x, Game.GRID_SIZE * y);
				objectGenerator.set(Std.parseInt(InGame.stage.getID(x, y)), Game.GRID_SIZE * x, Game.GRID_SIZE * y);
			}
		}
		pm = new PlayerManager(container, deadMan, party);
		ui = new UserInterface(container, pm.npc);
	}
	
	public function update():Bool{
		actorUpdate();
		bulletUpdate();
		var isEnd = pm.playerUpdate();
		ui.update(pm.pc);
		var it:Iterator<Actor> = deadMan.iterator();
		while (it.hasNext()){
			var d = it.next();
			if (!d.update()){
				if(d.TYPE == "Enemy" || d.TYPE == "Player")InGame.animator.add("death",d.container.x + d.hitBox.width/2,d.container.y + d.hitBox.height/2);
				container.removeChild(d.container);
				deadMan.remove(d);
			}
		}
		return isEnd;
	}
	
	public function getSubject():Point{
		return pm.subject;
	}

	private function bulletUpdate(){
		var it:Iterator<Bullet> = bullets.iterator();
		while (it.hasNext()){
			var b = it.next();
			b.update();
			
			var p:Actor = pm.pc;
			var it:Iterator<Actor> = pm.npc.iterator();
			while(true){
				if ((!b.dead) && b.container.hitTestObject(p.hitBox)){
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
	
	private function actorUpdate(){
		var aIt:Iterator<Actor> = actors.iterator();
		while (aIt.hasNext()){
			var e = aIt.next();
			if (Math.abs(e.container.x - pm.subject.x) > Game.width/2) continue;
			
			var p:Actor = pm.pc;
			var pIt:Iterator<Actor> = pm.npc.iterator();
			while(!(e.invincible > 0 || e.state.act == State.actions.DEAD)){
				if (e.hitBox.hitTestObject(p.hitBox)){
					p.hitAffect(e);
					e.hitAffect(p);
				}
				if (!pIt.hasNext()) break;
				p = pIt.next();
			}

			e.update();
			if(e.state.act == State.actions.DEAD){
				deadMan.add(e);
				actors.remove(e);
			}
		}
	}	
}