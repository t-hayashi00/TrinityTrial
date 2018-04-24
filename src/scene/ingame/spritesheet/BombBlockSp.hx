package scene.ingame.spritesheet;

import scene.ingame.actor.Actor;
import scene.ingame.actor.State;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.Assets;

/**
 * 爆弾ブロックのスプライトシートを管理するクラス
 * @author sigmal00
 */
class BombBlockSp extends SpritesheetManager
{
	private static var image:BitmapData;
	private var rect:Rectangle = new Rectangle(0, 0, 16, 16);

	public function new(target:Actor)
	{
		super(target);
		image = Assets.getBitmapData("img/c_block.png");
		setDrawArea(2, 0);
	}

	public override function update():Void
	{
		if (target.state.act == State.actions.DEAD){
			setDrawArea(0, 0);
		}
	}

	private function setDrawArea(x:Float, y:Float):Void
	{
		x = Math.floor(x);
		y = Math.floor(y);
		rect.x = rect.width * x;
		rect.y = rect.height * y;
		InGame.stage.upper.bitmapData.copyPixels(image, rect, new Point(target.container.x, target.container.y));
	}
}