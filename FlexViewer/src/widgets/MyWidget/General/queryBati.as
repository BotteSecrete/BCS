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


private function onQueryBatiResult(featureSet:FeatureSet, geolEditsStarted:Function, token:Object = null):void
{
	if(!featLayer.willTrigger(FeatureLayerEvent.EDITS_STARTING))
	{
		featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, geolEditsStarted);
	}
	
	//geol.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,geolEditsCompleted);
	if(featureSet.features.length>0)// on a des données !
	{
		for each (var gr:Graphic in featureSet.features)
		{
			batiArray = [];
			batiArray.push(gr.attributes.OBJECTID);
			batiArray.push(gr.attributes.CODE);
			batiArray.push(gr.attributes.FI);
			batiArray.push(gr.attributes.BW);
			batiArray.push(gr.attributes.BL);
			batiArray.push(gr.attributes.NSL);
			batiArray.push(gr.attributes.NSB);
			batiArray.push(gr.attributes.Depth_Storey);
			batiArray.push(gr.attributes.HB);
			batiArray.push(gr.attributes.Building_Category);
			batiArray.push(gr.attributes.Use_Building);
			batiArray.push(gr.attributes.UIZ);
			batiArray.push(gr.attributes.UB_Descr);
			batiArray.push(gr.attributes.HB_Descr);
			batiArray.push(gr.attributes.FI_desc);
			
		}
	} else
	{
		batiArray = [];
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
		batiArray.push();
	}
	
}//End function: OnQueryResult

private function onQueryBatiFault(fault:Fault, token:Object = null):void
{
	geolGridSource.removeAll();
	//Alert.show("FAUTE !!!");
	var error:Text = new Text();
	error.text = "Aucune entité trouvée pour cet object";
	index.ws1.addElement(error);
	//tablePanel.addElement(error);
}//END Function onQueryFault