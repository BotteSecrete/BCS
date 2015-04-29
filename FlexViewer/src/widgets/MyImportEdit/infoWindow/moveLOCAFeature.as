import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.tools.DrawTool;

import flash.display.DisplayObject;
import flash.events.MouseEvent;

import mx.containers.Form;
import mx.containers.FormItem;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.TextInput;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

import spark.components.TitleWindow;
import spark.components.VGroup;

private var eastingInputValue : mx.controls.TextInput = new mx.controls.TextInput();
private var northingInputValue : mx.controls.TextInput = new mx.controls.TextInput();
private var popup:spark.components.TitleWindow =  new spark.components.TitleWindow();

// ActionScript file

private function moveFeature(event:FeatureLayerEvent, k:Number):void
{
	Alert.yesLabel = "Click";
	Alert.noLabel = "Coord";
	Alert.show("Do you want to move the feature by clicking on the map or setting its new WGS coordinates ","Make your choice",mx.controls.Alert.YES | mx.controls.Alert.NO | mx.controls.Alert.CANCEL,null, alertListener, null, mx.controls.Alert.YES)
	function alertListener(eventObj:CloseEvent):void 
	{
		// Check to see if the OK button was pressed.
		if (eventObj.detail==mx.controls.Alert.YES) 
		{
			clickToMove = true;
			objectIdToMove = event.features[k].attributes.OBJECTID;
			setMapAction(DrawTool.MAPPOINT,"Click to move point", null, null)
			
		} 
		else if (eventObj.detail==mx.controls.Alert.NO)
		{
			var reExp:RegExp = /[.]/gi;
			
			
			var vGroupForm:VGroup =  new VGroup();
			vGroupForm.verticalAlign="middle";
			vGroupForm.horizontalAlign="center";
			vGroupForm.percentHeight = vGroupForm.percentWidth = 100;
			
			var coordForm:Form =  new Form();
			var eastVal:String = (event.features[k].geometry.x).toFixed(3).toString();
			if((event.features[k].geometry.x).toFixed(3).toString().search(reExp) > -1)
			{
				eastVal = (event.features[k].geometry.x).toFixed(3).toString().replace(reExp,",");
			}
			
			eastingInputValue.text = eastVal;
			
			var xFormItem:FormItem = new FormItem();
			xFormItem.label = "Easting (m) : ";
			xFormItem.addChild(eastingInputValue);
			
			coordForm.addElement(xFormItem);
			
			var northVal:String = (event.features[k].geometry.y).toFixed(3).toString();
			if((event.features[k].geometry.y).toFixed(3).toString().search(reExp) > -1)
			{
				northVal = (event.features[k].geometry.y).toFixed(3).toString().replace(reExp,",");
			}
			
			northingInputValue.text = northVal;
			
			var yFormItem:FormItem = new FormItem();
			yFormItem.label = "Northing (m) : ";
			yFormItem.addChild(northingInputValue);
			
			coordForm.addElement(yFormItem);
			
			var saveFormItem:FormItem = new FormItem();
			var saveButtonCoord:Button = new Button();
			saveButtonCoord.label = "Save New Coordinates";
			saveButtonCoord.addEventListener(MouseEvent.CLICK, saveCoordToMoveHandler);
			saveFormItem.addChild(saveButtonCoord);
			
			coordForm.addChild(saveFormItem);
			vGroupForm.addElement(coordForm);
			popup.addElement(vGroupForm);
			
			popup.title = "Enter new coordinates here";
			coordForm.x = popup.width*20/100;
			coordForm.top = popup.height*10/100
			popup.width = 33*screenWidth/100;
			popup.height = 25*screenHeight/100;
			PopUpManager.addPopUp(popup, parentApplication  as DisplayObject,true);
			PopUpManager.centerPopUp(popup);
			popup.addEventListener(CloseEvent.CLOSE, closePopUpCoord);
			
			function saveCoordToMoveHandler(ev:MouseEvent):void
			{
				//saveCoordToMove(event, k);
				coordToMove = true;
				var formPoint:MapPoint = new MapPoint(parseFloat(eastingInputValue.text), parseFloat(northingInputValue.text), map.spatialReference);
				movePoint(formPoint,event.features[k].attributes.OBJECTID)
				PopUpManager.removePopUp(popup);
			}		
			
			function closePopUpCoord(ev:CloseEvent):void
			{
				PopUpManager.removePopUp(popup);
			}
		}
	}
} // END OF FUNCTION moveFeatureByClick



/*private function saveCoordToMove(event:FeatureLayerEvent,k:Number):void
{
	coordToMove = true;
	
	var formPoint:MapPoint = new MapPoint(parseFloat(eastingInputValue.text), parseFloat(northingInputValue.text), map.spatialReference);

	var attributes:Object = {};
	
	attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
	var feature:Graphic = new Graphic(formPoint, null, attributes);
	var updates:Array = [ feature ];
	
	featLayer.applyEdits(null,updates,null);
	map.centerAt(formPoint);
	
	PopUpManager.removePopUp(popup);
}*/


private function movePoint(mp:MapPoint,objectID:Number):void
{
	var attributes:Object = {};
	
	attributes = {OBJECTID:objectID};
	var feature:Graphic = new Graphic(mp, null, attributes);
	var updates:Array = [ feature ];
	featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,myFeatureLayer_editsCompleteHandler);
	featLayer.applyEdits(null,updates,null);
	
	//featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,myFeatureLayer_editsCompleteHandler);
	map.centerAt(mp);
}