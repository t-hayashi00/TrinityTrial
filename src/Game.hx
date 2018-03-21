package;

import stage.*;
import actor.*;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
/**
 * ゲーム本体
 * @author sigmal00
 */
class Game 
{
	public static var display:Stage;
	public static var width:Float;
	public static var height:Float;
	public static var GRID_SIZE:Int = 16;
	public static var MAX_SPEED:Float = 4.3;
	public static var FC_VELOCITY:Float = 5.5;
	public static var stage:Stage_;

	private var game:Sprite;
	private var field:Sprite = new Sprite();
	private var panorama:Bitmap = new Bitmap(Assets.getBitmapData("img/panorama.png"));
	private var actorMediator:ActorMediator;
	
	public function new(game:Sprite)
	{
		this.game = game;
		display = game.stage;
		Module.setup();
		width = panorama.width;
		height = panorama.height;
		game.addChild(panorama);
		game.stage.frameRate = 60;
		game.scrollRect = new Rectangle(0, 0, panorama.width, panorama.height);
		game.addChild(field);
		
		stage = StageFactory.generate(0, 0);
		field.addChild(stage.container);
		
		actorMediator = new ActorMediator();
		field.addChild(actorMediator.container);
		field.scaleX = 2.0;
		field.scaleY = 2.0;
		
		game.stage.addEventListener(Event.ENTER_FRAME, update);
	}

	private function update(event:Event):Void
	{
		camera(actorMediator.getSubject());
		actorMediator.update();
	}

	
	private function camera(subject:Point):Void{
		var dest:Point = new Point(width / 2 - subject.x * field.scaleX, height / 2 - subject.y * field.scaleY);
		var scroll:Point = dest;
		
		field.x = scroll.x;
		field.y = scroll.y;
	}	
}