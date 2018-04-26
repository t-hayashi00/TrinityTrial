package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class Window
{
	public var container:Sprite = new Sprite();
	private var frame:Sprite = new Sprite();
	private var inside:Bitmap;
	public var textField:TextField = new TextField();
	public var textFormat:TextFormat = new TextFormat();

	public var width:Float;
	public var height:Float;
	private var x:Float;
	private var y:Float;
	private var cursor:Bool = false;

	public var fc:Int = 0;

	public function new(x:Float, y:Float, width:Float,height:Float, text:String, cursor:Bool)
	{
		this.cursor = cursor;
		if (width < 1)width = 1;
		if (height < 1)height = 1;
		inside = new Bitmap(Assets.getBitmapData("img/u_window.png"));
		inside.scrollRect = new Rectangle (0, 0, 14, 14);
		inside.x = 2;
		inside.y = 2;
		inside.alpha = 1;
		textFormat.size = 9;
		textFormat.align = TextFormatAlign.CENTER;
		textFormat.color = 0x643200;
		textField.setTextFormat(textFormat);
		textField.text = text;
		resize(width,height);
		setX(x);
		setY(y);
		container.addChild(inside);
		container.addChild(frame);
		container.addChild(textField);
	}

	public function getX():Float {return x;}
	public function getY():Float {return y;}

	public function setX(x:Float):Void
	{
		this.x = x;
		container.x = x -width/2 + 16;
	}

	public function setY(y:Float):Void
	{
		this.y = y;
		container.y = y -height - 32;
	}

	public function resize(width:Float,height:Float):Void
	{
		this.width = width;
		this.height = height;
		container.x = -width/2 + 16;
		container.y = if (cursor) -height - 32 else -height - 16;
		inside.width = width-4;
		inside.height = height-4;
		textField.width = width;
		textField.height = height;
		drawFrame();
	}

	private function drawFrame():Void
	{
		frame.graphics.lineStyle (1,0x643200, 1.0);
		frame.graphics.moveTo(0,0);
		frame.graphics.lineTo(width-5,0);
		frame.graphics.lineTo(width,5);
		frame.graphics.lineTo(width,height);
		frame.graphics.lineTo(5,height);
		frame.graphics.lineTo(0,height-5);
		frame.graphics.lineTo(0,0);
		if (cursor)
		{
			frame.graphics.beginFill (0xEEFFFF);
			frame.graphics.moveTo(width/2-4,height+3);
			frame.graphics.lineTo(width/2+4,height+3);
			frame.graphics.lineTo(width/2,height+11);
			frame.graphics.lineTo(width/2-4,height+3);
		}
	}
	public function draw()
	{
		if (container.parent != null)
		{
			fadeIn();
		}
		else
		{
			fadeOut();
		}
	}

	private function fadeIn():Void
	{
		if (container.alpha < 1)
		{
			container.alpha += 0.25;
		}
	}

	private function fadeOut():Void
	{
		if (container.alpha > 0)
		{
			container.alpha -= 0.25;
		}
	}
}