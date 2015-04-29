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


private function onQueryResult(featureSet:FeatureSet, structEditsStarted:Function, structEditsCompleted:Function, token:Object = null):void
{
	if(!struct.willTrigger(FeatureLayerEvent.EDITS_STARTING))
	{
		struct.addEventListener(FeatureLayerEvent.EDITS_STARTING, structEditsStarted);
	}
	
	struct.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,structEditsCompleted);
	if(featureSet.features.length>0)// on a des données !
	{
		isIn = true;
		for each (var gr:Graphic in featureSet.features)
		{
			structArray = [];
			structArray.push(gr.attributes.OBJECTID);
			structArray.push(gr.attributes.IDBATI);
			structArray.push(gr.attributes.MB);
			structArray.push(gr.attributes.TypeF);
			structArray.push(gr.attributes.FM);
			structArray.push(gr.attributes.Depth_Range);
			
		}
	} else
	{
		isIn = false;
		structArray = [];
		structArray.push();
		structArray.push();
		structArray.push();
		structArray.push();
		structArray.push();
		structArray.push();
	}
	
}//End function: OnQueryResult

private function onQueryFault(fault:Fault, token:Object = null):void
{
	geolGridSource.removeAll();
	//Alert.show("FAUTE !!!");
	var error:Text = new Text();
	error.text = "Aucune entité trouvée pour cet object";
	index.ws1.addElement(error);
	//tablePanel.addElement(error);
}//END Function onQueryFault
