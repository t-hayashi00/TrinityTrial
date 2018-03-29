package scene.ingame.actor.enemy;
import scene.ingame.actor.State;
using Sequencer;

/**
 * ...
 * @author sigmal00
 */
class Walker extends Enemy
{
	private var seq:Sequencer = new Sequencer(true);
	private var bullets:List<Bullet>;
	
	public override function new(x:Float, y:Float) 
	{
		cr = 0xFF0000;
		super(x, y, 12, 16);
		ATK = 1;
		seq.add(state.command = State.commands.LEFT);
		seq.wait(60);
		seq.add(state.command = State.commands.FREE);
		seq.wait(10);
		seq.add(state.command = State.commands.UP);
		seq.wait(60);
		seq.add(state.command = State.commands.RIGHT);
		seq.wait(60);
		seq.add(state.command = State.commands.FREE);
		seq.wait(10);
		seq.add(state.command = State.commands.UP);
		seq.wait(60);
	}
	
	private function test():Void{
		trace("ok");
	}
	
	public override function update():Bool{
		if(state.act != State.actions.DEAD) seq.run();
		return super.update();
	}
}