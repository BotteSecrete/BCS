import com.esri.ags.Graphic;

import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.events.CloseEvent;

private function addSampRowToTable(holeObjectID:Number):void
{	
	var add:Array = []
	var attributes:Object = {};
	
	attributes = {LOCA_ID:holeObjectID};
	var feature:Graphic = new Graphic(null, null, attributes);
	add.push(feature);
	cursorManager.setBusyCursor();
	dontDisplay = false;
	samp.applyEdits(add,null,null);
}


private function delSampRowFromTable():void
{
	if(sampDataGrid.selectedItems.length == 0)
	{
		Alert.show("Please select at least a row before");
	} 
	else
	{
		Alert.show("Are you sure you want to delete selected lines", "Warning", mx.controls.Alert.YES | mx.controls.Alert.NO,null, alertListener, null, mx.controls.Alert.YES);
		function alertListener(eventObj:CloseEvent):void 
		{
			if (eventObj.detail==mx.controls.Alert.YES) 
			{
				var del:Array = [];
				for(var k:Number = 0; k<sampDataGrid.selectedItems.length; k++)
				{
					var attrib:Object = {};
					attrib.OBJECTID = sampDataGrid.selectedItems[k].OBJECTID;
					var feature:Graphic = new Graphic(null, null, attrib);
					del.push(feature);
				}
				samp.applyEdits(null,null,del);
			}
		}
	}
}
