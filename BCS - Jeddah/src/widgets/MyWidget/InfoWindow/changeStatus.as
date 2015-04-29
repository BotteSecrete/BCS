import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;



private function changeStatusStruct(event:FeatureLayerEvent, ev:MouseEvent, k:Number):void
{
	
}

private function changeStatus(event:FeatureLayerEvent, ev:MouseEvent, k:Number):void
{
	if(configXML.USER == "Validateur")
	{
		switch (ev.target.label)
		{
			case "Terminated":
				if(ev.target.selected)
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.Terminated = "OUI";
					attributes.Returned = "NON";
					attributes.Concaten = "ONNN";
					ev.target.parent.getChildAt(1).enabled = true;
					ev.target.parent.getChildAt(1).selected = false;
					ev.target.parent.getChildAt(2).enabled = true;
					ev.target.parent.getChildAt(3).enabled = false;
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);
					sendMail(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
				}
				else
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.Terminated = "NON";
					attributes.Concaten = "NNNN";
					ev.target.parent.getChildAt(1).selected = false;
					ev.target.parent.getChildAt(1).enabled = false;
					ev.target.parent.getChildAt(2).selected = false;
					ev.target.parent.getChildAt(2).enabled = false;
					ev.target.parent.getChildAt(3).enabled = false;
					attributes.Validated = "NON";
					attributes.Returned = "NON";
					attributes.Report = "NON";
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);	
				}
				break;
			case "Returned":
				if(ev.target.selected)
				{
//					var attributes:Object = {};
//					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
//					attributes.Returned = "OUI";
//					attributes.Terminated = "NON";
//					attributes.Concaten = "NNON";
//					ev.target.parent.getChildAt(0).selected = false;
//					ev.target.parent.getChildAt(2).enabled = false;
//					ev.target.parent.getChildAt(3).enabled = false;
//					changedStatus = true;
//					var feature:Graphic = new Graphic(null, null, attributes);
//					var updates:Array = [ feature ];
//					featLayer.applyEdits(null,updates,null);
//					sendMailPresta(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//					sendMailLect1Reject(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//					sendMailLect2Reject(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//					sendMailLect3Reject(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
					var myPopup:DialogBox = PopUpManager.createPopUp(this,DialogBox,false) as DialogBox;
					myPopup.addEventListener(MouseEvent.CLICK,clickEvt);
					PopUpManager.centerPopUp(myPopup);
				}
				else
				{
					var attributes:Object = {};
					attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
					attributes.Terminated = "NON";
					attributes.Returned = "NON";
					attributes.Concaten = "ONNN";
					attributes.Validated = "NON";
					attributes.Report = "NON";
					changedStatus = true;
					ev.target.parent.getChildAt(2).enabled = true;
					ev.target.parent.getChildAt(3).enabled = false;
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
					Alert.show("This action means that this building is validated and you'll not be able to edit this one later","Warning",mx.controls.Alert.YES | mx.controls.Alert.NO,null, alertListenerValid, null, mx.controls.Alert.YES);
					function alertListenerValid(eventObj:CloseEvent):void {
						// Check to see if the OK button was pressed.
						if (eventObj.detail==mx.controls.Alert.YES) {
							var attributes:Object = {};
							attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
							attributes.Validated = "OUI";
							attributes.Terminated = "OUI";
							attributes.Returned = "NON";
							attributes.Report = "NON";
							attributes.Concaten = "OONN";
							statusValidated = true;
							changedStatus = true;
							ev.target.parent.getChildAt(0).enabled = false;
							ev.target.parent.getChildAt(1).enabled = false;
							ev.target.parent.getChildAt(2).enabled = false;
							ev.target.parent.getChildAt(3).enabled = true;
							var feature:Graphic = new Graphic(null, null, attributes);
							var updates:Array = [ feature ];
							featLayer.applyEdits(null,updates,null);
							sendMailPrestaValid(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//							sendMailLect1Valid(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//							sendMailLect2Valid(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//							sendMailLect3Valid(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
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
					attributes.Terminated = "OUI";
					attributes.Validated = "NON";
					attributes.Concaten = "ONNN";
					ev.target.parent.getChildAt(1).selected = false;
					ev.target.parent.getChildAt(2).selected = false;
					statusValidated = false;
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);
				}
				break;
			case "Report":
				if(ev.target.selected)
				{
					Alert.yesLabel = "Proceed";
					Alert.noLabel = "Cancel";
					Alert.show("This action means that the report for this building is done and you'll not be able to edit this one later","Warning",mx.controls.Alert.YES | mx.controls.Alert.NO,null, alertListenerReport, null, mx.controls.Alert.YES);
					function alertListenerReport(eventObj:CloseEvent):void {
						// Check to see if the OK button was pressed.
						if (eventObj.detail==mx.controls.Alert.YES) {
							var attributes:Object = {};
							attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
							attributes.Validated = "OUI";
							attributes.Terminated = "OUI";
							attributes.Returned = "NON";
							attributes.Report = "OUI";
							attributes.Concaten = "OONO";
							ev.target.parent.getChildAt(0).enabled = false;
							ev.target.parent.getChildAt(1).enabled = false;
							ev.target.parent.getChildAt(2).enabled = false;
							ev.target.parent.getChildAt(3).enabled = true;
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
					attributes.Terminated = "OUI";
					attributes.Validated = "NON";
					attributes.Concaten = "ONNN";
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
			case "Terminated":
				if(ev.target.selected)
				{
					Alert.yesLabel = "Proceed";
					Alert.noLabel = "Cancel";
					Alert.show("This action means that this building is completed and you'll not be able to edit this one later","Warning",mx.controls.Alert.YES | mx.controls.Alert.NO,null, alertListenerPresta, null, mx.controls.Alert.YES)
					function alertListenerPresta(eventObj:CloseEvent):void {
						// Check to see if the OK button was pressed.
						if (eventObj.detail==mx.controls.Alert.YES) {
							var attributes:Object = {};
							attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
							attributes.Terminated = "OUI";
							attributes.Concaten = "ONNN";
							ev.target.parent.getChildAt(0).enabled = false;
							changedStatus = true;
							var feature:Graphic = new Graphic(null, null, attributes);
							var updates:Array = [ feature ];
							featLayer.applyEdits(null,updates,null);
							sendMail(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//							sendMailLect1Complete(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//							sendMailLect2Complete(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
//							sendMailLect3Complete(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42);
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
					attributes.Terminated = "NON";
					attributes.Concaten = "NNNN";
					attributes.Validated = "NON";
					attributes.Returned = "NON";
					attributes.Report = "NON";
					changedStatus = true;
					var feature:Graphic = new Graphic(null, null, attributes);
					var updates:Array = [ feature ];
					featLayer.applyEdits(null,updates,null);	
				}
				break;
			
			
		}//End Switch
	}// End Presta Case
	
	function clickEvt(cEvt:MouseEvent):void {
		if (cEvt.target == myPopup.Yes){
//			Alert.show("Yes","Pupute");
			var attributes:Object = {};
			attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
			attributes.Returned = "OUI";
			attributes.Terminated = "NON";
			attributes.Concaten = "NNON";
			ev.target.parent.getChildAt(0).selected = false;
			ev.target.parent.getChildAt(2).enabled = false;
			ev.target.parent.getChildAt(3).enabled = false;
			changedStatus = true;
			var feature:Graphic = new Graphic(null, null, attributes);
			var updates:Array = [ feature ];
			featLayer.applyEdits(null,updates,null);
			sendMailPresta(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42, myPopup.Info.text);
			sendMailLect1Reject(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42, myPopup.Info.text);
			sendMailLect2Reject(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42, myPopup.Info.text);
			sendMailLect3Reject(event.features[k].attributes.OBJECTID.toString(), event.features[k].attributes.CODE.toString(), 42, myPopup.Info.text);
		} else if (cEvt.target == myPopup.Cancel){
			ev.target.selected = false;
			PopUpManager.removePopUp(myPopup);
		}
	}
	
}// End function