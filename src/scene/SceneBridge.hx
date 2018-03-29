package scene;

import openfl.display.Sprite;

/**
 * 各シーンの橋渡しを行うクラス
 * @author sigmal00
 */
class SceneBridge extends Scene
{
	private var seq:Sequencer = new Sequencer(false);

	public function new(game:Sprite)
	{
		this.game = game;
	}

	public override function update():Scene
	{
		return this;
	}
}