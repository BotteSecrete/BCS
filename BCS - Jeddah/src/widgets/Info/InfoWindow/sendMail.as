import com.esri.ags.tasks.supportClasses.Query;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.net.SharedObject;

import mx.controls.Alert;
import mx.rpc.AsyncResponder;
import mx.rpc.http.mxml.HTTPService;

import widgets.MyWidget.MyFirstWidget;

private function sendMail(id:String, locaID:String, projID:Number):void
{
	var getSharedObject:SharedObject = SharedObject.getLocal("userData","/");
	
	var _senderName:String = getSharedObject.data.user.username; //senderName.text;
	var _senderEmail:String = "syg@systra.com" //senderEmail.text;
	var _emailMessage:String = "Building Completed for code" + id;//emailMessage.text;
	var _emailSubject:String = "["+getSharedObject.data.user.username+"] Bati Completed in BCS Viewer"; //emailSubject.text;
	var _destiEmail:String = configData.configXML.responsable.mail;
	var _boreholeID:String = id;
	var indProj:Number = -1;
	var projName:String = "Baku Buildings";
//	for(var i:int=0; i<featLayer.layerDetails.relationships.length; i++)
//	{
//		if(featLayer.layerDetails.relationships[i].name == "Attributes from PROJ")
//		{
//			indProj = featLayer.layerDetails.relationships[i].relatedTableId;
//			break;
//		} 
//	}
	
//	var url:String = featLayer.url;
	
//	var projLay:FeatureLayer ;
//	if(indProj == -1 || indProj == featLayer.layerDetails.relationships.length -1 )
//	{
//		Alert.show("Can't find PROJ table, sorry... Please contact administrator");	
//	}
//	else 
//	{ 
//		url = url.split("FeatureServer")[0];
//		url += "FeatureServer/" + indProj;
//		projLay = new FeatureLayer(url, null, null) as FeatureLayer;
//		projLay.token = configData.opLayers[0].token;
//		projLay.outFields = ["*"];
//		projLay.disableClientCaching = true;
//		projLay.addEventListener(LayerEvent.LOAD, projLayerLoadedHandler);
		var _destiName:String = configData.configXML.responsable.name;
		
		var emailService:HTTPService = new HTTPService;
		emailService.url = "php/mail.php";
		emailService.method = "POST";
		emailService.resultFormat = "xml";
		emailService.useProxy = false;
		emailService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/email1.png";
		toastMessage.sampleCaption = "Responsable has been notified";
		toastMessage.timeToLive = 2;
		MyFirstWidget.index.simpleToaster.toast(toastMessage);
//	}
	
//	function projLayerLoadedHandler (event: LayerEvent) : void
//	{
//		var query = new Query();
//		query.objectIds = [projID];
//		query.outFields=["*"];
//		projLay.queryFeatures(query, new AsyncResponder(onProjQueryResult, onProjQueryFault)); 
//	}  
//	
//	function onProjQueryResult(featureSet:FeatureSet, token:Object = null)
//	{
//		var projName:String = featureSet.attributes[0].PROJ_NAME;
//		emailService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
//	}
//	
//	function onProjQueryFault(fault:Fault, token:Object = null)
//	{
//		var projName:String = "Unknown"
//		emailService.send({senderName: _senderName, boreholeID:_boreholeID, locaID: locaID ,destiName:_destiName, senderEmail:_senderEmail, emailSubject:_emailSubject, emailMessage: _emailMessage, destiEmail:_destiEmail, projName: projName});
//	}	
}



