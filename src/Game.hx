package;

import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.system.System;
import scene.*;
import openfl.text.TextField;
import scene.InGame;
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
		game.stage.addEventListener(Event.ENTER_FRAME, update);
	}
	
	public function setup():Void
	{
		scene = new Title(game);
	}
	
	var memory = new TextField();
	private function update(e:Event):Void
	{
		game.removeChild(memory);
		changeScene(scene.update());
		memory.text = Std.string(System.totalMemory);
		game.addChild(memory);
	}
	
	private function changeScene(nextScene:Scene):Void
	{
		scene = nextScene;
	}
	

}