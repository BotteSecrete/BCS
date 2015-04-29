package widgets.Selection.events
{
	import com.esri.ags.layers.FeatureLayer;
	
	import flash.events.Event;
	
	public class SelectionGraphicEvent extends Event
	{
		public static const OVER_GRAPHIC:String = "overGraphicEvent";
		public static const OVER_GRID:String = "overGridEvent";
		public static const CLICK_GRID:String = "clickGridEvent";
		public static const DOUBLECLICK_GRID:String = "doubleClickGridEvent";

		public var attribute:Object;
		public var featureLayer:FeatureLayer;
		
		public function SelectionGraphicEvent(type:String, attribute:Object, featureLayer:FeatureLayer)
		{
			super(type, true);
			this.attribute = attribute;
			this.featureLayer = featureLayer;
		}
	}
}