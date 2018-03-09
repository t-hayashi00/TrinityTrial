package animator.animation;
import openfl.display.Sprite;

/**
 * アニメーションの基底クラス
 * @author sigmal00
 */
class Animation 
{
	public var container:Sprite = new Sprite();
	private var lifeTime:Int;

	public function new() 
	{
		
	}
	
	public function draw():Bool
	{
		return (lifeTime > 0);
	}	
}