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
	import mx.controls.Label;
	import mx.core.FlexGlobals;
	
	import spark.primitives.BitmapImage;
	
	public class GameField extends Sprite
	{
		[Embed(source="../assets/background.jpg")]
		private var background:Class;
		
		[Embed(source="../assets/hammihammi.png")]
		private var hammihammi:Class;
		
		private var backgroundImage:Bitmap = new background;
		private var hammihammiImage:Bitmap = new hammihammi;
		
		private var mywidth:int = FlexGlobals.topLevelApplication.stage.width;
		private var myheight:int = FlexGlobals.topLevelApplication.stage.height;
		private var writingPixels:ByteArray;
		private var _players:Array;
		
//		private var score_label_p1:Label;
//		private var score_label_p2:Label;
//		private var score_label_p3:Label;
//		private var score_label_p4:Label;
		
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
			
			// create hammihammi image
			hammihammiImage.smoothing=true;
			hammihammiImage.width=40;
			hammihammiImage.height=30;
			replaceHammiHammi();
			addChild(hammihammiImage);
			
			//position score labels
//			score_label_p1 = new Label();
//			score_label_p1.top=10;
//			score_label_p1.left=10;
//			score_label_p1.setStyle("fontSize",20);
//			score_label_p1.text="Player 1: 0";
//			score_label_p1.width=100;
//			score_label_p1.height=100;
//			addChild(score_label_p1);
			
			// create snakes
			_players = new Array;
			_players.push(new Snake(1,4,300,300,0x00ff00,false,"red"));
			
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
			hammihammiImage.x=mouseX;
			hammihammiImage.y=mouseY;
		}
		
		// update gamefield
		public function update(dt:Number):void
		{
			//update snakes
			for(var i:int=0;i<_players.length;i++)
				_players[i].update(dt);
			
			//collision detection
			for(var i:int=0;i<_players.length;i++) 
			{
				var SnakeX:int = Snake(_players[i]).getPosition.x;
				var SnakeY:int = _players[i].getPosition.y;
				
				var dx:int = SnakeX - hammihammiImage.x;
				var dy:int = SnakeY - hammihammiImage.y;
				
				var distance_snake_hammihammi:int = Math.sqrt( dx*dx + dy*dy);
				
				if(distance_snake_hammihammi <= 20)
				{
					Snake(_players[i]).score += 1;
					replaceHammiHammi();
				}	
			}
			
			
		}
		
		// draw gamefield
		public function draw():void
		{
			for(var i:int=0;i<_players.length;i++) {
				var rec:Rectangle = new Rectangle(Snake(_players[i]).getPosition.x,Snake(_players[i]).getPosition.y,20,20);
				writingPixels.position = 0;
				backgroundImage.bitmapData.setPixels(rec,writingPixels);
			}
		}
		
		// Place HammiHammi somewhere on the screen
		private function replaceHammiHammi():void 
		{
			hammihammiImage.x=Math.random()*(mywidth-50)+25;
			hammihammiImage.y=Math.random()*(myheight-50)+25;
		}
	}
}