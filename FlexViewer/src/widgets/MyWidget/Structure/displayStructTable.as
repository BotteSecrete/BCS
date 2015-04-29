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
	setCondArray(k,event);
	setAttachArray(k,event);
//	setBatiArray(k,event);
	getStructDomainValue();
	
	attachGen = false;
	attachStruct = true;
	attachCond = false;
	
	var formStruct:Form = new Form();
	formStruct.id = "formStruct";
	
	var gridG:Grid = new Grid();
	gridG.name = "gridG";
	
	var gridRowG:GridRow = new GridRow();
	var gridItemGL:GridItem = new GridItem(); var gridItemGR:GridItem = new GridItem();
	
	var gridL:Grid = new Grid();
	gridL.name = "gridL";
	var gridRowL:GridRow = new GridRow();var gridRowL2:GridRow = new GridRow();var gridRowL3:GridRow = new GridRow();var gridRowL4:GridRow = new GridRow();
	var gridItemL:GridItem = new GridItem();var gridItemL2:GridItem = new GridItem();var gridItemL3:GridItem = new GridItem();var gridItemL4:GridItem = new GridItem();
	
	var gridR:Grid = new Grid();
	gridR.name = "gridR";
	var gridRowR:GridRow = new GridRow();var gridRowR2:GridRow = new GridRow();var gridRowR3:GridRow = new GridRow();var gridRowR4:GridRow = new GridRow();
	var gridItemR:GridItem = new GridItem();var gridItemR2:GridItem = new GridItem();var gridItemR3:GridItem = new GridItem();var gridItemR4:GridItem = new GridItem();
	
	var gridVH:Grid = new Grid();
	gridVH.name = "gridVH";
	
	var gridRowVHT:GridRow = new GridRow();
	var gridRowVH1:GridRow = new GridRow();
	var gridRowVH2:GridRow = new GridRow();
	var gridRowVH3:GridRow = new GridRow();
	var gridRowVH4:GridRow = new GridRow();
	var gridRowVH5:GridRow = new GridRow();
	var gridRowVH6:GridRow = new GridRow();
	var gridRowVH7:GridRow = new GridRow();
	
	var gridItemVT:GridItem = new GridItem();var gridItemHT:GridItem = new GridItem();var gridItemGT:GridItem = new GridItem();
	var gridItemV1:GridItem = new GridItem();var gridItemLV1:GridItem = new GridItem();var gridItemH1:GridItem = new GridItem();var gridItemLH1:GridItem = new GridItem();
	var gridItemV2:GridItem = new GridItem();var gridItemLV2:GridItem = new GridItem();var gridItemH2:GridItem = new GridItem();var gridItemLH2:GridItem = new GridItem();
	var gridItemV3:GridItem = new GridItem();var gridItemLV3:GridItem = new GridItem();var gridItemH3:GridItem = new GridItem();var gridItemLH3:GridItem = new GridItem();
	var gridItemV4:GridItem = new GridItem();var gridItemLV4:GridItem = new GridItem();var gridItemH4:GridItem = new GridItem();var gridItemLH4:GridItem = new GridItem();
	var gridItemV5:GridItem = new GridItem();var gridItemLV5:GridItem = new GridItem();var gridItemH5:GridItem = new GridItem();var gridItemLH5:GridItem = new GridItem();
	var gridItemV6:GridItem = new GridItem();var gridItemLV6:GridItem = new GridItem();var gridItemH6:GridItem = new GridItem();var gridItemLH6:GridItem = new GridItem();
	var gridItemV7:GridItem = new GridItem();var gridItemLV7:GridItem = new GridItem();var gridItemH7:GridItem = new GridItem();var gridItemLH7:GridItem = new GridItem();
	
	
	
	var HTLabel:mx.controls.Label = new mx.controls.Label();
	HTLabel.text = "Horizontal bearing structure ";
	gridItemHT.addChild(HTLabel);
	var gapLabel:mx.controls.Label = new mx.controls.Label();
	gapLabel.text = " ";
	gridItemGT.addChild(gapLabel);
	var VTLabel:mx.controls.Label = new mx.controls.Label();
	VTLabel.text = "Vertical bearing structure ";
	gridItemVT.addChild(VTLabel);
	gridRowVHT.addChild(gridItemVT);gridRowVHT.addChild(gridItemGT);gridRowVHT.addChild(gridItemHT);
	
	var LabelV1:mx.controls.Label = new mx.controls.Label();
	LabelV1.text = "Reinforced concrete ";
	var VCheck1:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck1.name = "Reinforced concrete";
	VCheck1.selected = structArray[1] == "Reinforced concrete"? true : false;
	VCheck1.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV1.addChild(LabelV1);
	gridItemV1.addChild(VCheck1);
	
	var LabelV2:mx.controls.Label = new mx.controls.Label();
	LabelV2.text = "Steel frame ";
	var VCheck2:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck2.name = "Steel frame";
	VCheck2.selected = structArray[1] == "Steel frame"? true : false;
	VCheck2.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV2.addChild(LabelV2);
	gridItemV2.addChild(VCheck2);
	
	var LabelV3:mx.controls.Label = new mx.controls.Label();
	LabelV3.text = "Masonry (block or stone)";
	var VCheck3:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck3.name = "Masonry (block or stone)";
	VCheck3.selected = structArray[1] == "Masonry (block or stone)"? true : false;
	VCheck3.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV3.addChild(LabelV3);
	gridItemV3.addChild(VCheck3);
	
	var LabelV4:mx.controls.Label = new mx.controls.Label();
	LabelV4.text = "Brick";
	var VCheck4:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck4.name = "Brick";
	VCheck4.selected = structArray[1] == "Brick"? true : false;
	VCheck4.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV4.addChild(LabelV4);
	gridItemV4.addChild(VCheck4);
	
	var LabelV5:mx.controls.Label = new mx.controls.Label();
	LabelV5.text = "Wood";
	var VCheck5:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck5.name = "Wood";
	VCheck5.selected = structArray[1] == "Wood"? true : false;
	VCheck5.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV5.addChild(LabelV5);
	gridItemV5.addChild(VCheck5);
	
	var LabelV6:mx.controls.Label = new mx.controls.Label();
	LabelV6.text = "Mixed ";
	var VCheck6:spark.components.CheckBox = new spark.components.CheckBox();
	VCheck6.name = "Mixed";
	VCheck6.selected = structArray[1] == "Mixed"? true : false;
	VCheck6.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
	gridItemLV6.addChild(LabelV6);
	gridItemV6.addChild(VCheck6);
	
	anyoneSelectedV();
	
	var LabelV7:mx.controls.Label = new mx.controls.Label();
	LabelV7.text = "Comments";
	var gridItemV7:GridItem = new GridItem();
	var genComInput:spark.components.TextArea = new spark.components.TextArea();
	
	genComInput.setStyle('color', 0x000000);
		if (structArray[3] == null)//VB_Descr
		{
			genComInput.text = "";
		}
		else
		{
			genComInput.text = structArray[3];
		}
	gridItemV7.colSpan = (1);
	genComInput.name = "genComInput";
	genComInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genComInput.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
	genComInput.width = 125;
	//genComInput.percentWidth = 100;
	genComInput.height = 40;
	gridItemLV7.addChild(LabelV7);gridItemLV7.visible = VCheck6.selected? true : false;
	gridItemV7.addChild(genComInput);gridItemV7.visible = VCheck6.selected? true : false;
	
	var LabelH1:mx.controls.Label = new mx.controls.Label();
	LabelH1.text = "Reinforced concrete ";
	var HCheck1:spark.components.CheckBox = new spark.components.CheckBox();
	HCheck1.name = "Reinforced concrete";
	HCheck1.selected = structArray[4] == "Reinforced concrete"? true : false;
	HCheck1.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
	gridItemLH1.addChild(LabelH1);
	gridItemH1.addChild(HCheck1);
	
	var LabelH2:mx.controls.Label = new mx.controls.Label();
	LabelH2.text = "Steel frame ";
	var HCheck2:spark.components.CheckBox = new spark.components.CheckBox();
	HCheck2.name = "Steel frame";
	HCheck2.selected = structArray[4] == "Steel frame"? true : false;
	HCheck2.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
	gridItemLH2.addChild(LabelH2);
	gridItemH2.addChild(HCheck2);
	
	var LabelH3:mx.controls.Label = new mx.controls.Label();
	LabelH3.text = "Masonry (block or stone)";
	var HCheck3:spark.components.CheckBox = new spark.components.CheckBox();
	HCheck3.name = "Masonry (block or stone)";
	HCheck3.selected = structArray[4] == "Masonry (block or stone)"? true : false;
	HCheck3.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
	gridItemLH3.addChild(LabelH3);
	gridItemH3.addChild(HCheck3);
	
	var LabelH4:mx.controls.Label = new mx.controls.Label();
	LabelH4.text = "Brick";
	var HCheck4:spark.components.CheckBox = new spark.components.CheckBox();
	HCheck4.name = "Brick";
	HCheck4.selected = structArray[4] == "Brick"? true : false;
	HCheck4.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
	gridItemLH4.addChild(LabelH4);
	gridItemH4.addChild(HCheck4);
	
	var LabelH5:mx.controls.Label = new mx.controls.Label();
	LabelH5.text = "Wood";
	var HCheck5:spark.components.CheckBox = new spark.components.CheckBox();
	HCheck5.name = "Wood";
	HCheck5.selected = structArray[4] == "Wood"? true : false;
	HCheck5.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
	gridItemLH5.addChild(LabelH5);
	gridItemH5.addChild(HCheck5);
	
	var LabelH6:mx.controls.Label = new mx.controls.Label();
	LabelH6.text = "Mixed ";
	var HCheck6:spark.components.CheckBox = new spark.components.CheckBox();
	HCheck6.name = "Mixed";
	HCheck6.selected = structArray[4] == "Mixed"? true : false;
	HCheck6.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
	gridItemLH6.addChild(LabelH6);
	gridItemH6.addChild(HCheck6);
	
	anyoneSelectedH();
	
	var LabelH7:mx.controls.Label = new mx.controls.Label();
	LabelH7.text = "Comments :";
	var gridItemH7:GridItem = new GridItem();
	var genComInputH:spark.components.TextArea = new spark.components.TextArea();
	
	genComInputH.setStyle('color', 0x000000);
		if (structArray[5] == null) //HB_Descr
		{
			genComInputH.text = "";
		}
		else
		{
			genComInputH.text = structArray[5];
		}
	gridItemH7.colSpan = (1);
	genComInputH.name = "genComInputH";
	genComInputH.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genComInputH.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
	genComInputH.width = 125;
	//genComInputH.percentWidth = 100;
	genComInputH.height = 40;
	gridItemLH7.addChild(LabelH7);gridItemLH7.visible = HCheck6.selected ? true : false;
	gridItemH7.addChild(genComInputH);gridItemH7.visible = HCheck6.selected ? true : false;
	
	gridRowVH1.addChild(gridItemLV1);gridRowVH1.addChild(gridItemV1);gridRowVH1.addChild(gridItemLH1);gridRowVH1.addChild(gridItemH1);
	gridRowVH2.addChild(gridItemLV2);gridRowVH2.addChild(gridItemV2);gridRowVH2.addChild(gridItemLH2);gridRowVH2.addChild(gridItemH2);
	gridRowVH3.addChild(gridItemLV3);gridRowVH3.addChild(gridItemV3);gridRowVH3.addChild(gridItemLH3);gridRowVH3.addChild(gridItemH3);
	gridRowVH4.addChild(gridItemLV4);gridRowVH4.addChild(gridItemV4);gridRowVH4.addChild(gridItemLH4);gridRowVH4.addChild(gridItemH4);
	gridRowVH5.addChild(gridItemLV5);gridRowVH5.addChild(gridItemV5);gridRowVH5.addChild(gridItemLH5);gridRowVH5.addChild(gridItemH5);
	gridRowVH6.addChild(gridItemLV6);gridRowVH6.addChild(gridItemV6);gridRowVH6.addChild(gridItemLH6);gridRowVH6.addChild(gridItemH6);
	gridRowVH7.addChild(gridItemLV7);gridRowVH7.addChild(gridItemV7);gridRowVH7.addChild(gridItemLH7);gridRowVH7.addChild(gridItemH7);
	
	gridVH.addChild(gridRowVHT);gridVH.addChild(gridRowVH1);gridVH.addChild(gridRowVH2);gridVH.addChild(gridRowVH3);
	gridVH.addChild(gridRowVH4);gridVH.addChild(gridRowVH5);gridVH.addChild(gridRowVH6);gridVH.addChild(gridRowVH7);
	
	gridItemL.addChild(gridVH);
	gridRowL.addChild(gridItemL);
	
	var hBoxRoof:HBox = new HBox();
//	var gridItemLRT3:GridItem = new GridItem();
	var roofLabel:mx.controls.Label = new mx.controls.Label();
	roofLabel.text = "Roof type :";
	var roofList:mx.controls.ComboBox = new mx.controls.ComboBox();
	roofList.setStyle('color', 0x000000);
		roofList.dataProvider = qResultsRT;				
		if (structArray[11] != null)
		{
			roofList.selectedIndex = 0;
			var len:int = qResultsRT.length;
			for (var j:int = 0; j < len; j++) 
			{
				if (roofList.dataProvider[j] == structArray[11]) 
				{
					roofList.selectedIndex = j;
					break;
				}
			}
		}
		else
		{
			roofList.selectedIndex = 0;
		}
	roofList.name = "roofList";
	roofList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	hBoxRoof.addChild(roofLabel);hBoxRoof.addChild(roofList);
	gridItemL2.addChild(hBoxRoof);gridRowL2.addChild(gridItemL2);
	
	var gridItemRT4:GridItem = new GridItem();
	var hBoxComents:HBox = new HBox();
	var comentsLabel:mx.controls.Label = new mx.controls.Label();
	comentsLabel.text = "Comments :";
	comentsLabel.visible = false;
	var genComInputRT:spark.components.TextArea = new spark.components.TextArea();
	genComInputRT.setStyle('color', 0x000000);
		if (structArray[12] == null)
		{
			genComInputRT.text = "";
		}
		else
		{
			genComInputRT.text = structArray[12];
		}
	//gridItemRT4.colSpan = (1);
	genComInputRT.name = "genComInputRT";
	genComInputRT.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genComInputRT.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
	//genComInputRT.width = 100;
	genComInputRT.percentWidth = 100;
	genComInputRT.height = 30;
//	genComInputRT.visible = false;
	genComInputRT.visible = roofList.selectedItem == "Other"? true : false;
	comentsLabel.visible = roofList.selectedItem == "Other"? true : false;
	hBoxComents.addChild(comentsLabel);hBoxComents.addChild(genComInputRT);
	gridItemRT4.addChild(hBoxComents);gridRowL3.addChild(gridItemRT4);
	
	
	var hBoxSource:HBox = new HBox();
	var LabelSource:mx.controls.Label = new mx.controls.Label();
	LabelSource.text = "Source :";
	var sourceList:mx.controls.ComboBox = new mx.controls.ComboBox();
	sourceList.setStyle('color', 0x000000);
	sourceList.dataProvider = qResultsSI;				
	if (structArray[13] != null)
	{
		sourceList.selectedIndex = 0;
		var len:int = qResultsSI.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (sourceList.dataProvider[j] == structArray[13]) 
			{
				sourceList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		sourceList.selectedIndex = 0;
	}
	sourceList.name = "sourceList";
	sourceList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	var genSourceInput:spark.components.TextArea = new spark.components.TextArea();
	
	genSourceInput.setStyle('color', 0x000000);
		if (structArray[14] == null)
		{
			genSourceInput.text = "";
		}
		else
		{
			genSourceInput.text = structArray[14];
		}
	genSourceInput.name = "genSourceInput";
	genSourceInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genSourceInput.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
	//genComInputRT.width = 100;
	genSourceInput.percentWidth = 100;
	genSourceInput.height = 30;
	genSourceInput.visible = sourceList.selectedItem == "Other" ? true : false;
	
	hBoxSource.addChild(LabelSource);hBoxSource.addChild(sourceList);hBoxSource.addChild(genSourceInput);
	gridItemL4.addChild(hBoxSource);
	gridRowL4.addChild(gridItemL4);
	
	
	var LabelTF:mx.controls.Label = new mx.controls.Label();
	LabelTF.text = "Type of fundation and soil reinforcement : ";
	gridItemR.addChild(LabelTF);
	gridRowR.addChild(gridItemR);
	
	var vBoxTF:VBox = new VBox();
	var hBoxLL:HBox = new HBox();
	
	var LabelTF:mx.controls.Label = new mx.controls.Label();
	LabelTF.text = "Type of foundation :";
	
	var LabelSR:mx.controls.Label = new mx.controls.Label();
	LabelSR.text = "Soil reinforcement :";
	
	var TFList:mx.controls.ComboBox = new mx.controls.ComboBox();
	TFList.setStyle('color', 0x000000);
	TFList.dataProvider = qResultsTF;
	if (structArray[6] != null)
	{
		TFList.selectedIndex = 0;
		var len:int = qResultsTF.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (TFList.dataProvider[j] == structArray[6]) 
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
	
	var SRList:mx.controls.ComboBox = new mx.controls.ComboBox();
	SRList.setStyle('color', 0x000000);
	SRList.dataProvider = qResultsSR;				
	if (structArray[7] != null)
	{
		SRList.selectedIndex = 0;
		var len:int = qResultsSR.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (SRList.dataProvider[j] == structArray[7]) 
			{
				SRList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		SRList.selectedIndex = 0;
	}
	SRList.name = "SRList";
	SRList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	hBoxLL.addChild(LabelTF);hBoxLL.addChild(TFList);hBoxLL.addChild(LabelSR);hBoxLL.addChild(SRList);
	
	var hBoxTF:HBox = new HBox();
	var TFLabel:mx.controls.Label = new mx.controls.Label();
	TFLabel.text = "Comments :";
	var genTFInput:spark.components.TextArea = new spark.components.TextArea();
	
	genTFInput.setStyle('color', 0x000000);
		if (structArray[8] == null)
		{
			genTFInput.text = "";
		}
		else
		{
			genTFInput.text = structArray[8];
		}
	genTFInput.name = "genTFInput";
	genTFInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genTFInput.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
	genTFInput.width = 400;
//	genTFInput.percentWidth = 200;
	genTFInput.height = 30;
	genTFInput.editable = true;
	hBoxTF.addChild(TFLabel);hBoxTF.addChild(genTFInput);
	
	vBoxTF.addChild(hBoxLL);vBoxTF.addChild(hBoxTF); //vBoxTF.addChild(genTFInput);
	
	gridItemR2.addChild(vBoxTF);//gridItemR2.
	gridRowR2.addChild(gridItemR2);
	
	var LabelFMD:mx.controls.Label = new mx.controls.Label();
	LabelFMD.text = "Fundation's material and depth : ";
	gridItemR3.addChild(LabelFMD);
	gridRowR3.addChild(gridItemR3);
	
	
	var hBoxFD1:HBox = new HBox();var hBoxFD2:HBox = new HBox();var hBoxFD3:HBox = new HBox();
	var vBoxFD:VBox = new VBox();
	
	var LabelFM:mx.controls.Label = new mx.controls.Label();
	LabelFM.text = "Fundation's material :";
	var LabelFM2:mx.controls.Label = new mx.controls.Label();
	LabelFM2.text = "Fundation's material :";
	
	var LabelFD:mx.controls.Label = new mx.controls.Label();
	LabelFD.text = "Depth";
	
	var TFList2:mx.controls.ComboBox = new mx.controls.ComboBox();
	TFList2.setStyle('color', 0x000000);
//	TFList2.dataProvider = qResultsFM;	
	TFList2.dataProvider = TFList.selectedItem == "Shallow" ? qResultsFMS : qResultsFM;	
	if (structArray[9] != null)
	{
		TFList2.selectedIndex = 0;
		var len:int = qResultsFM.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (TFList2.dataProvider[j] == structArray[9]) 
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
	
	var attachButDepth:Button = new Button();
	attachButDepth.name = "editAttach";
	attachButDepth.label = "Fundation Depth Attachments";
	attachButDepth.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	
	var TFList3:mx.controls.ComboBox = new mx.controls.ComboBox();
	TFList3.setStyle('color', 0x000000);
//		TFList3.dataProvider = qResultsFM;
		TFList3.dataProvider = TFList.selectedItem == "Deep" ? qResultsFMD : qResultsFM;	
		if (structArray[9] != null)
		{
			TFList3.selectedIndex = 0;
			var len:int = qResultsFM.length;
			for (var j:int = 0; j < len; j++) 
			{
				if (TFList3.dataProvider[j] == structArray[9]) 
				{
					TFList3.selectedIndex = j;
					break;
				}
			}
		}
		else
		{
			TFList3.selectedIndex = 0;
		}
	TFList3.name = "TFList3";
	TFList3.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	
	var DpthList:mx.controls.ComboBox = new mx.controls.ComboBox();
	DpthList.setStyle('color', 0x000000);
	DpthList.dataProvider = qResultsDR;				
		if (structArray[15] != null)
		{
			DpthList.selectedIndex = 0;
			var len:int = qResultsDR.length;
			for (var j:int = 0; j < len; j++) 
			{
				if (DpthList.dataProvider[j] == structArray[15]) 
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
	
	var labelCom:mx.controls.Label = new mx.controls.Label();
	labelCom.text = "Comments :";
	var genComInputFD:spark.components.TextArea = new spark.components.TextArea();
	
	genComInputFD.setStyle('color', 0x000000);
		if (structArray[10] == null)
		{
			genComInputFD.text = "";
		}
		else
		{
			genComInputFD.text = structArray[10];
		}
	genComInputFD.name = "genComInputFD";
	genComInputFD.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genComInputFD.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
	//genComInputFD.width = 100;
	genComInputFD.percentWidth = 100;
	genComInputFD.height = 30;
	
	hBoxFD1.addChild(LabelFM);hBoxFD1.addChild(TFList2);hBoxFD1.addChild(attachButDepth);hBoxFD1.visible = TFList.selectedItem == "Shallow"? true : false;
	hBoxFD2.addChild(LabelFM2);hBoxFD2.addChild(TFList3);hBoxFD2.addChild(LabelFD);hBoxFD2.addChild(DpthList); hBoxFD2.visible = TFList.selectedItem == "Deep" ? true : false;
	hBoxFD3.addChild(labelCom);hBoxFD3.addChild(genComInputFD); hBoxFD3.visible = DpthList.selectedItem == "Other" ? true : false;;
	
	vBoxFD.addChild(hBoxFD1);vBoxFD.addChild(hBoxFD2);vBoxFD.addChild(hBoxFD3);
	
	gridItemR4.addChild(vBoxFD);gridRowR4.addChild(gridItemR4);
	
	var gridItemSpace:GridItem = new GridItem();
	
	gridL.addChild(gridRowL);
	gridL.addChild(gridRowL2);
	gridL.addChild(gridRowL3);
	gridL.addChild(gridRowL4);
	
	gridR.addChild(gridRowR);
	gridR.addChild(gridRowR2);
	gridR.addChild(gridRowR3);
	gridR.addChild(gridRowR4);
	
	gridItemGL.addChild(gridL);
	gridItemGR.addChild(gridR);
	gridRowG.addChild(gridItemGL);
	gridRowG.addChild(gridItemSpace);
	gridRowG.addChild(gridItemGR);
	gridG.addChild(gridRowG);	
	
	formStruct.addChild(gridG);
	index.ws1.addChild(formStruct);
	index.ws1.label = "Structure Informations";
	index.ws1.height = 650;
	index.ws1.visible = true;
	
//	function addAllListener():void
//	{
//		geol.addEventListener(FeatureLayerEvent.EDITS_STARTING,geolEditsStarted);
//		
//		dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);
//		
//		dataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgItemEditEnd);
//		
//		addRowToTableBut.addEventListener(MouseEvent.CLICK,addRowToTableHandler);
//		addRowToTableBut.enabled = true;
//		delRowFromTableBut.addEventListener(MouseEvent.CLICK,delRowFromTable);
//		delRowFromTableBut.enabled = true;
//	}
	
	if (statusValidated)
	{
		genComInput.editable = false;
		genComInputH.editable = false;
		genComInputRT.editable = false;
		genSourceInput.editable = false;
		genTFInput.editable = false;
		genComInputFD.editable = false;
		
		roofList.editable = false;
		sourceList.editable = false;
		TFList.editable = false;
		SRList.editable = false;
		TFList2.editable = false;
		TFList3.editable = false;
		DpthList.editable = false;
		
		roofList.enabled = false;
		sourceList.enabled = false;
		TFList.enabled = false;
		SRList.enabled = false;
		TFList2.enabled = false;
		TFList3.enabled = false;
		DpthList.enabled = false;
		
		VCheck1.enabled = false;
		VCheck2.enabled = false;
		VCheck3.enabled = false;
		VCheck4.enabled = false;
		VCheck5.enabled = false;
		VCheck6.enabled = false;
		
		HCheck1.enabled = false;
		HCheck2.enabled = false;
		HCheck3.enabled = false;
		HCheck4.enabled = false;
		HCheck5.enabled = false;
		HCheck6.enabled = false;
		
		attachButDepth.enabled = false;
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
				VCheck5.enabled = ev.target.selected? false : true;
				VCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.VB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.VB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Steel frame":
				VCheck1.enabled = ev.target.selected? false : true;
				VCheck3.enabled = ev.target.selected? false : true;
				VCheck4.enabled = ev.target.selected? false : true;
				VCheck5.enabled = ev.target.selected? false : true;
				VCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.VB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.VB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Masonry (block or stone)":
				VCheck2.enabled = ev.target.selected? false : true;
				VCheck1.enabled = ev.target.selected? false : true;
				VCheck4.enabled = ev.target.selected? false : true;
				VCheck5.enabled = ev.target.selected? false : true;
				VCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.VB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.VB = null;
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
				VCheck5.enabled = ev.target.selected? false : true;
				VCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.VB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.VB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Wood":
				VCheck2.enabled = ev.target.selected? false : true;
				VCheck3.enabled = ev.target.selected? false : true;
				VCheck4.enabled = ev.target.selected? false : true;
				VCheck1.enabled = ev.target.selected? false : true;
				VCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.VB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.VB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Mixed":
				VCheck2.enabled = ev.target.selected? false : true;
				VCheck3.enabled = ev.target.selected? false : true;
				VCheck4.enabled = ev.target.selected? false : true;
				VCheck5.enabled = ev.target.selected? false : true;
				VCheck1.enabled = ev.target.selected? false : true;
				gridItemLV7.visible = ev.target.selected? true : false;
				gridItemV7.visible = ev.target.selected? true : false;
				if(ev.target.selected)
				{
					attributes.VB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.VB = null;
					hasToSave = true;
				}
//				if(structArray[1] != ev.target.name)
//				{
//					attributes.VB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
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
	
	
	function changeStatusHHandler(ev:MouseEvent):void
	{
		var hasToSave:Boolean = false;
		var attributes:Object = {};
		attributes = isIn ? {OBJECTID:structArray[0]} : {IDBATI:event.features[k].attributes.OBJECTID};
		
		switch(ev.target.name)
		{
			case "Reinforced concrete":
				HCheck2.enabled = ev.target.selected? false : true;
				HCheck3.enabled = ev.target.selected? false : true;
				HCheck4.enabled = ev.target.selected? false : true;
				HCheck5.enabled = ev.target.selected? false : true;
				HCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.HB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.HB = null;
					hasToSave = true;
				}
//				if(structArray[4] != ev.target.name)
//				{
//					attributes.HB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Steel frame":
				HCheck1.enabled = ev.target.selected? false : true;
				HCheck3.enabled = ev.target.selected? false : true;
				HCheck4.enabled = ev.target.selected? false : true;
				HCheck5.enabled = ev.target.selected? false : true;
				HCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.HB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.HB = null;
					hasToSave = true;
				}
//				if(structArray[4] != ev.target.name)
//				{
//					attributes.HB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Masonry (block or stone)":
				HCheck2.enabled = ev.target.selected? false : true;
				HCheck1.enabled = ev.target.selected? false : true;
				HCheck4.enabled = ev.target.selected? false : true;
				HCheck5.enabled = ev.target.selected? false : true;
				HCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.HB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.HB = null;
					hasToSave = true;
				}
//				if(structArray[4] != ev.target.name)
//				{
//					attributes.HB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Brick":
				HCheck2.enabled = ev.target.selected? false : true;
				HCheck3.enabled = ev.target.selected? false : true;
				HCheck1.enabled = ev.target.selected? false : true;
				HCheck5.enabled = ev.target.selected? false : true;
				HCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.HB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.HB = null;
					hasToSave = true;
				}
//				if(structArray[4] != ev.target.name)
//				{
//					attributes.HB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Wood":
				HCheck2.enabled = ev.target.selected? false : true;
				HCheck3.enabled = ev.target.selected? false : true;
				HCheck4.enabled = ev.target.selected? false : true;
				HCheck1.enabled = ev.target.selected? false : true;
				HCheck6.enabled = ev.target.selected? false : true;
				if(ev.target.selected)
				{
					attributes.HB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.HB = null;
					hasToSave = true;
				}
//				if(structArray[4] != ev.target.name)
//				{
//					attributes.HB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
				break;
			case "Mixed":
				HCheck2.enabled = ev.target.selected? false : true;
				HCheck3.enabled = ev.target.selected? false : true;
				HCheck4.enabled = ev.target.selected? false : true;
				HCheck5.enabled = ev.target.selected? false : true;
				HCheck1.enabled = ev.target.selected? false : true;
				gridItemLH7.visible = ev.target.selected? true : false;
				gridItemH7.visible = ev.target.selected? true : false;
				if(ev.target.selected)
				{
					attributes.HB = ev.target.name;
					hasToSave = true;
				} else
				{
					attributes.HB = null;
					hasToSave = true;
				}
//				if(structArray[4] != ev.target.name)
//				{
//					attributes.HB = ev.target.selected ? ev.target.name : null;
//					hasToSave = true;
//				}
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
	
	function saveInfoStructEditedKeyHandler(ev:KeyboardEvent):void
	{
		
		if (ev.keyCode == 13)
		{
			var retChar:RegExp = /\n/;
			ev.currentTarget.text = ev.currentTarget.text.replace(retChar, "");
			saveInfoStructEditedKey(ev.currentTarget, event, k);
			if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
			{
				//struct.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerStruct_editsStarted);
			}
		}
	}
	
	function saveInfoEditedHandler(ev:FlexEvent):void
	{
		saveInfoStructEdited(ev, event, k);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			//struct.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerStruct_editsStarted);
		}
	}// fin de saveInfoEditedHandler
	
	
	function myFeatureLayerStruct_editsStarted(ev:FeatureLayerEvent):void
	{
		struct.removeEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayerStruct_editsStarted);
		struct.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayerStruct_updateEditsComplete);
		
		genComInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputH.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputRT.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genSourceInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genTFInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputFD.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		genComInput.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genComInputH.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genComInputRT.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genSourceInput.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genTFInput.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genComInputFD.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		
		roofList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		sourceList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		SRList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList2.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList3.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		DpthList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		
		VCheck1.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck2.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck3.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck4.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck5.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck6.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		
		HCheck1.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck2.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck3.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck4.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck5.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck6.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		
		attachButDepth.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
		
		
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
		genComInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputH.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputRT.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genSourceInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genTFInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputFD.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		genComInput.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genComInputH.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoStructEditedKeyHandler);
		genComInputRT.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoStructEditedKeyHandler);
		genSourceInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoStructEditedKeyHandler);
		genTFInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoStructEditedKeyHandler);
		genComInputFD.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoStructEditedKeyHandler);
		
		roofList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		sourceList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		SRList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList2.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList3.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		DpthList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		
		VCheck1.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck2.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck3.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck4.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck5.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck6.addEventListener(MouseEvent.CLICK, changeStatusVHandler);
		
		HCheck1.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck2.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck3.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck4.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck5.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck6.addEventListener(MouseEvent.CLICK, changeStatusHHandler);
		
		attachButDepth.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
		
		map.infoWindow.addEventListener(flash.events.Event.CLOSE, infoWindowCloseButtonClickHandler);
		
	}// fin de addInfoWindListener
	
	
	function editAttachFeaturesHandler(ev:MouseEvent):void
	{
		if(!attachFeat.willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
//			attachFeat.addEventListener(FeatureLayerEvent.EDITS_STARTING, myAttachFeatureLayer_editsStarted);
		}
		
		attachEventDispatch.removeAllEventListeners();
		
		attachEventDispatch.addEvtListener(attachmentInspector,AttachmentEvent.ADD_ATTACHMENT_COMPLETE,addAttachmentComplete);
		attachEventDispatch.addEvtListener(attachmentInspector,AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE,addAttachmentComplete);
		
//		if (attachmentInspector.willTrigger(AttachmentEvent.ADD_ATTACHMENT_COMPLETE))
//		{
//			attachmentInspector.removeEventListener(AttachmentEvent.ADD_ATTACHMENT_COMPLETE, addAttachmentComplete);
//			attachmentInspector.removeEventListener(AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE, addAttachmentComplete);
//		}
//		
//		attachmentInspector.addEventListener(AttachmentEvent.ADD_ATTACHMENT_COMPLETE, addAttachmentComplete);
//		attachmentInspector.addEventListener(AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE, addAttachmentComplete);
		
		tooltipMaker();
		editAttachFeatures();
	}
	
	function addAttachmentComplete(ev:AttachmentEvent):void
	{
		if (attachStruct)
		{
			switch (ev.type)
			{
//				case "queryAttachmentInfosComplete":
//					tooltipMaker();
//					editAttachFeatures();
//					break;
				case "addAttachmentComplete":
					tooltipMaker();
					addAttachStructInfo(event,k,ev.featureEditResult.attachmentId.toString());
					break;
				case "deleteAttachmentsComplete":
					tooltipMaker();
					deleteAttachStructInfo(event,k,ev.featureEditResults[0].attachmentId);
					break;
			}
		}
	}
	
	function tooltipMaker():void
	{
		var info:String = "";
		if (isInAttach)
		{
			for (var i:int=0; i<(attachArray.length-1);i++)
			{
				if (attachArray[i][3] == "FD Attachments")
				{
					info = info+attachArray[i][2]+";";
				}
			}
			if (attachArray[(attachArray.length-1)][3] == "FD Attachments")
			{
				info = info+attachArray[(attachArray.length-1)][2];
			}
		} else {info="empty";}
		attachmentInspector.toolTip = info;
	}
	
	function addAttachStructInfo(event:FeatureLayerEvent, k:Number,idpjs:String):void
	{
		var attributes:Object = {};
		attributes = {IDBATI:event.features[k].attributes.CODE.toString(),IDPJ:idpjs,THEME:"FD Attachments"};
		var feature:Graphic = new Graphic(null, null, attributes);
		var updates:Array = [ feature ];
		//		isInCond = true;
		attachFeat.applyEdits(updates,null,null);
		attachFeat.clearSelection();
		attachFeat.refresh();
		attachmentInspector.toolTip = attachmentInspector.toolTip=="empty"|| attachmentInspector.toolTip=="empty" ? idpjs : attachmentInspector.toolTip +";"+idpjs;
	}
	
	function deleteAttachStructInfo(event:FeatureLayerEvent, k:Number,idpjs:String):void
	{
		var idDelPj:String;
		for (var i:Number=0;i<attachArray.length;i++)
		{
			if (attachArray[i][2] == idpjs)
			{
				idDelPj = attachArray[i][0];
			}
		}
		
		var attributes:Object = {};
		attributes = {OBJECTID:idDelPj};
		
		var feature:Graphic = new Graphic(null, null, attributes);
		var updates:Array = [ feature ];
		//		isInCond = true;
		attachFeat.applyEdits(null,null,updates);
		attachFeat.clearSelection();
		attachFeat.refresh();
	}
	
	function myAttachFeatureLayer_editsStarted(ev:FeatureLayerEvent):void
	{
		attachFeat.removeEventListener(FeatureLayerEvent.EDITS_STARTING, myAttachFeatureLayer_editsStarted);
		attachFeat.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,attachFeatLayer_updateEditsComplete);
		genComInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputH.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputRT.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genSourceInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genTFInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genComInputFD.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		genComInput.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genComInputH.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genComInputRT.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genSourceInput.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genTFInput.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		genComInputFD.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoStructEditedKeyHandler);
		
		roofList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		sourceList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		SRList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList2.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		TFList3.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		DpthList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		
		VCheck1.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck2.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck3.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck4.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck5.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		VCheck6.removeEventListener(MouseEvent.CLICK, changeStatusVHandler);
		
		HCheck1.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck2.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck3.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck4.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck5.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		HCheck6.removeEventListener(MouseEvent.CLICK, changeStatusHHandler);
		
		attachButDepth.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	}// fin de myAttachFeatureLayer_editsStarted
	
	function attachFeatLayer_updateEditsComplete(ev:FeatureLayerEvent):void
	{
		attachFeat.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE,attachFeatLayer_updateEditsComplete);
		//		if(!clickToAdd && !clickToMove  && !coordToMove) //Cas où l'on update un élément sans le bouger
		//		{
		if(ev.featureEditResults.updateResults.length > 0)
		{
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/save.png";
			toastMessage.sampleCaption = "Updated Test";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
			
			attachFeat.clearSelection();
			attachFeat.refresh();
			
			attachFeat.addEventListener(LayerEvent.UPDATE_END, attachFeatLayer_updateEndHandler); 
			
			function attachFeatLayer_updateEndHandler(evt:LayerEvent):void
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
				event.features[k] = (!isNaN(ind))?attachFeat.graphicProvider[ind]:event.features[k];
				//				isNotFattachFeat = true;
				isAtt = true;
				attachFeat.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler)
				addInfoWindListener();
				attachFeat.removeEventListener(LayerEvent.UPDATE_END, attachFeatLayer_updateEndHandler); 
			}
		}
		else if(ev.featureEditResults.deleteResults.length > 0)
		{
			map.infoWindow.hide();
			attachFeat.clearSelection();
			attachFeat.refresh();
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/trash.png";
			toastMessage.sampleCaption = "Borehole deleted";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
			attachFeat.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler);
			index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
		}
		else
		{
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/save.png";
			toastMessage.sampleCaption = "Updated Test";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
			
			attachFeat.clearSelection();
			attachFeat.refresh();
			
			attachFeat.addEventListener(LayerEvent.UPDATE_END, attachFeatLayer_addEndHandler); 
			
			function attachFeatLayer_addEndHandler(evt:LayerEvent):void
			{
				//				isNotFattachFeat = true;
				isAtt = true;
				attachFeat.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE, myFeatureLayer_selectionCompleteHandler)
				addInfoWindListener();
				attachFeat.removeEventListener(LayerEvent.UPDATE_END, attachFeatLayer_addEndHandler); 
			}
		}
		//		}
		
	}// fin de attachFeatLayer_updateEditsComplete
	
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
			case "SRList":
				if(structArray[7] != ev.target.selectedLabel)
				{
					attributes.SoilR = ev.target.selectedLabel;
					hasToSave = true;
				}
				break;
			case "roofList":
				if(!isIn || structArray[11] != ev.target.selectedLabel)
				{
					attributes.RoofT = ev.target.selectedLabel;
					hasToSave = true;
				}
				if (ev.target.selectedLabel == "Other") {genComInputRT.visible = true; comentsLabel.visible = true;} 
				else {genComInputRT.visible = false;comentsLabel.visible = false;}
				break;
			
			case "sourceList":
				if(!isIn || structArray[13] != ev.target.selectedLabel)
				{
					attributes.SourceInf = ev.target.selectedLabel;
					hasToSave = true;
				}
				if (ev.target.selectedLabel == "Other"){genSourceInput.visible = true;} else {genSourceInput.visible = false;}
				break;
			
			case "TFList":
				if(!isIn || structArray[6] != ev.target.selectedLabel)
				{
					attributes.TypeF = ev.target.selectedLabel;
					hasToSave = true;
				}
				if (TFList.selectedItem == "Shallow")
				{
					TFList2.dataProvider = qResultsFMS;
					hBoxFD1.visible = true;
					hBoxFD2.visible = false;
					hBoxFD3.visible = false;
					hasToSave = true;
					
				} else if (TFList.selectedItem == "Deep")
				{
					TFList3.dataProvider = qResultsFMD;
					hBoxFD2.visible = true;
					hBoxFD1.visible = false;
					hBoxFD3.visible = false;
				} else 
				{
					hBoxFD1.visible = false;
					hBoxFD2.visible = false;
					hBoxFD3.visible = false;
				}
				
				break;
			
			case "TFList2":
				if(!isIn || structArray[9] != ev.target.selectedLabel)
				{
					attributes.FM = ev.target.selectedLabel;
					hasToSave = true;
				}
				if (TFList2.selectedItem == "Other"){hBoxFD3.visible = true;} else {hBoxFD3.visible = false;}
				break;
			
			case "TFList3":
				if(!isIn || structArray[9] != ev.target.selectedLabel)
				{
					attributes.FM = ev.target.selectedLabel;
					hasToSave = true;
				}
				if (TFList3.selectedItem == "Other"){hBoxFD3.visible = true;}  else {hBoxFD3.visible = false;}
				break;
			
			case "DpthList":
				if(!isIn || structArray[15] != ev.target.selectedLabel)
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
			VCheck5.enabled = false;
			VCheck6.enabled = false;
		} else if (VCheck2.selected)
		{
			VCheck1.enabled = false;
			VCheck3.enabled = false;
			VCheck4.enabled = false;
			VCheck5.enabled = false;
			VCheck6.enabled = false;
		} else if (VCheck3.selected)
		{
			VCheck1.enabled = false;
			VCheck2.enabled = false;
			VCheck4.enabled = false;
			VCheck5.enabled = false;
			VCheck6.enabled = false;
		} else if (VCheck4.selected)
		{
			VCheck1.enabled = false;
			VCheck3.enabled = false;
			VCheck2.enabled = false;
			VCheck5.enabled = false;
			VCheck6.enabled = false;
		} else if (VCheck5.selected)
		{
			VCheck1.enabled = false;
			VCheck3.enabled = false;
			VCheck4.enabled = false;
			VCheck2.enabled = false;
			VCheck6.enabled = false;
		} else if (VCheck6.selected)
		{
			VCheck1.enabled = false;
			VCheck3.enabled = false;
			VCheck4.enabled = false;
			VCheck5.enabled = false;
			VCheck2.enabled = false;
		}
	}
	
	function anyoneSelectedH()
	{
		if (HCheck1.selected){
			HCheck2.enabled = false;
			HCheck3.enabled = false;
			HCheck4.enabled = false;
			HCheck5.enabled = false;
			HCheck6.enabled = false;
		} else if (HCheck2.selected)
		{
			HCheck1.enabled = false;
			HCheck3.enabled = false;
			HCheck4.enabled = false;
			HCheck5.enabled = false;
			HCheck6.enabled = false;
		} else if (HCheck3.selected)
		{
			HCheck1.enabled = false;
			HCheck2.enabled = false;
			HCheck4.enabled = false;
			HCheck5.enabled = false;
			HCheck6.enabled = false;
		} else if (HCheck4.selected)
		{
			HCheck1.enabled = false;
			HCheck3.enabled = false;
			HCheck2.enabled = false;
			HCheck5.enabled = false;
			HCheck6.enabled = false;
		} else if (HCheck5.selected)
		{
			HCheck1.enabled = false;
			HCheck3.enabled = false;
			HCheck4.enabled = false;
			HCheck2.enabled = false;
			HCheck6.enabled = false;
		} else if (HCheck6.selected)
		{
			HCheck1.enabled = false;
			HCheck3.enabled = false;
			HCheck4.enabled = false;
			HCheck5.enabled = false;
			HCheck2.enabled = false;
		}
	}
	
	if (configXML.USER == "Consulte")
	{
		VCheck1.enabled = false;
		VCheck2.enabled = false;
		VCheck3.enabled = false;
		VCheck4.enabled = false;
		VCheck5.enabled = false;
		VCheck6.enabled = false;
		HCheck1.enabled = false;
		HCheck2.enabled = false;
		HCheck3.enabled = false;
		HCheck4.enabled = false;
		HCheck5.enabled = false;
		HCheck6.enabled = false;
		
		
		roofList.editable = false;
		sourceList.editable = false;
		TFList.editable = false;
		TFList2.editable = false;
		TFList3.editable = false;
		SRList.editable = false;
		DpthList.editable = false;
		
		
		genComInput.editable = false;
		genComInputH.editable = false;
		genComInputRT.editable = false;
		genSourceInput.editable = false;
		genTFInput.editable = false;
		genComInputFD.editable = false;
		
		attachButDepth.visible = false;
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
			case "SoilR":
				cDomain = fld.domain;
				qResultsSR = [];
				qResultsSR.push(" ");
				for each (cVal in cDomain.codedValues)
			{
				qResultsSR.push(cVal.name);
			}
				fillSRD();
				fillSRS();
				break;
			case "RoofT":
				cDomain = fld.domain;
				qResultsRT = [];
				qResultsRT.push(" ");
				for each (cVal in cDomain.codedValues)
			{
				qResultsRT.push(cVal.name);
			}
				break;
			case "SourceInf":
				cDomain = fld.domain;
				qResultsSI = [];
				qResultsSI.push(" ");
				for each (cVal in cDomain.codedValues)
			{
				qResultsSI.push(cVal.name);
			}
				break;
			case "FM":
				cDomain = fld.domain;
				qResultsFM = [];
				qResultsFM.push(" ");
				for each (cVal in cDomain.codedValues)
			{
				qResultsFM.push(cVal.name);
			}
				fillFMS();
				fillFMD();
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



private function fillFMS():void
{
	qResultsFMS = [];
	qResultsFMS.push(" ");
	qResultsFMS.push(qResultsFM[1]);
	qResultsFMS.push(qResultsFM[2]);
	qResultsFMS.push(qResultsFM[5]);
}

private function fillFMD():void
{
	qResultsFMD = [];
	qResultsFMD.push(" ");
	qResultsFMD.push(qResultsFM[3]);
	qResultsFMD.push(qResultsFM[4]);
	qResultsFMD.push(qResultsFM[5]);
}

private function fillSRS():void
{
	qResultsSRS = [];
	qResultsSRS.push(" ");
	qResultsSRS.push(qResultsSR[1]);
	qResultsSRS.push(qResultsSR[2]);
	qResultsSRS.push(qResultsSR[3]);
}

private function fillSRD():void
{
	qResultsSRD = [];
	qResultsSRD.push(" ");
	qResultsSRD.push(qResultsSR[4]);
	qResultsSRD.push(qResultsSR[5]);
	qResultsSRD.push(qResultsSR[6]);
}

