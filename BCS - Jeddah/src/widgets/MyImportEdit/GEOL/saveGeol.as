import com.esri.ags.Graphic;

import mx.controls.TextInput;
import mx.events.DataGridEvent;
import mx.formatters.NumberFormatter;

import customRenderer.SizeRenderer;

// ActionScript file

private function dgItemEditEnd(event:DataGridEvent):void
{
	//dataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_IN,dgItemFocusIn);
	var updates:Array = [];
	var attributes:Object = {};
	
	if(event.type != "itemFocusOut")
	{
		indRow = event.rowIndex;
		attributes.OBJECTID = geolGridSource.getItemAt(indRow).OBJECTID;
		field = event.dataField;
		
		if (event.dataField == "GEOL_BASE") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			var myFormatter:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
			myFormatter.useThousandsSeparator = false;
			myFormatter.decimalSeparatorFrom = ","
			myFormatter.decimalSeparatorTo = ",";
			myFormatter.precision = 2;
			myFormatter.useThousandsSeparator = false;
			var virRegExp:RegExp = /[.]/gi;
			var regExp:RegExp = /[^0-9,]/gi;
			
			if((newData != null) && (newData.search(virRegExp)>-1))
			{
				newData = newData.replace(virRegExp,",");
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
			}
			
			if((newData != null) && (newData.search(regExp)>-1))
			{
				newData = ""
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
				event.preventDefault();
				mx.controls.TextInput(dataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else
			{
				if(newData != "")
				{
					mx.controls.TextInput(dataGrid.itemEditorInstance).text = myFormatter.format(newData);
					if((geolGridCopie.getItemAt(indRow).GEOL_BASE != myFormatter.format(newData)) && (myFormatter.format(geolGridCopie.getItemAt(indRow).GEOL_BASE)!=  myFormatter.format(newData)))
					{
						geolGridSource.getItemAt(indRow).GEOL_BASE =  myFormatter.format(newData);
						attributes[field] = geolGridSource.getItemAt(indRow)[field];
						var feature:Graphic = new Graphic(null, null, attributes);
						updates.push(feature);
						dontDisplay = true;
						geol.applyEdits(null,updates,null);
					}
				}
			}
			
			mx.controls.TextInput(dataGrid.itemEditorInstance).text = myFormatter.format(newData);
			geolGridSource.getItemAt(indRow).GEOL_BASE =  myFormatter.format(newData);
			
		}
		else if(event.dataField == "GEOL_DESC") 
		{
			var newData = mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			// Determine if the new value is an empty String. 
			/*if(newData.length > 255) {
				event.preventDefault();
				mx.controls.TextInput(dataGrid.itemEditorInstance).errorString = "Enter a text containing less than 255 characters \n" +
					"For now: " + mx.controls.TextInput(dataGrid.itemEditorInstance).text.length + "chars";
				return;
			}*/
			if(newData == " ")
			{
				newData="";
			}
			else
			{
				if(geolGridCopie.getItemAt(indRow).GEOL_DESC != newData)
				{
					geolGridSource.getItemAt(indRow).GEOL_DESC =  newData;
					attributes[field] = newData;
					var feature:Graphic = new Graphic(null, null, attributes);
					updates.push(feature);
					geol.applyEdits(null,updates,null);
				}
			}
		}
		else if(event.dataField == "GEOL_LEG")
		{
			if(geolGridCopie.getItemAt(indRow)[field] != SizeRenderer(dataGrid.itemEditorInstance).editor.selectedItem.data)
			{
				geolGridSource.getItemAt(indRow).GEOL_LEG =  SizeRenderer(dataGrid.itemEditorInstance).editor.selectedItem.data;
				attributes[field] = SizeRenderer(dataGrid.itemEditorInstance).editor.selectedItem.data;
				var feature:Graphic = new Graphic(null, null, attributes);
				updates.push(feature);
				geol.applyEdits(null,updates,null);
			}
		}
		else if (event.dataField == "GEOL_GEOL") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;

			if(newData != "")
			{
				mx.controls.TextInput(dataGrid.itemEditorInstance).text = newData;
				if((geolGridCopie.getItemAt(indRow).GEOL_GEOL != newData))
				{
					geolGridSource.getItemAt(indRow).GEOL_GEOL = newData;
					attributes[field] = geolGridSource.getItemAt(indRow)[field];
					var feature:Graphic = new Graphic(null, null, attributes);
					updates.push(feature);
					dontDisplay = true;
					geol.applyEdits(null,updates,null);
				}
			}
		
			
			mx.controls.TextInput(dataGrid.itemEditorInstance).text = newData;
			geolGridSource.getItemAt(indRow).GEOL_GEOL = newData;
		}
		else if (event.dataField == "GEOL_GEO2") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			if(newData != "")
			{
				mx.controls.TextInput(dataGrid.itemEditorInstance).text = newData;
				if((geolGridCopie.getItemAt(indRow).GEOL_GEO2 != newData))
				{
					geolGridSource.getItemAt(indRow).GEOL_GEO2 = newData;
					attributes[field] = geolGridSource.getItemAt(indRow)[field];
					var feature:Graphic = new Graphic(null, null, attributes);
					updates.push(feature);
					dontDisplay = true;
					geol.applyEdits(null,updates,null);
				}
			}
			
			
			mx.controls.TextInput(dataGrid.itemEditorInstance).text = newData;
			geolGridSource.getItemAt(indRow).GEOL_GEO2 = newData;
		}
	}
	else
	{
		
		if(field != "GEOL_BASE" && field != "GEOL_DESC" && field != "GEOL_LEG" && field != "GEOL_GEOL" && field != "GEOL_GEO2")
		{
			if(geolGridCopie.getItemAt(indRow)[field] != geolGridSource.getItemAt(indRow)[field])
			{
				attributes[field] = geolGridSource.getItemAt(indRow)[field];
				var feature:Graphic = new Graphic(null, null, attributes);
				updates.push(feature);
				dontDisplay = true;
				geol.applyEdits(null,updates,null);
			}
		}
	}
}//END dgItemEnd
