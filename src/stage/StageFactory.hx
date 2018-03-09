package stage;

/**
 * ステージの生成を行うクラス
 * @author sigmal00
 */
class StageFactory 
{
	public static function generate(stage:Int,floor:Int):Stage_{
		var fileName:String;
		switch(stage){
		case 0:
			fileName = "";
		default:
			fileName = "chip04b_castle.png";
		}
		return new Stage_(stage, floor, fileName);
	}	
}