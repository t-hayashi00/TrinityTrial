package scene.ingame.actor.enemy;
import scene.ingame.actor.Generator;

/**
 * Enemyの生成管理を行うクラス
 * @author sigmal00
 */
class EnemyGenerator extends Generator
{

	public function set(enemyNum:Int, x:Float, y:Float):Bool
	{
		var e:Enemy = null;
		switch(enemyNum){
		case 20:
			e = new Walker(x, y);
		case 21:
			e = new Gunner(x, y);
		case 22:
			e = new Bloomer(x, y, target);
		case 23:
			e = new Boss1(x, y);
			add(new BossObserver(e));
		default:
			return false;
		}
		InGame.stage.setIDByFloat(x, y, "0");
		return add(e);
	}
}