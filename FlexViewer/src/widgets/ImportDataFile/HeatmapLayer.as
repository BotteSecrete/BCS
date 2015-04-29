////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
// 
////////////////////////////////////////////////////////////////////////////////

package widgets.ImportDataFile
{
	import com.esri.ags.Graphic;
	import com.esri.ags.esri_internal;
	import com.esri.ags.events.LayerEvent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	use namespace esri_internal;
	
	public class HeatmapLayer extends GraphicsLayer
	{
		//Internal variables
		private var m_heatRadius:Number = 25;
		private var m_valueField:String = "";
		private var m_showPoints:Boolean = false;
		private var m_type:String = "";
		public static const POINT:Point = new Point();
		private var m_bitmapDataLayer:BitmapData;
		private const m_blurFilter:BlurFilter = new BlurFilter(4, 4);
		private var m_centerValue:Number;
		private var m_shape:Shape = new Shape();
		private const m_x:Array = [];	
		private const m_y:Array = [];
		
		/* Get/Set functions for:
			-showPoints: whether to show the points as well as the heatmap
			-heatRadius: how far to extend the density calculation
			-valueField: how to weight each point
		*/
		public function get showPoints():Boolean { return m_showPoints; }
		
		public function set showPoints(value:Boolean): void {
			m_showPoints = value;
			for each (var g:Graphic in (this.graphicProvider as ArrayCollection)) {
				g.alpha = (m_showPoints) ? 1 : 0;
			}}
		
		public function get heatRadius():Number { return m_heatRadius; }
		
		public function set heatRadius(value:Number):void {
			m_heatRadius = value;
			if(map) {drawHeatMap(); }
		}
		
		public function set type(value:String):void {
			m_type = value;
			if(map) {drawHeatMap(); }
		}
		
		public function get valueField():String {return m_valueField;}
		
		public function set valueField(value:String):void {
			m_valueField = value;
			if(map) {updatePoints(); drawHeatMap(); }
		}
		
		//Class initializer.   
		 
		public function HeatmapLayer()
		{
			//We're inheriting FeatureLayer and want to maintain it's functionality
			super();
			//When the layer is updated, we want to redraw the map
			addEventListener(LayerEvent.UPDATE_END, onUpdateHM);
		}
		
		protected function onUpdateHM(e:LayerEvent):void {
			// update the point list; if the update succeeded, redraw the heatmap
			var isPoint:Boolean = updatePoints();
			if (isPoint) {drawHeatMap();}
		}
		
				
		// This function was derived from Mansour Raad's heatmap layer,
		// available at http://thunderheadxpler.blogspot.com/2010/02/heat-map-layer-revisited.html
		private function updatePoints():Boolean {
			m_x.length = 0;
			m_y.length = 0;
			
			var max:Number = 5.0;
			
			const mapW:Number = super.map.width;
			const mapH:Number = super.map.height;
			const extW:Number = super.map.extent.width;
			const extH:Number = super.map.extent.height;
			const facX:Number = mapW / extW;
			const facY:Number = mapH / extH;
			
			var weight:Number  = 1;
			
			const dict:Dictionary = new Dictionary(true);
			var ac:ArrayCollection = this.graphicProvider as ArrayCollection;
			for each (var g:Graphic in ac) {
				if (g.geometry.type != com.esri.ags.geometry.Geometry.MAPPOINT) {return false;}
				g.alpha = (m_showPoints) ? 1 : 0;
				if (super.map.extent.contains(g.geometry)) {
					const sx:Number = ((g.geometry as MapPoint).x - super.map.extent.xmin ) * facX;
					const sy:Number = mapH - ((g.geometry as MapPoint).y - super.map.extent.ymin ) * facY;
					
					m_x.push(sx);
					m_y.push(sy);
					
					const key:String = Math.round(sx) + "_" + Math.round(sy);
					var val:Number = dict[key] as Number;
					if (m_valueField != "") {
						weight = g.attributes[m_valueField] || 1;
					}
					if (isNaN(val)) {
						val = weight;
					} else {
						val += weight;
					}
					dict[key] = val;
					max = Math.max(max, val);
				}
			}
			m_centerValue = Math.max(19.0, 255.0 / max);
			return true;
		}
		
		//Draw Heat map is also copied from Mansour's work, available as specified above
		private function drawHeatMap():void {
			const heatDiameter:int = m_heatRadius * 2;
			const matrix1:Matrix = new Matrix();
			matrix1.createGradientBox(heatDiameter, heatDiameter, 0, -m_heatRadius, -m_heatRadius);
			
			m_shape.graphics.clear();
			m_shape.graphics.beginGradientFill(GradientType.RADIAL, [m_centerValue, 0], [1,1], [0,255], matrix1);
			m_shape.graphics.drawCircle(0, 0, m_heatRadius);
			m_shape.graphics.endFill();
			m_shape.cacheAsBitmap = true;
			
			const bitmapDataShape:BitmapData = new BitmapData(m_shape.width, m_shape.height, true, 0x00000000);
			const matrix2:Matrix = new Matrix();
			matrix2.tx = m_heatRadius;
			matrix2.ty = m_heatRadius;
			bitmapDataShape.draw(m_shape, matrix2);
			
			const clip:Rectangle = new Rectangle(0, 0, super.map.width, super.map.height);
			
			if (m_bitmapDataLayer && m_bitmapDataLayer.width !== map.width && m_bitmapDataLayer.height !== map.height)
			{
				m_bitmapDataLayer.dispose();
				m_bitmapDataLayer = null;
			}
			if (m_bitmapDataLayer === null)
			{
				m_bitmapDataLayer = new BitmapData(map.width, map.height, true, 0x00000000);
			}
			m_bitmapDataLayer.fillRect(clip, 0x00000000);
			const len:int = m_x.length;
			for (var i:int = 0; i < len; i++)
			{
				matrix2.tx = m_x[i] - m_heatRadius;
				matrix2.ty = m_y[i] - m_heatRadius;
				m_bitmapDataLayer.draw(bitmapDataShape, matrix2, null, BlendMode.SCREEN);
			}
			bitmapDataShape.dispose();
			
			// paletteMap leaves some artifacts unless we get rid of the blackest colors 
			m_bitmapDataLayer.threshold(m_bitmapDataLayer, m_bitmapDataLayer.rect, POINT, "<=", 0x00000003, 0x00000000, 0x000000FF, true);
			
			// Replace the black and blue with the gradient. Blacker pixels will get their new colors from
			// the beginning of the gradientArray and bluer pixels will get their new colors from the end. 
			switch(m_type)
			{
				case "RAINBOW":
				{
					m_bitmapDataLayer.paletteMap(m_bitmapDataLayer, m_bitmapDataLayer.rect, POINT, null, null, GradientDict.RAINBOW, null);
					break;
				}
				case "THERMAL":
				{
					m_bitmapDataLayer.paletteMap(m_bitmapDataLayer, m_bitmapDataLayer.rect, POINT, null, null, GradientDict.THERMAL, null);
					break;
				}
				case "RED_WHITE_BLUE":
				{
					m_bitmapDataLayer.paletteMap(m_bitmapDataLayer, m_bitmapDataLayer.rect, POINT, null, null, GradientDict.RED_WHITE_BLUE, null);
					break;
				}
			}
			
			
			
			
			// This blur filter makes the heat map looks quite smooth.
			m_bitmapDataLayer.applyFilter(m_bitmapDataLayer, m_bitmapDataLayer.rect, POINT, m_blurFilter);
			
			graphics.clear();
			
			var matrix3:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, parent.scrollRect.x, parent.scrollRect.y);
			
			graphics.beginBitmapFill(m_bitmapDataLayer, matrix3, false, false);
			graphics.drawRect(parent.scrollRect.x, parent.scrollRect.y, map.width, map.height);
			graphics.endFill();
			
		}
		
	}
}