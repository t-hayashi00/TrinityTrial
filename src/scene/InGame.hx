package scene;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Point;
import scene.ingame.actor.ActorMediator;
import scene.ingame.stage.StageFactory;
import scene.ingame.stage.Stage_;
using Sequencer;

/**
 * ...
 * @author sigmal00
 */
class InGame extends Scene
{
	public static var stage:Stage_;
	private static var goToNextStage:Bool = false;
	private static var stageNum:Int;
	private static var floorNum:Int;

	private var seq:Sequencer = new Sequencer(false);
	
	private var field:Sprite = new Sprite();
	private var actorMediator:ActorMediator;
	private var panorama:Bitmap = new Bitmap(Assets.getBitmapData("img/panorama.png"));

	public function new(game:Sprite, stageNum_:Int, floorNum_:Int) 
	{
		this.game = game;
		stageNum = stageNum_;
		floorNum = floorNum_;
		game.addChild(panorama);
		game.addChild(field);
		stage = StageFactory.generate(stageNum_, floorNum_);
		field.addChild(stage.container);
		actorMediator = new ActorMediator();
		field.addChild(actorMediator.container);
		field.scaleX = 2.0;
		field.scaleY = 2.0;
	}
	
	var nextScene:Scene = this;
	public override function update():Scene
	{
		camera(actorMediator.getSubject());
		if (actorMediator.update()){
			seq.wait(60);
			seq.add(teardown());
			seq.add(nextScene = new Title(game));
		}
		
		if (goToNextStage){
			teardown();
			goToNextStage = false;
			nextScene = new InGame(game, stageNum, floorNum);
		}
		seq.run();
		return nextScene;
	}
	
	public static function setNextStage(stageNum_:Int, floorNum_:Int):Void{
		stageNum = stageNum_;
		floorNum = floorNum_;
		goToNextStage = true;
	}
	
	private function camera(subject:Point):Void
	{
		var dest:Point = new Point(Game.width / 2 - subject.x * field.scaleX, Game.height / 2 - subject.y * field.scaleY);
		var scroll:Point = dest;

		field.x = scroll.x;
		field.y = scroll.y;
	}	
}