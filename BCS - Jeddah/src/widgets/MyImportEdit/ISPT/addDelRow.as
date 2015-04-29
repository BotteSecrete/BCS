import com.esri.ags.Graphic;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.rpc.AsyncResponder;

// ActionScript file
private function addISPTRowToTable(holeObjId:Number, isptEditsFault:Function, isptEditsCompleted:Function):void
{					
	var add:Array = []
	var attributes:Object = {};
	attributes = {LOCA_ID:holeObjId};
	var feature:Graphic = new Graphic(null, null, attributes);
	add.push(feature);
	cursorManager.setBusyCursor();
	ispt.applyEdits(add,null,null,new AsyncResponder(isptEditsCompleted,isptEditsFault)); 		
	
}//END function AddRowTOTable

private function delISPTRowFromTable(event:MouseEvent):void //Ne possède pas de Handler car pas besoin de paramètre supplémentaire
{
	if(isptDataGrid.selectedItems.length == 0)
	{
		Alert.show("Please select at least a row before")
	} 
	else
	{
		Alert.yesLabel = "Yes, proceed";
		Alert.noLabel = "Cancel";
		Alert.show("Are you sure you want to delete selected lines", "Warning", mx.controls.Alert.YES | mx.controls.Alert.NO,null, alertListener, null, mx.controls.Alert.YES)
		function alertListener(eventObj:CloseEvent):void {
			if (eventObj.detail==mx.controls.Alert.YES) {
				var del:Array = [];
				for(var k:Number = 0; k<isptDataGrid.selectedItems.length; k++)
				{
					var attrib:Object = {};
					attrib.OBJECTID = isptDataGrid.selectedItems[k].OBJECTID;
					var feature:Graphic = new Graphic(null, null, attrib);
					del.push(feature);
				}
				ispt.applyEdits(null,null,del);
			}
		}
	}
}