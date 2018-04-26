package animator;
import animator.animation.*;

/**
 * アニメーションを生成する
 * @author sigmal00
 */
class AnimationFactory
{
/*	private static var anime:Map<String, Void -> Animation> = [
				"sample" => function():Animation{return new Animation(); },
				"death" => function():Animation{return new Death(); },
			];*/
	public static function get(animationName:String):Animation
	{
		var result:Animation = new Death();
		if (result == null) return new Animation();
		return result;
	}
}