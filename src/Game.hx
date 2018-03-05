package ;

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

	var game:Sprite;
	var field:Sprite = new Sprite();
	var panorama:Bitmap = new Bitmap(Assets.getBitmapData("img/panorama.png"));
	var actorManager:ActorManager;
	
	public function new(game:Sprite)
	{
		this.game = game;
		display = game.stage;
		Module.setup();
		width = panorama.width;
		height = panorama.height;
		game.addChild(panorama);
		game.stage.addEventListener(Event.ENTER_FRAME, update);
		game.stage.frameRate = 60;
		game.scrollRect = new Rectangle(0, 0, panorama.width, panorama.height);
		stage = StageGenerator.generate(0, 0);
		game.addChild(field);
		field.addChild(stage.container);
		actorManager = new ActorManager();
		field.addChild(actorManager.container);
		field.scaleX = 2.0;
		field.scaleY = 2.0;
		trace(display.width);
		trace(game.scrollRect.width);
	}

	private function update(event:Event):Void
	{
		camera(actorManager.getSubject());
		actorManager.update();
		shake();
	}

	
	private function camera(subject:Point):Void{
		var dest:Point = new Point(width / 2 - subject.x * field.scaleX, height / 2 - subject.y * field.scaleY);
		var scroll:Point = dest;
		
		field.x = scroll.x;
		field.y = scroll.y;
	}
	
	private static var power:Float = 0;
	private static var speed:Float = 0;
	private static var time:Int = 0;
	public static function setShake(power_:Float, speed_:Float, time_:Int){
		power = power_;
		speed = speed_;
		time = time_;
	}
	private function shake(){
		if (time <= 0) return;
		field.y += speed*time;
		power *=-1;
		if(power<0)time--;
	}
}