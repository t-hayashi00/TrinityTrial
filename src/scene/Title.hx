package scene;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.net.SharedObject;
import openfl.text.TextField;
import scene.Scene;
import openfl.ui.Keyboard;
import openfl.system.System;
using Sequencer;

/**
 * タイトルを表すシーン
 * @author sigmal00
 */
class Title extends Scene
{
	private var seq:Sequencer = new Sequencer(false);

	private var title:Bitmap = new Bitmap(Assets.getBitmapData("img/title.png"));

	public function new()
	{
		trace(System.totalMemory);
		title.scaleX = 1.05;
		title.scaleY = 1.05;
		for (i in 0...15)
		{
			seq.add(
			{
				title.scaleX -= 0.05/15;
				title.scaleY -= 0.05 / 15;
			});
			seq.wait(1);
		}
		var tf = new TextField();
		tf.text = "Press Z key to Start";
		tf.scaleX = 2.0;
		tf.scaleY = 2.0;
		tf.x = 30;
		tf.y = Game.height / 2 + 100;
		container.addChild(title);
		container.addChild(tf);
	}

	public override function update():Scene
	{
		if (!seq.run())return this;
		if (Module.isKeyPressed(Keyboard.Z))
		{
			var so:SharedObject = SharedObject.getLocal("saveData");
			if (so.data.stage == null) so.data.stage = 1;
			if (so.data.party == null) so.data.party = 1;
			return new InGame(so.data.stage, 1, so.data.party);
		}
		return this;
	}
}