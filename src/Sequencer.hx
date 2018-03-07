package;

import haxe.macro.Expr;

/**
 * ...
 * @author sigmal00
 */
class Sequencer
{
	private var functions: Array<Array<Void -> Void>> = [[]];
	private var waitTerms: Array<Int> = [];
	private var waitingCount: Int = 0;
	private var index: Int = 0;
	private var runningIndex: Int = 0;
	private var loop: Bool;
	public var isEnd: Bool;

	public function new(loop:Bool)
	{
		this.loop = loop;
	}

	public function loopEnd()
	{
		loop = false;
	}

	public function addSequence(func: Void -> Void)
	{
		isEnd = false;
		functions[index].push(func);
	}

	public function waitSequence(term: Int)
	{
		isEnd = false;
		waitTerms.push(term);
		index++;
		functions.push([]);
	}

	// 毎フレーム呼び出される場所で呼び出す
	public function run():Bool
	{
		if (waitingCount == 0)
		{
			for (func in functions[runningIndex])
			{
				func();
			}
			if (runningIndex == functions.length - 1)
			{
				if(loop){
					waitingCount = 0;
					index = 0;
					runningIndex = 0;
					return false;
				}
				isEnd = true;
				return true;
			}
			waitingCount = waitTerms[runningIndex];
		}
		else
		{
			waitingCount--;
			if (waitingCount == 0) runningIndex++;
		}
		return false;
	}
	
	macro public static function add(sequencer: Expr, expr: Expr)
	{
		return macro $sequencer.addSequence(function() { $expr; } );
	}
	
	macro public static function wait(sequencer: Expr, expr: Expr)
	{
		return macro $sequencer.waitSequence($expr);
	}	
}