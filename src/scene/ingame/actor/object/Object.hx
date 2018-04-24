package scene.ingame.actor.object;

/**
 * 各オブジェクトの基底クラス
 * @author sigmal00
 */
class Object extends Actor
{
	
	public function new(x:Float, y:Float, w:Float, h:Float)
	{
		super(x, y, w, h);
		TYPE = "Object";
	}

	public override function update():Bool
	{
		knockBack = 0;
		invincible = 0;
		shellCount = 0;
		hitStop = 0;
		return true;
	}	
}