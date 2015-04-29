import com.esri.ags.Graphic;
import com.esri.viewer.AppEvent;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.rpc.AsyncResponder;


private function addGratRow(event:AppEvent):void
{
	var add:Array = []
	var attributes:Object = {};
	
	
	var tmp:Object = content.getChildAt(content.selectedIndex); //getResCanvas
	tmp = tmp.getChildAt(0)//get Vcanvas
	tmp = tmp.getChildByName("grid"); //get grid
	tmp = tmp.getChildAt(2); //get gridRow3
	tmp = tmp.getChildByName("invisibleID"); // get invisibleID
	tmp = tmp.getChildAt(0);
	
	attributes = {GRAG_ID: tmp.text};
	var feature:Graphic = new Graphic(null, null, attributes);
	add.push(feature);
	dontDisplay = false;
	grat.applyEdits(add,null,null,false,new AsyncResponder(gratCompleteEdits,faultgratEdit));
}

private function delGratRow(event:AppEvent):void
{
	if(event.data.datagrid.selectedItems.length == 0)
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
				for(var k:Number = 0; k<event.data.datagrid.selectedItems.length; k++)
				{
					var attrib:Object = {};
					attrib.OBJECTID = event.data.datagrid.selectedItems[k].OBJECTID;
					var feature:Graphic = new Graphic(null, null, attrib);
					del.push(feature);
				}
				grat.applyEdits(null,null,del,false,new AsyncResponder(gratCompleteEdits,faultgratEdit));
			}
		}
	}
}