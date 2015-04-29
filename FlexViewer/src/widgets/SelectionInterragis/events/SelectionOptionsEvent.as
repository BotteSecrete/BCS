package widgets.Selection.events
{
	import com.esri.ags.layers.FeatureLayer;
	
	import flash.events.Event;
	
	public class SelectionOptionsEvent extends Event
	{
		public static var SELECTION_METHOD_CHANGE:String = "selectionMethodChange";
		
		public var selectionMethod:String
		
		public function SelectionOptionsEvent(type:String, selectionMethod:String = FeatureLayer.SELECTION_NEW )
		{
			super(type, true);
			this.selectionMethod = selectionMethod;
		}
	}
}