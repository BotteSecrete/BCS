// ActionScript file
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;

import mx.controls.Alert;
import mx.controls.DateField;
import mx.controls.TextInput;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.formatters.NumberFormatter;

private function onCbChange(ev:ListEvent, event:FeatureLayerEvent, k:Number, otherSiteLoca:mx.controls.TextInput):void
{
	var hasToSave:Boolean = false;
	var attributes:Object = {};
	attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
	switch (ev.target.name)
	{
		case "siteLocaList":
			if (ev.target.selectedIndex == 0)
			{
				otherSiteLoca.visible = true;
			}
			else
			{
				otherSiteLoca.visible = false;
				
				if(event.features[k].attributes.LOCA_LOCA != ev.target.selectedLabel)
				{
					attributes.LOCA_LOCA = ev.target.selectedLabel;
					hasToSave = true;
				}
				
			}
			break;
		case "holeTypeList":
			if(event.features[k].attributes.LOCA_TYPE != ev.target.selectedLabel)
			{
				attributes.LOCA_TYPE = ev.target.selectedLabel;
				hasToSave = true;
			}
			break;
		case "projList":
			if(event.features[k].attributes.PROJ_ID != ev.target.selectedLabel)
			{
				attributes.PROJ_ID = ev.target.selectedItem.data;
				hasToSave = true;
			}
			break;
	}
	var feature:Graphic = new Graphic(null, null, attributes);
	var updates:Array = [ feature ];
	if(hasToSave)
	{
		featLayer.applyEdits(null,updates,null);
	}
}
/*
private function saveDatesEdited(ev:CalendarLayoutChangeEvent, event:FeatureLayerEvent, k:Number, startDateChoose:DateField, endDateChoose:DateField):void
{
var hasToSave:Boolean = false;
var attributes:Object = {};
attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
switch (ev.target.name)
{
case "startDateChoose":
var myStartDate:Date = new Date(event.features[k].attributes.LOCA_STAR);
var myStartDF:DateFormatter = new DateFormatter();
myStartDF.formatString = "YYYY-MM-DD";
if(myStartDF.format(myStartDate) != ev.target.text)
{
if(endDateChoose.text != null)
{
var endArray:Array = endDateChoose.text.split("-");
endArray[1] = (parseInt(endArray[1]) - 1);
var myEndDate:Date = new Date (endArray[0], endArray[1], endArray[2]);
if(myEndDate.getTime() < new Date(ev.target.selectedDate).getTime())
{
ev.target.errorString = "Please choose an ending date later than " + myEndDate.toDateString(); 
} 
else
{
ev.target.errorString = "";
endDateChoose.errorString = "";
attributes.LOCA_STAR = ev.target.text;
hasToSave = true;
}
}
else
{	
ev.target.errorString = "";
attributes.LOCA_STAR = ev.target.text;
hasToSave = true;
}
}
break;
case "endDateChoose":
var myEndDate:Date = new Date(event.features[k].attributes.LOCA_ENDD);
var myEndDF:DateFormatter = new DateFormatter();
myEndDF.formatString = "YYYY-MM-DD";

if(myEndDF.format(myEndDate) != ev.target.text)
{
if(startDateChoose.text != null)
{
var startArray:Array = startDateChoose.text.split("-");
startArray[1] = (parseInt(startArray[1]) - 1);
var myStartDate:Date = new Date (startArray[0], startArray[1], startArray[2]);
if(myStartDate.getTime() >= new Date(ev.target.selectedDate).getTime())
{
ev.target.errorString = "Please choose an ending date later than " + myStartDate.toDateString(); 
} 
else
{
startDateChoose.errorString = "";
ev.target.errorString = "";
attributes.LOCA_ENDD = ev.target.text;
hasToSave = true;
}
}
else
{	
ev.target.errorString = "";
attributes.LOCA_ENDD = ev.target.text;
hasToSave = true;
}
}	
break;
}

var feature:Graphic = new Graphic(null, null, attributes);
var updates:Array = [ feature ];
if(hasToSave)
{
featLayer.applyEdits(null,updates,null);
}
}*/

private function saveInfoEdited(ev:FlexEvent, event:FeatureLayerEvent, k:Number, service:HTTPService):void
{
	//hasToSave = false;
	var attributes:Object = {};
	attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
	
	switch(ev.currentTarget.name)
	{
		case "IDT":
			saveTI(ev.currentTarget,attributes,"CODE", event.features[k],0,true);
			break;
		
		case "AddTxt":
			saveTI(ev.currentTarget,attributes,"Address",event.features[k],3);
			break;
		
		case "ContactTxt":
			saveTI(ev.currentTarget,attributes,"Contact",event.features[k],3);
			break;
		
		case "genRemInput":
			saveTI(ev.currentTarget,attributes,"Comments",event.features[k],2);
			break;
	}
} //END OF FUNCTION saveInfoEdited

private function saveTI(evTarg:Object, attributes:Object, field:String, selectedFeat:Object, nbPrecision:Number = 0, required:Boolean = false)
{
	var hasToSave:Boolean = false;
	var virRegExp:RegExp = /[.]/;
	var allRegExp:RegExp = /[^0-9,-]/gi;
	
	var locNF:NumberFormatter = new NumberFormatter();
	locNF.decimalSeparatorFrom = ",";
	locNF.decimalSeparatorTo = ",";
	locNF.useThousandsSeparator = false;
	var ind:Number;
	for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
	{
		if(featLayer.graphicProvider[id].attributes.OBJECTID == selectedFeat.attributes.OBJECTID)
		{
			ind = id;
			break;
		}
	}
	//featLayer.graphicProvider[15];
	if(nbPrecision != 0)
	{
		var hasToSave:Boolean = false;
		locNF.precision = nbPrecision;
		
		if(evTarg.text.search(virRegExp) != -1)
		{
			evTarg.text = evTarg.text.replace(virRegExp,",");
		}
		
		if(evTarg.text.search(allRegExp) > -1)
		{
			evTarg.errorString = "Please, enter a number only";	
			evTarg.text = "";
			hasToSave = false;
		}
		else if(evTarg.text.split(",").length > 2)
		{
			Alert.show("Trop de virgules là!!");
			evTarg.text = "";
		}
		else if(locNF.format(featLayer.graphicProvider[ind].attributes[field]) != locNF.format(evTarg.text) && evTarg.text != "")
		{
			evTarg.text = locNF.format(evTarg.text);
			evTarg.errorString = "";
			attributes[field] = evTarg.text;
			hasToSave = true;
		}
	}
	else if (nbPrecision == 0)
	{
		if(required){
			if(evTarg.text == "")
			{
				evTarg.errorString = "This name is required";
			}
		}
		if(featLayer.graphicProvider[ind].attributes[field] != evTarg.text && evTarg.text != "")
		{
			evTarg.errorString = "";
			attributes[field] = evTarg.text;
			hasToSave = true;
		}
	}
	
	if(hasToSave)
	{
		hasToSave = false;
		var feature:Graphic = new Graphic(null, null, attributes);
		var updates:Array = [ feature ];
		featLayer.applyEdits(null,updates,null);		
	}
}
