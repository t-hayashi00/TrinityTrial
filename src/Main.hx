package ;

import openfl.display.Sprite;

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