import com.esri.ags.Graphic;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.rpc.AsyncResponder;

// ActionScript file
private function addRowToTable(holeObjId:Number, geolEditsFault:Function, geolEditsCompleted:Function):void
{					
	for(var k:Number = 0; k<geolGridSource.length; k++)
	{
		var ind:Number;
		if(isNaN(parseFloat(geolGridSource.getItemAt(k).GEOL_BASE)))
		{
			ind = NaN;
			addResults = k;
			break;
		}
		else
		{
			ind = 0;
		}
	}
	
	if((!isNaN(ind)) || geolGridSource.length == 0){
		var add:Array = []
		var attributes:Object = {};
		attributes = {LOCA_ID:holeObjId};
		var feature:Graphic = new Graphic(null, null, attributes);
		add.push(feature);
		cursorManager.setBusyCursor();
		geol.applyEdits(add,null,null,new AsyncResponder(geolEditsCompleted,geolEditsFault)); 						
	}
	else
	{
		Alert.show("Veuillez remplir tous les GEOL_BASE avec des nombres correctes (dernière ligne)","Warning", mx.controls.Alert.YES,null, alertListener, null);
		function alertListener(eventObj:CloseEvent):void 
		{
			if (eventObj.detail == mx.controls.Alert.YES) {
				dataGrid.editedItemPosition = {columnIndex:1, rowIndex: addResults};
				addResults = -1;	
			}
		}
	}
}//END function AddRowTOTable

private function delRowFromTable(event:MouseEvent):void //Ne possède pas de Handler car pas besoin de paramètre supplémentaire
{
	if(dataGrid.selectedItems.length == 0)
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
				for(var k:Number = 0; k<dataGrid.selectedItems.length; k++)
				{
					var attrib:Object = {};
					attrib.OBJECTID = dataGrid.selectedItems[k].OBJECTID;
					var feature:Graphic = new Graphic(null, null, attrib);
					del.push(feature);
				}
				geol.applyEdits(null,null,del);
			}
		}
	}
}