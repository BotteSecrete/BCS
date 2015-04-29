package
{
	import mx.skins.RectangularBorder;
	
	public class HBoxSkin extends RectangularBorder
	{
		public function HBoxSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var cr:Number = getStyle("cornerRadius");
			var bc:Number = getStyle("backgroundColor");
			
			graphics.clear();
			graphics.beginFill(bc, 1);
			
			// Draw the rectangle manually, rounding only the top two corners
			graphics.drawRoundRectComplex(0, 0, unscaledWidth, unscaledHeight, cr, 0, cr, 0);
			graphics.endFill();
		}
	}
}