package scene.ingame.actor.object;
import openfl.geom.Point;
import scene.ingame.spritesheet.SpritesheetManager;
import scene.ingame.spritesheet.BombBlockSp;

/**
 * 爆弾ブロック
 * 破壊すると隣接しているブロックを消滅させる
 * @author sigmal00
 */
class BombBlock extends Object
{
	private var map:Map <Int, Block>;
	private var spSheet:SpritesheetManager;

	public override function new(x:Float, y:Float, map:Map<Int, Block>)
	{
		this.map = map;
		cr = 0xFFFF00;
		super(x, y, 16, 16);
		hitBox.alpha = 0;
		HP = 1;
		spSheet = new BombBlockSp(this);
	}

	public override function update():Bool
	{
		spSheet.update();
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
		var v = e.getVelocity();
		if (container.y - (e.container.y + e.hitBox.height) > -4 && v.y > 0){
			e.addForce(new Point(v.x, -3), true);
			HP -= 1;
		}
		if (e.isLimitBreak())
		{
			e.knockBack = 6;
			e.hitStop = 6;
		}
	}
}