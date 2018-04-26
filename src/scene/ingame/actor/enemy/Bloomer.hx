package scene.ingame.actor.enemy;
import openfl.geom.Point;
import scene.ingame.actor.State;
import scene.ingame.spritesheet.Slime2;
import scene.ingame.spritesheet.SpritesheetManager;

using Sequencer;

/**
 * 重力の影響を受ける弾を吐き出す敵
 * @author sigmal00
 */
class Bloomer extends Enemy
{
	private var seq:Sequencer = new Sequencer(true);
	private var enemies:List<Dynamic>;
	private var spSheet:SpritesheetManager;

	public override function new(x:Float, y:Float, enemies:List<Dynamic>)
	{
		cr = 0xFF0000;
		super(x, y, 16, 22);
		spSheet = new Slime2(this);
		hitBox.alpha = 0;
		ATK = 0;
		this.enemies = enemies;

		seq.wait(180);
		seq.add(bloom());
	}

	private function bloom ():Void
	{
		var v:Point = new Point(0, -5);
		for (i in 0...5)
		{
			var e = new Pollen(container.x + hitBox.width/2, container.y);
			container.parent.addChild(e.container);
			enemies.add(e);
			e.addForce(Module.rotateVector2D(v, (i-2)*5), true);
		}
	}

	public override function update():Bool
	{
		spSheet.update();
		if (state.act != State.actions.DEAD) seq.run();
		return super.update();
	}

}