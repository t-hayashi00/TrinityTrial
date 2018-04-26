package animator;
import animator.animation.Animation;
import openfl.display.Sprite;
/**
 * ...
 * @author sigmal00
 */
class Animator
{
	private var target:Sprite;
	private var animations:List<Animation> = new List<Animation>();

	public function new(target:Sprite)
	{
		this.target = target;
	}

	public function add(animationName:String, x:Float, y:Float):Void
	{
		var animation:Animation = AnimationFactory.get(animationName);
		animations.add(animation);
		animation.container.x = x;
		animation.container.y = y;
		target.addChild(animation.container);
	}

	public function draw():Void
	{
		var it:Iterator<Animation> = animations.iterator();
		while (it.hasNext())
		{
			var anime = it.next();
			if (!anime.draw())
			{
				animations.remove(anime);
				target.removeChild(anime.container);
			}
		}
	}

	public function removeAll():Void
	{
		var it:Iterator<Animation> = animations.iterator();
		while (it.hasNext())
		{
			var anime = it.next();
			animations.remove(anime);
			target.removeChild(anime.container);
		}
	}
}