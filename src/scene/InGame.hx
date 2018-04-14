package scene;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.net.SharedObject;
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
	public static var stageNum:Int;
	public static var floorNum:Int;
	public static var party:Int;
	private static var goToNextStage:Bool = false;

	private var seq:Sequencer = new Sequencer(false);

	private var field:Sprite = new Sprite();
	private var actorMediator:ActorMediator;
	private var panorama:Bitmap = new Bitmap(Assets.getBitmapData("img/panorama.png"));

	public function new(game:Sprite, stageNum_:Int, floorNum_:Int, party:Int)
	{
		this.game = game;
		stageNum = stageNum_;
		floorNum = floorNum_;
		game.addChild(panorama);
		game.addChild(field);
		stage = StageFactory.generate(stageNum_, floorNum_);
		if (stage == null ) {}
		field.addChild(stage.container);
		actorMediator = new ActorMediator(party);
		field.addChild(actorMediator.container);
		field.scaleX = 2.0;
		field.scaleY = 2.0;
		actorMediator.update();
		camera(actorMediator.getSubject());
		seq.add(Game.showScreen(5));
		seq.wait(10);
	}

	var nextScene:Scene = this;
	public override function update():Scene
	{
		if (!seq.run()) return this;
		camera(actorMediator.getSubject());
		if (actorMediator.update())
		{
			seq.wait(60);
			seq.add(Game.hideScreen(5));
			seq.wait(10);
			seq.add(
			{
				var so:SharedObject = SharedObject.getLocal("saveData");
				so.data.stage = stageNum;
				so.data.party = 1;
				teardown();
				nextScene = new InGame(game, stageNum, floorNum, 1);
			});
		}

		if (goToNextStage)
		{
			seq.clear();
			seq.add(Game.hideScreen(5));
			seq.wait(10);
			seq.add(
			{
				teardown();
				goToNextStage = false;
				nextScene = new InGame(game, stageNum, floorNum, party);
			});
		}
		return nextScene;
	}

	public static function goToNextFloor():Void
	{
		++floorNum;
		goToNextStage = true;
	}

	public static function setNextStage(stageNum_:Int, floorNum_:Int):Void
	{
		stageNum = stageNum_;
		floorNum = floorNum_;
		goToNextStage = true;
	}

	private function camera(subject:Point):Void
	{
		var dest:Point = new Point(Game.width / 2 - subject.x * field.scaleX, Game.height / 2 - subject.y * field.scaleY);
		var scroll:Point = dest;

		
		field.x = dest.x;
		field.y = dest.y;
	}
}