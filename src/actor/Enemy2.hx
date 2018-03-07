package actor;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Point;
using Sequencer;

/**
 * 敵のスーパークラス
 * @author sigmal00
 */
class Enemy2 extends Enemy
{
	private var seq:Sequencer = new Sequencer(true);
	private var bullets:List<Bullet>;
	
	public override function new(x:Float, y:Float, bullets:List<Bullet>) 
	{
		cr = 0xFF0000;
		super(x, y, 12, 16);
		ATK = 1;
		this.bullets = bullets;
		seq.add(
		{
			command = Module.command.FREE;
			command += Module.command.UP;
		});
		seq.wait(30);
		seq.add(
		{
			BulletGenerator.setBullet1(container.x, container.y, container.x-1, container.y, 3);
		});
		seq.wait(60);
	}
	
	private function test():Void{
		trace("ok");
	}
	
	public override function update():Bool{
		if(state != DEAD) seq.run();
		return super.update();
	}
}