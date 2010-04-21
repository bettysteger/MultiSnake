package utils
{
import flash.display.Sprite;
import flash.events.Event;

public class ShapeSprite extends Sprite
{
	//public var color:uint = 0xff0000;
	private var isInvalid:Boolean;

	public function ShapeSprite()
	{
		super();

		// step 1: 
		addEventListener(Event.RENDER, renderHandler);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

		render();
	}

	private function addedToStageHandler(e:Event):void
	{
		if (e.target == this)
		{
//			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			invalidate();
		}
	}

	private function renderHandler(e:Event):void
	{
		if (isInvalid)
		{
//			trace(name + " render");
			render();
			isInvalid = false;
		}
	}

	private var _strokeColor:uint;

	private var _color:uint = 0xff0000;

	public function get color():uint
	{
		return _color;
	}

	public function set color(value:uint):void
	{
		if (value == _color)
			return;

		_color = value;
//		trace(name + ": set color: invalidate");
		invalidate();
	}

	protected function render():void
	{
		throw new Error("Abstract function render: you must override this function!");
	}

	public function get strokeColor():uint
	{
		return _strokeColor;
	}

	public function set strokeColor(value:uint):void
	{
		if (value == _strokeColor)
			return;

		_strokeColor = value;
//		trace(name + " set strokeColor: invalidate");
		invalidate();
	}

	private function invalidate():void
	{
		// step 2: calling stage.invalidate causes the Flash Player
		// to dispatch the RENDER event before the next screen refresh
		isInvalid = true;
		if (stage)
			stage.invalidate();
	}

}
}