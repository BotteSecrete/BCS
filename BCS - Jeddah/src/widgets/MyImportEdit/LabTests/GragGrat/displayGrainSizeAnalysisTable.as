import com.esri.ags.FeatureSet;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.layers.supportClasses.FeatureEditResults;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.viewer.AppEvent;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;

private function countRelatedsEntity(sampObjID:Number):void
{
	var url:String = samp.url;
	//var grag:FeatureLayer;
	var indGrag:int;
	var j:int = 0;
	
	label1:
	do 
	{
		if(samp.layerDetails.relationships[j].name == "Attributes from GRAG")
		{
			indGrag= samp.layerDetails.relationships[j].relatedTableId;
			url = url.split("Feature")[0];
			url += "FeatureServer/" + indGrag;
			grag = new FeatureLayer(url, null, null);
			grag.token = configData.opLayers[0].token;
			break label1;
		}
		else if(j == 19)
		{
			Alert.show("Can't find GRAG table, sorry... Please contact administrator");	
			break label1;
		}
		else
		{
			j++;
		}
	} while (j<20)
	
	var queryCountGrag:Query = new Query();
	queryCountGrag.where = "SAMP_ID = " + sampObjID;
	grag.queryCount(queryCountGrag,new AsyncResponder(onQueryCountResult, onQueryCountFault));
	
	function onQueryCountFault(event:FaultEvent, token:Object = null):void
	{
		Alert.show(event.message.toString());
	}
	
	function onQueryCountResult(count:Number, token:Object = null):void
	{
		pan1.label = "Grain Size Analysis: " + count.toString();
	}
	
}
private function displayGrainSizeAnalysisTable(grag:FeatureLayer,grat:FeatureLayer, sampID:Number):void
{

	//Query pour sélectionner les features, si il y en a plusieurs on ajoute les bandeau goToleft et Right et on ajuste la taille du content...
	//Si on les rajoute pas au début et qu'on clique sur '+' il se rajoute, on réajuste la taille du content
	//Si on clique sur moins, on compte le nombre de content.nimChildren - 1 == 1? on enlève les bandeaux on réajuste la taille 
	//faire une fonction qui créer le formulaire pour remplir GRAG & GRAT avec en paramètre le GRAG ID en entrée
	//LET'S GO:
	
	var queryGragFeatures : Query = new Query();
	queryGragFeatures.where = "SAMP_ID = " + sampID;
	grag.outFields = ["*"];
	//var gragQueryResponder: AsyncResponder = new AsyncResponder(onQueryGragResHandler, onQueryGragFault)
	grag.queryFeatures(queryGragFeatures, new AsyncResponder(onQueryGragResHandler, onQueryGragFault));
	
	AppEvent.addListener(AppEvent.ADD_GRAT_ROW,addGratRow);
	AppEvent.addListener(AppEvent.DEL_GRAT_ROW,delGratRow);
	

	

	
//End gragCompleteEdits
	
	
	

	
}//end displayGrainSizeAnalysisTable

private function onQueryGragResHandler(result:FeatureSet, token:Object = null):void
{
	onQueryGragRes(result, token);
}

private function onQueryGragFault(event:FaultEvent, token:Object = null):void
{
	Alert.show(event.message.toString());
}

private function faultgragEdit(ev:FaultEvent, token: Object=null):void
{
	Alert.show(ev.fault.faultString + "\n\n" + ev.fault.faultDetail, "FeatureLayer Fault " + ev.fault.faultCode);
}
private function gragCompleteEdits(ev:FeatureEditResults, token: Object=null):void
{
	if(ev.addResults.length > 0)
	{
		//countRelatedsEntity(sampID);
		//addGrainTest.removeEventListener(MouseEvent.CLICK,addGrainAnalysisTest);
		grag.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, gragCompleteEdits);
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/save.png";
		toastMessage.sampleCaption = "Added";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
		//Alert.show("added for: " + ev.featureEditResults.addResults[0].objectId);
		//Alert.show("added with: " + sampID);
		var queryGragFeatObj:Query =  new Query();
		//queryGragFeatObj.objectIds = [ev.featureEditResults.addResults[0].objectId];
		queryGragFeatObj.where = "SAMP_ID = " + sampGridSource.getItemAt(sampDataGrid.selectedIndex).OBJECTID;
		grag.outFields = ["*"];
		grag.queryFeatures(queryGragFeatObj, new AsyncResponder(onQueryGragResHandler, onQueryGragFault))
		//grag.queryFeatures(queryGragFeatObj,new AsyncResponder(onQueryGragObjRes, onQueryGragObjFault));
	}
	else if (ev.deleteResults.length > 0)
	{
		//Alert.show("deleted for: " + ev.featureEditResults.deleteResults[0].objectId);
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/trash.png";
		toastMessage.sampleCaption = "Test deleted";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
		var queryGragFeatObj:Query =  new Query();
		queryGragFeatObj.where = "SAMP_ID = " + sampGridSource.getItemAt(sampDataGrid.selectedIndex).OBJECTID;
		grag.outFields = ["*"];
		grag.queryFeatures(queryGragFeatObj, new AsyncResponder(onQueryGragResHandler, onQueryGragFault))
	}
}


private function faultgratEdit(ev:FaultEvent, token: Object=null):void
{
	Alert.show(ev.fault.faultString + "\n\n" + ev.fault.faultDetail, "FeatureLayer Fault " + ev.fault.faultCode);
}
private function gratCompleteEdits(ev:FeatureEditResults, token: Object=null):void
{
	if(ev.addResults.length > 0)
	{
		//countRelatedsEntity(sampID);
		//addGrainTest.removeEventListener(MouseEvent.CLICK,addGrainAnalysisTest);
		grat.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, gragCompleteEdits);
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/save.png";
		toastMessage.sampleCaption = "Added";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
		
		var tmp:Object = content.getChildAt(content.selectedIndex); //getResCanvas
		tmp = tmp.getChildAt(0)//get Vcanvas
		tmp = tmp.getChildByName("grid"); //get grid
		tmp = tmp.getChildAt(2); //get gridRow3
		tmp = tmp.getChildByName("invisibleID"); // get invisibleID
		tmp = tmp.getChildAt(0);
		//Alert.show("added for: " + ev.featureEditResults.addResults[0].objectId);
		//Alert.show("added with: " + sampID);
		var queryGratFeatObj:Query =  new Query();
		//queryGragFeatObj.objectIds = [ev.featureEditResults.addResults[0].objectId];
		queryGratFeatObj.where = "GRAG_ID = " + tmp.text;
		grat.outFields = ["*"];
		grat.queryFeatures(queryGratFeatObj, new AsyncResponder(onQueryGratRes1Handler, onQueryGrat1Fault))
		//grag.queryFeatures(queryGragFeatObj,new AsyncResponder(onQueryGragObjRes, onQueryGragObjFault));
		function onQueryGratRes1Handler(gratResult:FeatureSet, token:Object = null):void
		{
			var tmpBis:Object = content.getChildAt(content.selectedIndex) as Object;
			tmpBis = tmpBis.getChildAt(0)//get Vcanvas
			tmpBis = tmpBis.getChildByName("gratPanel");//get the panel
			var gratPanel:HBox = tmpBis as HBox;
			onQueryGratRes2(gratResult, gratPanel, token);		
		}// END onQueryGratResHandler
		
		function onQueryGrat1Fault(gratFault:Fault, token:Object = null):void
		{
			Alert.show(gratFault.message.toString());
		}
		
	}
	else if (ev.deleteResults.length > 0)
	{
		//Alert.show("deleted for: " + ev.featureEditResults.deleteResults[0].objectId);
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/trash.png";
		toastMessage.sampleCaption = "Test deleted";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
		
		var tmp:Object = content.getChildAt(content.selectedIndex); //getResCanvas
		tmp = tmp.getChildAt(0)//get Vcanvas
		tmp = tmp.getChildByName("grid"); //get grid
		tmp = tmp.getChildAt(2); //get gridRow3
		tmp = tmp.getChildByName("invisibleID"); // get invisibleID
		tmp = tmp.getChildAt(0);
		
		var queryGratFeatObj:Query =  new Query();
		queryGratFeatObj.where = "GRAG_ID = " + tmp.text;
		grat.outFields = ["*"];
		grat.queryFeatures(queryGratFeatObj, new AsyncResponder(onQueryGratRes2Handler, onQueryGrat2Fault))
		function onQueryGratRes2Handler(gratResult:FeatureSet, token:Object = null):void
		{
			var tmpBis:Object = content.getChildAt(content.selectedIndex) as Object;
			tmpBis = tmpBis.getChildAt(0)//get Vcanvas
			tmpBis = tmpBis.getChildByName("gratPanel");//get the panel
			var gratPanel:HBox = tmpBis as HBox;
			onQueryGratRes2(gratResult, gratPanel, token);	
		}// END onQueryGratResHandler
		
		function onQueryGrat2Fault(gratFault:Fault, token:Object = null):void
		{
			Alert.show(gratFault.message.toString());
		}
		
	}
}



private function delThisGrainTest(ev:MouseEvent):void
{
	var del:Array = new Array();
	var attrib:Object = {};
	var tmp:Object = content.getChildAt(content.selectedIndex); //getResCanvas
	tmp = tmp.getChildAt(0)//get Vcanvas
	tmp = tmp.getChildByName("grid"); //get grid
	tmp = tmp.getChildAt(2); //get gridRow3
	tmp = tmp.getChildByName("invisibleID"); // get invisibleID
	tmp = tmp.getChildAt(0);
	//Alert.show(tmp.text);
	attrib.OBJECTID = tmp.text;
	var feature:Graphic = new Graphic(null, null, attrib);
	del.push(feature);
	grag.applyEdits(null,null,del,false, new AsyncResponder(gragCompleteEdits,faultgragEdit));
}

private function addGrainAnalysisTest(ev:MouseEvent):void
{
	//sampGridSource.refresh();
	var add:Array = []
	var attributes:Object = {};
	//Alert.show("adding: " + sampID.toString());
	attributes = {SAMP_ID : sampGridSource.getItemAt(sampDataGrid.selectedIndex).OBJECTID};
	var feature:Graphic = new Graphic(null, null, attributes);
	add.push(feature);
	grag.applyEdits(add,null,null,false, new AsyncResponder(gragCompleteEdits,faultgragEdit)); 
	
}//END addGrainAnalysisTest