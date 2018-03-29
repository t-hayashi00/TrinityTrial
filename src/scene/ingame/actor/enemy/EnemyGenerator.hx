package scene.ingame.actor.enemy;
import openfl.display.Sprite;
import scene.ingame.actor.Generator;

/**
 * ...
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
		default:
			return false;
		}
		InGame.stage.setIDByFloat(x, y, "0");
		return add(e);
	}
}