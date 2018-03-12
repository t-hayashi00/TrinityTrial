package actor.enemy;
import actor.enemy.Enemy;

using Sequencer;

/**
 * 敵
 * @author sigmal00
 */
class Gunner extends Enemy
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
			state.command = State.commands.FREE;
//			state.command += State.commands.UP;
		});
		seq.wait(30);
		seq.add(
		{
			BulletProducer.setBullet1(container.x, container.y, container.x-1, container.y, 3);
		});
		seq.wait(120);
	}
	
	private function test():Void{
		trace("ok");
	}
	
	public override function update():Bool{
		if(state.act != State.actions.DEAD) seq.run();
		return super.update();
	}
}