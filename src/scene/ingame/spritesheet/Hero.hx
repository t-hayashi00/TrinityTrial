package scene.ingame.spritesheet;

import scene.ingame.actor.Actor;
import scene.ingame.actor.State;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.Assets;

/**
 * 自機のスプライトシートを管理するクラス
 * @author sigmal00
 */
class Hero extends SpritesheetManager
{
	private static var image:BitmapData;
	private var rect:Rectangle = new Rectangle(0, 0, 24, 32);
	private var frame:Float = 0;
	private var pat:Array<Int> = [0, 1, 2, 1];

	public function new(target:Actor)
	{
		super(target);
		image = Assets.getBitmapData("img/c_hero.png");
		spritesheet = new Bitmap(new BitmapData(24,32));
//		spritesheet.scrollRect = rect;
		setDrawArea(1, 1);
		target.container.addChild(spritesheet);
		spritesheet.x = -7;
		spritesheet.y = -14;
	}

	public override function update():Void
	{
		if (target.hitStop > 0){
			spritesheet.x += (Math.random() - 0.5) * target.hitStop * 0.5;
			spritesheet.y += (Math.random() - 0.5) * target.hitStop * 0.5;
		}else{
			spritesheet.x = -6;
			spritesheet.y = -14;
		}
		var x:Float;
		var y:Float;
		frame += Math.abs(Point.distance(target.getVelocity(), new Point (0, 0)));
		if (target.state.act == State.actions.DEAD)
		{
			x = 0;
			y = if (target.hitStop > 0)5 else 6;
			y += target.state.dir;
		}
		else if (target.state.act == State.actions.HOLD)
		{
			x = 1;
			y = 2 + target.state.dir;
		}
		else {
			x = if (target.state.command != State.commands.FREE) getPattern(frame / 6) + 1 else 0;
			y = if (target.getAirTime() > 12)2 else 1;
			y += target.state.dir;
		}
		setDrawArea(x, y);
	}

	private function getPattern(frame:Float):Int
	{
		var index:Int = Math.round(frame) % pat.length;
		return pat[index];
	}

	private function setDrawArea(x:Float, y:Float):Void
	{
		x = Math.floor(x);
		y = Math.floor(y);
		rect.x = rect.width * x;
		rect.y = rect.height * y;
		spritesheet.bitmapData.copyPixels(image, rect, new Point(0, 0));
	}
}