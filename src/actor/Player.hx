package actor;

import spritesheet.Hero;
import spritesheet.SpritesheetManager;

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
		HP = 1;
		ATK = 0;
	}
	
	public override function update():Bool
	{
		spSheet.update();
		return super.update();	
	}
}