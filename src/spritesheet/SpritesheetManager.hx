package spritesheet;
import actor.Actor;
import openfl.display.Bitmap;

/**
 * スプライトシートを管理するクラスのスーパークラス
 * @author sigmal00
 */
class SpritesheetManager
{
	private var target:Actor;
	private var spritesheet:Bitmap = new Bitmap();

	public function new(target:Actor) 
	{
		this.target = target;
	}
	
	public function update():Void
	{
	}
	
}