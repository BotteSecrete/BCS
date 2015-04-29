import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;

import mx.controls.Alert;
import mx.events.ListEvent;
import mx.formatters.NumberFormatter;

// ActionScript file

private function onCbConditionChange(ev:ListEvent, event:FeatureLayerEvent, k:Number):void
{
	var hasToSave:Boolean = false;
	var attributes:Object = {};
	attributes = isInCond? {OBJECTID:condArray[0]} : {IDBATI:event.features[k].attributes.OBJECTID};
	switch (ev.target.name)
	{
		case "CDList":
			if(!isInCond || condArray[2] != ev.target.selectedLabel)
			{
				attributes.Categ_Damage = ev.target.selectedLabel;
				hasToSave = true;
			}
			break;
		
		case "ODList":
			if(!isInCond || condArray[3] != ev.target.selectedLabel)
			{
				attributes.Other_Damage = ev.target.selectedLabel;
				hasToSave = true;
			}
			break;
	}
	var feature:Graphic = new Graphic(null, null, attributes);
	var updates:Array = [ feature ];
	if(hasToSave && isInCond)
	{
		cond.applyEdits(null,updates,null);
		cond.clearSelection();
		cond.refresh();
	} else if (hasToSave && !isInCond)
	{
		isInCond = true;
		cond.applyEdits(updates,null,null);
		cond.clearSelection();
		cond.refresh();
	}
}

private function saveInfoCondEdited(ev:FlexEvent, event:FeatureLayerEvent, k:Number):void
{
	//hasToSave = false;
	var attributes:Object = {};
	attributes = isIn? {OBJECTID:structArray[0]} : {IDBATI:event.features[k].attributes.OBJECTID};
	
	saveTICond(ev.currentTarget,attributes,"Other_Damage_Descr", event.features[k]);
		
} //END OF FUNCTION saveInfoEdited

private function saveTICond(evTarg:Object, attributes:Object, field:String, selectedFeat:Object, nbPrecision:Number = 0, required:Boolean = false)
{
	var hasToSave:Boolean = false;
	var virRegExp:RegExp = /[.]/;
	var allRegExp:RegExp = /[^0-9,-]/gi;
	
	var locNF:NumberFormatter = new NumberFormatter();
	locNF.decimalSeparatorFrom = ",";
	locNF.decimalSeparatorTo = ",";
	locNF.useThousandsSeparator = false;
	var ind:Number;
	//featLayer.graphicProvider[15];
	hasToSave = true;
	
	var feature:Graphic = new Graphic(null, null, attributes);
	var updates:Array = [ feature ];
	if(hasToSave && isInCond)
	{
		cond.applyEdits(null,updates,null);
		cond.clearSelection();
		cond.refresh();
	} else if (hasToSave && !isInCond)
	{
		isInCond = true;
		cond.applyEdits(updates,null,null);
		cond.clearSelection();
		cond.refresh();
	}
}