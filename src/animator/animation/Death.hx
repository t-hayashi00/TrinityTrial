package animator.animation;

import animator.animation.*;
import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author sigmal00
 */
class Death extends Animation 
{
	private var dusts:List<Particle> = new List<Particle>();
	public function new() 
	{
		super();
		container.blendMode = BlendMode.ADD;
		for (i in 0...12)
		{
			var dust:Particle = new Particle(0.5*(Math.random() - 0.5), 0, 0,  -0.1 * Math.random(), 2, "circle", 0xFFEE33);
			container.addChild(dust.container);
			dusts.add(dust);
		}
		lifeTime = 60;
	}
	override public function draw():Bool
	{
		container.alpha = lifeTime / 30;
		var it = dusts.iterator();
		while(it.hasNext()){
			var dust:Particle = it.next();
			dust.update();
		}
		lifeTime--;
		trace("ok");
		return super.draw();
	}
	
}