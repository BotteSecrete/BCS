package widgets.Selection.events
{
	import com.esri.ags.layers.FeatureLayer;
	
	import flash.events.Event;
	
	public class SelectionFeatureLayerEvent extends Event
	{
		public static var REMOVE_GRAPHIC_LISTENER:String = "removeGraphicListener";
		public static var ADD_GRAPHIC_LISTENER:String = "addGraphicListener";
		public static var LAYER_RESULTS:String = "featurelayer_results";
		public static var SHOW_RESULTS:String = "show_featurelayer_results";
		
		public var featureLayer:FeatureLayer;
		
		public function SelectionFeatureLayerEvent(type:String, featureLayer:FeatureLayer)
		{
			super(type, true);
			
			this.featureLayer = featureLayer;
		}
	}
}