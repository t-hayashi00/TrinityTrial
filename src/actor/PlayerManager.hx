package actor;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import openfl.display.Sprite;

/**
 * 自機の操作を管理するクラス
 * @author sigmal00
 */
class PlayerManager
{
	private var container:Sprite;
	private var isExtincted:Bool = false;
	private var bullet:Actor = null;
	private var aiming:Aiming = new Aiming();
	private var deadMan:List<Actor>;

	public var subject:Point = new Point();
	public var pc:Actor;
	public var npc:List<Actor> = new List<Actor>();

	public function new(parent:Sprite, deadMan:List<Actor>)
	{
		this.deadMan = deadMan;
		container = parent;
		var pos = Game.stage.getPlayerPos();
		for (i in 0...3)
		{
			var p = new Player(pos.x + 16*(i-1), pos.y, 12, 16);
			container.addChild(p.container);
			npc.add(p);
		}
		pc = npc.pop();
	}
	public function playerControl():Bool
	{
		if (!isExtincted)
		{
			if (pcControl())subjectUpdate();
			npcControl();
		}
		return isExtincted;
	}

	private function pcControl():Bool
	{
		pc.command = Module.command.FREE;
		if (Module.isKeyPressed(Keyboard.A))
		{
			generatePlayer();
		}
		if (Module.isKeyPressed(Keyboard.S))
		{
		}
		if (Module.isKeyPressed(Keyboard.SHIFT))
		{
			changeControl(false,false);
		}
		if (Module.isKeyDown(Keyboard.DOWN))
		{
			if (bullet == null)
			{
				gather();
			}
			else
			{
				aiming.degree += 1.5;
			}
		}
		else if (Module.isKeyDown(Keyboard.UP))
		{
			if (bullet == null)
			{
				disband();
			}
			else
			{
				aiming.degree -= 1.5;
			}
		}
		if (Module.isKeyDown(Keyboard.LEFT))
		{
			pc.command += Module.command.LEFT;
		}
		if (Module.isKeyDown(Keyboard.RIGHT))
		{
			pc.command += Module.command.RIGHT;
		}
		if (Module.isKeyPressed(Keyboard.Z))
		{
			pc.command += Module.command.UP;
		}
		if (Module.isKeyPressed(Keyboard.X))
		{
			throwing();
		}
		var isAlive = pc.update();

		if (!isAlive)
		{
			container.removeChild(pc.container);
			changeControl(true,false);
		}

		return isAlive;
	}

	private function npcControl()
	{
		var it:Iterator<Actor> = npc.iterator();
		var previous = pc;
		while (it.hasNext())
		{
			var p = it.next();
			p.update();
			p.command = Module.command.FREE;
			if (p.state == DEAD)
			{
				deadMan.add(p);
				npc.remove(p);
			}
			if (p.state == TRAIL)
			{
				if (previous.container.y - p.container.y <= -24) p.command += Module.command.UP;
				if (previous.container.x - p.container.x >= 16) p.command += Module.command.RIGHT;
				if (previous.container.x - p.container.x <= -16) p.command += Module.command.LEFT;
				previous = p;
			}
		}
		if (bullet != null)
		{
			bullet.container.x = pc.container.x;
			bullet.container.y = pc.container.y;
		}
	}

	private function subjectUpdate()
	{
		subject.setTo(pc.container.x, pc.container.y - 48);
		if (bullet != null)
		{
			aiming.container.x = pc.container.x + Math.cos(aiming.getRad())*96;
			aiming.container.y = pc.container.y + Math.sin(aiming.getRad())*96;
		}
		if (subject.x < (Game.width/2) / container.parent.scaleX)
		{
			subject.x = (Game.width/2) / container.parent.scaleX;
		}
		if (subject.x > (Game.stage.getWidth()*16) - (Game.width/2 / container.parent.scaleX))
		{
			subject.x = (Game.stage.getWidth()*16) - (Game.width/2 / container.parent.scaleX);
		}
		if (subject.y < Game.height/2 / container.parent.scaleY)
		{
			subject.y = Game.height/2 / container.parent.scaleY;
		}
		if (subject.y > (Game.stage.getHeight()*16) - (Game.height/2 / container.parent.scaleY))
		{
			subject.y = (Game.stage.getHeight()*16) - (Game.height/2 / container.parent.scaleY);
		}
	}

	private function throwing()
	{
		if (bullet == null)
		{
			var it:Iterator<Actor> = npc.iterator();
			while (it.hasNext())
			{
				var p = it.next();
				var inside:Point = new Point(pc.container.x - p.container.x, pc.container.y - p.container.y);
				if ((-20 < inside.x && inside.x < 20)&&(-20 < inside.y && inside.y < 20))
				{
					bullet = p;
					container.addChild(aiming.container);
					break;
				}
			}
		}
		else{
			bullet.state = WAIT;
			var v:Point = new Point(aiming.container.x - bullet.container.x, aiming.container.y - bullet.container.y);
			v.normalize(Game.FC_VELOCITY + 1);
			v.add(pc.getVelocity());
			bullet.addForce(v, true);
			bullet.limitBreakCount = 30;
			bullet = null;
			container.removeChild(aiming.container);
		}
	}

	private function gather()
	{
		var it:Iterator<Actor> = npc.iterator();
		while (it.hasNext())
		{
			var p = it.next();
			p.state = TRAIL;
		}
	}

	private function disband()
	{
		var it:Iterator<Actor> = npc.iterator();
		while (it.hasNext())
		{
			var p = it.next();
			p.state = WAIT;
		}
	}

	private function changeControl(dead:Bool, reverse:Bool)
	{
		if (npc.length == 0)
		{
			if (dead)
			{
				isExtincted = true;
			}
			return;
		}
		bullet = null;
		container.removeChild(aiming.container);
		if (!dead)
		{
			pc.state = WAIT;
			if (reverse) npc.push(pc);
			else npc.add(pc);
		}
		if (reverse)
		{
			pc = npc.last();
			npc.remove(pc);
		}
		else pc = npc.pop();
		pc.addForce(new Point(0, -1), false);
		var it:Iterator<Actor> = npc.iterator();
		while (it.hasNext())
		{
			var p = it.next();
			p.state = WAIT;
			if (pc.inRange(p.container.x, p.container.y, 32))
			{
				p.state = TRAIL;
			}
		}
	}

	private function generatePlayer()
	{
		if (npc.length >= 2)
		{
			var p = npc.pop();
			container.removeChild(p.container);
			npc.remove(p);
		}
		var p = new Player(pc.container.x, pc.container.y, 12, 16);
		container.addChild(p.container);
		p.addForce(new Point(0, -1), true);
		npc.add(p);
	}
}