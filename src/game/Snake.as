package game
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import utils.BodySprite;
	import utils.HeadSprite;
	import utils.ShapeSprite;
	
	public class Snake extends Sprite
	{
		private var _score:int;
		private var elements:Array = new Array;
		private var element:ShapeSprite;
		private var GameSpeed:Number = 0.1;
		private var direction:Point;
		public var rightKey:Number = 39;
		public var leftKey:Number = 37;
		public var playerID:String;
		private var keyPressedRight:Boolean = false, keyPressedLeft:Boolean = false;
		
		public function Snake(player:uint, startlength:uint, x:Number, y:Number, color:uint, dead:Boolean, id:String)
		{	
			playerID=id;
			direction = new Point(1,0);
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
			for (var i:int = 0; i < startlength; i++)
			{
//				if (i == 0)
//					element = new HeadSprite();
//				else
					element = new BodySprite();
				
				elements[i] = element;
				//Start position
				element.x = x;
				element.y = y;
				
//				element.x -= element.width*i;
				
				element.color = color;
				
				addChild(element);
			}
			
			
		}
			
		// returns the position of the head of the snake
		public function get getPosition():Point
		{
			var point:Point = new Point(elements[0].x,elements[0].y);
			return point;
		}

		public function update(dt:int):void
		{		
			var angle:Number = 0.003*dt;
			var counter:int = 0;
			
			if(keyPressedLeft) {
				direction.y = Math.cos(Math.atan2(direction.x,direction.y)+angle);
				direction.x = Math.sin(Math.atan2(direction.x,direction.y)+angle);
			}
			else if(keyPressedRight){
				direction.y = Math.cos(Math.atan2(direction.x,direction.y)-angle);
				direction.x = Math.sin(Math.atan2(direction.x,direction.y)-angle);
			}
			
			
			for(var i:int=elements.length-1; i>=1; i--) {	
				elements[i].x = elements[i-1].x;
				elements[i].y = elements[i-1].y;
			}

			// move head into new direction
			elements[0].x += direction.x*dt*GameSpeed;
			elements[0].y += direction.y*dt*GameSpeed;

			//trace(angle);
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
			stage.focus = stage;
		}
		
		private function keyHandler(e:KeyboardEvent):void
		{
			if(e.type==KeyboardEvent.KEY_DOWN && e.keyCode==rightKey)
			{
				keyPressedRight = true;
			}
			else if(e.type==KeyboardEvent.KEY_DOWN && e.keyCode==leftKey)
			{
				keyPressedLeft = true;
			}	
			if(e.type==KeyboardEvent.KEY_UP)
			{
				keyPressedRight = false;
				keyPressedLeft = false;
			}
			
		}
			
		
		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score = value;
		}

	}
}
