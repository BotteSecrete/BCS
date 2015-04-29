import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.viewer.AppEvent;
import com.esri.viewer.ViewerContainer;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Text;
import mx.controls.TextInput;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.MenuEvent;
import mx.formatters.NumberFormatter;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.styles.CSSStyleDeclaration;

import spark.components.Panel;
import spark.components.supportClasses.Skin;

import ImageButton;

import customRenderer.SizeRenderer;

import mySkins.AddButtonSkin;


// ActionScript file
private function displayCoreTable(holeObjId:Number):void
{
	coreGridSource.removeAll();
	coreGridSource.refresh();
	
	coreGridCopie.removeAll();
	coreGridCopie.refresh();
	
	
	index.ws1.removeAllChildren();
	HButtonBox.removeAllChildren();

	var headerStyleName:CSSStyleDeclaration=new CSSStyleDeclaration;
	headerStyleName.setStyle("color",0xd22228); 
	
	coreDataGrid.setStyle("alternatingItemColors",[0xF7F7F7,0xFFFFFF]);
	coreDataGrid.setStyle("selectionColor",0x959595);
	coreDataGrid.setStyle("headerStyleName", headerStyleName);
	coreDataGrid.setStyle("color", 0xd22228);
	coreDataGrid.percentWidth = 100;
	coreDataGrid.percentHeight = 95;
	coreDataGrid.id = "coreTable";
	coreDataGrid.name = "coreTable";
	coreDataGrid.dataProvider = coreGridSource;
	coreDataGrid.editable = true;
	coreDataGrid.draggableColumns = true;
	coreDataGrid.allowMultipleSelection = true;
	coreDataGrid.allowDragSelection = true;
	coreDataGrid.addEventListener(KeyboardEvent.KEY_UP, manageKey);
	coreDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dgCoreItemEditEnd);
	coreDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgCoreItemEditEnd);
	
	var i:Number = 1;
	var columns:Array = new Array();

	if(index.ws1.owns(coreDataGrid))
	{
		index.ws1.removeChild(coreDataGrid);
	}
	
	
	
	
	var addRowToTableBut:Button = new Button();
	addRowToTableBut.label = "+";
	addRowToTableBut.buttonMode = true;
	//addRowToTableBut.setStyle("skin",null);
	addRowToTableBut.setStyle("textRollOverColor", 0xFFFFFF); 
	addRowToTableBut.setStyle("textSelectedColor", 0xFFFFFF); 
		


	addRowToTableBut.addEventListener(MouseEvent.CLICK, addRowToTableHandler);
	HButtonBox.addChild(addRowToTableBut);
	
	var delRowFromTableBut : Button = new Button();
	delRowFromTableBut.label = "-";
	delRowFromTableBut.buttonMode = true;
	delRowFromTableBut.setStyle("textRollOverColor", 0xFFFFFF); 
	delRowFromTableBut.setStyle("textSelectedColor", 0xFFFFFF); 
	delRowFromTableBut.addEventListener(MouseEvent.CLICK, delRowFromCoreTable);
	HButtonBox.addChild(delRowFromTableBut);

	var query:Query = new Query();
	query.where = "LOCA_ID = " + holeObjId;
	query.outFields = ["*"];
	core.outFields = ["*"];
	core.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));

	index.ws1.addChild(coreDataGrid);
	index.ws1.addChild(HButtonBox);
	index.ws1.label = "Coring Information";
	index.ws1.visible = true;
	

	
	function onQueryResultHandler(featureSet:FeatureSet, token:Object = null):void
	{
		onCoreQueryResult(featureSet,  columns, coreEditsStarted);
	}
	function onQueryFaultHandler(fault:Fault, token:Object = null):void
	{
		onCoreQueryFault(fault);
	}
	
	function addRowToTableHandler(event:MouseEvent):void
	{					
		addRowToCoreTable(holeObjId, coreEditsFault, coreEditsCompleted);
	}
	
	function coreEditsFault(ev:FaultEvent):void
	{
		/*geol.removeEventListener(FaultEvent.FAULT, coreEditsFault);
		geol.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, coreEditsCompleted);
		callLater(reloadIfFault); 
		geol.refresh();
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/error.png";
		toastMessage.sampleCaption = ev.fault.faultCode + ev.fault.faultDetail;
		toastMessage.timeToLive = 2 ;
		index.simpleToaster.toast(toastMessage);
	*/}
	
	function reloadIfFault():void
	{/*
		cursorManager.removeBusyCursor();
		var query:Query = new Query();
		
		query.where = "LOCA_ID = " + holeObjId ; 
		query.outFields = ["*"];
		
		geol.disableClientCaching = true;
		geol.outFields = ["*"];
		geolGridSource.removeAll();
		geol.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
	*/}
	
	function addAllListener():void
	{
		core.addEventListener(FeatureLayerEvent.EDITS_STARTING,coreEditsStarted);

		coreDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dgCoreItemEditEnd);

		coreDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgCoreItemEditEnd);
		
		addRowToTableBut.addEventListener(MouseEvent.CLICK,addRowToTableHandler);
		addRowToTableBut.enabled = true;
		delRowFromTableBut.addEventListener(MouseEvent.CLICK,delRowFromCoreTable);
		delRowFromTableBut.enabled = true;
	}
	
	function coreEditsStarted(ev:FeatureLayerEvent):void
	{
		if(!core.willTrigger(FaultEvent.FAULT))
		{
			core.addEventListener(FaultEvent.FAULT, coreEditsFault);
		}
		
		if(!core.willTrigger(FeatureLayerEvent.EDITS_COMPLETE))
		{
			core.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, coreEditsCompleted);
		}
		
		coreDataGrid.removeEventListener(DataGridEvent.ITEM_EDIT_END, dgCoreItemEditEnd);
		coreDataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT, dgCoreItemEditEnd);
		addRowToTableBut.removeEventListener(MouseEvent.CLICK,addRowToTableHandler);
		delRowFromTableBut.removeEventListener(MouseEvent.CLICK,delRowFromTable);
		addRowToTableBut.enabled = false;
		delRowFromTableBut.enabled = false;
		core.removeEventListener(FeatureLayerEvent.EDITS_STARTING,coreEditsStarted);	
	}
	
	function coreEditsCompleted(ev:FeatureLayerEvent):void
	{
		
		core.removeEventListener(FaultEvent.FAULT, coreEditsFault);
		core.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, coreEditsCompleted);
		//cursorManager.removeBusyCursor();
		if(ev.featureEditResults.addResults.length > 0)
		{
			addResults = coreGridSource.length;
			var query:Query = new Query();
			query.where = "LOCA_ID = " + holeObjId;
			query.outFields = ["*"];
			core.outFields = ["*"];
			coreGridSource.removeAll();
			coreGridCopie.removeAll();
			core.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
			
			var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
			toastMessage.imageSource = "assets/images/trash.png";
			toastMessage.sampleCaption = "Added";
			toastMessage.timeToLive = 2;
			index.simpleToaster.toast(toastMessage);
			
		}
		else if(ev.featureEditResults.deleteResults.length > 0)
		{
			var query:Query = new Query();
			coreGridSource.removeAll();
			coreGridCopie.removeAll();
			query.where = "LOCA_ID = " + holeObjId;
			query.outFields = ["*"];
			core.disableClientCaching = true;
			core.outFields = ["*"];
			core.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
			
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
		
		callLater(addAllListener);
	}
	
}//END displayGeolTable
