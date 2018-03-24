package scene;
import openfl.display.Sprite;

/**
 * ゲームのシーンを表す基底クラス
 * @author sigmal00
 */
class Scene 
{
	private var game:Sprite;
	public function update():Scene
	{
		return this;
	}
	
	private function teardown():Void
	{
		game.removeChildren();		
	}
}