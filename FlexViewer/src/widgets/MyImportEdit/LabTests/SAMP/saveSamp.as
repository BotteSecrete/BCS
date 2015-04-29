import com.esri.ags.Graphic;

import mx.controls.TextInput;
import mx.events.DataGridEvent;
import mx.formatters.NumberFormatter;

// ActionScript file
private function dgSampItemEditEnd(event:DataGridEvent):void
{
	var updates:Array = [];
	var attributes:Object = {};
	
	if(event.type != "itemFocusOut"){
		
		indRowSamp = event.rowIndex;
		attributes.OBJECTID = sampGridSource.getItemAt(indRowSamp).OBJECTID;
		fieldSamp = event.dataField;
		
		if(event.dataField == "SAMP_TOP") 
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
			var testRegExp:RegExp = /[,]/gi;
			var compare:Number = 999999;
			
			if((newData != null) && (newData.search(virRegExp)>-1))
			{
				newData = newData.replace(virRegExp,",");
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
			}
			if((sampGridSource.getItemAt(indRowSamp).SAMP_BASE != null) && ((myFormatter.format(sampGridSource.getItemAt(indRowSamp).SAMP_BASE)).search(testRegExp)>-1))
			{
				compare = parseFloat((myFormatter.format(sampGridSource.getItemAt(indRowSamp).SAMP_BASE)).replace(testRegExp,"."));
			}
			if((newData != null) && (newData.search(regExp)>-1))
			{
				newData = ""
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
				event.preventDefault();
				mx.controls.TextInput(sampDataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else if(sampGridSource.getItemAt(indRowSamp).SAMP_BASE != null && compare < parseFloat(newData))
			{
				event.preventDefault();
				mx.controls.TextInput(sampDataGrid.itemEditorInstance).toolTip = "Enter a number lower than " + sampGridSource.getItemAt(indRowSamp).SAMP_BASE ;
				return;
			}
			else
			{
				if(newData != "")
				{
					mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = myFormatter.format(newData);
					if((sampGridCopie.getItemAt(indRowSamp).SAMP_TOP != myFormatter.format(newData)) && (myFormatter.format(sampGridCopie.getItemAt(indRowSamp).SAMP_TOP)!=  myFormatter.format(newData)))
					{
						sampGridSource.getItemAt(indRowSamp).SAMP_TOP =  myFormatter.format(newData);
						attributes[fieldSamp] = sampGridSource.getItemAt(indRowSamp)[fieldSamp];
						var feature:Graphic = new Graphic(null, null, attributes);
						updates.push(feature);
						dontDisplay = true;
						samp.applyEdits(null,updates,null);
					}
				}
			}
			
			mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = myFormatter.format(newData);
			sampGridSource.getItemAt(indRowSamp).SAMP_TOP =  myFormatter.format(newData);	
		}
		else if (event.dataField == "SAMP_BASE") 
		{
			var newData:String = mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			var myFormatter:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
			myFormatter.useThousandsSeparator = false;
			myFormatter.decimalSeparatorFrom = ","
			myFormatter.decimalSeparatorTo = ",";
			myFormatter.precision = 2;
			myFormatter.useThousandsSeparator = false;
			var virRegExp:RegExp = /[.]/gi;
			var regExp:RegExp = /[^0-9,]/gi;
			var testRegExp:RegExp = /[,]/gi;
			var compare:Number = -999999;
			
			if((newData != null) && (newData.search(virRegExp)>-1))
			{
				newData = newData.replace(virRegExp,",");
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
			}
			if((sampGridSource.getItemAt(indRowSamp).SAMP_TOP != null) && ((myFormatter.format(sampGridSource.getItemAt(indRowSamp).SAMP_TOP)).search(testRegExp)>-1))
			{
				compare = parseFloat((myFormatter.format(sampGridSource.getItemAt(indRowSamp).SAMP_TOP)).replace(testRegExp,"."));
			}
			
			if((newData != null) && (newData.search(regExp)>-1))
			{
				newData = ""
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
				event.preventDefault();
				mx.controls.TextInput(sampDataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else if(compare > parseFloat(newData))
			{
				event.preventDefault();
				mx.controls.TextInput(sampDataGrid.itemEditorInstance).toolTip = "Enter a number higher than " + sampGridSource.getItemAt(indRowSamp).SAMP_TOP ;
				return;
			}
			else
			{
				if(newData != "")
				{
					mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = myFormatter.format(newData);
					if((sampGridCopie.getItemAt(indRowSamp).SAMP_BASE != myFormatter.format(newData)) && (myFormatter.format(sampGridCopie.getItemAt(indRowSamp).SAMP_BASE)!=  myFormatter.format(newData)))
					{
						sampGridSource.getItemAt(indRowSamp).SAMP_BASE =  myFormatter.format(newData);
						attributes[fieldSamp] = sampGridSource.getItemAt(indRowSamp)[fieldSamp];
						var feature:Graphic = new Graphic(null, null, attributes);
						updates.push(feature);
						dontDisplay = true;
						samp.applyEdits(null,updates,null);
					}
				}	
			}
			
			mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = myFormatter.format(newData);
			sampGridSource.getItemAt(indRowSamp).SAMP_BASE =  myFormatter.format(newData);
		}
		else if (event.dataField == "SAMP_ID") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			if(newData != "")
			{
				mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = newData;
				if((sampGridCopie.getItemAt(indRowSamp).SAMP_ID != newData))
				{
					sampGridCopie.getItemAt(indRowSamp).SAMP_ID = newData;
					attributes[fieldSamp] = sampGridSource.getItemAt(indRowSamp)[fieldSamp];
					var feature:Graphic = new Graphic(null, null, attributes);
					updates.push(feature);
					dontDisplay = true;
					samp.applyEdits(null,updates,null);
				}
			}
			
			
			mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = newData;
			sampGridSource.getItemAt(indRowSamp).SAMP_ID = newData;
		}
		else if (event.dataField == "SAMP_DESC") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			if(newData != "")
			{
				mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = newData;
				if((sampGridCopie.getItemAt(indRowSamp).SAMP_DESC != newData))
				{
					sampGridCopie.getItemAt(indRowSamp).SAMP_DESC = newData;
					attributes[fieldSamp] = sampGridSource.getItemAt(indRowSamp)[fieldSamp];
					var feature:Graphic = new Graphic(null, null, attributes);
					updates.push(feature);
					dontDisplay = true;
					samp.applyEdits(null,updates,null);
				}
			}
			
			
			mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = newData;
			sampGridSource.getItemAt(indRowSamp).SAMP_DESC = newData;
		}
		else if (event.dataField == "SAMP_TYPE") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			if(newData != "")
			{
				mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = newData;
				if((sampGridCopie.getItemAt(indRowSamp).SAMP_TYPE != newData))
				{
					sampGridCopie.getItemAt(indRowSamp).SAMP_TYPE = newData;
					attributes[fieldSamp] = sampGridSource.getItemAt(indRowSamp)[fieldSamp];
					var feature:Graphic = new Graphic(null, null, attributes);
					updates.push(feature);
					dontDisplay = true;
					samp.applyEdits(null,updates,null);
				}
			}
			
			
			mx.controls.TextInput(sampDataGrid.itemEditorInstance).text = newData;
			sampGridSource.getItemAt(indRowSamp).SAMP_TYPE = newData;
		}

	}
	else
	{
		attributes.OBJECTID = sampGridSource.getItemAt(indRowSamp).OBJECTID;
		if(fieldSamp != "SAMP_TOP" && fieldSamp != "SAMP_BASE" && fieldSamp != "SAMP_ID" && fieldSamp != "SAMP_DESC" && fieldSamp != "SAMP_TYPE")
		{
			attributes[fieldSamp] = sampGridSource.getItemAt(indRowSamp)[fieldSamp];
			var feature:Graphic = new Graphic(null, null, attributes);
			updates.push(feature);
			dontDisplay = true;
			samp.applyEdits(null,updates,null);
		}
		
	}
}
