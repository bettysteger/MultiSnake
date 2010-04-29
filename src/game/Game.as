package game
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.charts.chartClasses.DataDescription;
	import mx.core.Application;
	import mx.core.FlexGlobals;

	public class Game extends Sprite
	{
		private var last_frame_time:Number;
		private var gamefield:GameField;
		
		public function Game()
		{
			gamefield = new GameField;
			addChild(gamefield);

			addEventListener(Event.ADDED_TO_STAGE, function():void {
				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			});
		
			
		}
	
		private function enterFrameHandler(e:Event):void 
		{
			var date:Date = new Date;
			update(date.time - last_frame_time);
			last_frame_time = date.time; 
		}
		
		private function update(dt:Number):void 
		{
<<<<<<< HEAD
			//trace(dt);
=======
>>>>>>> ff730d25653241539f61069396882d44999027a1
			gamefield.update(dt);
			gamefield.draw();
		}
	}
}