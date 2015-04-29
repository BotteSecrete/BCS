import com.esri.ags.events.FeatureLayerEvent;

import flash.events.Event;

import mx.events.EffectEvent;

// ActionScript file
private function infoWindowCloseButtonClickHandler(event:Event):void
{
	map.infoWindow.removeEventListener(flash.events.Event.CLOSE, infoWindowCloseButtonClickHandler);
	featLayer.clearSelection();
	index.ws0.removeAllChildren();
	index.ws1.removeAllChildren();
	index.ws2.removeAllChildren();
	index.ws3.removeAllChildren();
	index.ws0.visible = index.ws1.visible = index.ws2.visible = index.ws3.visible = false;
	if(clickToAdd){
		clickToAdd = false;
	}
	if (clickToMove)
	{
		clickToMove =  false;
	}
//	status.text="";
	featLayer.outFields = ["*"];
	map.infoWindow.hide();
	featLayer.clearSelection();
	featLayer.refresh();
	
	featLayer.removeEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler);
	
	/*if(index.btn.label == 'Close')
	{
	panelIn.play();
	panelIn.addEventListener(EffectEvent.EFFECT_END,goFadeOut);
	index.btnArrow.setStyle("upSkin",leftArrow);
	index.btnArrow.setStyle("downSkin",leftArrow);
	index.btnArrow.setStyle("overSkin",leftArrow);
	index.btnArrow.setStyle("disableSkin",leftArrow);
	function goFadeOut(ev:EffectEvent):void
	{
	fadeOut.play();	
	panelIn.removeEventListener(EffectEvent.EFFECT_END,goFadeOut);
	}
	} else {
	fadeOut.play();
	}*/
}