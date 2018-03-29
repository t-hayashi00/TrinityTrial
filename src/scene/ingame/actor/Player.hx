package scene.ingame.actor;

import scene.ingame.spritesheet.Hero;
import scene.ingame.spritesheet.SpritesheetManager;
import openfl.geom.Point;

/**
 * 自機を表すクラス
 * @author sigmal00
 */
class Player extends Actor
{ 
//	public var leader:Player = null;
	private var spSheet:SpritesheetManager;
	
	public function new(x:Float, y:Float, w:Float,h:Float) 
	{
		cr = 0x0000FF;
		super(x, y, w, h);
		spSheet = new Hero(this);
		hitBox.alpha = 0;
		HP = 1;
		ATK = 0;
	}
	
	public override function update():Bool
	{
		spSheet.update();
		return super.update();	
	}
	
	public override function hitAffect(e:Actor):Void
	{
		var f = new Point(e.container.x - container.x, e.container.y - container.y);
		var v = e.getVelocity();
		f.normalize(3);
		f.add(v);
		e.addForce(f, isLimitBreak());
		e.knockBack = 6;
		e.hitStop = 6;
		e.invincible = 30;
		e.HP -= if (!isLimitBreak()) ATK else ATK + 1;
	}
}