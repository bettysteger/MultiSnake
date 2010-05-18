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
		
		public function Game(nplayers:int)
		{
			gamefield = new GameField(nplayers);
			addChild(gamefield);

			addEventListener(Event.ADDED_TO_STAGE, function():void {
				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			});		
		}
		
		public function getPlayers():Array
		{
			return gamefield.players;
		}
	
		private function enterFrameHandler(e:Event):void 
		{
			var date:Date = new Date;
			update(date.time - last_frame_time);
			last_frame_time = date.time; 
			if(gamefield.gameEnded) {
				gamefield.hammiTimer.stop();
					FlexGlobals.topLevelApplication.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			
		}
		
		private function update(dt:Number):void 
		{
			gamefield.update(dt);
			gamefield.draw();
		}
	}
}