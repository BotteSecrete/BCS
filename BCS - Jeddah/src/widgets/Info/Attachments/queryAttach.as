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


private function onQueryAttachResult(featureSet:FeatureSet, condEditsStarted:Function,condEditsCompleted:Function, token:Object = null):void
{
	if(!attachFeat.willTrigger(FeatureLayerEvent.EDITS_STARTING))
	{
		attachFeat.addEventListener(FeatureLayerEvent.EDITS_STARTING, condEditsStarted);
	}
	attachFeat.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,condEditsCompleted);
	if(featureSet.features.length>0)// on a des données !
	{
		isInAttach = true;
		attachArray = [];
		var attachGraph:Array;
		for each (var gr:Graphic in featureSet.features)
		{
			attachGraph = [];
			attachGraph.push(gr.attributes.OBJECTID);
			attachGraph.push(gr.attributes.IDBATI);
			attachGraph.push(gr.attributes.IDPJ);
			attachGraph.push(gr.attributes.THEME);
			attachArray.push(attachGraph);
			
		}
	} else
	{
		isInAttach = false;
		attachArray = [];
		attachArray.push();
		attachArray.push();
		attachArray.push();
		attachArray.push();
	}
	
}//End function: OnQueryResult

private function onQueryAttachFault(fault:Fault, token:Object = null):void
{
	//geolGridSource.removeAll();
//	Alert.show("FAUTE !!!\n"+fault.content);
	//var error:Text = new Text();
	//error.text = "Aucune entité trouvée pour cet object";
	//index.ws1.addElement(error);
	//tablePanel.addElement(error);
}//END Function onQueryFault
