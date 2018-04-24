package scene.ingame.actor.object;

import scene.ingame.spritesheet.SpritesheetManager;
import scene.ingame.spritesheet.BlockSp;
using Sequencer;

/**
 * 障害物となるブロック
 * @author sigmal00
 */
class Block extends Object
{
	private var seq:Sequencer = new Sequencer(false);
	private var map:Map <Int, Block>;
	private var spSheet:SpritesheetManager;
	
	public override function new(x:Float, y:Float, map:Map<Int, Block>)
	{
		this.map = map;
		cr = 0xEE00EE;
		super(x, y, 16, 16);
		spSheet = new BlockSp(this);
		hitBox.alpha = 0;
	}
	
	public override function update():Bool
	{
		spSheet.update();
		knockBack = 0;
		invincible = 0;
		shellCount = 0;
		hitStop = 0;
		return !seq.run();
	}

	public override function hitAffect(e:Actor):Void
	{
		if (e != null) return;
		if (seq.isEmpty())
		{
			seq.wait(3);
			seq.add(
			{
				InGame.stage.setIDByFloat(container.x, container.y, "0");
				state.act = State.actions.DEAD;
				var b = map.get(Math.floor((container.x - Game.GRID_SIZE) + container.y*InGame.stage.getWidth()));
				if (b != null) b.hitAffect(null);
				var b = map.get(Math.floor(container.x + (container.y - Game.GRID_SIZE)*InGame.stage.getWidth()));
				if (b != null) b.hitAffect(null);
				var b = map.get(Math.floor((container.x + Game.GRID_SIZE) + container.y*InGame.stage.getWidth()));
				if (b != null) b.hitAffect(null);
				var b = map.get(Math.floor(container.x + (container.y + Game.GRID_SIZE)*InGame.stage.getWidth()));
				if (b != null) b.hitAffect(null);
				seq.clear();
			});
		}
	}
}