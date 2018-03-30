package scene.ingame.actor.object;

/**
 * ...
 * @author sigmal00
 */
class BombBlock extends Object
{
	private var map:Map <Int, Block>;

	public override function new(x:Float, y:Float, map:Map<Int, Block>)
	{
		this.map = map;
		cr = 0xFFFF00;
		super(x, y, 16, 16);
		HP = 1;
	}

	public override function update():Bool
	{
		knockBack = 0;
		invincible = 0;
		shellCount = 0;
		hitStop = 0;
		if (HP <= 0)
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
		}
		return false;
	}

	public override function hitAffect(e:Actor):Void
	{
		if (e.isLimitBreak())
		{
			e.knockBack = 6;
			e.hitStop = 6;
		}
	}
}