package scene;
import openfl.display.Sprite;

/**
 * ゲームのシーンを表す基底クラス
 * @author sigmal00
 */
class Scene
{
	public var container:Sprite = new Sprite();

	public function update():Scene
	{
		return this;
	}
}