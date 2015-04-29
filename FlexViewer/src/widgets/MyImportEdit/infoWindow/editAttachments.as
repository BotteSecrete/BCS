import com.esri.ags.Graphic;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.skins.supportClasses.AttachmentMouseEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.events.FlexEvent;

import spark.components.RichText;

// ActionScript file
private function editAttachFeatures():void
{
	if(clickToAdd){
		clickToAdd = false;
	}
	if (clickToMove)
	{
		clickToMove =  false;
	}
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
	index.ws0.removeElement(attachmentInspector);
	var rt:RichText = new RichText();
	rt.text = (index.ws0.label).split(", ")[0];
	map.infoWindow.label = rt.text;
}

private function attachmentGroupClickedHandler(event:Event):void
{
	index.ws0.addChildAt(attachmentInspector,1);
	attachmentInspector.percentHeight = 100;
	attachmentInspector.left = -200;
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
		attachmentInspector.showAttachments(featLayer.graphicProvider[ind] as Graphic, featLayer);
	}
}