package widgets.Selection.utils
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Multipoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.utils.GraphicUtil;

	public class SelectionWidgetUtil
	{
		public static function zoomtoSelectedFeatures(featureLayer:FeatureLayer):void            
		{
			var map:Map
			if (featureLayer.map)
			{
				map = featureLayer.map;
			}
			else
			{
				return;
			}
			
			if (featureLayer.selectedFeatures.length > 0)
			{
				var graphicsExtent:Extent = GraphicUtil.getGraphicsExtent(featureLayer.selectedFeatures);
				// Check if there is only one feature and it is a point
				if (graphicsExtent== null && featureLayer.selectedFeatures.length==1)
				{
					var g:Graphic = Graphic(featureLayer.selectedFeatures[0]);
					if (g.geometry.type==Geometry.MAPPOINT)
					{
						var myPoint:MapPoint = MapPoint(g.geometry);
						graphicsExtent = new Extent(myPoint.x + 500, myPoint.y + 500,
							myPoint.x - 500, myPoint.y - 500, null);
					}
				} 
				
				if (graphicsExtent)
				{
					
					map.extent = graphicsExtent;
					// make sure the whole extent is visible
					if (!map.extent.contains(graphicsExtent))
					{
						map.level--;
					}
				}
			} 
		} // end function zoomtoSelectedFeatures
		
		public static function getGraphicExtent(graphic:Graphic):Extent
		{
			var result:Extent;
			switch (graphic.geometry.type)
			{
				case Geometry.MAPPOINT:
				{
					var myPoint:MapPoint = MapPoint(graphic.geometry);
					result = new Extent(myPoint.x + 500, 
						myPoint.y + 500,
						myPoint.x - 500,
						myPoint.y - 500,
						null);
					//result = MapPoint(graphic.geometry).extent;
					break;
				}
				case Geometry.POLYLINE:
				{
					result = Polyline(graphic.geometry).extent;
					break;
				}
				case Geometry.POLYGON:
				{
					result = Polygon(graphic.geometry).extent;
					break;
				}
			} // End Switch
			return result;
		} // End Function
		
		public static function unionGeoms(featureSet:FeatureSet):Geometry
		{
			/*This function is by Robert Scheitlin
				taken from his Enhanced search widget 18 Feb 2011
			    http://www.arcgis.com/home/item.html?id=5d4995ccdb99429185dfd8d8fb2a513e
			*/
			
			var graphic:Graphic;
			var retGeom:Geometry;
			var mPoint:Multipoint = new Multipoint(null);
			var mPoly:Polygon = new Polygon(null);
			var mPolyL:Polyline = new Polyline(null);
			var rType:String;
			for each (graphic in featureSet.features)
			{
				if(graphic.geometry.type == "esriGeometryPoint")
				{
					mPoint.addPoint(graphic.geometry as MapPoint);
					rType = "point";
				}
				
				if(graphic.geometry.type == "esriGeometryMultipoint")
				{
					var mp:Multipoint = graphic.geometry as Multipoint
					var pnts:MapPoint;
					for (var p:int=0;p < mp.points.length; p++)
					{
						mPoint.addPoint(mp.points[p]);
					}
					rType = "point";
				}
				
				if(graphic.geometry.type == "esriGeometryPolygon")
				{
					var poly:Polygon = graphic.geometry as Polygon;
					for (var i2:int = poly.rings.length - 1; i2 >= 0; i2--)
					{
						var ringArray:Array = [];
						for (var j1:int = 0; j1 < poly.rings[i2].length; j1++)
						{
							var mp2:MapPoint = poly.getPoint(i2,j1) as MapPoint;
							mp2.spatialReference = poly.spatialReference;
							ringArray.push(mp2);
						}
						mPoly.addRing(ringArray);
					}
					rType = "poly";
					mPoly.spatialReference = poly.spatialReference;
				}
				
				if(graphic.geometry.type == "esriGeometryPolyline")
				{
					var polyl:Polyline = graphic.geometry as Polyline;
					for(var l:int=polyl.paths.length-1; l >= 0; l--)
					{
						var pathArray:Array = [];
						for (var j2:int = 0; j2 < polyl.paths[l].length; j2++)
						{
							var mp3:MapPoint = polyl.getPoint(l,j2) as MapPoint;
							mp3.spatialReference = polyl.spatialReference;
							pathArray.push(mp3);
						}
						mPolyL.addPath(pathArray);
					}
					rType = "line";
				}
				
				if(graphic.geometry.type == "esriGeometryEnvelope")
				{
					var ext:Extent = graphic.geometry as Extent;
					var pA:Array = [];
					pA.push(new MapPoint(ext.xmin,ext.ymin,ext.spatialReference));
					pA.push(new MapPoint(ext.xmin,ext.ymax,ext.spatialReference));
					pA.push(new MapPoint(ext.xmax,ext.ymax,ext.spatialReference));
					pA.push(new MapPoint(ext.xmax,ext.ymin,ext.spatialReference));
					pA.push(new MapPoint(ext.xmin,ext.ymin,ext.spatialReference));
					mPoly.addRing(pA);
					rType = "poly";
				}
			}
			switch(rType){
				case "point":
				{
					retGeom = mPoint;
					break;
				}
				case "poly":
				{
					retGeom = mPoly;
					break;
				}
				case "line":
				{
					retGeom = mPolyL;
					break;
				}
			}
			trace("unionGeoms Complete");
			return retGeom;
		}
	}
}