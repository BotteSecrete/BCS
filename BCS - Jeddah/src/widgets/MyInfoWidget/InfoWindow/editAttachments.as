import com.esri.ags.Graphic;
import com.esri.ags.components.ContentNavigator;
import com.esri.ags.events.MapMouseEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.skins.supportClasses.AttachmentMouseEvent;
import com.esri.ags.symbols.InfoSymbol;
import com.esri.ags.tasks.IdentifyTask;
import com.esri.ags.tasks.supportClasses.IdentifyParameters;
import com.esri.ags.tasks.supportClasses.IdentifyResult;
import com.esri.ags.utils.GraphicUtil;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.events.FlexEvent;
import mx.rpc.AsyncResponder;
import mx.utils.GraphicsUtil;

import spark.components.RichText;

private var contentNavigator:ContentNavigator;

// ActionScript file
private function editAttachFeatures():void
{
//	if(clickToAdd){
//		clickToAdd = false;
//	}
//	if (clickToMove)
//	{
//		clickToMove =  false;
//	}
	dispatchEvent(new Event("attachmentGroupClicked", true, true));
}

private function attachmentInspector_initializeHandler(event:FlexEvent):void
{
	super.initializationComplete();
	attachmentInspector.addEventListener(AttachmentMouseEvent.ATTACHMENT_DOUBLE_CLICK, attachmentDoubleClickHandler);
}

private function attachmentDoubleClickHandler(event:AttachmentMouseEvent):void
{
	navigateToURL(new URLRequest(event.attachmentInfo.url));
}


private function attributeGroupClickedHandler(event:Event):void
{
	map.infoWindow.content = null;
	index.ws1.removeElement(attachmentInspector);
	var rt:RichText = new RichText();
	rt.text = (index.ws0.label).split(", ")[0];
	map.infoWindow.label = rt.text;
}

private function attachmentGroupClickedHandler(event:Event):void
{
	index.ws1.addChildAt(attachmentInspector,1);
	attachmentInspector.percentHeight = 100;
	attachmentInspector.left = -200;
//	if (isPlan){
//		attachmentInspector.attachmentInfos.removeItemAt(0);
//	} else if (isPicture) {
//		attachmentInspector.attachmentInfos.removeItemAt(1);
//	}
	callLater(showAttachments);
	
	var ind:Number;
	for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
	{
		if(featLayer.graphicProvider[id].attributes.OBJECTID == (index.ws0.label).split(", ")[1])
		{
			ind = id;
			break;
		}
	}
	
	function showAttachments():void
	
	{
//		var attch:FeatureLayer;
//		var url:String = featLayer.url;
//		var indStruct:int;
//		indStruct=(index.ws0.label).split(", ")[1];
//		Alert.show("url (attachment) : "+url+"\n ind : "+(index.ws0.label).split(", ")[1],"Debugg");
//		var url:String = "https://sygdev.systra.info/arcgis/rest/services/TSS/TSS_BAKU_Building_FA_140612/FeatureServer/2/151/attachments/1201";
//		url += "/" + indStruct + "/attachments/1";
//		Alert.show("url : "+url,"Debugg");
//		attch = new FeatureLayer(url, null, null);
//		attch.token = configData.opLayers[0].token;
//		attch.disableClientCaching = true;
//		attch.refresh();
		
//		var ind:Number;
//		for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
//		{
//			if(featLayer.graphicProvider[id].attributes.OBJECTID == (index.ws0.label).split(", ")[1])
//			{
//				ind = id;
//				break;
//			}
//		}
		
//		Alert.show("apres creation attch !","Debugg");
////		var ind:Number;
//		var showAtt:Array = attachmentInspector.attachmentInfos.toArray();
//		attachmentInspector.attachmentInfos.removeAll();
//		attachmentInspector.attachmentInfos.addItem(showAtt[0]);
		attachmentInspector.showAttachments(featLayer.graphicProvider[ind] as Graphic, featLayer);
		
//		attachmentInspector.showAttachments(attch.graphicProvider[0] as Graphic,attch);
//		Alert.show("Apres showAttachments ! \n length : "+ attachmentInspector.attachmentInfos.length,"Debugg");
		
//		attachmentInspector.attachmentInfos.
//		attachmentInspector.showAttachments(featLayerGraphic as Graphic, featLayer);
	}
	
}