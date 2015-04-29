import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.tasks.supportClasses.Query;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import mx.controls.Alert;
import mx.rpc.Fault;

private function featLayerSelectFault(fault:Fault, token:Object = null):void
{
	Alert.show("fault");
}


public function myFeatureLayer_selectionCompleteHandler(event:FeatureLayerEvent):void
{	
	
	if(featLayer.selectedFeatures.length == 0)
	{
		map.infoWindow.hide();
	}
	var ndFeatSel:uint = event.target.selectedFeatures.length;
	var numFeatDisp:uint = 0;
	status.text = ndFeatSel.toString() + " feature(s) selected";
	
	if(ndFeatSel > 0)//cas où il y a au moins une entité sélectionnée
	{
		createInfoWindow(numFeatDisp, event, ndFeatSel)
	}
	
}//End myFeatureLayer_SelectionComplete		


private function myFeatureLayer_editsCompleteHandler(event:FeatureLayerEvent):void
{
	
	var query:Query = new Query();
	featLayer.outFields = ["*"];
	
	if(clickToAdd && !clickToMove && !coordToMove) //Cas où l'on ajoute un élément par click
	{
		clickToAdd=false;	
		if(event.featureEditResults.addResults.length>0){
			query = new Query();
			query.objectIds = [event.featureEditResults.addResults[0].objectId];
			query.outFields=["*"];
			callLater(featLayer.refresh);
			featLayer.selectFeatures(query);
//			addButtonByClick.label =  "Click to add";
//			addButtonByClick.selected = false;
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/trash.png";
			toastMessage.sampleCaption = "Added";
			toastMessage.timeToLive = 3;
			index.simpleToaster.toast(toastMessage);
		}
	}
	
	
	if(!featLayer.willTrigger(FeatureLayerEvent.SELECTION_COMPLETE))
	{
		featLayer.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler);
	}
	featLayer.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE,myFeatureLayer_editsCompleteHandler);
}