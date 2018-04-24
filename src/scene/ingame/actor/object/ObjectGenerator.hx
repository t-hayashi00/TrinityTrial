package scene.ingame.actor.object;
import scene.ingame.actor.Generator;

/**
 * Objectの生成を管理するクラス
 * @author sigmal00
 */
class ObjectGenerator extends Generator
{
	private var map:Map<Int, Block> = new Map<Int, Block>();

	public function set(objectNum:Int, x:Float, y:Float):Bool
	{
		var o:Object = null;
		switch(objectNum){
		case 11:
			o = new Door(x, y);
			InGame.stage.setIDByFloat(x, y, "0");
		case 12:
			var b = new Block(x, y, map);
			map.set(Math.floor(x + y*InGame.stage.getWidth()), b);
			o = b;
			InGame.stage.setIDByFloat(x, y, "1");
		case 13:
			o = new BombBlock(x, y, map);
			InGame.stage.setIDByFloat(x, y, "2");
		case 14:
			o = new Trampoline(x, y);
			InGame.stage.setIDByFloat(x, y, "0");
		default:
			return false;
		}
		return add(o);
	}	
}