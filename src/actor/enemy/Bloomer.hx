package actor.enemy;
import openfl.display.Sprite;
import openfl.geom.Point;
using Sequencer;

/**
 * ...
 * @author sigmal00
 */
class Bloomer extends Enemy
{
	private var seq:Sequencer = new Sequencer(true);
	private var enemies:List<Actor>;

	public override function new(x:Float, y:Float, enemies:List<Actor>)
	{
		cr = 0xFF0000;
		super(x, y, 16, 16);
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
		if (state.act != State.actions.DEAD) seq.run();
		return super.update();
	}

}