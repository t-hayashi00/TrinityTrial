package scene.ingame.actor;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author sigmal00
 */
class UserInterface 
{
	private var target:Sprite;
	private var npc:List<Actor>;
	private var nowLeader:Bitmap;
	
	public function new(target:Sprite, npc:List<Actor>) 
	{
		this.target = target;
		this.npc = npc;
		nowLeader = new Bitmap(Assets.getBitmapData("img/c_arrow.png"));
		nowLeader.x = -30;
		nowLeader.y = -30;
		target.addChild(nowLeader);
	}
	
	public function update(pc:Actor):Void {
		nowLeader.x = pc.container.x -2;
		nowLeader.y = pc.container.y - 16;
	}
}