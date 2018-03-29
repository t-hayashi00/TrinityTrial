package;

import openfl.Assets;
import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BlendMode;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.system.System;
import scene.*;
import openfl.text.TextField;

using Sequencer;

/**
 * ゲーム本体
 * @author sigmal00
 */
class Game
{
	public static var display:Stage;
	public static var width:Float = 800;
	public static var height:Float = 480;
	public static var GRID_SIZE:Int = 16;
	public static var MAX_SPEED:Float = 4.3;
	public static var FC_VELOCITY:Float = 5.5;

	private var game:Sprite;

	public static var scene:scene.Scene;
	/*	private static var title:scene.Scene;
		private static var inGame:scene.Scene;
		private static var gemeOver:scene.Scene;
	*/

	public function new(game:Sprite)
	{
		this.game = game;
		display = game.stage;
		Module.setup();
		game.stage.frameRate = 60;
		game.scrollRect = new Rectangle(0, 0, width, height);
		trace(game.stage.width,game.stage.height);
		setup();
		screenSp.addChild(new Bitmap(Assets.getBitmapData("img/changeScene.png")));
		screenSp.x = -400;
		game.addChild(screenSp);
		game.stage.addEventListener(Event.ENTER_FRAME, update);
	}

	public function setup():Void
	{
		showScreen(5);
		scene = new Title(game);
	}

	private function update(e:Event):Void
	{
		screenSeq.run();
		changeScene(scene.update());
		game.addChild(screenSp);
	}

	private function changeScene(nextScene:Scene):Void
	{
		scene = nextScene;
	}
	
	static var screenSeq:Sequencer = new Sequencer(false);
	static var screenSp:Sprite = new Sprite();
	public static function hideScreen(time:Int)
	{
		if (time <= 0) time = 1;
		screenSeq.clear();
		screenSeq.add(
		{
			screenSp.alpha = 1;
			screenSp.x = -1600;
		});
		for (i in 0...time)
		{
			screenSeq.add(screenSp.x += 1200/time);
			screenSeq.wait(1);
		}
	}

	public static function showScreen(time:Int)
	{
		if (time <= 0) time = 1;
		screenSeq.clear();
		screenSeq.add(screenSp.x = -400);
		for (i in 0...time)
		{
			screenSeq.add(screenSp.x += 1200/time);
			screenSeq.wait(1);
		}
		screenSeq.add(screenSp.alpha = 0);
	}
}