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
		private var mywidth = FlexGlobals.topLevelApplication.stage.width;
		private var myheight = FlexGlobals.topLevelApplication.stage.height;
		
		public function GameField()
		{
			backgroundImage.width = mywidth;
			backgroundImage.height = myheight;
			backgroundImage.smoothing=true;
			addChild(backgroundImage);
		}
		
		public function update(dt:Number):void
		{
			
		}
		
		public function draw():void
		{
//			graphics.beginBitmapFill(backgroundImage.bitmapData);
//			graphics.drawRect(0, 0, mywidth, myheight);
		}
	}
}