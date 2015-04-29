import com.esri.ags.events.FeatureLayerEvent;

import mx.controls.Alert;
import mx.events.CloseEvent;

// ActionScript file
private function deleteFeature(event:FeatureLayerEvent, k:Number):void
{
	Alert.yesLabel = "Yes, proceed";
	Alert.noLabel = "Cancel";
	Alert.show("Are you sure you want to delete  this building","Make your choice",mx.controls.Alert.YES | mx.controls.Alert.NO,null, alertListener, null, mx.controls.Alert.YES)
	function alertListener(eventObj:CloseEvent):void {
		// Check to see if the OK button was pressed.
		if (eventObj.detail==mx.controls.Alert.YES) {
			if(clickToAdd){
				clickToAdd = false;
			}
			if (clickToMove)
			{
				clickToMove =  false;
			}
			featLayer.applyEdits(null,null,[event.features[k]]);
		}
	}
} // END OF FUNCTION deleteFeature