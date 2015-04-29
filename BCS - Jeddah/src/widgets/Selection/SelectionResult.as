package widgets.Selection
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.symbols.Symbol;
	
	[Bindable]
	[RemoteClass(alias="widgets.Selection.SelectionResult")]
	
	public class SelectionResult extends EventDispatcher
	{
		public var title:String;
		
		public var symbol:Symbol;
		
		public var content:String;
		
		public var point:MapPoint;
		
		public var link:String;
		
		public var geometry:Geometry;
	}
}