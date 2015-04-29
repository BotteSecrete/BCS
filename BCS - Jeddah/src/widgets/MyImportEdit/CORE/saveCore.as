import com.esri.ags.Graphic;

import mx.controls.TextInput;
import mx.events.DataGridEvent;
import mx.formatters.NumberFormatter;

import customRenderer.SizeRenderer;

// ActionScript file

private function dgCoreItemEditEnd(event:DataGridEvent):void
{
	//coreDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_IN,dgItemFocusIn ) ;
	var updates:Array = [];
	var attributes:Object = {};
	var comp_BASE:Number = new Number();
	var comp_TOP:Number = new Number();
	var tcomp_BASE:String = new String();
	var tcomp_TOP:String = new String();
	var verif_percent:Number = new Number();
	var tverif_percent:String = new String();
	
	if(event.type != "itemFocusOut")
	{
		indRow = event.rowIndex;
		attributes.OBJECTID = coreGridSource.getItemAt(indRow).OBJECTID;
		field = event.dataField;
		
		if (event.dataField == "CORE_BASE") 
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
			var ptExp:RegExp = /[,]/gi;
			
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
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else
			{
				if(newData != "")
				{
					mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
					tcomp_TOP = coreGridCopie.getItemAt(indRow).CORE_TOP;
					if((coreGridCopie.getItemAt(indRow).CORE_BASE != myFormatter.format(newData)) && (myFormatter.format(coreGridCopie.getItemAt(indRow).CORE_BASE)!=  myFormatter.format(newData)))
					{
						if ((tcomp_TOP == null) || (tcomp_TOP == ""))
						{
							coreGridSource.getItemAt(indRow).CORE_BASE =  myFormatter.format(newData);
							attributes[field] = coreGridSource.getItemAt(indRow)[field];
							var feature:Graphic = new Graphic(null, null, attributes);
							updates.push(feature);
							dontDisplay = true;
							core.applyEdits(null,updates,null);
						}
						else
						{
							tcomp_BASE = newData;
							tcomp_BASE = tcomp_BASE.replace(ptExp,".");
							tcomp_TOP = tcomp_TOP.replace(ptExp,".");
							comp_BASE = parseFloat(tcomp_BASE);
							comp_TOP = parseFloat(tcomp_TOP);
							if (comp_BASE>comp_TOP)
							{
								coreGridSource.getItemAt(indRow).CORE_BASE =  myFormatter.format(newData);
								attributes[field] = coreGridSource.getItemAt(indRow)[field];
								var feature:Graphic = new Graphic(null, null, attributes);
								updates.push(feature);
								dontDisplay = true;
								core.applyEdits(null,updates,null);
							}
							else 
							{
								newData = "";
								mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
								event.preventDefault();
								mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "CORE_BASE is down CORE_TOP";
								return;
							}
						}
					}				
				}
			}
			
			mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
			coreGridSource.getItemAt(indRow).CORE_BASE =  myFormatter.format(newData);
			
		}
		else if (event.dataField == "CORE_TOP") 
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
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else
			{
				if(newData != "")
				{
					mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
					tcomp_BASE = coreGridCopie.getItemAt(indRow).CORE_BASE;
					if((coreGridCopie.getItemAt(indRow).CORE_TOP != myFormatter.format(newData)) && (myFormatter.format(coreGridCopie.getItemAt(indRow).CORE_TOP)!=  myFormatter.format(newData)))
					{
						if ((tcomp_BASE == null) || (tcomp_BASE == ""))
						{
							coreGridSource.getItemAt(indRow).CORE_TOP =  myFormatter.format(newData);
							attributes[field] = coreGridSource.getItemAt(indRow)[field];
							var feature:Graphic = new Graphic(null, null, attributes);
							updates.push(feature);
							dontDisplay = true;
							core.applyEdits(null,updates,null);
						}
						else
						{
							tcomp_TOP = newData;
							tcomp_TOP = tcomp_TOP.replace(ptExp,".");
							tcomp_BASE = tcomp_BASE.replace(ptExp,".");
							comp_TOP = parseFloat(tcomp_TOP);
							comp_BASE = parseFloat(tcomp_BASE);
							if (comp_TOP<comp_BASE)
							{
								coreGridSource.getItemAt(indRow).CORE_TOP =  myFormatter.format(newData);
								attributes[field] = coreGridSource.getItemAt(indRow)[field];
								var feature:Graphic = new Graphic(null, null, attributes);
								updates.push(feature);
								dontDisplay = true;
								core.applyEdits(null,updates,null);
							}
							else 
							{
								newData = "";
								mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
								event.preventDefault();
								mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "CORE_TOP is above CORE_BASE";
								return;
							}
						}
					}				
				}
			}
			
			mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
			coreGridSource.getItemAt(indRow).CORE_TOP =  myFormatter.format(newData);
			
		}
		else if (event.dataField == "CORE_DIAM") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			var myFormatter:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
			myFormatter.useThousandsSeparator = false;
			myFormatter.decimalSeparatorFrom = ","
			myFormatter.decimalSeparatorTo = ",";
			myFormatter.precision = 0;
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
				newData = "";
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
				event.preventDefault();
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else
			{
				if(newData != "")
				{
					mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
					if((coreGridCopie.getItemAt(indRow).CORE_DIAM != myFormatter.format(newData)) && (myFormatter.format(coreGridCopie.getItemAt(indRow).CORE_DIAM)!=  myFormatter.format(newData)))
					{
						coreGridSource.getItemAt(indRow).CORE_DIAM =  myFormatter.format(newData);
						attributes[field] = coreGridSource.getItemAt(indRow)[field];
						var feature:Graphic = new Graphic(null, null, attributes);
						updates.push(feature);
						dontDisplay = true;
						core.applyEdits(null,updates,null);
					}
				}
			}
			
			mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
			coreGridSource.getItemAt(indRow).CORE_DIAM =  myFormatter.format(newData);
			
		}
		else if (event.dataField == "CORE_PREC") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			var myFormatter:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
			myFormatter.useThousandsSeparator = false;
			myFormatter.decimalSeparatorFrom = ","
			myFormatter.decimalSeparatorTo = ",";
			myFormatter.precision = 0;
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
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else
			{
				tverif_percent = newData;
				tverif_percent = tverif_percent.replace(ptExp,".");
				verif_percent = parseFloat(tverif_percent);
				if ((verif_percent>0)&&(verif_percent<100))
				{
					if(newData != "")
					{
						mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
						if((coreGridCopie.getItemAt(indRow).CORE_PREC != myFormatter.format(newData)) && (myFormatter.format(coreGridCopie.getItemAt(indRow).CORE_PREC)!=  myFormatter.format(newData)))
						{
							coreGridSource.getItemAt(indRow).CORE_PREC =  myFormatter.format(newData);
							attributes[field] = coreGridSource.getItemAt(indRow)[field];
							var feature:Graphic = new Graphic(null, null, attributes);
							updates.push(feature);
							dontDisplay = true;
							core.applyEdits(null,updates,null);
						}
					}
				}
				else
				{
				newData = ""
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
				event.preventDefault();
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a percent";
				return;	
				}
			}
			
			mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
			coreGridSource.getItemAt(indRow).CORE_PREC =  myFormatter.format(newData);
			
		}
		else if (event.dataField == "CORE_SREC") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			var myFormatter:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
			myFormatter.useThousandsSeparator = false;
			myFormatter.decimalSeparatorFrom = ","
			myFormatter.decimalSeparatorTo = ",";
			myFormatter.precision = 0;
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
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else
			{
				tverif_percent = newData;
				tverif_percent = tverif_percent.replace(ptExp,".");
				verif_percent = parseFloat(tverif_percent);
				if ((verif_percent>0)&&(verif_percent<100))
				{
					if(newData != "")
					{
						mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
						if((coreGridCopie.getItemAt(indRow).CORE_SREC != myFormatter.format(newData)) && (myFormatter.format(coreGridCopie.getItemAt(indRow).CORE_SREC)!=  myFormatter.format(newData)))
						{
							coreGridSource.getItemAt(indRow).CORE_SREC =  myFormatter.format(newData);
							attributes[field] = coreGridSource.getItemAt(indRow)[field];
							var feature:Graphic = new Graphic(null, null, attributes);
							updates.push(feature);
							dontDisplay = true;
							core.applyEdits(null,updates,null);
						}
					}
				}
				else
				{
				newData = ""
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
				event.preventDefault();
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a percent";
				return;	
				}
			}
			
			mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
			coreGridSource.getItemAt(indRow).CORE_SREC =  myFormatter.format(newData);
			
		}
		else if (event.dataField == "CORE_RQD") 
		{
			var newData:String=mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			
			var myFormatter:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
			myFormatter.useThousandsSeparator = false;
			myFormatter.decimalSeparatorFrom = ","
			myFormatter.decimalSeparatorTo = ",";
			myFormatter.precision = 0;
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
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a valid number.";
				return;
			}
			else
			{
				tverif_percent = newData;
				tverif_percent = tverif_percent.replace(ptExp,".");
				verif_percent = parseFloat(tverif_percent);
				if ((verif_percent>0)&&(verif_percent<100))
				{
					if(newData != "")
					{
						mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
						if((coreGridCopie.getItemAt(indRow).CORE_RQD != myFormatter.format(newData)) && (myFormatter.format(coreGridCopie.getItemAt(indRow).CORE_RQD)!=  myFormatter.format(newData)))
						{
							coreGridSource.getItemAt(indRow).CORE_RQD =  myFormatter.format(newData);
							attributes[field] = coreGridSource.getItemAt(indRow)[field];
							var feature:Graphic = new Graphic(null, null, attributes);
							updates.push(feature);
							dontDisplay = true;
							core.applyEdits(null,updates,null);
						}
					}
				}
				else
				{
				newData = ""
				mx.controls.TextInput(event.currentTarget.itemEditorInstance).text = newData;
				event.preventDefault();
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a percent";
				return;	
				}
			}
			
			mx.controls.TextInput(coreDataGrid.itemEditorInstance).text = myFormatter.format(newData);
			coreGridSource.getItemAt(indRow).CORE_RQD =  myFormatter.format(newData);
			
		}
		else if(event.dataField == "CORE_REM") 
		{
			var newData = mx.controls.TextInput(event.currentTarget.itemEditorInstance).text;
			// Determine if the new value is an empty String. 
			/*if(newData.length > 255) {
				event.preventDefault();
				mx.controls.TextInput(coreDataGrid.itemEditorInstance).errorString = "Enter a text containing less than 255 characters \n" +
					"For now: " + mx.controls.TextInput(coreDataGrid.itemEditorInstance).text.length + "chars";
				return;
			}*/
			if(newData == " ")
			{
				newData="";
			}
			else
			{
				if(coreGridCopie.getItemAt(indRow).CORE_REM != newData)
				{
					coreGridSource.getItemAt(indRow).CORE_REM =  newData;
					attributes[field] = newData;
					var feature:Graphic = new Graphic(null, null, attributes);
					updates.push(feature);
					core.applyEdits(null,updates,null);
				}
			}
		}
		
	}
	else
	{
		
		if(field != "CORE_TOP" && field != "CORE_BASE" && field != "CORE_PREC" && field != "CORE_SREC" && field != "CORE_RQD" && field != "CORE_DIAM" && field != "CORE_REM")
		{
			if(coreGridCopie.getItemAt(indRow)[field] != coreGridSource.getItemAt(indRow)[field])
			{
				attributes[field] = coreGridSource.getItemAt(indRow)[field];
				var feature:Graphic = new Graphic(null, null, attributes);
				updates.push(feature);
				dontDisplay = true;
				core.applyEdits(null,updates,null);
			}
		}
	}
}//END dgItemEnd
