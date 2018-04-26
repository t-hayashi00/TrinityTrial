package scene;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.text.TextField;
import scene.Scene;
import openfl.ui.Keyboard;

/**
 * ...
 * @author sigmal00
 */
class GameOver extends Scene
{
	private var title:Bitmap = new Bitmap(Assets.getBitmapData("img/title.png"));

	public function new()
	{
		var tf = new TextField();
		tf.text = "Thank you\n    for Playing!";
		tf.scaleX = 2.0;
		tf.scaleY = 2.0;
		tf.x = 30;
		tf.y = Game.height / 2 + 100;
		container.addChild(title);
		container.addChild(tf);
	}

	public override function update():Scene
	{
		if (Module.isKeyPressed(Keyboard.Z))
		{
			return new Title();
		}
		return this;
	}
}