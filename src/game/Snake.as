package game
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import utils.BodySprite;
	import utils.HeadSprite;
	import utils.ShapeSprite;
	
	public class Snake extends Sprite
	{
		public function Snake(player:uint, startlength:uint, x:Number, y:Number, color:uint, dead:Boolean)
		{
			var elements:Array = new Array;
			var element:ShapeSprite;
			
			for (var i:int = 0; i < startlength; i++)
			{
				if (i == 0)
					element = new HeadSprite();
				else
					element = new BodySprite();
				
				elements[i] = element;
				//Start position
				element.x = x;
				element.y = y;
				
				elements.x += element.width*i;
				
				element.color = color;
				
				addChild(element);
			}
			
			
		}
		
	}
}
