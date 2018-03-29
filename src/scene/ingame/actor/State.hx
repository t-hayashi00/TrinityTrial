package scene.ingame.actor;

/**
 * キャラクターの状態を表すクラス
 * @author sigmal00
 */
class State 
{
	static public var commands = {
		FREE:0x0,
		RIGHT:0x1,
		LEFT:0x2,
		UP:0x8,
		DOWN:0x10
	};
	static public var actions = {
		TRAIL:0,//NPC専用ステート
		WAIT:1,
		HOLD:2,
		DEAD:3
	};
	static public var directions = {
		LEFT: -1,
		RIGHT:1
	};
	public var command:UInt = commands.FREE;
	public var jumped:Int = 0;
	public var act:Int = actions.TRAIL;
	public var dir:Int = directions.RIGHT;
	
	public function new (){
		
	}
}