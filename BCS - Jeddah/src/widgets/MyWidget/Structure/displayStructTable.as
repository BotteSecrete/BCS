import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.AttachmentEvent;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.layers.supportClasses.CodedValue;
import com.esri.ags.layers.supportClasses.CodedValueDomain;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.viewer.AppEvent;
import com.esri.viewer.ViewerContainer;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.containers.Form;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.Text;
import mx.controls.TextInput;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.formatters.NumberFormatter;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.styles.CSSStyleDeclaration;

import spark.components.CheckBox;
import spark.components.ComboBox;
import spark.components.Panel;
import spark.components.TextArea;
import spark.components.supportClasses.Skin;

import ImageButton;

import customRenderer.SizeRenderer;

import flexlib.events.WindowShadeEvent;

import mySkins.AddButtonSkin;
import mySkins.MySkins2;


// ActionScript file
private function displayStructTable(k:uint,event:FeatureLayerEvent,holeObjId:Number):void
{
	index.ws1.removeAllChildren();
//	setCondArray(k,event);
	setAttachArray(k,event);
//	setBatiArray(k,event);
	getStructDomainValue();
	
//	attachGen = false;
//	attachStruct = true;
//	attachCond = false;
	
	var formStruct:Form = new Form();
	formStruct.id = "formStruct";
	
	var gridG:Grid = new Grid();
	gridG.name = "gridG";
	
	var gridRowG:GridRow = new GridRow();
	var gridItemGL:GridItem = new GridItem();
	
	var gridL:Grid = new Grid();
	gridL.name = "gridL";
	var gridRowL:GridRow = new GridRow();//var gridRowL2:GridRow = new GridRow();var gridRowL3:GridRow = new GridRow();var gridRowL4:GridRow = new GridRow();
	var gridItemL:GridItem = new GridItem();//var gridItemL2:GridItem = new GridItem();var gridItemL3:GridItem = new GridItem();var gridItemL4:GridItem = new GridItem();
	
	var gridR:Grid = new Grid();
	gridR.name = "gridR";
	var gridRowR:GridRow = new GridRow();//var gridRowR2:GridRow = new GridRow();var gridRowR3:GridRow = new GridRow();var gridRowR4:GridRow = new GridRow();
	var gridItemR:GridItem = new GridItem();//var gridItemR2:GridItem = new GridItem();var gridItemR3:GridItem = new GridItem();var gridItemR4:GridItem = new GridItem();
	
	var gridVH:Grid = new Grid();
	gridVH.name = "gridVH";
	
	var gridRowVHT:GridRow = new GridRow();
	var gridRowVH1:GridRow = new GridRow();
	var gridRowVH2:GridRow = new GridRow();
	var gridRowVH3:GridRow = new GridRow();
	var gridRowVH4:GridRow = new GridRow();
	
	var gridItemVT:GridItem = new GridItem();
	var gridItemV1:GridItem = new GridItem();var gridItemLV1:GridItem = new GridItem();
	var gridItemV2:GridItem = new GridItem();var gridItemLV2:GridItem = new GridItem();
	var gridItemV3:GridItem = new GridItem();var gridItemLV3:GridItem = new GridItem();
	var gridItemV4:GridItem = new GridItem();var gridItemLV4:GridItem = new GridItem();
	
	var VTLabel:mx.controls.Label = new mx.controls.Label();
	VTLabel.text = "Main bearing structure ";
	gridItemVT.addChild(VTLabel);
	gridRowVHT.addChild(gridItemVT);
	
	var LabelV1:mx.controls.Label = new mx.controls.Label();
	LabelV1.text = "Reinforced concrete ";
	var VCheck1:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck1.name = "Reinforced concrete";
	VCheck1.selected = structArray[2] == "Reinforced concrete"? true : false;
	VCheck1.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV1.addChild(LabelV1);
	gridItemV1.addChild(VCheck1);
	
	var LabelV2:mx.controls.Label = new mx.controls.Label();
	LabelV2.text = "Steel";
	var VCheck2:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck2.name = "Steel";
	VCheck2.selected = structArray[2] == "Steel"? true : false;
	VCheck2.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV2.addChild(LabelV2);
	gridItemV2.addChild(VCheck2);
	
	var LabelV3:mx.controls.Label = new mx.controls.Label();
	LabelV3.text = "Stone";
	var VCheck3:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck3.name = "Stone";
	VCheck3.selected = structArray[2] == "Stone"? true : false;
	VCheck3.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV3.addChild(LabelV3);
	gridItemV3.addChild(VCheck3);
	
	var LabelV4:mx.controls.Label = new mx.controls.Label();
	LabelV4.text = "Brick";
	var VCheck4:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck4.name = "Brick";
	VCheck4.selected = structArray[2] == "Brick"? true : false;
	VCheck4.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV4.addChild(LabelV4);
	gridItemV4.addChild(VCheck4);
	
	
	anyoneSelectedV();
	
	
	gridRowVH1.addChild(gridItemLV1);gridRowVH1.addChild(gridItemV1);
	gridRowVH2.addChild(gridItemLV2);gridRowVH2.addChild(gridItemV2);
	gridRowVH3.addChild(gridItemLV3);gridRowVH3.addChild(gridItemV3);
	gridRowVH4.addChild(gridItemLV4);gridRowVH4.addChild(gridItemV4);
	
	gridVH.addChild(gridRowVHT);gridVH.addChild(gridRowVH1);gridVH.addChild(gridRowVH2);
	gridVH.addChild(gridRowVH3);gridVH.addChild(gridRowVH4);
	
	gridItemL.addChild(gridVH);
	gridRowL.addChild(gridItemL);
	
	var hBoxFD1:HBox = new HBox();var hBoxFD2:HBox = new HBox();var hBoxFD3:HBox = new HBox();
	var gridItemFD1:GridItem = new GridItem();var gridItemFD2:GridItem = new GridItem();var gridItemFD3:GridItem = new GridItem();
	var gridRowFD1:GridRow = new GridRow();var gridRowFD2:GridRow = new GridRow();var gridRowFD3:GridRow = new GridRow();
	
	var LabelTF:mx.controls.Label = new mx.controls.Label();
	LabelTF.text = "Foundations : ";
	
	var TFList:mx.controls.ComboBox = new mx.controls.ComboBox();
	TFList.setStyle('color', 0x000000);
	TFList.dataProvider = qResultsTF;
	if (structArray[3] != null)
	{
		TFList.selectedIndex = 0;
		var len:int = qResultsTF.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (TFList.dataProvider[j] == structArray[3]) 
			{
				TFList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		TFList.selectedIndex = 0;
	}
	TFList.name = "TFList";
	TFList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	
	hBoxFD1.addChild(LabelTF);hBoxFD1.addChild(TFList);
	gridItemFD1.addChild(hBoxFD1);gridRowFD1.addChild(gridItemFD1);
	
	var LabelFMD:mx.controls.Label = new mx.controls.Label();
	LabelFMD.text = "Type of foundation : ";
	
	var TFList2:mx.controls.ComboBox = new mx.controls.ComboBox();
	TFList2.setStyle('color', 0x000000);
	TFList2.dataProvider = qResultsFM;	
	if (structArray[4] != null)
	{
		TFList2.selectedIndex = 0;
		var len:int = qResultsFM.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (TFList2.dataProvider[j] == structArray[4]) 
			{
				TFList2.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		TFList2.selectedIndex = 0;
	}
	TFList2.name = "TFList2";
	TFList2.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	
	hBoxFD2.addChild(LabelFMD);hBoxFD2.addChild(TFList2);
	gridItemFD2.addChild(hBoxFD2);gridRowFD2.addChild(gridItemFD2);
	
	var LabelFD:mx.controls.Label = new mx.controls.Label();
	LabelFD.text = "Depth range : ";
	
	var DpthList:mx.controls.ComboBox = new mx.controls.ComboBox();
	DpthList.setStyle('color', 0x000000);
	DpthList.dataProvider = qResultsDR;				
		if (structArray[5] != null)
		{
			DpthList.selectedIndex = 0;
			var len:int = qResultsDR.length;
			for (var j:int = 0; j < len; j++) 
			{
				if (DpthList.dataProvider[j] == structArray[5]) 
				{
					DpthList.selectedIndex = j;
					break;
				}
			}
		}
		else
		{
			DpthList.selectedIndex = 0;
		}
	DpthList.name = "DpthList";
	DpthList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	
	hBoxFD3.addChild(LabelFD);hBoxFD3.addChild(DpthList);
	gridItemFD3.addChild(hBoxFD3);gridRowFD3.addChild(gridItemFD3);
	
	
	var gridItemSpace:GridItem = new GridItem();
	
	gridL.addChild(gridRowL);
//	gridL.addChild(gridRowL2);
//	gridL.addChild(gridRowL3);
//	gridL.addChild(gridRowL4);
	gridL.addChild(gridRowFD1);
	gridL.addChild(gridRowFD2);
	gridL.addChild(gridRowFD3);
	
	gridItemGL.addChild(gridL);
	gridRowG.addChild(gridItemGL);
	gridG.addChild(gridRowG);	
	
	formStruct.addChild(gridG);
	index.ws1.addChild(formStruct);
	index.ws1.label = "Structure Informations";
	index.ws1.height = 350;
	index.ws1.visible = true;
	
	if (statusValidated)
	{
		
		
		TFList.editable = false;
		TFList2.editable = false;
		DpthList.editable = false;
		
		TFList.enabled = false;
		TFList2.enabled = false;
		DpthList.enabled = false;
		
		VCheck1.enabled = false;
		VCheck2.enabled = false;
		VCheck3.enabled = false;
		VCheck4.enabled = false;
		
	}
	
	function changeStatusVHandler(ev:MouseEvent):void
	{
		var hasToSave:Boolean = false;
		var attributes:Object = {};
		attributes = isIn? {OBJECTID:structArray[0]} : {IDBATI:event.features[k].attributes.OBJECTID};
		
		switch(ev.target.name)
		{
			case "Reinforced concrete":
				VCheck2.enabled = ev.target.selected? false : true;
				VCheck3.enabled = ev.target.selected? false : true;
				VCheck4.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.MB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.MB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Steel":
				VCheck1.enabled = ev.target.selected? false : true;
				VCheck3.enabled = ev.target.selected? false : true;
				VCheck4.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.MB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.MB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Stone":
				VCheck2.enabled = ev.target.selected? false : true;
				VCheck1.enabled = ev.target.selected? false : true;
				VCheck4.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.MB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.MB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Brick":
				VCheck2.enabled = ev.target.selected? false : true;
				VCheck3.enabled = ev.target.selected? false : true;
				VCheck1.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.MB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.MB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			break;
		}
		
		var feature:Graphic = new Graphic(null, null, attributes);
		var updates:Array = [ feature ];
		if(hasToSave && isIn)
		{
			struct.applyEdits(null,updates,null);
		} else if (hasToSave && !isIn)
		{
			isIn = true;
			struct.applyEdits(updates,null,null);
		}
		
	}
	
	
//	function changeStatusRTHandler(ev:MouseEvent):void
//	{
//		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
//		{
//			struct.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerStruct_editsStarted);
//		}
//		changeStatusStruct(event, ev, k);
//		
//	}
	
	function onCbChangeHandler(ev:ListEvent):void
	{
		onCbStructureChange(ev, event, k);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			//struct.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerStruct_editsStarted); 
		}	
	}	
	
	function myFeatureLayerStruct_editsStarted(ev:FeatureLayerEvent):void
	{
		struct.removeEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerStruct_editsStarted);
		struct.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayerStruct_updateEditsComplete);
		
		
		TFList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList2.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		DpthList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		
		VCheck1.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck2.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck3.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck4.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		
		
	}// fin de myFeatureLayer_editsStarted
	
	function featLayerStruct_updateEditsComplete(ev:FeatureLayerEvent):void
	{
		struct.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayerStruct_updateEditsComplete);
		if(!clickToAdd && !clickToMove  && !coordToMove) //Cas où l'on update un élément sans le bouger
		{
			if(ev.featureEditResults.updateResults.length > 0)
			{
				var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
				toastMessage.imageSource = "assets/images/save.png";
				toastMessage.sampleCaption = "Updated Test";
				toastMessage.timeToLive = 2;
				index.simpleToaster.toast(toastMessage);
				
				struct.clearSelection();
				struct.refresh();
				
				struct.addEventListener(LayerEvent.UPDATE_END, featLayerStruct_updateEndHandler); 
				
				function featLayerStruct_updateEndHandler(evt:LayerEvent):void
				{
					var ind:Number;
//					for (var id:Number = 0; id < struct.graphicProvider.length; id++)
//					{
//						if(struct.graphicProvider[id].attributes.OBJECTID == event.features[k].attributes.OBJECTID)
//						{
//							ind = id;
//							break;
//						}
//					}
					ind = featInd;
					event.features[k] = (!isNaN(ind))?struct.graphicProvider[ind]:event.features[k];
					
					isNotFStruct = true;
					
					if(changedStatus)
					{
						changedStatus = false;
						
						if((index.collapsingPanel.fullScreen||!index.collapsingPanel.collapsed) && isNaN(ind))
						{
							index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						}
					}		
					struct.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler)
					addInfoWindListener();
					struct.removeEventListener(LayerEvent.UPDATE_END, featLayerStruct_updateEndHandler); 
				}// fin de featLayerStruct_updateEndHandler
			}
			else if(ev.featureEditResults.deleteResults.length > 0)
			{
				map.infoWindow.hide();
				struct.clearSelection();
				struct.refresh();
				var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
				toastMessage.imageSource = "assets/images/trash.png";
				toastMessage.sampleCaption = "Borehole deleted";
				toastMessage.timeToLive = 2;
				index.simpleToaster.toast(toastMessage);
				struct.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler);
				index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		else if(!clickToAdd && (clickToMove || coordToMove)) //Cas où l'on bouge un élément dans un update
		{
//			map.infoWindow.hide();
//			struct.clearSelection();
//			clickToMove = false;	
//			coordToMove = false;
//			var query = new Query();
//			query = new Query();
//			query.objectIds = [event.featureEditResults.updateResults[0].objectId];
//			query.outFields=["*"];
//			struct.refresh();
//			struct.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler)
//			struct.selectFeatures(query);
		}
		
	}// fin de featLayer_updateEditsComplete
	
	function addInfoWindListener():void
	{
		
		TFList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList2.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		DpthList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		
		VCheck1.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck2.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck3.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck4.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		
		map.infoWindow.addEventListener(flash.events.Event.CLOSE, infoWindowCloseButtonClickHandler);
		
	}// fin de addInfoWindListener

	function ifMatched():void
	{
		index.ws2.visible = index.ws3.visible = false;
		if(clickToAdd){
			clickToAdd = false;
		}
		if (clickToMove)
		{
			clickToMove =  false;
		}
	}
	
	
	function onCbStructureChange(ev:ListEvent, event:FeatureLayerEvent, k:Number):void
	{
		var hasToSave:Boolean = false;
		var attributes:Object = {};
		attributes = isIn? {OBJECTID:structArray[0]} : {IDBATI:event.features[k].attributes.OBJECTID};
		switch (ev.target.name)
		{
			
			case "TFList":
				if(!isIn || structArray[3] != ev.target.selectedLabel)
				{
					attributes.TypeF = ev.target.selectedLabel;
					hasToSave = true;
				}
				if (TFList.selectedItem == "Shallow")
				{
					hBoxFD1.visible = true;
					hBoxFD2.visible = false;
					hBoxFD3.visible = false;
					hasToSave = true;
					
				} else if (TFList.selectedItem == "Deep")
				{
					hasToSave = true;
				}
				
				break;
			
			case "TFList2":
				if(!isIn || structArray[4] != ev.target.selectedLabel)
				{
					attributes.FM = ev.target.selectedLabel;
					hasToSave = true;
				}
				break;
			
			case "DpthList":
				if(!isIn || structArray[5] != ev.target.selectedLabel)
				{
					attributes.Depth_Range = ev.target.selectedLabel;
					hasToSave = true;
				}
				break;
		}
		var feature:Graphic = new Graphic(null, null, attributes);
		var updates:Array = [ feature ];
		if(hasToSave && isIn)
		{
			struct.applyEdits(null,updates,null);
			struct.clearSelection();
			struct.refresh();
		} else if (hasToSave && !isIn)
		{
			isIn = true;
			struct.applyEdits(updates,null,null);
			struct.clearSelection();
			struct.refresh();
		}
	}
	
	function anyoneSelectedV()
	{
		if (VCheck1.selected){
			VCheck2.enabled = false;
			VCheck3.enabled = false;
			VCheck4.enabled = false;
		} else if (VCheck2.selected)
		{
			VCheck1.enabled = false;
			VCheck3.enabled = false;
			VCheck4.enabled = false;
		} else if (VCheck3.selected)
		{
			VCheck1.enabled = false;
			VCheck2.enabled = false;
			VCheck4.enabled = false;
		} else if (VCheck4.selected)
		{
			VCheck1.enabled = false;
			VCheck3.enabled = false;
			VCheck2.enabled = false;
		}
	}
	
	if (configXML.USER == "Consulte")
	{
		VCheck1.enabled = false;
		VCheck2.enabled = false;
		VCheck3.enabled = false;
		VCheck4.enabled = false;
		
		TFList.editable = false;
		TFList2.editable = false;
		DpthList.editable = false;
	}
}



private function getStructDomainValue():void
{
	var returnValue:String = "";
	var fld:Object;
	var cVal:CodedValue;
	var cDomain:CodedValueDomain;
	for each (fld in struct.layerDetails.fields)
	{
		switch (fld.name)
		{
			case "FM":
				cDomain = fld.domain;
				qResultsFM = [];
				qResultsFM.push(" ");
				for each (cVal in cDomain.codedValues)
			{
				qResultsFM.push(cVal.name);
			}
				break;
			case "TypeF":
				cDomain = fld.domain;
				qResultsTF = [];
				qResultsTF.push(" ");
				for each (cVal in cDomain.codedValues)
			{
				qResultsTF.push(cVal.name);
			}
				break;
			case "Depth_Range":
				cDomain = fld.domain;
				qResultsDR = [];
				qResultsDR.push(" ");
				for each (cVal in cDomain.codedValues)
			{
				qResultsDR.push(cVal.name);
			}
				break;
		}	
		
	}
	
	
	
}

