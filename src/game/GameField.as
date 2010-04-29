package game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import mx.controls.Image;
	import mx.core.FlexGlobals;
	
	import spark.primitives.BitmapImage;
	
	public class GameField extends Sprite
	{
		[Embed(source="../assets/background.jpg")]
		private var background:Class;
		private var backgroundImage:Bitmap = new background;
		private var mywidth:int = FlexGlobals.topLevelApplication.stage.width;
		private var myheight:int = FlexGlobals.topLevelApplication.stage.height;
		private var snake:Snake;
		
		public function GameField()
		{
			backgroundImage.width = mywidth;
			backgroundImage.height = myheight;
			backgroundImage.smoothing=true;
			addChild(backgroundImage);
			snake = new Snake(1,4,300,300,0x00ff00,false);
			addChild(snake);
		}
		
		public function update(dt:Number):void
		{
			snake.update(dt);
		}
		
		public function draw():void
		{
//			graphics.beginBitmapFill(backgroundImage.bitmapData);
//			graphics.drawRect(0, 0, mywidth, myheight);
		}
	}
}