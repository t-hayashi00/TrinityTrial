package scene.ingame.spritesheet;

import scene.ingame.actor.Actor;
import scene.ingame.actor.State;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.Assets;

/**
 * ブロックのスプライトシートを管理するクラス
 * @author sigmal00
 */
class Boss1Sp extends SpritesheetManager
{
	private static var image:BitmapData;
	private var rect:Rectangle = new Rectangle(0, 0, 24, 32);
	private var frame:Float = 0;

	public function new(target:Actor)
	{
		super(target);
		image = Assets.getBitmapData("img/c_boss1.png");
		spritesheet = new Bitmap(new BitmapData(24,32));
		setDrawArea(0, 0);
		target.container.addChild(spritesheet);
		spritesheet.scaleX = 1.3;
		spritesheet.scaleY = 1.3;
	}

	public override function update():Void
	{
		if (target.hitStop > 0){
			spritesheet.x += (Math.random() - 0.5) * target.hitStop * 0.5;
			spritesheet.y += (Math.random() - 0.5) * target.hitStop * 0.5;
		}else{
			spritesheet.x = -7;
			spritesheet.y = -13;
		}
		frame++;
		spritesheet.y += 2*Math.sin(Module.toRad((2*frame)%360)) ;
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