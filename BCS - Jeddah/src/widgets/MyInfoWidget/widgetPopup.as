import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.geometry.Polygon;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.symbols.Symbol;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.ags.tools.DrawTool;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.events.Event;

import mx.controls.Alert;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;

// ActionScript file
private function addToFeatureLayerHandler():void
{
//	if(lon.text == "" || lat.text=="")
//	{
//		Alert.show("Veuillez entrer des coordonnées SVP");
//	}
//	else
//	{
//		if((lon.text.split(",").length > 1)||(lat.text.split(",").length > 1))
//		{
//			Alert.show("Attention, il y a plusieurs séparateurs ici...");
//		}
//		else
//		{
//			if(lon.text.search(/[,]/) != -1)
//			{
//				lon.text = lon.text.replace(/[,]/, ".");
//			}
//			if(lat.text.search(/[,]/) != -1)
//			{
//				lat.text = lat.text.replace(/[,]/, ".");
//			}
//		}
//		
//		
//		if(isNaN(parseFloat(lon.text)) ||isNaN(parseFloat(lat.text)))
//		{
//			Alert.show("Veuillez entrer des coordonnées correctes SVP");
//		}
//		else if((lon.text.split(".").length > 1)||(lat.text.split(".").length > 1))
//		{
//			Alert.show("Attention, il y a plusieurs séparateurs ici...");
//		}
//		else
//		{
//			var formPoint:MapPoint = new MapPoint(parseFloat(lon.text), parseFloat(lat.text), map.spatialReference);
//			addPoint(formPoint);
//		}
//	}
}

private function addOnClickToFeatureLayerHandler(evt:Event):void
{ 
	if (evt.target.selected){
		clickToAdd = true;
		//cursorID = CursorManager.setCursor(waitCursorSymbol);
		var symbol:Symbol = featLayer.layerDetails.drawingInfo.renderer.getSymbol(featLayer.layerDetails.types[0].templates[0].prototype as Graphic) as Symbol;;
		
		//featLayer.layerDetails.drawingInfo.renderer.getSymbol(featLayer as Graphic);
		setMapAction(DrawTool.MAPPOINT,"Click to add", symbol, null);
		
//		addButtonByClick.label = "Cancel";
	}
	else
	{
		clickToAdd = false;
//		addButtonByClick.label =  "Click to add";
		setMapAction(null,null,null,null);
	}
}

private function addPoint(mp:MapPoint):void
{
	/*if(mp!=null)
	{
		var attributes:Object = {};
		attributes = {LOCA_ID:0,
			LOCA_NATE:mp.x,
				LOCA_NATN:mp.y,
				LOCA_CNGE:((dpProj[0].data).toString() + "a"),
				PROJ_ID:dpProj[0].data,
				VALIDE:"NON",
				CHECK_:"NON",
				COMPLETE:"NON"};
		var feature:Graphic = new Graphic(mp, null, attributes);
		var add:Array = [ feature ];
		featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,myFeatureLayer_editsCompleteHandler);
		featLayer.applyEdits(add,null,null);
		
		//featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,myFeatureLayer_editsCompleteHandler);
		map.centerAt(mp);
	}
	else
	{
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/trash.png";
		toastMessage.sampleCaption = "Can't add this";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
	}*/
}
private function addPolygon(pg:Polygon):void
{
	if (pg!=null)
	{
		clickToAdd = true;
		var attributes:Object = {};
		attributes = {CODE:"0",
			Concaten:"NNNN",
			Terminated:"NON",
			Validated:"NON",
			Returned:"NON",
			Report:"NON"};
		var feature:Graphic = new Graphic(pg, null, attributes);
		var add:Array = [feature];
		featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,myFeatureLayer_editsAddCompleteHandler);
		featLayer.applyEdits(add,null,null);
		
		map.centerAt(pg.extent.center);
	}
}

private function myFeatureLayer_editsAddCompleteHandler(event:FeatureLayerEvent):void
{
	featLayer.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE,myFeatureLayer_editsAddCompleteHandler);
	var attributes:Object = {};
	attributes = {OBJECTID:event.featureEditResults.addResults[0].objectId,
		OBJECTID_COPIE:event.featureEditResults.addResults[0].objectId};
	var feature:Graphic = new Graphic (null, null, attributes);
	var update:Array = [feature];
	featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,myFeatureLayer_editsCompleteHandler);
	featLayer.applyEdits(null,update,null);
}

