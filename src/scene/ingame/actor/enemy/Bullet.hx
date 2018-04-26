package scene.ingame.actor.enemy;
import openfl.geom.Point;
import openfl.display.Sprite;
import scene.InGame;
import scene.ingame.actor.Actor;

/**
 * 敵弾を表すクラス
 * 重力の影響は受けない
 * @author sigmal00
 */
class Bullet 
{
	public var container:Sprite = new Sprite();
	public var ATK:Int;
	public var dead:Bool = false;

	private var v:Point;
	private var a:Point;
	private var t:Int = -1;
	private var lifetime:Int;
	private var reflect:Bool = false;
	private var through:Bool = false;
	
	// 通常　壁反射　壁貫通
	public function new(x:Float, y:Float,
		vx:Float, vy:Float,
		ax:Float, ay:Float,
		ATK:Int, lifetime:Int,
		reflect:Bool, through:Bool) 
	{
		container.x = x;
		container.y = y;
		v = new Point(vx, vy);
		a = new Point(ax, ay);
		this.ATK = ATK;
		this.lifetime = lifetime;
		this.reflect = reflect;
		this.through = through;
		container.graphics.beginFill(0x000000,1.0);
		container.graphics.drawCircle(0, 0, 3);
		container.graphics.beginFill(0x10CF4A,1.0);
		container.graphics.drawCircle(0, 0, 2.5);
	}
	
	public function update()
	{
		t++;
		if (t == lifetime) dead = true;
		
		if (dead) return;
		
		if (!speedCap(v)){
			v.x += a.x * t * 0.01;
			v.y += a.y * t * 0.01;
		}
		switch(InGame.stage.getIDByFloat(container.x + v.x, container.y)){
		case "0":
		default:
			if(reflect){
				v.x *= -1;
			}
			else if(!through){
				dead = true;
			}
		}
		switch(InGame.stage.getIDByFloat(container.x, container.y + v.y)){
		case "0":
		default:
			if(reflect){
				v.y *= -1;
			}
			else if(!through){
				dead = true;
			}
		}
		container.x += v.x;
		container.y += v.y;
	}
	
	public function hitAffect(p:Actor):Void{
		if (!through) dead = true;
		if (p.invincible > 0) return;
		var f = new Point(container.x - p.container.x + p.container.width/2, container.y - p.container.y + p.container.height/2);
		f.normalize(3);
		f.add(v);
		p.addForce(f, true);
		p.knockBack = 6;
		p.hitStop = 6;
		p.invincible = 30;
		p.HP -= ATK;
	}

	private function speedCap(v:Point):Bool{
		return (v.x * v.x + v.y * v.y) > (Game.MAX_SPEED * Game.MAX_SPEED * 2.25);
	}
}