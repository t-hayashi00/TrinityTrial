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
class Title extends scene.Scene
{
	private var seq:Sequencer = new Sequencer(false);

	private var title:Bitmap = new Bitmap(Assets.getBitmapData("img/title.png"));
	private var dispalyEffect:Sprite = new Sprite();

	public function new(game:Sprite)
	{
		this.game = game;
		trace(System.totalMemory);
		dispalyEffect.graphics.beginFill(0xFFFFFF, 1.0);
		dispalyEffect.graphics.drawRect(0, 0, Game.width, Game.height);
		title.scaleX = 1.05;
		title.scaleY = 1.05;
		seq.wait(30);
		for (i in 0...15)
		{
			seq.add(
			{
				dispalyEffect.alpha -= 1/15;
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
		game.addChild(dispalyEffect);
	}

	var result:Scene = this;
	public override function update():Scene
	{
		if (!seq.run())return this;
		if (Module.isKeyPressed(Keyboard.Z))
		{
			for (i in 0...15)
			{
				seq.add(dispalyEffect.alpha += 1/15);
				seq.wait(1);
			}
			seq.add(
			{
				teardown();
				result = new InGame(game, 0, 0);
			});
		}
		return result;
	}
}