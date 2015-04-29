import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.CloseEvent;



private function changeStatus(event:FeatureLayerEvent, ev:MouseEvent, k:Number):void
{
	if(configXML.USER == "Validateur")
	{
		switch (ev.target.label)
		{
			case "Completed":
				if(ev.target.selected)
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.COMPLETE = "OUI";
					attributes.LOCA_CNGE = event.features[k].attributes.PROJ_ID + "b";
					ev.target.parent.getChildAt(1).enabled = true;
					ev.target.parent.getChildAt(2).enabled = false;
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);	
				}
				else
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.COMPLETE = "NON";
					attributes.LOCA_CNGE = event.features[k].attributes.PROJ_ID + "a";
					ev.target.parent.getChildAt(1).selected = false;
					ev.target.parent.getChildAt(2).selected = false;
					attributes.CHECK_ = "NON";
					attributes.VALID = "NON";
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);	
				}
				break;
			case "Checked":
				if(ev.target.selected)
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.COMPLETE = "OUI";
					attributes.CHECK_ = "OUI";
					attributes.LOCA_CNGE = event.features[k].attributes.PROJ_ID + "c";
					ev.target.parent.getChildAt(1).enabled = true;
					ev.target.parent.getChildAt(2).enabled = true;
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);
				}
				else
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.COMPLETE = "OUI";
					attributes.CHECK_ = "NON";
					attributes.LOCA_CNGE = event.features[k].attributes.PROJ_ID + "b";
					attributes.VALID = "NON";
					changedStatus = true;
					ev.target.parent.getChildAt(2).selected = false;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);
				}
				break;
			case "Validated":
				if(ev.target.selected)
				{
					Alert.yesLabel = "Proceed";
					Alert.noLabel = "Cancel";
					Alert.show("This action means that this borehole is validated and you'll not be able to edit this one later","Warning",mx.controls.Alert.YES | mx.controls.Alert.NO,null, alertListenerValid, null, mx.controls.Alert.YES);
					function alertListenerValid(eventObj:CloseEvent):void {
						// Check to see if the OK button was pressed.
						if (eventObj.detail==mx.controls.Alert.YES) {
							var attributes:Object = {};
							attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
							attributes.COMPLETE = "OUI";
							attributes.CHECK_ = "OUI";
							attributes.VALIDE = "OUI";
							attributes.LOCA_CNGE = event.features[k].attributes.PROJ_ID + "d";
							var feature:Graphic = new Graphic(null, null, attributes);
							var updates:Array = [ feature ];
							featLayer.applyEdits(null,updates,null);
							//statusbut.enabled = false;
							map.infoWindow.hide();
						}
						else
						{
							ev.target.selected = false;
						}
					}
				}
				else
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.COMPLETE = "OUI";
					attributes.CHECK_ = "OUI";
					attributes.VALID = "NON";
					attributes.LOCA_CNGE = event.features[k].attributes.PROJ_ID + "c";
					ev.target.parent.getChildAt(1).selected = false;
					ev.target.parent.getChildAt(2).selected = false;
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);
				}
				break;
		}
	}
	else  //Presta Case
	{
		switch (ev.target.label)
		{
			case "Completed":
				if(ev.target.selected)
				{
					Alert.yesLabel = "Proceed";
					Alert.noLabel = "Cancel";
					Alert.show("This action means that this borehole is completed and you'll not be able to edit this one later","Warning",mx.controls.Alert.YES | mx.controls.Alert.NO,null, alertListenerPresta, null, mx.controls.Alert.YES)
					function alertListenerPresta(eventObj:CloseEvent):void {
						// Check to see if the OK button was pressed.
						if (eventObj.detail==mx.controls.Alert.YES) {
							changedStatus = true;
							var attributes:Object = {};
							attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
							attributes.COMPLETE = "OUI";
							attributes.LOCA_CNGE = event.features[k].attributes.PROJ_ID + "b";
							var feature:Graphic = new Graphic(null, null, attributes);
							var updates:Array = [ feature ];
							featLayer.applyEdits(null,updates,null);
							//statusbut.enabled = false;
							map.infoWindow.hide();
							//TODO code pour envoyer le mail
							sendMail(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.LOCA_ID.toString(), event.features[k].attributes.PROJ_ID);
						}
						else if (eventObj.detail == mx.controls.Alert.NO)
						{
							ev.target.selected = false;
						}
					}
				}
				else
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.COMPLETE = "NON";
					attributes.LOCA_CNGE = event.features[k].attributes.PROJ_ID + "a";
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);
				}
				break;
			
		
		}//End Switch
	}// End Presta Case
}// End function