package animator;
import animator.animation.Animation;

/**
 * アニメーションを生成する
 * @author sigmal00
 */
class AnimationFactory
{
	public static function get(animationName:String):Animation
	{
		switch (animationName)
		{
		default:
			return new Animation();
		}
	}
}