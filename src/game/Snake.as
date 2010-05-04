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
		public var rightKey:Number = 39;
		public var leftKey:Number = 37;
		private var _head:Point = new Point(300,300);
		private var tail:Point = new Point(100,100);
		private var direction:Point = new Point(_head.x-tail.x,_head.y-tail.y);
		private var right:Boolean = false, left = false, up = false, down = false;
		private var keyPressedRight:Boolean = false, keyPressedLeft:Boolean = false;
		
		public function Snake(player:uint, startlength:uint, x:Number, y:Number, color:uint, dead:Boolean)
		{	
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
				
				element.x -= element.width*i;
				
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
			var counter:int = 0;
			/*
			for (var i:int = 0; i < elements.length; i++)
			{
				if(counter == 0) elements[i].x += dt*GameSpeed; right = true;
				if(keyPressedLeft) {
					if (counter < 2)
						elements[i].y += dt*GameSpeed;
					else
						elements[i].x -= dt*GameSpeed;
					counter++;
				}else if(keyPressedRight){
					elements[i].y -= dt*GameSpeed;
					counter++;
				}
			}
			*/
/*
			function VektorDrehen(a: TVektor; phi: Double): TVektor;
			begin 
			result.x := cos(arctan(a.y/a.x)+phi);
			result.y := sin(arctan(a.y/a.x)+phi);
			end;
			*/
				if(counter == 0) right = true;
				
				if(keyPressedLeft && right) {
					if (counter < 2)
						elements[0].y += dt*GameSpeed;
					else
						elements[0].x -= dt*GameSpeed;
					counter++;
				}
				else if(keyPressedRight){
					down = true;
					counter++;
				}
				
				if(right) elements[0].x += dt*GameSpeed;
				if(left) elements[0].x -= dt*GameSpeed;
				if(up) elements[0].y += dt*GameSpeed;
				if(down) elements[0].y -= dt*GameSpeed;

			
			trace(counter);
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
