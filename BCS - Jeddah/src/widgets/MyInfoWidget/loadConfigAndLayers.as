// ActionScript file
import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.events.MapMouseEvent;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.tasks.supportClasses.Query;

import flash.events.MouseEvent;
import flash.net.SharedObject;

import mx.controls.Alert;
import mx.core.ClassFactory;
import mx.events.ResizeEvent;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;

import customRenderer.SizeRenderer;

// ActionScript file
private function basewidget_widgetConfigLoaded():void
{
	attachmentsLabel = getDefaultString("attachmentsLabel");
	attachmentInspector.addEventListener("attributeGroupClicked", attributeGroupClickedHandler);
	addEventListener("attachmentGroupClicked", attachmentGroupClickedHandler);
	sizeRen = new ClassFactory(SizeRenderer);								
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var s:String = "Hello " + getSharedObject.data.user.username + ", ";
	var sst:String = "Please select the building to see informations";
	hello.text = s;
	st.text = sst;
	
	map.infoWindow.hide();
	clickToAdd = false;
	clickToMove = false;
	
	map.addEventListener(MapMouseEvent.MAP_CLICK,map_mapClickHandler);
	map.addLayer(myGraphicsLayer);
	
	//dpSiteLocation.addItem({label:"Other", data:""});
	
	if(!opened){
		index = parentDocument.parentDocument.parentDocument.parentDocument.parentDocument.parentDocument.parentDocument.parentDocument;
		screenWidth = stage.stageWidth;
		screenHeight = stage.stageHeight;
	}
	
	HButtonBox.id = "HBBox";
	HButtonBox.name = "HBBox";
	VPanelBox.id = "VPBox";
	VPanelBox.name = "VPBox";
	VPanelBox.percentHeight = 90;
	VPanelBox.percentWidth = 95;
	VPanelBox.right = 0;
	VPanelBox.top = 20;
	
	bord.name = "bord";
	bordbis.name = "bordbis";
	
	
	featLayer = map.getLayer("BatiInEdition") as FeatureLayer;
	featLayer.token = configData.opLayers[0].token;
	featLayer.disableClientCaching = true;
	
	var mLayer:FeatureLayer = map.getLayer("BatiValidated") as FeatureLayer;
	mLayer.token = configData.opLayers[0].token;
	var validLayer:FeatureLayer = new FeatureLayer(mLayer.url, null, null);
	//validLayer.addEventListener(LayerEvent.LOAD, mLayerLoadedHandler);
	validLayer.token = configData.opLayers[0].token;
	
	function mLayerLoadedHandler(ev:LayerEvent):void
	{
		var str:String = validLayer.layerDetails.copyright.toString();
		if(str == "")
		{
			str = "PROJ_ID = 4";
			
		}
		var project:Array = new Array();
		project = str.replace(/[^a-zA-Z0-9=]/g,"").split("OR");
		var projNum:Array = new Array();
		
		
		if(project.length > 1)
		{
			for(var i:int = 0; i<project.length; i++)
			{
				var str1:String = (project[i]).split("PROJID=")[1];
				projNum.push(parseInt(str1));
			}
		}
		else
		{
			var str1:String = (project[i]).split("PROJID=")[1];
			projNum.push(parseInt(str1));
		}
		
		var url:String = mLayer.url;
		
		var projLay:FeatureLayer;
		
		var indProj:int = -1;
		for(var i:int=0; i<validLayer.layerDetails.relationships.length; i++)
		{
			if(validLayer.layerDetails.relationships[i].name == "Attributes from PROJ")
			{
				indProj = validLayer.layerDetails.relationships[i].relatedTableId;
				break;
			} 
		}
		if(indProj == -1)
		{
			Alert.show("Can't find PROJ table, sorry... Please contact administrator");	
		}
		else 
		{ 
			url = url.split("MapSer")[0];
			url += "FeatureServer/" + indProj;
			projLay = new FeatureLayer(url, null, null) as FeatureLayer;
			projLay.token = configData.opLayers[0].token;
			projLay.outFields = ["*"];
			projLay.disableClientCaching = true;
			projLay.addEventListener(LayerEvent.LOAD, projLayerLoadedHandler);
		}
		
		function projLayerLoadedHandler(evt:LayerEvent):void
		{
			var queryProj:Query = new Query();
			queryProj.where = "";
			for (var i:int = 0; i<projNum.length; i++)
			{
				queryProj.where += "OBJECTID = " + projNum[i];
				queryProj.outFields = ["*"];
				
				if(i < projNum.length - 1){
					queryProj.where += " OR ";
				}
			}
			
			projLay.queryFeatures(queryProj,new AsyncResponder(onQueryResult, onQueryFault));
			function onQueryResult(featureSet:FeatureSet, token:Object = null):void
			{	
				for each(var gr:Graphic in featureSet.features){
					var tmpObj:Object = {data:gr.attributes.OBJECTID, label:gr.attributes.PROJ_NAME}
//					dpProj.push(tmpObj);
				}
				
				opened = true;
			}
			function onQueryFault(fault:Fault, token:Object = null):void
			{
				Alert.show("Erreur de chargerment de la table PROJ");
			}
		}
	}
}