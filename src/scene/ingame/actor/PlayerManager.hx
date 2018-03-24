package scene.ingame.actor;
import openfl.Assets;
import openfl.display.Bitmap;
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
	private var shell:Actor = null;
	private var aiming:Aiming = new Aiming();
	private var nowLeader:Bitmap;
	private var deadMan:List<Actor>;

	public var subject:Point = new Point();
	public var pc:Actor;
	public var npc:List<Actor> = new List<Actor>();

	public function new(parent:Sprite, deadMan:List<Actor>)
	{
		this.deadMan = deadMan;
		container = parent;
		var pos = InGame.stage.getPlayerPos();
		for (i in 0...3)
		{
			var p = new Player(pos.x + 16*(i-1), pos.y, 12, 16);
			container.addChild(p.container);
			npc.add(p);
		}
		pc = npc.pop();
		nowLeader = new Bitmap(Assets.getBitmapData("img/c_arrow.png"));
		container.addChild(nowLeader);
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
		nowLeader.x = pc.container.x -2;
		nowLeader.y = pc.container.y - 16;
		if (Module.isKeyPressed(Keyboard.Q))
		{
			isExtincted = false;
			generatePlayer(48, 48);
		}
		pc.state.command = State.commands.FREE;
		if (Module.isKeyDoubleClick(Keyboard.SHIFT))
		{
			changeControl(false,false);
		}
		if (pc.state.act != State.actions.DEAD)
		{
			if (Module.getKeyHoldTime(Keyboard.SHIFT) == 30)
			{
				generatePlayer(pc.container.x, pc.container.y);
			}
			if (Module.isKeyPressed(Keyboard.A))
			{
				gather();
			}
			if (Module.isKeyPressed(Keyboard.S))
			{
				disband();
			}
			if (Module.isKeyDown(Keyboard.DOWN) && shell != null)
			{
				if (aiming.controlAng < 180)aiming.controlAng += 1.5;
			}
			else if (Module.isKeyDown(Keyboard.UP) && shell != null)
			{
				if (aiming.controlAng > 0)aiming.controlAng -= 1.5;
			}
			if (Module.isKeyDown(Keyboard.LEFT))
			{
				pc.state.command += State.commands.LEFT;
				if (shell == null) pc.state.dir = State.directions.LEFT;
			}
			if (Module.isKeyDown(Keyboard.RIGHT))
			{
				pc.state.command += State.commands.RIGHT;
				if (shell == null) pc.state.dir = State.directions.RIGHT;
			}
			if (Module.isKeyPressed(Keyboard.Z))
			{
				pc.state.command += State.commands.UP;
			}

			if (shell == null)
			{
				if (Module.isKeyPressed(Keyboard.X))throwing();
			}
			else
			{
				if (Module.isKeyDoubleClick(Keyboard.RIGHT)) pc.state.dir = State.directions.RIGHT;
				if (Module.isKeyDoubleClick(Keyboard.LEFT)) pc.state.dir = State.directions.LEFT;
				if (!Module.isKeyDown(Keyboard.X)) throwing();
				if (Module.isKeyDown(Keyboard.C)) cancelThrowing(shell.state.act = State.actions.TRAIL);
			}
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
			p.state.command = State.commands.FREE;
			if (p.state.act == State.actions.DEAD)
			{
				deadMan.add(p);
				npc.remove(p);
			}
			if (p.state.act == State.actions.TRAIL)
			{
				if (previous.container.y - p.container.y <= -24) p.state.command += State.commands.UP;
				if (previous.container.x - p.container.x >= 16)
				{
					p.state.command += State.commands.RIGHT;
					p.state.dir = State.directions.RIGHT;
				}
				if (previous.container.x - p.container.x <= -16)
				{
					p.state.command += State.commands.LEFT;
					p.state.dir = State.directions.LEFT;
				}
				previous = p;
			}
		}
		if (shell != null)
		{
			aiming.update(pc.container.x, pc.container.y, pc.state.dir);
			shell.addForce(new Point(0, 0), true);
			shell.container.x = pc.container.x - 6 * pc.state.dir;
			shell.container.y = pc.container.y - 8;
			shell.state.dir = pc.state.dir;
			if (shell.state.act == State.actions.DEAD) cancelThrowing(State.actions.DEAD);
		}
	}

	private function subjectUpdate()
	{
		subject.setTo(pc.container.x, pc.container.y - 48);
		if (subject.x < (Game.width/2) / container.parent.scaleX)
		{
			subject.x = (Game.width/2) / container.parent.scaleX;
		}
		if (subject.x > (InGame.stage.getWidth()*16) - (Game.width/2 / container.parent.scaleX))
		{
			subject.x = (InGame.stage.getWidth()*16) - (Game.width/2 / container.parent.scaleX);
		}
		if (subject.y < Game.height/2 / container.parent.scaleY)
		{
			subject.y = Game.height/2 / container.parent.scaleY;
		}
		if (subject.y > (InGame.stage.getHeight()*16) - (Game.height/2 / container.parent.scaleY))
		{
			subject.y = (InGame.stage.getHeight()*16) - (Game.height/2 / container.parent.scaleY);
		}
	}

	private function throwing()
	{
		if (shell == null)
		{
			var it:Iterator<Actor> = npc.iterator();
			while (it.hasNext())
			{
				var p = it.next();
				var inside:Point = new Point(pc.container.x - p.container.x, pc.container.y - p.container.y);
				if ((-20 < inside.x && inside.x < 20)&&(-20 < inside.y && inside.y < 20))
				{
					shell = p;
					shell.state.act = State.actions.HOLD;
					container.addChild(aiming.container);
					break;
				}
			}
		}
		else
		{
			var v:Point = new Point(aiming.container.x - shell.container.x, aiming.container.y - shell.container.y);
			v.normalize(Game.FC_VELOCITY + 1);
			v.add(pc.getVelocity());
			shell.addForce(v, true);
			shell.shellCount = 30;
			cancelThrowing(State.actions.WAIT);
		}
	}

	private function cancelThrowing(action:Int)
	{
		shell.container.x = pc.container.x;
		shell.container.y = pc.container.y - 8;
		shell.state.act = action;
		shell = null;
		container.removeChild(aiming.container);
	}

	private function gather()
	{
		var it:Iterator<Actor> = npc.iterator();
		while (it.hasNext())
		{
			var p = it.next();
			p.state.act = State.actions.TRAIL;
		}
	}

	private function disband()
	{
		var it:Iterator<Actor> = npc.iterator();
		while (it.hasNext())
		{
			var p = it.next();
			p.state.act = State.actions.WAIT;
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
		if (shell != null)cancelThrowing(State.actions.TRAIL);
		if (!dead)
		{
			pc.state.act = State.actions.WAIT;
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
			p.state.act = State.actions.WAIT;
			if (pc.inRange(p.container.x, p.container.y, 32)) p.state.act = State.actions.TRAIL;
		}
	}

	private function generatePlayer(x:Float, y:Float)
	{
		if (npc.length >= 2)
		{
			var p = npc.first();
			if (p.isLimitBreak()) return;
			p.HP = 0;
			deadMan.add(p);
			npc.remove(p);
		}
		var p = new Player(x, y, 12, 16);
		container.addChild(p.container);
		p.addForce(new Point(0, -1), true);
		npc.add(p);
	}
}