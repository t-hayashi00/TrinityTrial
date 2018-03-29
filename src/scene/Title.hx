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
 * ...
 * @author sigmal00
 */
class Title extends Scene
{
	private var seq:Sequencer = new Sequencer(false);

	private var title:Bitmap = new Bitmap(Assets.getBitmapData("img/title.png"));

	public function new(game:Sprite)
	{
		this.game = game;
		trace(System.totalMemory);
		title.scaleX = 1.05;
		title.scaleY = 1.05;
		seq.wait(30);
		seq.add(Game.showScreen(15));
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
		game.addChild(title);
		game.addChild(tf);
	}

	var result:Scene = this;
	public override function update():Scene
	{
		if (!seq.run())return this;
		if (Module.isKeyPressed(Keyboard.Z))
		{
			seq.add(Game.hideScreen(5));
			seq.wait(5);
			seq.add(
			{
				teardown();
				var so:SharedObject = SharedObject.getLocal("saveData");
				if (so.data.stage == null) so.data.stage = 1;
				if (so.data.party == null) so.data.party = 1;
				result = new InGame(game, so.data.stage, 1, so.data.party);
			});
			seq.wait(5);
		}
		return result;
	}
}