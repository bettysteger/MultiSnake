package utils
{

public class BodySprite extends ShapeSprite
{
	public function BodySprite()
	{
		super();
	}

	override protected function render():void
	{
		graphics.clear();
//		graphics.lineStyle(2, strokeColor);
		graphics.beginFill(color);
		graphics.drawCircle(10, 10, 10);
		graphics.endFill();
	}

}
}