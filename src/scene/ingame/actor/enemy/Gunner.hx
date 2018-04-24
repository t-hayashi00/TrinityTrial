package scene.ingame.actor.enemy;
import scene.ingame.actor.enemy.Enemy;
import scene.ingame.actor.State;

using Sequencer;

/**
 * 敵
 * @author sigmal00
 */
class Gunner extends Enemy
{
	private var seq:Sequencer = new Sequencer(true);
	
	public override function new(x:Float, y:Float) 
	{
		cr = 0xFF0000;
		super(x, y, 12, 16);
		ATK = 1;
		seq.add(
		{
			state.command = State.commands.FREE;
			state.command += State.commands.UP;
		});
		seq.wait(30);
		seq.add(
		{
			ActorMediator.bulletGenerator.addBullet1(container.x, container.y, container.x - 1, container.y, 3);
		});
		seq.wait(120);
	}
	
	public override function update():Bool{
		if(state.act != State.actions.DEAD) seq.run();
		return super.update();
	}
}