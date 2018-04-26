package scene.ingame.actor.enemy;
import scene.ingame.actor.State;
import scene.ingame.spritesheet.Slime;
import scene.ingame.spritesheet.SpritesheetManager;
using Sequencer;

/**
 * 歩き回る敵
 * @author sigmal00
 */
class Walker extends Enemy
{
	private var seq:Sequencer = new Sequencer(true);
	private var spSheet:SpritesheetManager;

	public override function new(x:Float, y:Float)
	{
		cr = 0xFF0000;
		super(x, y, 12, 13);
		spSheet = new Slime(this);
		hitBox.alpha = 0;
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

	public override function update():Bool
	{
		spSheet.update(); 		if (state.act != State.actions.DEAD) seq.run();
		return super.update();
	}
}