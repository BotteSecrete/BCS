import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.MapEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.viewer.AppEvent;
import com.esri.viewer.ViewerContainer;
import com.esri.viewer.components.toc.utils.MapUtil;
import com.esri.viewer.managers.MapManager;

import mx.controls.Alert;
import mx.controls.Text;
import mx.rpc.Fault;

import spark.components.Panel;

import flashx.textLayout.tlf_internal;

import widgets.MapSwitcher.MapSwitcherWidget;
import widgets.OverviewMap.OverviewMapComponent;
import widgets.OverviewMap.OverviewMapWidget;

// ActionScript file


private function onQueryCondResult(featureSet:FeatureSet, condEditsStarted:Function,condEditsCompleted:Function, token:Object = null):void
{
	if(!cond.willTrigger(FeatureLayerEvent.EDITS_STARTING))
	{
		cond.addEventListener(FeatureLayerEvent.EDITS_STARTING, condEditsStarted);
	}
	
	cond.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,condEditsCompleted);
	if(featureSet.features.length>0)// on a des données !
	{
		isInCond = true;
		for each (var gr:Graphic in featureSet.features)
		{
			condArray = [];
			condArray.push(gr.attributes.OBJECTID);
			condArray.push(gr.attributes.IDBATI);
			condArray.push(gr.attributes.Categ_Damage);
			condArray.push(gr.attributes.Other_Damage);
			condArray.push(gr.attributes.Other_Damage_Descr);
			
		}
	} else
	{
		isInCond = false;
		condArray = [];
		condArray.push();
		condArray.push();
		condArray.push();
		condArray.push();
		condArray.push();
	}
	
}//End function: OnQueryResult

private function onQueryCondFault(fault:Fault, token:Object = null):void
{
	//geolGridSource.removeAll();
	//Alert.show("FAUTE !!!");
	var error:Text = new Text();
	error.text = "Aucune entité trouvée pour cet object";
	index.ws1.addElement(error);
	//tablePanel.addElement(error);
}//END Function onQueryFault
