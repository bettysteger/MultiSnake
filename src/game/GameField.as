package game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
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
		private var writingPixels:ByteArray;
		private var _players:Array;
		
		public static var GAME_END:String = "GAME_END";
		
		public function GameField()
		{
			// rescale background
			var tmp:BitmapData = new BitmapData(mywidth,myheight);		
			var scaleMatrix:Matrix=new Matrix();
			scaleMatrix.scale(mywidth/backgroundImage.width,myheight/backgroundImage.height);
			tmp.draw(backgroundImage.bitmapData,scaleMatrix);
			backgroundImage.bitmapData = tmp;
			
			var bmp:BitmapData = new BitmapData(20,20,false,0xffffff);
			writingPixels = bmp.getPixels(new Rectangle(0,0,20,20));
			addChild(backgroundImage);
			
			// create snakes
			_players = new Array;
			_players.push(new Snake(1,4,300,300,0x00ff00,false));
			
			for(var i:int=0;i<_players.length;i++)
				addChild(_players[i]);
			
			// add keyboard event listener
			addEventListener(Event.ADDED_TO_STAGE, function():void {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			});

		}
		
		// return players sorted by highscore
		public function get players():Array
		{
			_players.sort(function(a:Snake, b:Snake):Number {
				if(a.score > b.score) {
					return 1;
				} else if(a.score < b.score) {
					return -1;
				} else  {
					//aPrice == bPrice
					return 0;
				}
			});

			return _players;
		}

		public function keyDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 27) //ESC Key
			{
				FlexGlobals.topLevelApplication.endGame();
			}
		}
		
		public function update(dt:Number):void
		{
			
			//update snakes
			for(var i:int=0;i<_players.length;i++)
				_players[i].update(dt);
		}
		
		public function draw():void
		{
			for(var i:int=0;i<_players.length;i++) {
				var rec:Rectangle = new Rectangle(Snake(_players[i]).getPosition.x,Snake(_players[i]).getPosition.y,20,20);
				writingPixels.position = 0;
				backgroundImage.bitmapData.setPixels(rec,writingPixels);
			}
		}
	}
}