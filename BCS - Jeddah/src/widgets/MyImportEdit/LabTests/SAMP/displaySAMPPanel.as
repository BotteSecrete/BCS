import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.tasks.supportClasses.Query;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.MouseEvent;

import mx.charts.AreaChart;
import mx.charts.GridLines;
import mx.charts.Legend;
import mx.charts.LinearAxis;
import mx.charts.LogAxis;
import mx.charts.renderers.CircleItemRenderer;
import mx.charts.series.AreaSeries;
import mx.charts.series.LineSeries;
import mx.charts.series.PlotSeries;
import mx.collections.ArrayCollection;
import mx.containers.Box;
import mx.containers.Canvas;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.DataGrid;
import mx.controls.Label;
import mx.controls.Text;
import mx.controls.TextInput;
import mx.core.ClassFactory;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.IndexChangedEvent;
import mx.formatters.NumberFormatter;
import mx.graphics.ImageSnapshot;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.styles.CSSStyleDeclaration;

import spark.components.Panel;

import customRenderer.MyTabComponent;

// ActionScript file

private var indRowSamp:Number;
private var fieldSamp:String;

private function displaySAMPPanel(holeObjId:Number, tablePanel:Panel = null):void
{
	VPanelBox.removeAllChildren();
	HButtonBox.removeAllChildren();
	//var sampGridSource:ArrayCollection = new ArrayCollection();
	//var sampDataGrid:DataGrid = new DataGrid();	
	sampGridSource.removeAll();
	sampGridSource.refresh();
	
	sampGridCopie.removeAll();
	sampGridCopie.refresh();
	
	/*var hSampChoiceBox:HBox = new HBox();
	hSampChoiceBox.percentWidth = 100;
	hSampChoiceBox.percentHeight = 100;
	if(!tablePanel)
	{
		var tablePanel:Panel = new Panel();
	}
	
	tablePanel.name = "tablePanel";
	tablePanel.title =  "Sample informations for Hole: " + map.infoWindow.label;
	tablePanel.percentWidth = 100;
	tablePanel.percentHeight = 100;
	tablePanel.right = 0;
	
	hSampChoiceBox.addChild(tablePanel);*/
	
	/*var menuLab:PopUpMenuButton = new PopUpMenuButton();
	menuLab.dataProvider = labTests;
	menuLab.labelField = "@label";
	menuLab.showRoot = false;
	menuLab.addEventListener(MenuEvent.ITEM_CLICK,openedTestTable);*/
	var hButtonBox:HBox =  new HBox();
	//vButtonBox.addChild(menuLab);
	//hSampChoiceBox.addChild(vButtonBox);
	
	var addSampToTable : Button = new Button();
	addSampToTable.label = "+";
	addSampToTable.setStyle("textRollOverColor", 0xd22228); 
	addSampToTable.setStyle("textSelectedColor", 0xd22228); 
	addSampToTable.addEventListener(MouseEvent.CLICK, addSampRowToTableHandler);
	
	var delSampFromTable:Button = new Button();
	delSampFromTable.label = "-";
	delSampFromTable.setStyle("textRollOverColor", 0xd22228); 
	delSampFromTable.setStyle("textSelectedColor", 0xd22228); 
	delSampFromTable.addEventListener(MouseEvent.CLICK,delSampRowFromTableHandler);
	
	var seeRelatTests:Button = new Button();
	seeRelatTests.label = "See related tests";
	seeRelatTests.setStyle("textRollOverColor", 0xd22228); 
	seeRelatTests.setStyle("textSelectedColor", 0xd22228); 
	seeRelatTests.addEventListener(MouseEvent.CLICK,seeRelatedTestsHandler)
	hButtonBox.addChild(addSampToTable);
	hButtonBox.addChild(delSampFromTable);
	hButtonBox.addChild(seeRelatTests);
	//VPanelBox.addChild(hSampChoiceBox);
	index.ws1.removeAllChildren();
	index.ws1.visible = true;
	index.ws1.label = "Samples Details";
	index.ws1.addChild(sampDataGrid);
	index.ws1.addChild(hButtonBox);
	//index.panel.addChild(VPanelBox);
	
	/*if(index.btn.label == 'Open'){
		panelOut.play();
		//Alert.show(index.btnArrow.setStyle("upSkin",rightArrow));
		index.btnArrow.setStyle("upSkin",rightArrow);
		index.btnArrow.setStyle("downSkin",rightArrow);
		index.btnArrow.setStyle("overSkin",rightArrow);
		index.btnArrow.setStyle("disableSkin",rightArrow);
	}*/

	
	var query:Query = new Query();
	query.where = "LOCA_ID = " + holeObjId;
	query.outFields = ["*"];
	samp.outFields = ["*"];
	samp.queryFeatures(query,new AsyncResponder(onQuerySAMPResultHanlder, onQuerySAMPFaultHandler));
	//samp.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, sampEditsCompleted);
	


	
	var columns:Array = new Array();
	
	samp.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, sampEditsCompleted);
	
	var headerStyleName:CSSStyleDeclaration = new CSSStyleDeclaration;
	headerStyleName.setStyle("color",0xd22228); //FONCTIONNE PAS
	sampDataGrid.setStyle("alternatingItemColors",[0xF7F7F7,0xFFFFFF]);
	sampDataGrid.setStyle("selectionColor",0x959595);
	sampDataGrid.setStyle("rollOverColor",0xC3C3C3);
	sampDataGrid.setStyle("headerStyleName", headerStyleName);
	sampDataGrid.setStyle("color", 0xd22228);
	sampDataGrid.percentWidth = 100;
	sampDataGrid.percentHeight = 95;
	//sampDataGrid.verticalScrollPolicy = ScrollPolicy.OFF;
	sampDataGrid.id = "sampTable";
	sampDataGrid.name = "sampTable";
	sampDataGrid.dataProvider = sampGridSource;
	sampDataGrid.editable = true;
	sampDataGrid.draggableColumns = true;
	sampDataGrid.allowMultipleSelection = true;
	sampDataGrid.allowDragSelection = true;
	
	//dataGrid.addEventListener(KeyboardEvent.KEY_UP, manageKey);
	sampDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dgSampItemEditEnd);
	sampDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT, dgSampItemEditEnd);
	var indRow:Number;

	var field:String;
	var addedRow:Boolean = false;
	
	function onQuerySAMPResultHanlder(featureSet:FeatureSet, token:Object = null):void
	{
		onQuerySAMPResult(featureSet, columns, addedRow);
		
	}//End function: OnQueryResult
	
	function onQuerySAMPFaultHandler(fault:Fault, token:Object = null):void
	{
		onQuerySAMPFault(fault);
	}//END Function onQueryFault
	

	function sampEditsFault(ev:FaultEvent):void
	{
		samp.removeEventListener(FaultEvent.FAULT, sampEditsFault);
		samp.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, sampEditsCompleted);
		callLater(reloadIfFault);
		samp.refresh();
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/error.png";
		toastMessage.sampleCaption = ev.fault.faultCode + ev.fault.faultDetail;
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
	}
	
	function reloadIfFault():void
	{
		cursorManager.removeBusyCursor();
		var query:Query = new Query();
		
		query.where = "LOCA_ID = " + holeObjId;
		query.outFields = ["*"];
		
		samp.disableClientCaching = true;
		samp.outFields = ["*"];
		sampGridSource.removeAll();
		samp.queryFeatures(query,new AsyncResponder(onQuerySAMPResultHanlder, onQuerySAMPFaultHandler));
	}
	
	function addAllListener():void
	{
		samp.addEventListener(FeatureLayerEvent.EDITS_STARTING,sampEditsStarted);
		
		sampDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dgSampItemEditEnd);
		
		sampDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgSampItemEditEnd);
		
		addSampToTable.addEventListener(MouseEvent.CLICK,addSampRowToTableHandler);
		addSampToTable.enabled = true;
		delSampFromTable.addEventListener(MouseEvent.CLICK,delSampRowFromTableHandler);
		delSampFromTable.enabled = true;
	}
	
	function sampEditsStarted(ev:FeatureLayerEvent):void
	{
		if(!samp.willTrigger(FaultEvent.FAULT))
		{
			samp.addEventListener(FaultEvent.FAULT, sampEditsFault);
		}
		
		if(!samp.willTrigger(FeatureLayerEvent.EDITS_COMPLETE))
		{
			samp.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, sampEditsCompleted);
		}
		
		sampDataGrid.removeEventListener(DataGridEvent.ITEM_EDIT_END, dgSampItemEditEnd);
		sampDataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgSampItemEditEnd);
		addSampToTable.removeEventListener(MouseEvent.CLICK,addSampRowToTableHandler);
		delSampFromTable.removeEventListener(MouseEvent.CLICK,delSampRowFromTableHandler);
		addSampToTable.enabled = false;
		delSampFromTable.enabled = false;
		samp.removeEventListener(FeatureLayerEvent.EDITS_STARTING,sampEditsStarted);	
	}
	
	function sampEditsCompleted(ev:FeatureLayerEvent):void
	{
		
		samp.removeEventListener(FaultEvent.FAULT, sampEditsFault);
		samp.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, sampEditsCompleted);
		cursorManager.removeBusyCursor();
		if(ev.featureEditResults.addResults.length > 0)
		{
			addResults = sampGridSource.length;
			var query:Query = new Query();
			query.where = "LOCA_ID = " + holeObjId;
			query.outFields = ["*"];
			samp.outFields = ["*"];
			sampGridSource.removeAll();
			sampGridCopie.removeAll();
			samp.queryFeatures(query,new AsyncResponder(onQuerySAMPResultHanlder, onQuerySAMPFaultHandler));
			
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/add.png";
			toastMessage.sampleCaption = "Added";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
			
		}
		else if(ev.featureEditResults.deleteResults.length > 0)
		{
			var query:Query = new Query();
			sampGridSource.removeAll();
			sampGridCopie.removeAll();
			query.where = "LOCA_ID = " + holeObjId;
			query.outFields = ["*"];
			samp.disableClientCaching = true;
			samp.outFields = ["*"];
			samp.queryFeatures(query,new AsyncResponder(onQuerySAMPResultHanlder, onQuerySAMPFaultHandler));
			
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
		
		callLater(addAllListener);
	}
	
	function addSampRowToTableHandler(event:MouseEvent):void
	{	
		addSampRowToTable(holeObjId);
		addedRow = true;
	}

	//END function addSampRowToTableHandler
	
	function delSampRowFromTableHandler(event:MouseEvent):void
	{
		delSampRowFromTable();
	}
	
	function seeRelatedTestsHandler(event:MouseEvent):void
	{
		seeRelatedTests();
	}
	
}//END displaySAMPPanel

