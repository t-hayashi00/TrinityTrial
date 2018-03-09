package animator;
import animator.animation.*;

/**
 * ...
 * @author sigmal00
 */
class AnimationFactory 
{
	static public function getAnimation(animationName:String):Animation{
		switch (animationName){
		default:
			return new Animation();
		}
	}
}