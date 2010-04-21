package utils
{

public class HeadSprite extends ShapeSprite
{
	public function HeadSprite()
	{
		super();
	}

	override protected function render():void
	{
		graphics.clear();
//		graphics.lineStyle(2, strokeColor);
		graphics.beginFill(color);
		graphics.drawCircle(15,15,15);
		graphics.endFill();
	}

}
}