import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.components.AttachmentInspector;
import com.esri.ags.events.AttachmentEvent;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.layers.supportClasses.CodedValue;
import com.esri.ags.layers.supportClasses.CodedValueDomain;
import com.esri.ags.layers.supportClasses.LayerDetails;
import com.esri.ags.layers.supportClasses.RangeDomain;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.viewer.AppEvent;
import com.esri.viewer.ViewerContainer;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.containers.Form;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Label;
import mx.controls.List;
import mx.controls.Text;
import mx.controls.TextInput;
import mx.events.CalendarLayoutChangeEvent;
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

import spark.components.Label;
import spark.components.Panel;
import spark.components.supportClasses.Skin;

import ImageButton;

import customRenderer.SizeRenderer;

import flexlib.events.WindowShadeEvent;

import mySkins.AddButtonSkin;

import widgets.MyWidget.EditWidgetAttachmentInspectorSkin;
import widgets.MyWidget.testClass;


// ActionScript file
private function displayGeneralInfo(k:uint,event:FeatureLayerEvent,holeObjId:Number):void
{
	
	index.ws1.removeAllChildren();
	
	setStructArray(k,event);
	setCondArray(k,event);
	setAttachArray(k,event);
	
	attachGen = true;
	attachStruct = false;
	attachCond = false;
	
	getDomainValue();
	
	var virRegExp:RegExp = /[.]/gi;
	var allRegExp:RegExp = /[^0-9,-]/gi;
	var reExp:RegExp = /[.]/gi;
	
	var formGen:Form = new Form();
	formGen.id = "formGen";
	
	var gridG:Grid = new Grid();
	gridG.name = "gridG";
	
	var gridRowG:GridRow = new GridRow();var gridRowG2:GridRow = new GridRow();
	var gridItemGUL:GridItem = new GridItem(); var gridItemGUR:GridItem = new GridItem();var gridItemGB:GridItem = new GridItem();
	
	var gridUL:Grid = new Grid();var gridUR:Grid = new Grid();var gridDC:Grid = new Grid();
	
	var gridRowUL1:GridRow = new GridRow();var gridItemUL11:GridItem = new GridItem();var gridItemUL12:GridItem = new GridItem();
	var gridRowUL2:GridRow = new GridRow();var gridItemUL21:GridItem = new GridItem();var gridItemUL22:GridItem = new GridItem();
	var gridRowUL3:GridRow = new GridRow();var gridItemUL31:GridItem = new GridItem();var gridItemUL32:GridItem = new GridItem();var gridItemUL33:GridItem = new GridItem();
	var gridRowUL4:GridRow = new GridRow();var gridItemUL41:GridItem = new GridItem();var gridItemUL42:GridItem = new GridItem();var gridItemUL43:GridItem = new GridItem();
	
	var gridRowUR1:GridRow = new GridRow();var gridItemUR11:GridItem = new GridItem();var gridItemUR12:GridItem = new GridItem();
	var gridRowUR2:GridRow = new GridRow();var gridItemUR21:GridItem = new GridItem();var gridItemUR22:GridItem = new GridItem();
	var gridRowUR3:GridRow = new GridRow();var gridItemUR31:GridItem = new GridItem();var gridItemUR32:GridItem = new GridItem();
	var gridRowUR4:GridRow = new GridRow();var gridItemUR41:GridItem = new GridItem();var gridItemUR42:GridItem = new GridItem();
	var gridRowUR5:GridRow = new GridRow();var gridItemUR51:GridItem = new GridItem();var gridItemUR52:GridItem = new GridItem();
	
	var gridRowDC1:GridRow = new GridRow();var gridItemDC11:GridItem = new GridItem();var gridItemDC12:GridItem = new GridItem();var gridItemDC13:GridItem = new GridItem();
	var gridRowDC2:GridRow = new GridRow();var gridItemDC21:GridItem = new GridItem();var gridItemDC22:GridItem = new GridItem();var gridItemDC23:GridItem = new GridItem();
	var gridRowDC3:GridRow = new GridRow();var gridItemDC31:GridItem = new GridItem();var gridItemDC32:GridItem = new GridItem();var gridItemDC33:GridItem = new GridItem();
	var gridRowDC4:GridRow = new GridRow();var gridItemDC41:GridItem = new GridItem();var gridItemDC42:GridItem = new GridItem();var gridItemDC43:GridItem = new GridItem();
	var gridRowDC5:GridRow = new GridRow();var gridItemDC51:GridItem = new GridItem();var gridItemDC52:GridItem = new GridItem();
	var gridRowDC6:GridRow = new GridRow();var gridItemDC61:GridItem = new GridItem();var gridItemDC62:GridItem = new GridItem();var gridItemDC63:GridItem = new GridItem();
	
	var LabelUIZ:mx.controls.Label = new mx.controls.Label();
	LabelUIZ.text = "Underground impact zone ";
	var UIZList:mx.controls.ComboBox = new mx.controls.ComboBox();
	UIZList.setStyle('color', 0x000000);
	UIZList.dataProvider = qResultsUIZ;				
	if (event.features[k].attributes.UIZ != null)
	{
		UIZList.selectedIndex = 0;
		var len:int = UIZList.dataProvider.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (UIZList.dataProvider[j] == event.features[k].attributes.UIZ) 
			{
				UIZList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		UIZList.selectedIndex = 0;
	}
	UIZList.name = "UIZList";
	UIZList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	gridItemUL11.addChild(LabelUIZ);gridItemUL12.addChild(UIZList);
	gridRowUL1.addChild(gridItemUL11);gridRowUL1.addChild(gridItemUL12);
	
	var LabelFI:mx.controls.Label = new mx.controls.Label();
	LabelFI.text = "First inspection ";
	var FIList:mx.controls.ComboBox = new mx.controls.ComboBox();
	FIList.setStyle('color', 0x000000);
	FIList.dataProvider = qResultsFI;	
	if (event.features[k].attributes.FI != null)
	{
		FIList.selectedIndex = 0;
		var len:int = FIList.dataProvider.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (FIList.dataProvider[j] == event.features[k].attributes.FI) 
			{
				FIList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		FIList.selectedIndex = 0;
	}
	FIList.name = "FIList";
	FIList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	gridItemUL21.addChild(LabelFI);gridItemUL22.addChild(FIList);
	gridRowUL2.addChild(gridItemUL21);gridRowUL2.addChild(gridItemUL22);
	
	var LabelBD:mx.controls.Label = new mx.controls.Label();
	LabelBD.text = "Building dimensions : ";
	var LabelBDW:mx.controls.Label = new mx.controls.Label();
	LabelBDW.text = "Width ";
	var WTxt:mx.controls.TextInput = new mx.controls.TextInput();
	WTxt.setStyle('color',0x000000);
	if (event.features[k].attributes.BW == null)
	{
		WTxt.text = "";
	}
	else
	{
		WTxt.text = event.features[k].attributes.BW;
	}
	WTxt.width = 100;
	WTxt.name="BW";
	WTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	WTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
	gridItemUL31.addChild(LabelBD);gridItemUL32.addChild(LabelBDW);gridItemUL33.addChild(WTxt);
	gridRowUL3.addChild(gridItemUL31);gridRowUL3.addChild(gridItemUL32);gridRowUL3.addChild(gridItemUL33);
	
	var LabelBDE:mx.controls.Label = new mx.controls.Label();
	LabelBDE.text = "";
	var LabelBDL:mx.controls.Label = new mx.controls.Label();
	LabelBDL.text = "Length ";
	var LTxt:mx.controls.TextInput = new mx.controls.TextInput();
	LTxt.setStyle('color',0x000000);
	if (event.features[k].attributes.BL == null)
	{
		LTxt.text = "";
	}
	else
	{
		LTxt.text = event.features[k].attributes.BL;
	}
	LTxt.width = 100;
	LTxt.name = "BL";
	LTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	LTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
	gridItemUL41.addChild(LabelBDE);gridItemUL42.addChild(LabelBDL);gridItemUL43.addChild(LTxt);
	gridRowUL4.addChild(gridItemUL41);gridRowUL4.addChild(gridItemUL42);gridRowUL4.addChild(gridItemUL43);
	
	gridUL.addChild(gridRowUL1);gridUL.addChild(gridRowUL2);gridUL.addChild(gridRowUL3);gridUL.addChild(gridRowUL4);
	
	var LabelLoc:mx.controls.Label = new mx.controls.Label();
	LabelLoc.text = "Plan view with picture localisation ";
	var attachButLoc1:Button = new Button();
	attachButLoc1.name = "PlanGen1";
	attachButLoc1.label = "Localisation";
	attachButLoc1.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	gridItemUR11.addChild(LabelLoc);gridItemUR12.addChild(attachButLoc1);
	gridRowUR1.addChild(gridItemUR11);gridRowUR1.addChild(gridItemUR12);
	
	var LabelOver:mx.controls.Label = new mx.controls.Label();
	LabelOver.text = "Overview : ";
	var attachButOver1:Button = new Button();
	attachButOver1.name = "PictureGen1";
	attachButOver1.label = "Overview ";
	attachButOver1.toolTip = "Pictures of the facade";
	attachButOver1.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	gridItemUR21.addChild(LabelOver);gridItemUR22.addChild(attachButOver1);
	gridRowUR2.addChild(gridItemUR21);gridRowUR2.addChild(gridItemUR22);
	
//	var LabelOE1:mx.controls.Label = new mx.controls.Label();
//	LabelOE1.text = " ";
//	var attachButOver2:Button = new Button();
//	attachButOver2.name = "attachButOver2";
//	attachButOver2.label = "Picture";
//	attachButOver2.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//	gridItemUR31.addChild(LabelOE1);gridItemUR32.addChild(attachButOver2);
//	gridRowUR3.addChild(gridItemUR31);gridRowUR3.addChild(gridItemUR32);
//	
//	var LabelOE2:mx.controls.Label = new mx.controls.Label();
//	LabelOE2.text = " ";
//	var attachButOver3:Button = new Button();
//	attachButOver3.name = "attachButOver3";
//	attachButOver3.label = "Picture";
//	attachButOver3.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//	gridItemUR41.addChild(LabelOE2);gridItemUR42.addChild(attachButOver3);
//	gridRowUR4.addChild(gridItemUR41);gridRowUR4.addChild(gridItemUR42);
//	
//	var LabelOE3:mx.controls.Label = new mx.controls.Label();
//	LabelOE3.text = " ";
//	var attachButOver4:Button = new Button();
//	attachButOver4.name = "attachButOver4";
//	attachButOver4.label = "Picture";
//	attachButOver4.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//	gridItemUR51.addChild(LabelOE3);gridItemUR52.addChild(attachButOver4);
//	gridRowUR5.addChild(gridItemUR51);gridRowUR5.addChild(gridItemUR52);
	
	gridUR.addChild(gridRowUR1);gridUR.addChild(gridRowUR2);//gridUR.addChild(gridRowUR3);gridUR.addChild(gridRowUR4);gridUR.addChild(gridRowUR5);
	
	var LabelSD:mx.controls.Label = new mx.controls.Label();
	LabelSD.text = "Storey data : ";
	var LabelSAG:mx.controls.Label = new mx.controls.Label();
	LabelSAG.text = "N. storeys above ground level :";
	var SAGTxt:mx.controls.TextInput = new mx.controls.TextInput();
	SAGTxt.setStyle('color',0x000000);
	if (event.features[k].attributes.NSL == null)
	{
		SAGTxt.text = "";
	}
	else
	{
		SAGTxt.text = event.features[k].attributes.NSL;
	}
	SAGTxt.width = 100;
	SAGTxt.name = "SAG";
	SAGTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	SAGTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
	gridItemDC11.addChild(LabelSD);gridItemDC12.addChild(LabelSAG);gridItemDC13.addChild(SAGTxt);
	gridRowDC1.addChild(gridItemDC11);gridRowDC1.addChild(gridItemDC12);gridRowDC1.addChild(gridItemDC13);
	
	var LabelSDE1:mx.controls.Label = new mx.controls.Label();
	LabelSDE1.text = "";
	var LabelNBS:mx.controls.Label = new mx.controls.Label();
	LabelNBS.text = "N. of basement storeys :";
	var NBSTxt:mx.controls.TextInput = new mx.controls.TextInput();
	NBSTxt.setStyle('color',0x000000);
	if (event.features[k].attributes.NSB == null)
	{
		NBSTxt.text = "";
	}
	else
	{
		NBSTxt.text = event.features[k].attributes.NSB;
	}
	NBSTxt.width = 100;
	NBSTxt.name = "NBS";
	NBSTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	NBSTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
	gridItemDC21.addChild(LabelSDE1);gridItemDC22.addChild(LabelNBS);gridItemDC23.addChild(NBSTxt);
	gridRowDC2.addChild(gridItemDC21);gridRowDC2.addChild(gridItemDC22);gridRowDC2.addChild(gridItemDC23);
	
	var LabelSDE2:mx.controls.Label = new mx.controls.Label();
	LabelSDE2.text = "";
	var LabelADOB:mx.controls.Label = new mx.controls.Label();
	LabelADOB.text = "Approximate depth of overall basement :";
	var ADOBTxt:mx.controls.TextInput = new mx.controls.TextInput();
	ADOBTxt.setStyle('color',0x000000);
	if (event.features[k].attributes.Depth_Storey == null)
	{
		ADOBTxt.text = "";
	}
	else
	{
		ADOBTxt.text = event.features[k].attributes.Depth_Storey;
	}
	ADOBTxt.width = 100;
	ADOBTxt.name = "ADOB";
	ADOBTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	ADOBTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
	gridItemDC31.addChild(LabelSDE2);gridItemDC32.addChild(LabelADOB);gridItemDC33.addChild(ADOBTxt);
	gridRowDC3.addChild(gridItemDC31);gridRowDC3.addChild(gridItemDC32);gridRowDC3.addChild(gridItemDC33);
	
	var hBoxHBdg:HBox = new HBox();
	
	var LabelHB:mx.controls.Label = new mx.controls.Label();
	LabelHB.text = "Historical Building :";
	var HBList:mx.controls.ComboBox = new mx.controls.ComboBox();
	HBList.setStyle('color', 0x000000);
	HBList.dataProvider = qResultsHB;	
	if (event.features[k].attributes.HB != null)
	{
		HBList.selectedIndex = 0;
		var len:int = HBList.dataProvider.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (HBList.dataProvider[j] == event.features[k].attributes.HB) 
			{
				HBList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		HBList.selectedIndex = 0;
	}
	HBList.name = "HBList";
	HBList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	var gridItemDC44:GridItem = new GridItem();
	var HBRLabel:mx.controls.Label = new mx.controls.Label();
	HBRLabel.text = "Comments :";
	var genHBInput:spark.components.TextArea = new spark.components.TextArea();
	genHBInput.setStyle('color', 0x000000);
	if (event.features[k].attributes.HB_Descr == null)
	{
		genHBInput.text = "";
	}
	else
	{
		genHBInput.text = event.features[k].attributes.HB_Descr;
	}
	genHBInput.name = "genHBInput";
	genHBInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genHBInput.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
	//genHBInput.width = 100;
	genHBInput.percentWidth = 100;
	genHBInput.height = 30;
	
//	gridItemDC41.addChild(LabelHB);gridItemDC42.addChild(HBList);gridItemDC43.addChild(genHBInput);gridItemDC44.addChild(HBRLabel);
	hBoxHBdg.addChild(LabelHB);hBoxHBdg.addChild(HBList);hBoxHBdg.addChild(HBRLabel);hBoxHBdg.addChild(genHBInput);
	gridItemDC41.addChild(hBoxHBdg);
	gridItemDC41.colSpan = 4;
	gridRowDC4.addChild(gridItemDC41);//gridRowDC4.addChild(gridItemDC42);gridRowDC4.addChild(gridItemDC44);gridRowDC4.addChild(gridItemDC43);
	
	var LabelBC:mx.controls.Label = new mx.controls.Label();
	LabelBC.text = "Building category :";
	var BCList:mx.controls.ComboBox = new mx.controls.ComboBox();
	BCList.setStyle('color', 0x000000);
	BCList.dataProvider = qResultsBC;	
	if (event.features[k].attributes.Building_Category != null)
	{
		BCList.selectedIndex = 0;
		var len:int = qResultsBC.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (BCList.dataProvider[j] == event.features[k].attributes.Building_Category) 
			{
				BCList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		BCList.selectedIndex = 0;
	}
	BCList.name = "BCList";
	BCList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	
	gridItemDC51.addChild(LabelBC);gridItemDC52.addChild(BCList);
	gridRowDC5.addChild(gridItemDC51);gridRowDC5.addChild(gridItemDC52);
	
	var hBoxUB:HBox = new HBox();
	
	var LabelUB:mx.controls.Label = new mx.controls.Label();
	LabelUB.text = "Use of building :";
	var UBList:mx.controls.ComboBox = new mx.controls.ComboBox();
	UBList.setStyle('color', 0x000000);
	UBList.dataProvider = qResultsUB;	
	if (event.features[k].attributes.Use_Building != null)
	{
		UBList.selectedIndex = 0;
		var len:int = UBList.dataProvider.length;
		for (var j:int = 0; j < len; j++) 
		{
			if (UBList.dataProvider[j] == event.features[k].attributes.Use_Building) 
			{
				UBList.selectedIndex = j;
				break;
			}
		}
	}
	else
	{
		UBList.selectedIndex = 0;
	}
	UBList.name = "UBList";
	UBList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	
	var gridItemDC64:GridItem = new GridItem();
	var UBRLabel:mx.controls.Label = new mx.controls.Label();
	UBRLabel.text = "Remarks :";
	var genUBInput:spark.components.TextArea = new spark.components.TextArea();
	genUBInput.setStyle('color', 0x000000);
	if (event.features[k].attributes.UB_Descr == null)
	{
		genUBInput.text = "";
	}
	else
	{
		genUBInput.text = event.features[k].attributes.UB_Descr;
	}
	genUBInput.name = "genUBInput";
	genUBInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genUBInput.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
	//genUBInput.width = 100;
	genUBInput.percentWidth = 100;
	genUBInput.height = 30;
	
//	gridItemDC61.addChild(LabelUB);gridItemDC62.addChild(UBList);gridItemDC63.addChild(genUBInput);gridItemDC64.addChild(UBRLabel);
	hBoxUB.addChild(LabelUB);hBoxUB.addChild(UBList);hBoxUB.addChild(UBRLabel);hBoxUB.addChild(genUBInput);
	gridItemDC61.addChild(hBoxUB);
	gridItemDC61.colSpan = 4;
	gridRowDC6.addChild(gridItemDC61);//gridRowDC6.addChild(gridItemDC62);gridRowDC6.addChild(gridItemDC64);gridRowDC6.addChild(gridItemDC63);
	
	gridDC.addChild(gridRowDC1);gridDC.addChild(gridRowDC2);gridDC.addChild(gridRowDC3);
	gridDC.addChild(gridRowDC4);gridDC.addChild(gridRowDC5);gridDC.addChild(gridRowDC6);
	
	
	gridItemGUL.addChild(gridUL);
	gridItemGUR.addChild(gridUR);
	gridItemGB.addChild(gridDC);
	gridRowG.addChild(gridItemGUL);
	gridRowG.addChild(gridItemGUR);
	gridRowG2.addChild(gridItemGB);
	gridG.addChild(gridRowG);
	gridG.addChild(gridRowG2);
	
	formGen.addChild(gridG);
	index.ws1.addChild(formGen);
	index.ws1.label = "General Informations";
	index.ws1.height = 650;
	index.ws1.visible = true;
		
	function onCbChangeHandler(ev:ListEvent):void
	{
		onCbGeneralChange(ev, event, k);
		if(!featLayer.willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted); 
		}	
	}
	
	function saveInfoEditedKeyHandler(ev:KeyboardEvent):void
	{
		
		if (ev.keyCode == 13)
		{
			var retChar:RegExp = /\n/;
			ev.currentTarget.text = ev.currentTarget.text.replace(retChar, "");
			saveInfoEditedKey(ev.currentTarget, event, k);
			if(!featLayer.willTrigger(FeatureLayerEvent.EDITS_STARTING))
			{
				featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
			}
		}
	}
	
	function saveInfoEditedHandler(ev:FlexEvent):void
	{
		saveInfoEdited(ev, event, k);
		if(!featLayer.willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
	}// fin de saveInfoEditedHandler
	
	
	if (statusValidated)
	{
		WTxt.editable = false;
		LTxt.editable = false;
		SAGTxt.editable = false;
		NBSTxt.editable = false;
		ADOBTxt.editable = false;
		
		
		ADOBTxt.editable = false;
		genUBInput.editable = false;
		
		UIZList.enabled = false;
		UIZList.editable = false;
		FIList.enabled = false;
		HBList.editable = false;
		HBList.enabled = false;
		BCList.editable = false;
		BCList.enabled = false;
		UBList.editable = false;
		UBList.enabled = false;
		
		attachButLoc1.enabled = false;
		attachButOver1.enabled = false;
//		attachButOver2.enabled = false;
//		attachButOver3.enabled = false;
//		attachButOver4.enabled = false;
		
	}
	
	function myFeatureLayer_editsStarted(ev:FeatureLayerEvent):void
	{
		featLayer.removeEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayer_updateEditsComplete);
		WTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		WTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		LTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		SAGTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		NBSTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		ADOBTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		LTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		SAGTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		NBSTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		ADOBTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		
		ADOBTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		ADOBTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		genUBInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genHBInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		UIZList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		FIList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		HBList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		BCList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		UBList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		
		attachButLoc1.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
		attachButOver1.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver2.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver3.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver4.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	}// fin de myFeatureLayer_editsStarted
	
	function featLayer_updateEditsComplete(ev:FeatureLayerEvent):void
	{
		featLayer.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayer_updateEditsComplete);
		if(!clickToAdd && !clickToMove  && !coordToMove) //Cas où l'on update un élément sans le bouger
		{
			if(ev.featureEditResults.updateResults.length > 0)
			{
				var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
				toastMessage.imageSource = "assets/images/save.png";
				toastMessage.sampleCaption = "Updated Test";
				toastMessage.timeToLive = 2;
				index.simpleToaster.toast(toastMessage);
				
				featLayer.clearSelection();
				featLayer.refresh();
//				var query:Query = new Query();
//				query.objectIds = [event.features[k].attributes.OBJECTID];
//				query.outFields = ["*"];
//				featLayer.selectFeatures(query);
				
				featLayer.addEventListener(LayerEvent.UPDATE_END, featLayer_updateEndHandler); 
				
				function featLayer_updateEndHandler(evt:LayerEvent):void
				{
					var ind:Number;
					for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
					{
						if(featLayer.graphicProvider[id].attributes.OBJECTID == (index.ws0.label).split(", ")[1])
						{
							ind = id;
							break;
						}
					}
					
					isGene = true;
					event.features[k] = (!isNaN(ind))?featLayer.graphicProvider[ind]:event.features[k];
					
					
					featLayer.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler)
					addInfoWindListener();
					featLayer.removeEventListener(LayerEvent.UPDATE_END, featLayer_updateEndHandler); 
				}
			}
			else if(ev.featureEditResults.deleteResults.length > 0)
			{
				map.infoWindow.hide();
				featLayer.clearSelection();
				featLayer.refresh();
				
				map.getLayer("BatiInEdition").refresh();
				
				var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
				toastMessage.imageSource = "assets/images/trash.png";
				toastMessage.sampleCaption = "Building deleted";
				toastMessage.timeToLive = 2;
				index.simpleToaster.toast(toastMessage);
				featLayer.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler);
				index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		else if(!clickToAdd && (clickToMove || coordToMove)) //Cas où l'on bouge un élément dans un update
		{
			map.infoWindow.hide();
			featLayer.clearSelection();
			clickToMove = false;	
			coordToMove = false;
			var query = new Query();
			query = new Query();
			query.objectIds = [event.featureEditResults.updateResults[0].objectId];
			query.outFields=["*"];
			featLayer.refresh();
			featLayer.addEventListener(FeatureLayerEvent.SELECTION_COMPLETE,myFeatureLayer_selectionCompleteHandler)
			featLayer.selectFeatures(query);
		}
		
	}// fin de featLayer_updateEditsComplete
	
	function myAttachFeatureLayer_editsStarted(ev:FeatureLayerEvent):void
	{
		attachFeat.removeEventListener(FeatureLayerEvent.EDITS_STARTING, myAttachFeatureLayer_editsStarted);
		attachFeat.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,attachFeatLayer_updateEditsComplete);
		WTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		WTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		LTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		SAGTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		NBSTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		ADOBTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		LTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		SAGTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		NBSTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		ADOBTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		
		ADOBTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		ADOBTxt.removeEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		genUBInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genHBInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		UIZList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		FIList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		HBList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		BCList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		UBList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		
		attachButLoc1.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
		attachButOver1.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver2.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver3.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver4.removeEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
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
				ind = featInd;
				event.features[k] = (!isNaN(ind))?attachFeat.graphicProvider[ind]:event.features[k];
				isAtt= true;
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
	
	function addInfoWindListener():void
	{
		WTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		WTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		LTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		SAGTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		NBSTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		ADOBTxt.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		LTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		SAGTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		NBSTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		ADOBTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		genUBInput.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		genHBInput.addEventListener(KeyboardEvent.KEY_DOWN, saveInfoEditedKeyHandler);
		genUBInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genHBInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		UIZList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		FIList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		HBList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		BCList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		UBList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		
		attachButLoc1.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
		attachButOver1.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver2.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver3.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		attachButOver4.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
			
	}// fin de addInfoWindListener
	
	function editAttachFeaturesHandler(ev:MouseEvent):void
	{
		if (ev.currentTarget.name == "PlanGen1"){isLocalisation = true;isOverview = false;}
		else if (ev.currentTarget.name == "PictureGen1"){isLocalisation = false;isOverview = true;}
		if(!attachFeat.willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
//			attachFeat.addEventListener(FeatureLayerEvent.EDITS_STARTING, myAttachFeatureLayer_editsStarted);
		}
		
		attachEventDispatch.removeAllEventListeners();
		
		attachEventDispatch.addEvtListener(attachmentInspector,AttachmentEvent.ADD_ATTACHMENT_COMPLETE,addAttachmentComplete);
		attachEventDispatch.addEvtListener(attachmentInspector,AttachmentEvent.DELETE_ATTACHMENTS_COMPLETE,addAttachmentComplete);
		
		tooltipMaker();
		editAttachFeatures();
	}
	
	function addAttachmentComplete(ev:AttachmentEvent):void
	{	
		if (attachGen)
		{
			switch (ev.type)
			{
	//			case "queryAttachmentInfosComplete":
	//				tooltipMaker();
	//				editAttachFeatures();
	//				break;
				case "addAttachmentComplete":
					tooltipMaker();
					addAttachInfo(event,k,ev.featureEditResult.attachmentId.toString());
					break;
				case "deleteAttachmentsComplete":
					tooltipMaker();
					deleteAttachInfo(event,k,ev.featureEditResults[0].attachmentId);
					break;
			}
		}
	}
	
	function tooltipMaker():void
	{
		if (isInAttach)
		{
			if (isLocalisation) {setTooltip("Localisation");}
			else if (isOverview) {setTooltip("Overview");}
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
		if (attachArray[(attachArray.length-1)][3] ==cond)
		{
			info = info+attachArray[(attachArray.length-1)][2];
		}
		attachmentInspector.toolTip = info;
	}
	
	function setTooltipEmpty():void
	{
		attachmentInspector.toolTip = "empty";
	}
	
	function addAttachInfo(event:FeatureLayerEvent, k:Number,idpjs:String):void
	{
		var attributes:Object = {};
		if (isLocalisation) {attributes = {IDBATI:event.features[k].attributes.CODE.toString(),IDPJ:idpjs,THEME:"Localisation"};}
		else if (isOverview) {attributes = {IDBATI:event.features[k].attributes.CODE.toString(),IDPJ:idpjs,THEME:"Overview"};}
		var feature:Graphic = new Graphic(null, null, attributes);
		var updates:Array = [ feature ];
//		isInCond = true;
		attachFeat.applyEdits(updates,null,null);
		attachFeat.clearSelection();
		attachFeat.refresh();
		attachmentInspector.toolTip = attachmentInspector.toolTip=="empty" ? idpjs : attachmentInspector.toolTip +";"+idpjs;
	}
	
	function deleteAttachInfo(event:FeatureLayerEvent, k:Number,idpjs:String):void
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
	
}// fin de displayGeneralInfo



private function getDomainValue():void
{
	var returnValue:String = "";
	var fld:Object;
	var cVal:CodedValue;
	var cDomain:CodedValueDomain;
	for each (fld in featLayer.layerDetails.fields)
	{
		switch (fld.name)
		{
			case "FI":
				cDomain = fld.domain;
				qResultsFI = [];
				qResultsFI.push(" ");
				for each (cVal in cDomain.codedValues)
				{
					qResultsFI.push(cVal.name);
				}
				break;
			case "UIZ":
				cDomain = fld.domain;
				qResultsUIZ = [];
				qResultsUIZ.push(" ");
				for each (cVal in cDomain.codedValues)
				{
					qResultsUIZ.push(cVal.name);
				}
				break;
			case "Building_Category":
				cDomain = fld.domain;
				qResultsBC = [];
				qResultsBC.push(" ");
				for each (cVal in cDomain.codedValues)
				{
					qResultsBC.push(cVal.name);
				}
				break;
			case "Use_Building":
				cDomain = fld.domain;
				qResultsUB = [];
				qResultsUB.push(" ");
				for each (cVal in cDomain.codedValues)
				{
					qResultsUB.push(cVal.name);
				}
				break;
			case "HB":
				cDomain = fld.domain;
				qResultsHB = [];
				qResultsHB.push(" ");
				for each (cVal in cDomain.codedValues)
				{
					qResultsHB.push(cVal.name);
				}
				break;				
		}
		
	}
}
