package animator;

import openfl.display.Sprite;
import animator.animation.Animation;

/**
 * 任意のスプライトにアニメーションを付与するクラス
 * @author sigmal00
 */
class Animator 
{
	private var target:Sprite;
	private var animations:List<Animation> = new List<Animation>;
	
	public function new(target:Sprite) 
	{
		this.target = target;
	}

	public function add(animeNum:String):Void{
		var animation:Animation = AnimationFactory.getAnimation(animeNum);
		animations.add(animation);
		target.addChild(animation.container);
	}
	
	public function draw():Void{
		var It:Iterator<Animation> = animations.iterator();
		while(It.hasNext()){
			var animation:Animation = It.next();
			if(!animation.draw()){
				animations.remove(animation);
				target.removeChild(animation.container);
			}
		}
	}
	
	public function removeAll():Void{
		var It:Iterator<Animation> = animations.iterator();
		while(It.hasNext()){
			var animation:Animation = It.next();
			animations.remove(animation);
			target.removeChild(animation.container);
		}	
	}	
}