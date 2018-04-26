package scene.ingame.actor.enemy;

/**
 * Bloomerが吐き出す弾
 * 重力の影響を受ける
 * @author sigmal00
 */
class Pollen extends Enemy
{
	private var seq:Sequencer = new Sequencer(true);
	
	public override function new(x:Float, y:Float) 
	{
		cr = 0xFFAAAA;
		super(x, y, 5, 5);
		TYPE = "Object";
		ATK = 1;
		HP = 90;
	}
	
	public override function update():Bool{
		HP--;
		return super.update();
	}
}