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
		private var elements:Array = new Array;
		private var element:ShapeSprite;
		private var GameSpeed:Number = 0.1;
		public var rightKey:Number = 77;
		public var leftKey:Number = 75;
		private var head:Point = new Point(300,300);
		private var tail:Point = new Point(100,100);
		private var direction:Point = new Point(head.x-tail.x,head.y-tail.y);
		private var keyPressed:Boolean = false;
		
		
		public function Snake(player:uint, startlength:uint, x:Number, y:Number, color:uint, dead:Boolean)
		{	
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
				
				element.x -= element.width*i;
				
				element.color = color;
				
				addChild(element);
			}
			
			
		}
			
		public function update(dt:int):void
		{
			for (var i:int = 0; i < elements.length; i++)
			{
				elements[i].x += dt*GameSpeed;
			}
			
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		}
		
		private function keyHandler(e:KeyboardEvent):void
		{
			trace("keyyyy");
			if(e.type==KeyboardEvent.KEY_DOWN && e.keyCode==rightKey)
			{
				trace("rechts");
				elements[0].y += 10;
			}
			else if(e.type==KeyboardEvent.KEY_DOWN && e.keyCode==leftKey)
			{
				trace("links");
				elements[0].y -= 10;
			}	
		}
			
		
	}
}
