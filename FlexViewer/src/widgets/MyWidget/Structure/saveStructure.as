import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;

import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.events.ListEvent;
import mx.formatters.NumberFormatter;

// ActionScript file
private function saveInfoStructEditedKey(txtIn:Object, event:FeatureLayerEvent, k:Number):void
{
	var attributes:Object = {};
	attributes = isIn? {OBJECTID:structArray[0]} : {IDBATI:event.features[k].attributes.OBJECTID};
	
	switch(txtIn.name)
	{
		case "genComInput":
			saveTIStruct(txtIn,attributes,"VB_Descr", 3);
			break;
		
		case "genComInputH":
			saveTIStruct(txtIn,attributes,"HB_Descr",5);
			break;
		
		case "genComInputRT":
			saveTIStruct(txtIn,attributes,"RoofT_Descr",12);
			break;
		
		case "genTFInput":
			saveTIStruct(txtIn,attributes,"SoilR_Descr",8);
			break;
		
		case "genComInputFD":
			saveTIStruct(txtIn,attributes,"FM_Descr",10);
			break;
		
		case "genSourceInput":
			saveTIStruct(txtIn,attributes,"SourceInf_Descr",14);
			break;
	}
}

private function saveInfoStructEdited(ev:FlexEvent, event:FeatureLayerEvent, k:Number):void
{
	//hasToSave = false;
	var attributes:Object = {};
	attributes = isIn? {OBJECTID:structArray[0]} : {IDBATI:event.features[k].attributes.OBJECTID};
	
	switch(ev.currentTarget.name)
	{
		case "genComInput":
			saveTIStruct(ev.currentTarget,attributes,"VB_Descr", 3);
			break;
		
		case "genComInputH":
			saveTIStruct(ev.currentTarget,attributes,"HB_Descr",5);
			break;
		
		case "genComInputRT":
			saveTIStruct(ev.currentTarget,attributes,"RoofT_Descr",12);
			break;
		
		case "genTFInput":
			saveTIStruct(ev.currentTarget,attributes,"SoilR_Descr",8);
			break;
		
		case "genComInputFD":
			saveTIStruct(ev.currentTarget,attributes,"FM_Descr",10);
			break;
		
		case "genSourceInput":
			saveTIStruct(ev.currentTarget,attributes,"SourceInf_Descr",14);
			break;
	}
} //END OF FUNCTION saveInfoEdited

private function saveTIStruct(evTarg:Object, attributes:Object, field:String, indice:Number, nbPrecision:Number = 0, required:Boolean = false)
{
	var hasToSave:Boolean = false;
	var virRegExp:RegExp = /[.]/;
	var allRegExp:RegExp = /[^0-9,-]/gi;
	
	var locNF:NumberFormatter = new NumberFormatter();
	locNF.decimalSeparatorFrom = ",";
	locNF.decimalSeparatorTo = ",";
	locNF.useThousandsSeparator = false;
	var ind:Number;
//	for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
//	{
//		if(featLayer.graphicProvider[id].attributes.OBJECTID == selectedFeat.attributes.OBJECTID)
//		{
//			ind = id;
//			break;
//		}
//	}
	//featLayer.graphicProvider[15];
	if((!isIn || structArray[indice] != evTarg.text) )//&& evTarg.text != "")
		{
			evTarg.errorString = "";
			attributes[field] = evTarg.text;
			hasToSave = true;
		}
	
	var feature:Graphic = new Graphic(null, null, attributes);
	var updates:Array = [ feature ];
	if(hasToSave && isIn)
	{
		struct.applyEdits(null,updates,null);
		struct.clearSelection();
		struct.refresh();
	} else if (hasToSave && !isIn)
	{
		isIn = true;
		struct.applyEdits(updates,null,null);
		struct.clearSelection();
		struct.refresh();
	}
}