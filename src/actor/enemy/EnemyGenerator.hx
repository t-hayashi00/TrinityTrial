package actor.enemy;
import openfl.display.Sprite;

/**
 * ...
 * @author sigmal00
 */
class EnemyGenerator 
{
	private var enemies:List<Actor>;
	private var bullets:List<Bullet>;
	private var container:Sprite;
	
	public function new()
	{
	} 
	
	public function setup(enemies:List<Actor>, bullets:List<Bullet>, container:Sprite)
	{
		this.enemies = enemies;
		this.bullets = bullets;
		this.container = container;
	}
	
	public function setEnemy(enemyNum:Int, x:Float, y:Float):Bool
	{
		var e:Enemy = null;
		switch(enemyNum){
		case 11:
			e = new Gunner(x, y, bullets);
		case 12:
			e = new Walker(x, y, bullets);
		case 13:
			e = new Trampoline(x, y);
		case 14:
			e = new Bloomer(x, y, enemies);
		default:
		}
		return addEnemy(e);
	}

	private function addEnemy(e:Actor):Bool
	{
		if (e == null) return false;
		container.addChild(e.container);
		enemies.add(e);
		return true;
	}
}