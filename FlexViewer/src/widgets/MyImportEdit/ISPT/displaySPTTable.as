import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.tasks.supportClasses.Query;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.Label;
import mx.controls.PopUpMenuButton;
import mx.controls.TextInput;
import mx.events.DataGridEvent;
import mx.events.ListEvent;
import mx.formatters.NumberFormatter;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.styles.CSSStyleDeclaration;
import mx.utils.object_proxy;

import spark.components.TextArea;
import spark.components.TextInput;

import widgets.HeaderController.HeaderControllerWidget;

private function displaySPTTable(holeObjId:Number):void
{
	isptGridSource.removeAll();
	isptGridSource.refresh();
	
	isptGridCopie.removeAll();
	isptGridCopie.refresh();
	
	 
	index.ws1.removeAllChildren();
	//VPanelBox.removeAllChildren();
	HButtonBox.removeAllChildren();

	var headerStyleName:CSSStyleDeclaration=new CSSStyleDeclaration;
	headerStyleName.setStyle("color",0xd22228); 
	
	isptDataGrid.setStyle("alternatingItemColors",[0xF7F7F7,0xFFFFFF]);
	isptDataGrid.setStyle("selectionColor",0x959595);
	isptDataGrid.setStyle("headerStyleName", headerStyleName);
	isptDataGrid.setStyle("color", 0xd22228);
	isptDataGrid.percentWidth = 30;
	isptDataGrid.left = 10;
	isptDataGrid.percentHeight = 95;
	isptDataGrid.id = "isptTable";
	isptDataGrid.name = "isptTable";
	isptDataGrid.dataProvider = isptGridSource;
	isptDataGrid.editable = false;
	isptDataGrid.draggableColumns = true;
	isptDataGrid.allowMultipleSelection = true;
	isptDataGrid.allowDragSelection = true;
	isptDataGrid.addEventListener(KeyboardEvent.KEY_UP, manageKey);
	//isptDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT, isptDgFocusOut);
	if(!isptDataGrid.willTrigger(ListEvent.ITEM_CLICK))
		isptDataGrid.addEventListener(ListEvent.ITEM_CLICK, isptDgFocusIn);
	/*isptDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, isptDgItemEditEnd);
	isptDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_IN,isptDgItemEditEnd);
	*/
	var rowInd:Number = new Number();
	var columns:Array = new Array();
	

	
	var gridSPT:Grid = createGridSPT();
	
	
	grid.name = "gridSPT";
	grid.setStyle("color", 0xd22228);

	
	/*if(VPanelBox.owns(tablePanel))
	{
	VPanelBox.removeChild(tablePanel);
	}*/
	if(index.ws1.owns(isptDataGrid))
	{
		index.ws1.removeChild(isptDataGrid);
	}
	
	
	var query:Query = new Query();
	query.where = "LOCA_ID = " + holeObjId;
	query.outFields = ["*"];
	ispt.outFields = ["*"];
	ispt.queryFeatures(query,new AsyncResponder(onISPTQueryResultHandler, onISPTQueryFaultHandler));
	
	//geol.addEventListener(FaultEvent.FAULT, geolOnFault);
	var addRowToTableBut:Button = new Button();
	addRowToTableBut.label = "+";
	addRowToTableBut.buttonMode = true;
	//addRowToTableBut.setStyle("skin",null);
	addRowToTableBut.setStyle("textRollOverColor", 0xFFFFFF); 
	addRowToTableBut.setStyle("textSelectedColor", 0xFFFFFF); 
	
	addRowToTableBut.addEventListener(MouseEvent.CLICK, addISPTRowToTableHandler);
	HButtonBox.addChild(addRowToTableBut);
	
	var delRowFromTableBut : Button = new Button();
	delRowFromTableBut.label = "-";
	delRowFromTableBut.buttonMode = true;
	delRowFromTableBut.setStyle("textRollOverColor", 0xFFFFFF); 
	delRowFromTableBut.setStyle("textSelectedColor", 0xFFFFFF); 
	delRowFromTableBut.addEventListener(MouseEvent.CLICK, delISPTRowFromTable);
	HButtonBox.addChild(delRowFromTableBut);

	index.ws1.addChild(isptDataGrid);
	index.ws1.addChild(HButtonBox);
	index.ws1.label = "Standard Penetration Tests";
	index.ws1.visible = true;
	
	
	
	function onISPTQueryResultHandler(featureSet:FeatureSet, token:Object = null):void
	{
		onISPTQueryResult(featureSet,  columns, isptEditsStarted);
	}
	function onISPTQueryFaultHandler(fault:Fault, token:Object = null):void
	{
		onISPTQueryFault(fault);
	}
	
	function addISPTRowToTableHandler(event:MouseEvent):void
	{					
		addISPTRowToTable(holeObjId, isptEditsFault, isptEditsCompleted);
	}
	
	function isptEditsFault(ev:FaultEvent):void
	{
		ispt.removeEventListener(FaultEvent.FAULT, isptEditsFault);
		/*geol.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
		callLater(reloadIfFault);*/
		ispt.refresh();
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/error.png";
		toastMessage.sampleCaption = ev.fault.faultCode + ev.fault.faultDetail;
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
	}
	
	function isptDgFocusIn(ev:ListEvent):void
	{
		if(!index.ws2.visible)
		{
			index.ws2.removeAllChildren();
			//TODO Display le formulaire
			index.ws2.visible = true;
			index.ws2.label = "SPT Details";
		}
		
		if(ev.rowIndex != rowInd)
		{
			rowInd = ev.rowIndex;
			if(!index.ws2.owns(gridSPT))
			{
				index.ws2.addChild(gridSPT);
			}
			openISPTForm(rowInd, gridSPT);
		}
	}
	/*function reloadIfFault():void
	{
		cursorManager.removeBusyCursor();
		var query:Query = new Query();
		
		query.where = "LOCA_ID = " + holeObjId;
		query.outFields = ["*"];
		
		geol.disableClientCaching = true;
		geol.outFields = ["*"];
		geolGridSource.removeAll();
		geol.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
	}
	
	function addAllListener():void
	{
		geol.addEventListener(FeatureLayerEvent.EDITS_STARTING,geolEditsStarted);
		
		dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);
		
		dataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_IN,dgItemEditEnd);
		
		addRowToTableBut.addEventListener(MouseEvent.CLICK,addRowToTableHandler);
		addRowToTableBut.enabled = true;
		delRowFromTableBut.addEventListener(MouseEvent.CLICK,delRowFromTable);
		delRowFromTableBut.enabled = true;
	}*/
	
	function isptEditsStarted(ev:FeatureLayerEvent):void
	{
		
		if(!ispt.willTrigger(FeatureLayerEvent.EDITS_COMPLETE))
		{
			ispt.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, isptEditsCompleted);
		}
		if(!ispt.willTrigger(FaultEvent.FAULT))
		{
			ispt.addEventListener(FaultEvent.FAULT, isptEditsFault);
		}
		
		ispt.removeEventListener(FeatureLayerEvent.EDITS_STARTING,isptEditsStarted);
		
		/*if(!geol.willTrigger(FaultEvent.FAULT))
		{
			geol.addEventListener(FaultEvent.FAULT, geolEditsFault);
		}
		
		if(!geol.willTrigger(FeatureLayerEvent.EDITS_COMPLETE))
		{
			geol.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
		}
		
		dataGrid.removeEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);
		dataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_IN,dgItemEditEnd);
		addRowToTableBut.removeEventListener(MouseEvent.CLICK,addRowToTableHandler);
		delRowFromTableBut.removeEventListener(MouseEvent.CLICK,delRowFromTable);
		addRowToTableBut.enabled = false;
		delRowFromTableBut.enabled = false;
		*/	
	}
	
	function isptEditsCompleted(ev:FeatureLayerEvent):void
	{
		ispt.removeEventListener(FaultEvent.FAULT, isptEditsFault);
		ispt.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, isptEditsCompleted);
		ispt.addEventListener(FeatureLayerEvent.EDITS_STARTING,isptEditsStarted);
		cursorManager.removeBusyCursor();
		
		if(ev.featureEditResults.addResults.length > 0)
		{
			var query:Query = new Query();
			query.where = "LOCA_ID = " + holeObjId;
			query.outFields = ["*"];
			ispt.outFields = ["*"];
			isptGridSource.removeAll();
			isptGridCopie.removeAll();
			ispt.queryFeatures(query,new AsyncResponder(onISPTQueryResultHandler, onISPTQueryFaultHandler));
			
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/trash.png";
			toastMessage.sampleCaption = "Added";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
			
		}
		else if(ev.featureEditResults.deleteResults.length > 0)
		{
			var query:Query = new Query();
			isptGridSource.removeAll();
			isptGridCopie.removeAll();
			query.where = "LOCA_ID = " + holeObjId;
			query.outFields = ["*"];
			ispt.disableClientCaching = true;
			ispt.outFields = ["*"];
			ispt.queryFeatures(query,new AsyncResponder(onISPTQueryResultHandler, onISPTQueryFaultHandler));
			
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/trash.png";
			toastMessage.sampleCaption = "Deleted";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
		}
		else //cas du update
		{
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/save.png";
			toastMessage.sampleCaption = "Updated";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
		}
		
		/*geol.removeEventListener(FaultEvent.FAULT, geolEditsFault);
		geol.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
		cursorManager.removeBusyCursor();
		if(ev.featureEditResults.addResults.length > 0)
		{
			addResults = geolGridSource.length;
			var query:Query = new Query();
			query.where = "LOCA_ID = " + holeObjId;
			query.outFields = ["*"];
			geol.outFields = ["*"];
			geolGridSource.removeAll();
			geolGridCopie.removeAll();
			geol.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
			
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/trash.png";
			toastMessage.sampleCaption = "Added";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
			
		}
		else if(ev.featureEditResults.deleteResults.length > 0)
		{
			var query:Query = new Query();
			geolGridSource.removeAll();
			geolGridCopie.removeAll();
			query.where = "LOCA_ID = " + holeObjId;
			query.outFields = ["*"];
			geol.disableClientCaching = true;
			geol.outFields = ["*"];
			geol.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
			
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/trash.png";
			toastMessage.sampleCaption = "Deleted";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
			
			
		}
		else //cas du update
		{
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/email1.png";
			toastMessage.sampleCaption = "Updated";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
		}
		
		callLater(addAllListener);*/
	}
}

private function createGridSPT():Grid
{
	var gridSPT:Grid = new Grid();
	
	var gridRow1:GridRow = new GridRow();
	
	var sptTopItem:GridItem = new GridItem();
	
	sptTopItem.setStyle("verticalAlign", "middle");
	var sptTopLabel:Label = new Label();
	sptTopLabel.text = "Depth:";
	sptTopItem.addChild(sptTopLabel);
	gridRow1.addChild(sptTopItem);
	
	var sptTopValue:GridItem = new GridItem();
	sptTopValue.name = "sptTopValue";
	sptTopValue.setStyle("verticalAlign", "middle");
	
	var sptTopInput:spark.components.TextInput = new spark.components.TextInput();
	sptTopInput.width = 80;
	sptTopInput.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	sptTopValue.addChild(sptTopInput);
	gridRow1.addChild(sptTopValue);
	
		
	var sptTypeItem:GridItem = new GridItem();
	sptTypeItem.setStyle("verticalAlign", "middle");
	var sptTypeLabel:Label = new Label();
	sptTypeLabel.text = "Type:";
	sptTypeItem.addChild(sptTypeLabel);
	gridRow1.addChild(sptTypeItem);
	
	var sptTypeValue:GridItem = new GridItem();
	sptTypeValue.name = "sptTypeValue";
	sptTypeValue.setStyle("verticalAlign", "middle");
	var sptTypeInput:PopUpMenuButton = new PopUpMenuButton();
	sptTypeInput.name = "sptTypeInput";
	sptTypeInput.dataProvider = sptType;
	sptTypeInput.labelField = "@label";
	sptTypeInput.showRoot = false;
	
	sptTypeInput.width = 80;
	sptTypeValue.addChild(sptTypeInput);
	gridRow1.addChild(sptTypeValue);
	
	var sptERItem:GridItem = new GridItem();
	
	sptERItem.setStyle("verticalAlign", "middle");
	var sptERLabel:Label = new Label();
	sptERLabel.text = "Energy Ratio (%):";
	sptERItem.addChild(sptERLabel);
	gridRow1.addChild(sptERItem);
	
	var sptERValue:GridItem = new GridItem();
	sptERValue.name = "sptERValue";
	sptERValue.setStyle("verticalAlign", "middle");
	
	var sptERInput:spark.components.TextInput = new spark.components.TextInput();
	sptERInput.width = 80;
	sptERInput.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	sptERValue.addChild(sptERInput);
	gridRow1.addChild(sptERValue);
	
	gridSPT.addChild(gridRow1);
	
	
	
	var gridRow2:GridRow = new GridRow();
	
	var sptN1Item:GridItem = new GridItem();
	
	sptN1Item.setStyle("verticalAlign", "middle");
	var sptN1Label:Label = new Label();
	sptN1Label.text = "N1:";
	sptN1Item.addChild(sptN1Label);
	gridRow2.addChild(sptN1Item);
	
	var sptN1Value:GridItem = new GridItem();
	sptN1Value.name = "sptN1Value";
	sptN1Value.setStyle("verticalAlign", "middle");
	
	var sptN1Input:spark.components.TextInput = new spark.components.TextInput();
	sptN1Input.width = 80;
	sptN1Input.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	sptN1Value.addChild(sptN1Input);
	gridRow2.addChild(sptN1Value);
	
	var sptP1Item:GridItem = new GridItem();
	
	sptP1Item.setStyle("verticalAlign", "middle");
	var sptP1Label:Label = new Label();
	sptP1Label.text = "P1:";
	sptP1Item.addChild(sptP1Label);
	gridRow2.addChild(sptP1Item);
	
	var sptP1Value:GridItem = new GridItem();
	sptP1Value.name = "sptP1Value";
	sptP1Value.setStyle("verticalAlign", "middle");
	
	var sptP1Input:spark.components.TextInput = new spark.components.TextInput();
	sptP1Input.width = 80;
	sptP1Input.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	sptP1Value.addChild(sptP1Input);
	gridRow2.addChild(sptP1Value);
	
	
	gridSPT.addChild(gridRow2);
	
	var gridRow3:GridRow = new GridRow();
	
	var sptN2Item:GridItem = new GridItem();
	
	sptN2Item.setStyle("verticalAlign", "middle");
	var sptN2Label:Label = new Label();
	sptN2Label.text = "N2:";
	sptN2Item.addChild(sptN2Label);
	gridRow3.addChild(sptN2Item);
	
	var sptN2Value:GridItem = new GridItem();
	sptN2Value.name = "sptN2Value";
	sptN2Value.setStyle("verticalAlign", "middle");
	
	var sptN2Input:spark.components.TextInput = new spark.components.TextInput();
	sptN2Input.width = 80;
	sptN2Input.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	sptN2Value.addChild(sptN2Input);
	gridRow3.addChild(sptN2Value);
	
	var sptP2Item:GridItem = new GridItem();
	
	sptP2Item.setStyle("verticalAlign", "middle");
	var sptP2Label:Label = new Label();
	sptP2Label.text = "P2:";
	sptP2Item.addChild(sptP2Label);
	gridRow3.addChild(sptP2Item);
	
	var sptP2Value:GridItem = new GridItem();
	sptP2Value.name = "sptP2Value";
	sptP2Value.setStyle("verticalAlign", "middle");
	
	var sptP2Input:spark.components.TextInput = new spark.components.TextInput();
	sptP2Input.width = 80;
	sptP2Input.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	sptP2Value.addChild(sptP2Input);
	gridRow3.addChild(sptP2Value);
	
	
	gridSPT.addChild(gridRow3);
	
	var gridRow4:GridRow = new GridRow();
	
	var sptN3Item:GridItem = new GridItem();
	
	sptN3Item.setStyle("verticalAlign", "middle");
	var sptN3Label:Label = new Label();
	sptN3Label.text = "N3:";
	sptN3Item.addChild(sptN3Label);
	gridRow4.addChild(sptN3Item);
	
	var sptN3Value:GridItem = new GridItem();
	sptN3Value.name = "sptN3Value";
	sptN3Value.setStyle("verticalAlign", "middle");
	
	var sptN3Input:spark.components.TextInput = new spark.components.TextInput();
	sptN3Input.width = 80;
	sptN3Input.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	sptN3Value.addChild(sptN3Input);
	gridRow4.addChild(sptN3Value);

	
	var sptP3Item:GridItem = new GridItem();
	
	sptP3Item.setStyle("verticalAlign", "middle");
	var sptP3Label:Label = new Label();
	sptP3Label.text = "P3:";
	sptP3Item.addChild(sptP3Label);
	gridRow4.addChild(sptP3Item);
	
	var sptP3Value:GridItem = new GridItem();
	sptP3Value.name = "sptP3Value";
	sptP3Value.setStyle("verticalAlign", "middle");
	
	var sptP3Input:spark.components.TextInput = new spark.components.TextInput();
	sptP3Input.width = 80;
	sptP3Input.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	sptP3Value.addChild(sptP3Input);
	gridRow4.addChild(sptP3Value);
	
	gridSPT.addChild(gridRow4);
	
	var gridRow5:GridRow = new GridRow();
	
	var sptNvalItem:GridItem = new GridItem();
	
	sptNvalItem.setStyle("verticalAlign", "middle");
	var sptNvalLabel:Label = new Label();
	sptNvalLabel.text = "Nval:";
	sptNvalItem.addChild(sptNvalLabel);
	gridRow5.addChild(sptNvalItem);
	
	var sptNvalValue:GridItem = new GridItem();
	sptNvalValue.name = "sptNvalValue";
	sptNvalValue.setStyle("verticalAlign", "middle");
	
	var sptNvalInput:Label = new Label();
	sptNvalInput.width = 80;
	sptNvalValue.addChild(sptNvalInput);
	gridRow5.addChild(sptNvalValue);

	
	var sptNRepItem:GridItem = new GridItem();
	
	sptNRepItem.setStyle("verticalAlign", "middle");
	var sptNRepLabel:Label = new Label();
	sptNRepLabel.text = "NRep:";
	sptNRepItem.addChild(sptNRepLabel);
	gridRow5.addChild(sptNRepItem);
	
	var sptNRepValue:GridItem = new GridItem();
	sptNRepValue.name = "sptNRepValue";
	sptNRepValue.setStyle("verticalAlign", "middle");
	
	var sptNRepInput:Label = new Label();
	sptNRepInput.width = 80;
	sptNRepValue.addChild(sptNRepInput);
	gridRow5.addChild(sptNRepValue);
	
	
	var sptFocedValueItem:GridItem = new GridItem();
	
	sptFocedValueItem.setStyle("verticalAlign", "middle");
	var sptForceLabel:Label = new Label();
	sptForceLabel.text = "Auto calulate Nval?";
	sptFocedValueItem.addChild(sptForceLabel);
	gridRow5.addChild(sptFocedValueItem);
	
	var sptForcedValue:GridItem = new GridItem();
	sptForcedValue.name = "sptForcedValue";
	sptForcedValue.setStyle("verticalAlign", "middle");
	
	var sptForceInput:mx.controls.CheckBox = new mx.controls.CheckBox();
	sptForceInput.selected = true;
	sptForceInput.addEventListener(MouseEvent.CLICK, toggleForcedNvalHandler);
	sptForcedValue.addChild(sptForceInput);
	gridRow5.addChild(sptForcedValue);
	
	gridSPT.addChild(gridRow5);

	
	var gridRow6:GridRow = new GridRow();

	var sptRemItem:GridItem = new GridItem();
	
	sptRemItem.setStyle("verticalAlign", "middle");
	var sptRemLabel:Label = new Label();
	sptRemLabel.text = "Remark:";
	sptRemItem.addChild(sptRemLabel);
	gridRow6.addChild(sptRemItem);
	
	var sptRemValue:GridItem = new GridItem();
	sptRemValue.name = "sptRemValue";
	sptRemValue.colSpan = 4;
	sptRemValue.setStyle("verticalAlign", "middle");
	
	var sptRemInput:spark.components.TextArea = new spark.components.TextArea();
	sptRemValue.addChild(sptRemInput);
	sptRemValue.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
	gridRow6.addChild(sptRemValue);
	gridSPT.addChild(gridRow6);
	
	//gridSPT.percentWidth = 100;
	gridSPT.height = 200;
	
	return gridSPT;
}


private function textInputValueCommitHandler(event:FocusEvent):void
{	
	event.currentTarget.addEventListener(FocusEvent.FOCUS_OUT, textInputFocusOutHandler);
	event.currentTarget.errorString = null;
}

private function textInputFocusOutHandler(event:FocusEvent):void
{
	event.currentTarget.removeEventListener(FocusEvent.FOCUS_OUT, textInputFocusOutHandler);

	var updates:Array = [];
	var attributes:Object = {};
	attributes.OBJECTID = parseInt(isptDataGrid.selectedItem.OBJECTID);//Utiliser plutôt rowInd
	var attributesBis:Object = {};
	attributesBis.OBJECTID = parseInt(isptDataGrid.selectedItem.OBJECTID);
	
	var myFormatter:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
	myFormatter.useThousandsSeparator = false;
	myFormatter.decimalSeparatorFrom = ","
	myFormatter.decimalSeparatorTo = ",";
	myFormatter.precision = 2;
	myFormatter.useThousandsSeparator = false;
	
	
	var myFormatterBis:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
	myFormatterBis.useThousandsSeparator = false;
	myFormatterBis.decimalSeparatorFrom = "."
	myFormatterBis.decimalSeparatorTo = ".";
	myFormatterBis.precision = 2;
	myFormatterBis.useThousandsSeparator = false;
	
	var virRegExp:RegExp = /[.]/gi;
	var regExp:RegExp = /[^0-9,]/gi;
	
	
	switch(event.currentTarget.owner.name)
	{
		case"sptTopValue":
			/*if(isptDataGrid.selectedItem.ISPT_TOP != event.currentTarget.text)
			{*/
			if(event.currentTarget.text != null && (event.currentTarget.text).search(virRegExp) != -1)
			{
				event.currentTarget.text = (event.currentTarget.text).replace(virRegExp,",");
			}
			if((event.currentTarget.text != null) && (event.currentTarget.text.search(regExp)>-1))
			{
				event.currentTarget.text = ""
				event.preventDefault();
				event.currentTarget.errorString = "Enter a valid number.";
				return;
			}			
			else
			{
				if(event.currentTarget.text != "")
				{
					event.currentTarget.text = myFormatter.format(event.currentTarget.text);
					if((isptDataGrid.selectedItem.ISPT_TOP != myFormatter.format(event.currentTarget.text)) && (myFormatter.format(isptDataGrid.selectedItem.ISPT_TOP)!=  myFormatter.format(event.currentTarget.text)))
					{
						attributes.ISPT_TOP = event.currentTarget.text;
						var feature:Graphic = new Graphic(null, null, attributes);
						updates.push(feature);
						attributesBis.ISPT_TOP = parseFloat(event.currentTarget.text);
						isptGridSource.setItemAt(attributesBis,isptDataGrid.selectedIndex);
						//isptGridSource.refresh();
						
						ispt.applyEdits(null,updates,null);
					}
				}
			}
				
			//}
			break;
		case "sptERValue":
			if(isptDataGrid.selectedItem.ISPT_ERAT != event.currentTarget.text)
			{
				attributes.ISPT_ERAT = event.currentTarget.text;
				var feature:Graphic = new Graphic(null, null, attributes);
				updates.push(feature);
				isptGridSource.setItemAt(attributes,isptDataGrid.selectedIndex);
				//isptGridSource.refresh();
				
				ispt.applyEdits(null,updates,null);
			}
			break;
		case "sptRemValue":
			if(isptDataGrid.selectedItem.ISPT_REM != event.currentTarget.text)
			{
				
				attributes.ISPT_REM = event.currentTarget.text;
				var feature:Graphic = new Graphic(null, null, attributes);
				updates.push(feature);
				isptGridSource.setItemAt(attributes,isptDataGrid.selectedIndex);
				//isptGridSource.refresh();
				
				ispt.applyEdits(null,updates,null);
			}
			break;
	}
	
	if(event.currentTarget.owner.owner.owner.getChildAt(4).getChildAt(5).getChildAt(0).selected)
	{
		//Alert.show("selected");
	}
	else
	{
		//Alert.show("unselected");
	}
}
 
private function toggleForcedNvalHandler(event:MouseEvent):void
{
	var tmp:Object = new Object();
	tmp = event.target.owner.owner;//gridRow
	if(event.target.selected)
	{
		//TODO applyEdits
		var tmpGrid:Object = new Object();
		tmpGrid = tmp.owner;
		tmpGrid.getChildAt(1).getChildAt(1).enabled = tmpGrid.getChildAt(1).getChildAt(3).enabled = tmpGrid.getChildAt(2).getChildAt(1).enabled = tmpGrid.getChildAt(2).getChildAt(3).enabled = tmpGrid.getChildAt(3).getChildAt(1).enabled = tmpGrid.getChildAt(3).getChildAt(3).enabled = true;
		var tiNval:Label = new Label();
		tiNval.width = 80;
		tmp.getChildAt(1).removeChildAt(0);
		tmp.getChildAt(1).addChild(tiNval);
		
		var tiRep:Label = new Label();
		tiRep.width = 80;
		tmp.getChildAt(3).removeChildAt(0);
		tmp.getChildAt(3).addChild(tiRep);
	}
	else
	{
		//TODO applyEdits
		var tmpGrid:Object = new Object();
		tmpGrid = tmp.owner;
		tmpGrid.getChildAt(1).getChildAt(1).enabled = tmpGrid.getChildAt(1).getChildAt(3).enabled = tmpGrid.getChildAt(2).getChildAt(1).enabled = tmpGrid.getChildAt(2).getChildAt(3).enabled = tmpGrid.getChildAt(3).getChildAt(1).enabled = tmpGrid.getChildAt(3).getChildAt(3).enabled = false;
		var tiNvalbis:spark.components.TextInput = new spark.components.TextInput();
		tiNvalbis.width = 80;
		tiNvalbis.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
		tmp.getChildAt(1).removeChildAt(0);
		tmp.getChildAt(1).addChild(tiNvalbis);
		
		var tiRepbis:spark.components.TextInput = new spark.components.TextInput();
		tiRepbis.width = 80;
		tiRepbis.addEventListener(FocusEvent.FOCUS_IN, textInputValueCommitHandler);
		tmp.getChildAt(3).removeChildAt(0);
		tmp.getChildAt(3).addChild(tiRepbis);
	}
}