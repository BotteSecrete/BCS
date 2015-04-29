import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;

import mx.controls.Alert;
import mx.controls.DateField;
import mx.controls.TextInput;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.formatters.NumberFormatter;

private function saveDatesEdited(ev:CalendarLayoutChangeEvent, event:FeatureLayerEvent, k:Number, startDateChoose:DateField):void
{
	var hasToSave:Boolean = false;
	var attributes:Object = {};
	attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
	var myStartDate:Date = new Date(event.features[k].attributes.DATE_SURVEY);
	var myStartDF:DateFormatter = new DateFormatter();
	myStartDF.formatString = "YYYY-MM-DD";
	if(myStartDF.format(myStartDate) != ev.target.text)
	{
			ev.target.errorString = "";
			attributes.DATE_SURVEY = ev.target.text;
			hasToSave = true;
	}
	
	var feature:Graphic = new Graphic(null, null, attributes);
	var updates:Array = [ feature ];
	if(hasToSave)
	{
		featLayer.applyEdits(null,updates,null);
	}
}

private function onCbGeneralChange(ev:ListEvent, event:FeatureLayerEvent, k:Number):void
{
	Alert.show("début onCbGeneralChange","Debugg");
	var hasToSave:Boolean = false;
	var attributes:Object = {};
	attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
	switch (ev.target.name)
	{
		case "UBList":
			if(event.features[k].attributes.Use_Building != ev.target.selectedLabel)
			{
				attributes.Use_Building = ev.target.selectedLabel;
				hasToSave = true;
			}
			break;
		
		case "BCList":
			Alert.show("case BCList","Debugg");
			if(event.features[k].attributes.Building_Category != ev.target.selectedLabel)
			{
				Alert.show("dans le if du case","Debugg");
				attributes.Building_Category = ev.target.selectedLabel;
				hasToSave = true;
			}
			break;
		
		case "HBList":
			if(event.features[k].attributes.HB != ev.target.selectedLabel)
			{
				attributes.HB = ev.target.selectedLabel;
				hasToSave = true;
			}
			break;
		
		case "UIZList":
			if(event.features[k].attributes.UIZ != ev.target.selectedLabel)
			{
				attributes.UIZ = ev.target.selectedLabel;
				hasToSave = true;
			}
			break;
		
		case "FIList":
			if(event.features[k].attributes.FI != ev.target.selectedLabel)
			{
				attributes.FI = ev.target.selectedLabel;
				hasToSave = true;
			}
			break;
	}
	var feature:Graphic = new Graphic(null, null, attributes);
	var updates:Array = [ feature ];
	if(hasToSave)
	{
		Alert.show("dans le if hastosave","Debugg");
		featLayer.applyEdits(null,updates,null);
		featLayer.clearSelection();
		featLayer.refresh();
	}
}

private function saveInfoEdited(ev:FlexEvent, event:FeatureLayerEvent, k:Number):void
{
	//hasToSave = false;
	var attributes:Object = {};
	attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
	
	switch(ev.currentTarget.name)
	{
		case "IDTBC":
			saveTI(ev.currentTarget,attributes,"CODE",event.features[k]);
			break;
		
		case "IDTName":
			saveTI(ev.currentTarget,attributes,"NAME_SURVEY",event.features[k]);
			break;
		
		case "AddTxt":
			saveTI(ev.currentTarget,attributes,"Address",event.features[k]);
			break;
		
		case "ContactTxt":
			saveTI(ev.currentTarget,attributes,"Contact",event.features[k]);
			break;
		
		case "BW":
			saveTI(ev.currentTarget,attributes,"BW",event.features[k],3);
			break;
		
		case "BL":
			saveTI(ev.currentTarget,attributes,"BL",event.features[k],2);
			break;
		
		case "SAG":
			saveTI(ev.currentTarget,attributes,"NSL",event.features[k]);
			break;
		
		case "NBS":
			saveTI(ev.currentTarget,attributes,"NSB",event.features[k]);
			break;
		
		case "ADOB":
			saveTI(ev.currentTarget,attributes,"Depth_Storey",event.features[k])
			break;
		
		case "genUBInput":
			saveTI(ev.currentTarget,attributes,"UB_Descr",event.features[k]);
			break;
		
		case "genHBInput":
			saveTI(ev.currentTarget,attributes,"HB_Descr",event.features[k]);
			break;
		
		case "genRemInput":
			saveTI(ev.currentTarget,attributes,"Comments",event.features[k]);
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
