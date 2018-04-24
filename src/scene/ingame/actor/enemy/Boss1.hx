package scene.ingame.actor.enemy;
import openfl.geom.Point;
import scene.ingame.actor.State;
import scene.ingame.spritesheet.Boss1Sp;
import scene.ingame.spritesheet.SpritesheetManager;
using Sequencer;

/**
 * ...
 * @author sigmal00
 */
class Boss1 extends Enemy
{
	private var seq:Sequencer = new Sequencer(false);
	private var bullets:List<Bullet>;
	private var spSheet:SpritesheetManager;

	private var preHP:Int = 0;
	private var constant:Point;
	public override function new(x:Float, y:Float)
	{
		constant = new Point (x, y);
		cr = 0xFF0000;
		super(x, y, 16, 16);
		spSheet = new Boss1Sp(this);
		hitBox.alpha = 0;
		HP = 4;
		preHP = HP;
		ATK = 1;
		seq.wait(20);
		setBlock();
		seq.wait(120);
	}

	public override function update():Bool
	{
		spSheet.update();
		if (state.act != State.actions.DEAD)
		{
			if (seq.run())
			{
				attack();
			}
		}
		container.x = constant.x;
		container.y = constant.y;
		return super.update();
	}

	private function attack():Void
	{
		seq.clear();
		if (preHP != HP)
		{
			setBlock();
		}
		else {
			switch (HP)
			{
				case 4:
					for (i in 0...3)
					{
						seq.add(
						{
							ActorMediator.bulletGenerator.aimForYourself(container.x+8, container.y, 1, false, true);
						});
						seq.wait(6);
					}
					seq.wait(180);
				case 3:
					for (i in 0...3)
					{
						seq.add(
						{
							ActorMediator.bulletGenerator.aimForYourself(container.x+8, container.y, 2, 240, false,true);
						});
						seq.wait(12);
					}
					seq.wait(180);
				case 2:
					seq.add(
					{
						ActorMediator.bulletGenerator.nWay(container.x+8, container.y, 2, 6, 120, false,true);
					});
					seq.wait(180);
				case 1:
					for (i in 0...3)
					{
						seq.add(
						{
							ActorMediator.bulletGenerator.nWay(container.x+8, container.y, 2, 6, 120, false,true);
						});
						seq.wait(12);
					}
					seq.wait(180);
				default:
			}
		}
		preHP = HP;
	}

	private function setBlock():Void
	{
		switch (HP)
		{
			case 4:
				for (i in 0...4)
				{
					seq.add(
					{
						ActorMediator.objectGenerator.set(12, constant.x + (i - 2) * 16, constant.y + 32);
						ActorMediator.objectGenerator.set(12, constant.x + (2 - i) * 16, constant.y - 32);
						ActorMediator.objectGenerator.set(12, constant.x - 32, constant.y + (i - 2) * 16);
						ActorMediator.objectGenerator.set(12, constant.x + 32, constant.y + (2 - i) * 16);
					});
					seq.wait(2);
				}
				seq.add(ActorMediator.objectGenerator.set(13, constant.x + 3 * 16, constant.y));
			case 3:
				seq.add(ActorMediator.objectGenerator.set(12, constant.x + 16, constant.y));
				seq.wait(2);
				for (i in 0...3) {
					seq.add(ActorMediator.objectGenerator.set(12, constant.x + (1 - i) * 16, constant.y - 16));
					seq.wait(2);
				}
				for (i in 0...3){
					seq.add(ActorMediator.objectGenerator.set(12, constant.x - 16, constant.y + i * 16));
					seq.wait(2);
				}
				for (i in 0...4){
					seq.add(ActorMediator.objectGenerator.set(12, constant.x + i * 16, constant.y + 32));
					seq.wait(2);
				}
				for (i in 0...5){
					seq.add(ActorMediator.objectGenerator.set(12, constant.x + 48, constant.y + (2 - i)*16));
					seq.wait(2); 
				}
				for (i in 0...7){
					seq.add(ActorMediator.objectGenerator.set(12, constant.x + (3 - i)*16, constant.y - 48));
					seq.wait(2); 
				}
				for (i in 0...5){
					seq.add(ActorMediator.objectGenerator.set(12, constant.x - 48, constant.y + (i - 2) * 16));
					seq.wait(2);
				}
				seq.add(ActorMediator.objectGenerator.set(13, constant.x - 48, constant.y + 48));
			case 2:
				for (i in 0...2)
				{
					seq.add(
					{
						ActorMediator.objectGenerator.set(12, constant.x + (i - 1) * 16, constant.y + 16);
						ActorMediator.objectGenerator.set(12, constant.x + (1 - i) * 16, constant.y - 16);
						ActorMediator.objectGenerator.set(12, constant.x - 16, constant.y + (i - 1) * 16);
						ActorMediator.objectGenerator.set(12, constant.x + 16, constant.y + (1 - i) * 16);
					});
					seq.add(ActorMediator.objectGenerator.set(13, constant.x, constant.y + 32));
					seq.wait(2);
				}
				for (i in 0...6)
				{
					seq.add(
					{
						ActorMediator.objectGenerator.set(12, constant.x + (i - 3) * 16, constant.y + 48);
						ActorMediator.objectGenerator.set(12, constant.x + (3 - i) * 16, constant.y - 48);
						ActorMediator.objectGenerator.set(12, constant.x - 48, constant.y + (i - 3) * 16);
						ActorMediator.objectGenerator.set(12, constant.x + 48, constant.y + (3 - i) * 16);
					});
					seq.wait(2);
				}
				seq.add(ActorMediator.objectGenerator.set(13, constant.x, constant.y - 64));
			case 1:
				for (i in 0...2)
				{
					seq.add(
					{
						ActorMediator.objectGenerator.set(12, constant.x + (i - 1) * 16, constant.y + 16);
						ActorMediator.objectGenerator.set(12, constant.x + (1 - i) * 16, constant.y - 16);
						ActorMediator.objectGenerator.set(12, constant.x - 16, constant.y + (i - 1) * 16);
						ActorMediator.objectGenerator.set(12, constant.x + 16, constant.y + (1 - i) * 16);
					});
					seq.add(ActorMediator.objectGenerator.set(13, constant.x + 32, constant.y));
					seq.wait(2);
				}
				for (i in 0...6)
				{
					seq.add(
					{
						ActorMediator.objectGenerator.set(12, constant.x + (i - 3) * 16, constant.y + 48);
						ActorMediator.objectGenerator.set(12, constant.x + (3 - i) * 16, constant.y - 48);
						ActorMediator.objectGenerator.set(12, constant.x - 48, constant.y + (i - 3) * 16);
						ActorMediator.objectGenerator.set(12, constant.x + 48, constant.y + (3 - i) * 16);
					});
					seq.wait(2);
				}
				seq.add(ActorMediator.objectGenerator.set(13, constant.x - 64, constant.y));
			default:
		}
		seq.wait(60);
	}
}