import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.components.AttachmentInspector;
import com.esri.ags.events.AttachmentEvent;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.layers.supportClasses.CodedValue;
import com.esri.ags.layers.supportClasses.CodedValueDomain;
import com.esri.ags.layers.supportClasses.RangeDomain;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.viewer.AppEvent;
import com.esri.viewer.ViewerContainer;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.containers.Form;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
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

import spark.components.Panel;
import spark.components.TextArea;
import spark.components.supportClasses.Skin;

import ImageButton;

import customRenderer.SizeRenderer;

import mySkins.AddButtonSkin;


// ActionScript file
private function displayConditionTable(k:uint,event:FeatureLayerEvent,holeObjId:Number):void
{
	
	index.ws1.removeAllChildren();
	setStructArray(k,event);
	setAttachArray(k,event);
//	setBatiArray(k,event);
	getCondDomainValue();
	
	attachGen = false;
	attachStruct = false;
	attachCond = true;
	
	var formCond:Form = new Form();
	formCond.id = "formCond";
	
	var gridG:Grid = new Grid();
	gridG.name = "gridG";
	
	var gridRowG:GridRow = new GridRow();
	var gridItemGL:GridItem = new GridItem(); var gridItemGR:GridItem = new GridItem();
	
	var gridL:Grid = new Grid();
	gridL.name = "gridL";
	var gridRowL:GridRow = new GridRow();var gridRowL2:GridRow = new GridRow();
	var gridItemL:GridItem = new GridItem();var gridItemL2:GridItem = new GridItem();
	
	var gridR:Grid = new Grid();
	gridR.name = "gridR";
	var gridRowR:GridRow = new GridRow();var gridRowR2:GridRow = new GridRow();var gridRowR3:GridRow = new GridRow();
	var gridItemR:GridItem = new GridItem();var gridItemR2:GridItem = new GridItem();var gridItemR3:GridItem = new GridItem();
	
	
	var gridD:Grid = new Grid();
	var gridRowD:GridRow = new GridRow();var gridRowD2:GridRow = new GridRow();var gridRowD3:GridRow = new GridRow();
	var gridRowD4:GridRow = new GridRow();var gridRowD5:GridRow = new GridRow();
	var gridItemD:GridItem = new GridItem();var gridItemD2:GridItem = new GridItem();var gridItemD3:GridItem = new GridItem();
	var gridItemD4:GridItem = new GridItem();var gridItemD5:GridItem = new GridItem();
	
	var GILabel:mx.controls.Label = new mx.controls.Label();
	GILabel.text = "General Inspection / exterior walls ";
	gridItemL.addChild(GILabel);gridRowL.addChild(gridItemL);
	
	var gridItemD11:GridItem = new GridItem();var gridItemD12:GridItem = new GridItem();var gridItemD13:GridItem = new GridItem();
	var DPLabel:mx.controls.Label = new mx.controls.Label();
	DPLabel.text = "Description of patterns ";
	
	var attachButDP:Button = new Button();
	attachButDP.name = "editAttachDP";
	attachButDP.label = "Descriptions";
	attachButDP.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	
	gridItemD11.addChild(DPLabel); gridItemD13.addChild(attachButDP);
	gridRowD.addChild(gridItemD11); gridRowD.addChild(gridItemD13);
	
	var gridItemD21:GridItem = new GridItem();var gridItemD22:GridItem = new GridItem();var gridItemD23:GridItem = new GridItem();
	var SPLabel:mx.controls.Label = new mx.controls.Label();
	SPLabel.text = "Sketches of patterns ";
	
	var attachButSP:Button = new Button();
	attachButSP.name = "editAttachSP";
	attachButSP.label = "Sketches";
	attachButSP.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	
	gridItemD21.addChild(SPLabel); gridItemD23.addChild(attachButSP);
	gridRowD2.addChild(gridItemD21); gridRowD2.addChild(gridItemD23);
	
	var gridItemD31:GridItem = new GridItem();var gridItemD32:GridItem = new GridItem();
	var LabelCD:mx.controls.Label = new mx.controls.Label();
	LabelCD.text = "Category of damage";
	
	var CDList:mx.controls.ComboBox = new mx.controls.ComboBox();
	CDList.setStyle('color', 0x000000);
	CDList.dataProvider = qResultsCD;				
	if (condArray[2] != null)
	{
		CDList.selectedIndex = 0;
		var len:int = qResultsCD.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (CDList.dataProvider[j] == condArray[2]) 
			{
				CDList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		CDList.selectedIndex = 0;
	}
	CDList.name = "CDList";
//	CDList.addEventListener(ListEvent.CHANGE, onCbChangeCondHandler);
	CDList.enabled = false;
	
	gridItemD31.addChild(LabelCD);gridItemD32.addChild(CDList);
	gridRowD3.addChild(gridItemD31);gridRowD3.addChild(gridItemD32);
	
	var gridItemD41:GridItem = new GridItem();var gridItemD42:GridItem = new GridItem();var gridItemD43:GridItem = new GridItem();
	var LabelOD:mx.controls.Label = new mx.controls.Label();
	LabelOD.text = "Other damage";
	var ODList:mx.controls.ComboBox = new mx.controls.ComboBox();
	ODList.setStyle('color', 0x000000);
	ODList.dataProvider = qResultsOD;				
	if (condArray[3] != null)
	{
		ODList.selectedIndex = 0;
		var len:int = qResultsOD.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (ODList.dataProvider[j] == condArray[3]) 
			{
				ODList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		ODList.selectedIndex = 0;
	}
	ODList.name = "ODList";
//	ODList.addEventListener(ListEvent.CHANGE, onCbChangeCondHandler);
	ODList.enabled = false;
	var attachButOD:Button = new Button();
	attachButOD.name = "editAttachOD";
	attachButOD.label = "Attachment";
	attachButOD.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	gridItemD41.addChild(LabelOD);gridItemD42.addChild(ODList);gridItemD43.addChild(attachButOD);
	gridRowD4.addChild(gridItemD41);gridRowD4.addChild(gridItemD42);gridRowD4.addChild(gridItemD43);
	
	gridD.addChild(gridRowD);gridD.addChild(gridRowD2);gridD.addChild(gridRowD3); gridD.addChild(gridRowD4);	
	
	
	var gridItemD0:GridItem = new GridItem();
	var LabelDam:mx.controls.Label = new mx.controls.Label();
	LabelDam.text = "Description";
	LabelDam.toolTip = "Description of damages";
	var genComInputOD:spark.components.TextArea = new spark.components.TextArea();
	genComInputOD.setStyle('color', 0x000000);
	if (condArray[4] == null)
	{
		genComInputOD.text = "";
	}
	else
	{
		genComInputOD.text = condArray[4];
	}
	genComInputOD.name = "genComInputOD";
	gridItemD5.colSpan = (2);
//	genComInputOD.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoCondEditedHandler);
	genComInputOD.editable = false;
	//genComInputOD.width = 125;
	genComInputOD.percentWidth = 100;
	genComInputOD.height = 40;
	gridItemD5.addChild(genComInputOD);gridItemD0.addChild(LabelDam);
	gridRowD5.addChild(gridItemD0);gridRowD5.addChild(gridItemD5);gridD.addChild(gridRowD5);
	
	gridItemL2.addChild(gridD);gridRowL2.addChild(gridItemL2);
	
	var LabelPic:mx.controls.Label = new mx.controls.Label();
	LabelPic.text = "Pictures ";
	gridItemR.addChild(LabelPic);gridRowR.addChild(gridItemR);
	
	var LabelPText:mx.controls.Label = new mx.controls.Label();
	LabelPText.text = "Plan view with picture localisation ";
	gridItemR2.addChild(LabelPText);gridRowR2.addChild(gridItemR2);
	
	var gridAttach:Grid = new Grid();
	var gridItemAttach1:GridItem = new GridItem();var gridItemAttach2:GridItem = new GridItem();var gridItemAttach3:GridItem = new GridItem();
	var gridItemAttach4:GridItem = new GridItem();var gridItemAttach5:GridItem = new GridItem();
	var gridRowAttach1:GridRow = new GridRow();var gridRowAttach2:GridRow = new GridRow();var gridRowAttach3:GridRow = new GridRow();
	var gridRowAttach4:GridRow = new GridRow();var gridRowAttach5:GridRow = new GridRow();
	
	var attachButPic1:Button = new Button();
	attachButPic1.name = "attachButPic1";
	attachButPic1.label = "Plan";
	attachButPic1.toolTip = "Plan view with picture localisation";
	attachButPic1.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//	var attachButPic2:Button = new Button();
//	attachButPic2.name = "attachButPic2";
//	attachButPic2.label = "Edit attachments";
////	attachButPic2.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//	var attachButPic3:Button = new Button();
//	attachButPic3.name = "attachButPic3";
//	attachButPic3.label = "Edit attachments";
////	attachButPic3.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//	var attachButPic4:Button = new Button();
//	attachButPic4.name = "attachButPic4";
//	attachButPic4.label = "Edit attachments";
////	attachButPic4.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//	var attachButPic5:Button = new Button();
//	attachButPic5.name = "attachButPic5";
//	attachButPic5.label = "Edit attachments";
//	attachButPic5.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	
	gridItemAttach1.addChild(attachButPic1);gridRowAttach1.addChild(gridItemAttach1)
//	gridItemAttach2.addChild(attachButPic2);gridRowAttach2.addChild(gridItemAttach2)
//	gridItemAttach3.addChild(attachButPic3);gridRowAttach3.addChild(gridItemAttach3)
//	gridItemAttach4.addChild(attachButPic4);gridRowAttach4.addChild(gridItemAttach4)
//	gridItemAttach5.addChild(attachButPic5);gridRowAttach5.addChild(gridItemAttach5)
	
	gridAttach.addChild(gridRowAttach1);//gridAttach.addChild(gridRowAttach2);gridAttach.addChild(gridRowAttach3);
//	gridAttach.addChild(gridRowAttach4);gridAttach.addChild(gridRowAttach5);
	
	gridItemR3.addChild(gridAttach); gridRowR3.addChild(gridItemR3);
	
	var gridItemSpace:GridItem = new GridItem();
	gridItemSpace.width = 50;
	
	gridL.addChild(gridRowL);
	gridL.addChild(gridRowL2);
	
	gridR.addChild(gridRowR);
	gridR.addChild(gridRowR2);
	gridR.addChild(gridRowR3);
	
	gridItemGL.addChild(gridL);
	gridItemGR.addChild(gridR);
	gridRowG.addChild(gridItemGL);
	gridRowG.addChild(gridItemSpace);
	gridRowG.addChild(gridItemGR);
	gridG.addChild(gridRowG);	
	
	formCond.addChild(gridG);
	index.ws1.addChild(formCond);
	index.ws1.label = "Condition Informations";
	index.ws1.height = 500;
	index.ws1.visible = true;
	
	
//	if (configXML.USER == "Consulte")
//	{
//		genComInputOD.editable = false;
//		
//		CDList.editable = false;
//		ODList.editable = false;
//		
//		attachButPic1.visible = false;
//		attachButPic2.visible = false;
//		attachButPic3.visible = false;
//		attachButPic4.visible = false;
//		attachButPic5.visible = false;
//		attachButOD.visible = false;
//	}
	
	
	function saveInfoCondEditedHandler(ev:FlexEvent):void
	{
		saveInfoCondEdited(ev, event, k);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			cond.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerCond_editsStarted);
		}
	}// fin de saveInfoEditedHandler
	
	function editAttachFeaturesHandler(ev:MouseEvent):void
	{
		switch (ev.currentTarget.name){
			case "editAttachDP":
				isDescription = true;
				isSketches = false;
				isAttach = false;
				isPlan = false;
				break;
			case "editAttachSP":
				isDescription = false;
				isSketches = true;
				isAttach = false;
				isPlan = false;
				break;
			case "editAttachOD":
				isDescription = false;
				isSketches = false;
				isAttach = true;
				isPlan = false;
				break;
			case "attachButPic1":
				isDescription = false;
				isSketches = false;
				isAttach = false;
				isPlan = true;
				break;
		}		
		
		
		tooltipMaker();
		if(!attachmentInspector.visible){attachmentInspector.setVisible(true);}
		editAttachFeatures();
	}
	function addAttachmentComplete(ev:AttachmentEvent):void
	{
//		if (attachCond)
//		{
//			switch (ev.type)
//			{
//				//				case "queryAttachmentInfosComplete":
//				//					tooltipMaker();
//				//					editAttachFeatures();
//				//					break;
//				case "addAttachmentComplete":
//					tooltipMaker();
//					addAttachCondInfo(event,k,ev.featureEditResult.attachmentId.toString());
//					break;
//				case "deleteAttachmentsComplete":
//					tooltipMaker();
//					deleteAttachCondInfo(event,k,ev.featureEditResults[0].attachmentId);
//					break;
//			}
//		}
	}
	function tooltipMaker():void
	{
		if (isInAttach)
		{
			if (isDescription){setTooltip("Description");}
			else if (isSketches){setTooltip("Sketches");}
			else if (isAttach){setTooltip("Other Damages");}
			else if (isPlan){setTooltip("Plan");}
		} else {setTooltipEmpty();}
	}
	
	function setTooltip(cond:String):void
	{
		var info:String = "";
		for (var i:int=0; i<(attachArray.length-1);i++)
		{
			if (attachArray[i][3] == cond)
			{
				info = info+attachArray[i][2]+";";
			}
		}
		if (attachArray[(attachArray.length-1)][3] == cond)
		{
			info = info+attachArray[(attachArray.length-1)][2];
		}
		attachmentInspector.toolTip = info;
	}
	
	function setTooltipEmpty():void
	{
		attachmentInspector.toolTip = "empty";
	}
	
	function onCbChangeCondHandler(ev:ListEvent):void
	{
		onCbConditionChange(ev, event, k);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			cond.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerCond_editsStarted); 
		}	
	}
	
	function myFeatureLayerCond_editsStarted(ev:FeatureLayerEvent):void
	{
		cond.removeEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerCond_editsStarted);
		cond.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayerCond_updateEditsComplete);
		
		genComInputOD.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoCondEditedHandler);
		
		CDList.removeEventListener(ListEvent.CHANGE, onCbChangeCondHandler);
		ODList.removeEventListener(ListEvent.CHANGE, onCbChangeCondHandler);
		
	}// fin de myFeatureLayer_editsStarted
	
	function featLayerCond_updateEditsComplete(ev:FeatureLayerEvent):void
	{
		cond.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayerCond_updateEditsComplete);
		if(!clickToAdd && !clickToMove  && !coordToMove) //Cas où l'on update un élément sans le bouger
		{
			if(ev.featureEditResults.updateResults.length > 0)
			{
				var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
				toastMessage.imageSource = "assets/images/save.png";
				toastMessage.sampleCaption = "Updated Test";
				toastMessage.timeToLive = 2;
				index.simpleToaster.toast(toastMessage);
				
				cond.clearSelection();
				cond.refresh();
				
				cond.addEventListener(LayerEvent.UPDATE_END, featLayer_updateEndHandler); 
				
				function featLayer_updateEndHandler(evt:LayerEvent):void
				{
							
//					cond.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler)
					addInfoWindListener();
//					cond.removeEventListener(LayerEvent.UPDATE_END, featLayer_updateEndHandler); 
				}
			}
			else if(ev.featureEditResults.deleteResults.length > 0)
			{
				map.infoWindow.hide();
				cond.clearSelection();
				cond.refresh();
				var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
				toastMessage.imageSource = "assets/images/trash.png";
				toastMessage.sampleCaption = "Borehole deleted";
				toastMessage.timeToLive = 2;
				index.simpleToaster.toast(toastMessage);
				cond.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler);
				index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
	}// fin de featLayer_updateEditsComplete
	
	function addInfoWindListener():void
	{
		genComInputOD.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoCondEditedHandler);
		
		CDList.addEventListener(ListEvent.CHANGE, onCbChangeCondHandler);
		ODList.addEventListener(ListEvent.CHANGE, onCbChangeCondHandler);
		
		map.infoWindow.addEventListener(flash.events.Event.CLOSE, infoWindowCloseButtonClickHandler);
		
	}// fin de addInfoWindListener
	
	
	
}

private function getCondDomainValue():void
{
	var returnValue:String = "";
	var fld:Object;
	var rDomain:RangeDomain;
	var max:Number;
	var min:Number;
	var cVal:CodedValue;
	var cDomain:CodedValueDomain;
	for each (fld in cond.layerDetails.fields)
	{
		switch (fld.name)
		{
			case "Categ_Damage":
				rDomain = fld.domain;
				max = rDomain.maxValue;
				min = rDomain.minValue;
				qResultsCD = [];
				qResultsCD.push(" ");
				for (var i:Number = min; i<=max; i++)
				{
					qResultsCD.push(i);
				}
				break;
			case "Other_Damage":
				cDomain = fld.domain;
				qResultsOD = [];
				qResultsOD.push(" ");
				for each (cVal in cDomain.codedValues)
			{
				qResultsOD.push(cVal.name);
			}
				break;
		}
		
	}
}



