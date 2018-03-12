package actor.enemy;

/**
 * ...
 * @author sigmal00
 */
class EnemyFactory 
{

	public static function getEnemy(enemyNum:Int, x:Float, y:Float, bullets:List<Bullet>):Enemy
	{
		var e:Enemy;
		switch(enemyNum){
		case 11:
			e = new Gunner(x, y, bullets);
		case 12:
			e = new Walker(x, y, bullets);
		default:
			e = null;
		}
		return e;
	}
	
}