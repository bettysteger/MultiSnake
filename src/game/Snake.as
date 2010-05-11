package game
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import utils.BodySprite;
	import utils.HeadSprite;
	import utils.ShapeSprite;
	
	public class Snake extends Sprite
	{
		private var _score:int;
		private var _color:uint;
		private var _startpos:Point;
		private var _dead:Boolean=false;
		private var elements:Array = new Array;
		private var GameSpeed:Number = 0.15;
		private var direction:Point;
		public var rightKey:Number;
		public var leftKey:Number;
		public var playerID:String;
		private var keyPressedRight:Boolean = false, keyPressedLeft:Boolean = false;
		
		[Embed(source="assets/crash.mp3")]
		public var sndClass:Class;
		public var dieSound:Sound = new sndClass();
		
		public function Snake(player:uint, startlength:uint, startX:Number, startY:Number, color:uint, dead:Boolean, id:String, leftkey:int, rightkey:int, startdirection:Point)
		{	
			playerID=id;
			_color=color;
			direction=startdirection;
			this.rightKey = rightkey;
			this.leftKey = leftkey;
			_startpos = new Point(startX,startY);
			
			
			// create Head
			var head:BodySprite = new BodySprite();
			elements.push(head);
			head.x=_startpos.x;
			head.y=_startpos.y;
			head.color = _color;
			addChild(head);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		
			addBodyParts(startlength);			
		}
		
		private function addBodyParts(num:int):void
		{
			for (var i:int = 0; i < num; i++)
			{
				var element:BodySprite = new BodySprite();
				
				elements.push(element);
				element.x=-999;
				element.y=-999;
				element.color = _color;
				
				addChild(element);
			}
		}
			
		// returns the position of the head of the snake
		public function get getPosition():Point
		{
			var point:Point = new Point(elements[0].x,elements[0].y);
			return point;
		}

		// set position
		public function set position(pos:Point):void
		{
			elements[0].x = pos.x;
			elements[0].y = pos.y;
		}
		
		public function isDead():Boolean
		{
			return _dead;
		}

		public function update(dt:int):void
		{		
			if(_dead)
				return;
			
			var angle:Number = 0.003*dt;
			var counter:int = 0;
			
			// steering (rotating the direction)
			if(keyPressedLeft) {
				direction.y = Math.cos(Math.atan2(direction.x,direction.y)+angle);
				direction.x = Math.sin(Math.atan2(direction.x,direction.y)+angle);
			}
			else if(keyPressedRight){
				direction.y = Math.cos(Math.atan2(direction.x,direction.y)-angle);
				direction.x = Math.sin(Math.atan2(direction.x,direction.y)-angle);
			}
			
			// reposition every body parr
			for(var i:int=elements.length-1; i>=1; i--) {	
				
				var direction_part:Point = new Point(elements[i].x-elements[i-1].x,elements[i].y-elements[i-1].y);

				elements[i].x = elements[i-1].x;
				elements[i].y = elements[i-1].y;
		
				// check self collision
				var dx:int = elements[i].x - elements[0].x;
				var dy:int = elements[i].y - elements[0].y;
				
				var distance:int = Math.sqrt( dx*dx + dy*dy);
				
				if(i > 10) 
				{
					if(distance < 15 && direction.x/direction.y - direction_part.x/direction_part.y)
						die();
				}
			}

			// move head into new direction
			elements[0].x += direction.x*dt*GameSpeed;
			elements[0].y += direction.y*dt*GameSpeed;

			
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
			if(e.type==KeyboardEvent.KEY_DOWN && e.keyCode==leftKey)
			{
				keyPressedLeft = true;
			}
			
			if(e.type==KeyboardEvent.KEY_UP && e.keyCode==rightKey)
			{
				keyPressedRight = false;
			}
			if(e.type==KeyboardEvent.KEY_UP && e.keyCode==leftKey)
			{
				keyPressedLeft = false;
			}
			
		}
		
		public function checkCollision(pos:Point):Boolean
		{
			for (var i:int = 0; i < elements.length; i++)
			{
				
				var dx:int = pos.x - elements[i].x;
				var dy:int = pos.y - elements[i].y;
				
				var distance:int = Math.sqrt( dx*dx + dy*dy);
				
				if(distance <= 15)
				{
					return true;
				}	
			}
			return false;
		}
		
		public function die():void
		{
			if(!_dead)
				dieSound.play(0,0,null);
			_dead=true;
		}
		
		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			addBodyParts(20);
			_score = value;
		}

	}
}
