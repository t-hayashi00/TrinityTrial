package ;

import openfl.display.Sprite;
import haxe.macro.Expr;
using Sequencer;

/**
 * Main
 * @author sigmal00
 */
class Main extends Sprite 
{
	var game:Game;
	public function new() 
	{
		super();
		game = new Game(this);
	}	
}
