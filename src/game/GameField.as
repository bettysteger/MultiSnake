package game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.FlexGlobals;
	
	import org.osmf.events.TimeEvent;
	
	import spark.primitives.BitmapImage;
	import spark.primitives.Rect;
	
	public class GameField extends Sprite
	{
		[Embed(source="../assets/background.jpg")]
		private var background:Class;
		
		[Embed(source="../assets/hammihammi.png")]
		private var hammihammi:Class;

		[Embed(source="../assets/shadow.png")]
		private var shadow:Class;
		
		private var backgroundImage:Bitmap = new background;
		private var hammihammiImage:Bitmap = new hammihammi;
		private var shadowImage:Bitmap = new shadow;
		
		private var mywidth:int = FlexGlobals.topLevelApplication.window_width;
		private var myheight:int = FlexGlobals.topLevelApplication.window_height;
		private var writingPixels:ByteArray;
		private var _players:Array;
		private var _gameEnded:Boolean = false;
		public var hammiTimer:Timer = new Timer(1000);
		private var hammiblink:Boolean = false;
		
		[Embed(source="assets/eat.mp3")]
		private var sndClass:Class;
		private var eatSound:Sound = new sndClass();
		
		[Embed(source="assets/alarm.mp3")]
		private var alarmSndClass:Class;
		private var alarmSound:Sound = new alarmSndClass();
		private var alarmChannel:SoundChannel = new SoundChannel();

		[Embed(source="assets/background.mp3")]
		private var bkgsndClass:Class;
		private var backgroundSound:Sound = new bkgsndClass();
		private var backgroundChannel:SoundChannel = new SoundChannel();
		
		[Embed(source="assets/win.mp3")]
		private var snd2Class:Class;
		private var winSound:Sound = new snd2Class();
		
//		private var score_label_p1:Label;
//		private var score_label_p2:Label;
//		private var score_label_p3:Label;
//		private var score_label_p4:Label;
		
		public static var GAME_END:String = "GAME_END";
		
		public function GameField()
		{
			backgroundChannel = backgroundSound.play(0,99999);
			var soundTransform:SoundTransform = backgroundChannel.soundTransform;
			soundTransform.volume=0.3;			
			backgroundChannel.soundTransform = soundTransform;
			// rescale background
			var tmp:BitmapData = new BitmapData(mywidth,myheight);		
			var scaleMatrix:Matrix=new Matrix();
			scaleMatrix.scale(mywidth/backgroundImage.width,myheight/backgroundImage.height);
			tmp.draw(backgroundImage.bitmapData,scaleMatrix);
			backgroundImage.bitmapData = tmp;
			
			//writingPixels = shadowImage.bitmapData.getPixels(new Rectangle(0,0,20,20));
			addChild(backgroundImage);
			
			// create hammihammi image
			hammihammiImage.smoothing=true;
			hammihammiImage.width=40;
			hammihammiImage.height=30;
			replaceHammiHammi();
			addChild(hammihammiImage);
			hammiTimer.start();
			
			hammiTimer.addEventListener(TimerEvent.TIMER,timerHandler);
			
			
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
			_players.push(new Snake("green",70,50,50,0x00ff00,false,37,39,new Point(1,0))); // LEFT RIGHT
			_players.push(new Snake("red",70,mywidth-50,myheight-50,0xff0000,false,65,83,new Point(-1,0))); // A S
			_players.push(new Snake("yellow",70,50,myheight-50,0xffff00,false,71,72,new Point(1,0))); // G H
			_players.push(new Snake("blue",70,mywidth-50,50,0x0000ff,false,81,87,new Point(-1,0))); // ALT STRG
			
			for(var i:int=0;i<_players.length;i++)
				addChild(_players[i]);
			
			// add keyboard event listener
			addEventListener(Event.ADDED_TO_STAGE, function():void {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			});

		}
		
		// return players sorted by highscore

		public function get gameEnded():Boolean
		{
			return _gameEnded;
		}

		public function get players():Array
		{
			_players.sort(function(a:Snake, b:Snake):Number {
				if(a.score > b.score) {
					return -1;
				} else if(a.score < b.score) {
					return 1;
				} else  {
					//aPrice == bPrice
					return 0;
				}
			});

			return _players;
		}

		public function keyDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 50) //2 Key
			{
				FlexGlobals.topLevelApplication.endGame();
				_gameEnded = true;
			}
		}
		
		// update gamefield
		public function update(dt:Number):void
		{
			
			if(_gameEnded)
				return;
			
			// check if at least N-1 snakes are alive
			var dead_count:int = 0;
			
			//update snakes
			for(var i:int=0;i<_players.length;i++)
			{
				// is snake dead?
				if(Snake(_players[i]).isDead())
				{
					dead_count++;
					continue;
				}
				
				// update pos
				_players[i].update(dt);
				
				// check snakes out of bound
				var pos:Point = Snake(_players[i]).getPosition;
				if(pos.x < 0)
					Snake(_players[i]).position = new Point(mywidth,pos.y);
					
				if(pos.y < 0)
					Snake(_players[i]).position = new Point(pos.x,myheight);
					
				if(pos.x > mywidth)
					Snake(_players[i]).position = new Point(0,pos.y);
					
				if(pos.y > myheight)
					Snake(_players[i]).position = new Point(pos.x,0);
			}
			
			// end game if N-1 snakes are dead
			if(dead_count >= _players.length-1)
			{
				FlexGlobals.topLevelApplication.endGame();
				_gameEnded=true;
				backgroundChannel.stop();
				winSound.play();
				FlexGlobals.topLevelApplication.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
				
			//collision detection with hammi hammi
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
					eatSound.play();
				}	
			}
			
			// collision detection of snakes
			for(var me:int=0;me<_players.length;me++) 
			{
				//does this snake-head collide?
				for(var other:int=0;other<_players.length;other++) 
				{
					if(other == me) continue; // skip myself
					if(Snake(_players[other]).checkCollision(Snake(_players[me]).getPosition))
					{
						Snake(_players[me]).die();
					}
				}
			}
			
		}
		
		// draw gamefield
		public function draw():void
		{
			// draw snake trails
			for(var i:int=0;i<_players.length;i++) {
				var rec:Rectangle = new Rectangle(Snake(_players[i]).getPosition.x,Snake(_players[i]).getPosition.y,15,15);
				backgroundImage.bitmapData.copyPixels(shadowImage.bitmapData,new Rectangle(0,0,20,20),new Point(Snake(_players[i]).getPosition.x,Snake(_players[i]).getPosition.y),null,null,true);
			}
		}
		
		// Place HammiHammi somewhere on the screen
		private function replaceHammiHammi():void 
		{
			hammiTimer.reset();
			hammiTimer.start();
			hammiblink = false;
			alarmChannel.stop();
			hammihammiImage.x=Math.random()*(mywidth-50)+25;
			hammihammiImage.y=Math.random()*(myheight-50)+25;
		}
		
		public function blinkHammiHammi():void {
//			if((hammihammiImage.visible) && (hammihammiblink >= 10)) {
//				hammihammiImage.visible = false;
//				hammihammiblink = 0;				
//			}
//			else if((!hammihammiImage.visible) && (hammihammiblink >= 10)) {
//				hammihammiImage.visible = true;
//				hammihammiblink = 0;
//			}
//				hammihammiblink++;
			if(hammihammiImage.alpha > 0.5)
				hammihammiImage.alpha = 0.5;
			else
				hammihammiImage.alpha = 1;
					
		}
		
		private function timerHandler(e:Event):void {
			if(e.target.currentCount > 10) {
				if(!hammiblink)
					alarmChannel = alarmSound.play();
				hammiblink = true;
				blinkHammiHammi();
			}
			if(e.target.currentCount > 20) {
				hammihammiImage.alpha = 1;
				replaceHammiHammi();
			}		
			
		}
	}
}