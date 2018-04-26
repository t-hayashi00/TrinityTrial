package scene;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.net.SharedObject;
import animator.Animator;
import scene.GameOver;
import scene.ingame.actor.ActorMediator;
import scene.ingame.stage.StageFactory;
import scene.ingame.stage.Stage_;
using Sequencer;

/**
 * ゲーム本体部分のシーンを表すクラス
 * @author sigmal00
 */
class InGame extends Scene
{
	public static var stage:Stage_;
	public static var stageNum:Int;
	public static var floorNum:Int;
	public static var party:Int;
	public static var animator:Animator;
	public static var gameEnd:Bool = false;
	private static var goToNextStage:Bool = false;

	private var field:Sprite = new Sprite();
	private var actorMediator:ActorMediator;
	private var panorama:Bitmap;
	private var seq:Sequencer = new Sequencer(false);

	public function new(stageNum_:Int, floorNum_:Int, party:Int)
	{
		stageNum = stageNum_;
		floorNum = floorNum_;
		gameEnd = false;
		panorama = new Bitmap(Assets.getBitmapData("img/panorama.png"));
		container.addChild(panorama);
		container.addChild(field);
		stage = StageFactory.generate(stageNum_, floorNum_);
		goToNextStage = false;
		if (stage == null ) {trace("stage == null");}
		field.addChild(stage.container);
		actorMediator = new ActorMediator(party);
		field.addChild(actorMediator.container);
		field.scaleX = 2.0;
		field.scaleY = 2.0;
		actorMediator.update();
		camera(actorMediator.getSubject());
		animator = new Animator(field);
	}

	public override function update():Scene
	{
		seq.run();
		animator.draw();
		camera(actorMediator.getSubject());
		if (actorMediator.update())
		{
			var so:SharedObject = SharedObject.getLocal("saveData");
			so.data.stage = stageNum;
			so.data.party = 1;
			return new InGame(stageNum, floorNum, 1);
		}
		else if (goToNextStage)
		{
			return new InGame(stageNum, floorNum, party);
		}
		else if (gameEnd)
		{
			return new GameOver();
		}
		return this;
	}

	// フロアを一つ進める
	public static function goToNextFloor():Void
	{
		++floorNum;
		goToNextStage = true;
	}

	// 指定したフロアとステージに移動する
	public static function setNextStage(stageNum_:Int, floorNum_:Int):Void
	{
		stageNum = stageNum_;
		floorNum = floorNum_;
		goToNextStage = true;
	}

	// カメラ制御を行う
	private function camera(subject:Point):Void
	{
		var dest:Point = new Point(Game.width / 2 - subject.x * field.scaleX, Game.height / 2 - subject.y * field.scaleY);
		var scroll:Point = dest;

		field.x = (field.x + scroll.x) /2;
		field.y = (field.y + scroll.y) /2;
	}
}