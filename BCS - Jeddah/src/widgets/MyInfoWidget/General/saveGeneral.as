import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.tasks.supportClasses.Query;

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
			if(event.features[k].attributes.Building_Category != ev.target.selectedLabel)
			{
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
//				attributes.UIZ = ev.target.selectedLabel;
				attributes["UIZ"] = ev.target.selectedLabel;
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
	
	if(hasToSave)
	{
		hasToSave = false;
		isGene = true;
		var feature:Graphic = new Graphic(null, null, attributes);
		var updates:Array = [ feature ];
		featLayer.applyEdits(null,updates,null);
		
		var query:Query = new Query();
		query.objectIds = [event.features[k].attributes.OBJECTID];
		query.outFields = ["*"];
		featLayer.clearSelection();
		featLayer.refresh();
		featLayer.selectFeatures(query);
//		featLayer.clearSelection();
//		featLayer.refresh();
	}
}

private function saveInfoEditedKey(txtIn:Object, event:FeatureLayerEvent, k:Number):void
{
	var attributes:Object = {};
	attributes = {OBJECTID:event.features[k].attributes.OBJECTID};
	switch(txtIn.name)
	{
		case "IDTBC":
			saveTI(txtIn,attributes,"CODE",event.features[k]);
			break;
		
		case "IDTName":
			saveTI(txtIn,attributes,"NAME_SURVEY",event.features[k]);
			break;
		
		case "AddTxt":
			saveTI(txtIn,attributes,"Address",event.features[k]);
			break;
		
		case "ContactTxt":
			saveTI(txtIn,attributes,"Contact",event.features[k]);
			break;
		
		case "GPSTxt":
			saveTI(txtIn,attributes,"GPS_Coord",event.features[k]);
			break;
		
		case "NBS":
			saveTI(txtIn,attributes,"NSB",event.features[k],42);
			break;
		
		case "ADOB":
			saveTI(txtIn,attributes,"Depth_Storey",event.features[k],2)
			break;
		
		case "genRemInput":
			saveTI(txtIn,attributes,"Comments",event.features[k]);
			break;
		
		case "NPTxt":
			saveTI(txtIn,attributes,"Nb_Pictures",event.features[k]);
			break;
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
		
		case "GPSTxt":
			saveTI(ev.currentTarget,attributes,"GPS_Coord",event.features[k]);
			break;
		
		case "YCTxt":
			saveTI(ev.currentTarget,attributes,"Year_Construction",event.features[k]);
			break;
		
		case "NBS":
			saveTI(ev.currentTarget,attributes,"NSB",event.features[k],42);
			break;
		
		case "genRemInput":
			saveTI(ev.currentTarget,attributes,"Comments",event.features[k]);
			break;
		
		case "NPTxt":
			saveTI(ev.currentTarget,attributes,"Nb_Pictures",event.features[k]);
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
			if (nbPrecision == 42){
				evTarg.text = evTarg.text.split(",")[0];
				attributes[field] = evTarg.text;
				hasToSave = true;
			} else {
			evTarg.text = locNF.format(evTarg.text);
			evTarg.errorString = "";
			attributes[field] = evTarg.text;
			hasToSave = true;}
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
		if(featLayer.graphicProvider[ind].attributes[field] != evTarg.text )//&& evTarg.text != "")
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
