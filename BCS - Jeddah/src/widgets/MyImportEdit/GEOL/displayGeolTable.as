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
private function displayGeolTable(holeObjId:Number):void
{
	geolGridSource.removeAll();
	geolGridSource.refresh();
	
	geolGridCopie.removeAll();
	geolGridCopie.refresh();
	
	
	index.ws1.removeAllChildren();
	HButtonBox.removeAllChildren();

	var headerStyleName:CSSStyleDeclaration=new CSSStyleDeclaration;
	headerStyleName.setStyle("color",0xd22228); 
	
	dataGrid.setStyle("alternatingItemColors",[0xF7F7F7,0xFFFFFF]);
	dataGrid.setStyle("selectionColor",0x959595);
	dataGrid.setStyle("headerStyleName", headerStyleName);
	dataGrid.setStyle("color", 0xd22228);
	dataGrid.percentWidth = 100;
	dataGrid.percentHeight = 95;
	dataGrid.id = "geolTable";
	dataGrid.name = "geolTable";
	dataGrid.dataProvider = geolGridSource;
	dataGrid.editable = true;
	dataGrid.draggableColumns = true;
	dataGrid.allowMultipleSelection = true;
	dataGrid.allowDragSelection = true;
	dataGrid.addEventListener(KeyboardEvent.KEY_UP, manageKey);
	dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);
	dataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgItemEditEnd);
	
	var i:Number = 1;
	var columns:Array = new Array();

	if(index.ws1.owns(dataGrid))
	{
		index.ws1.removeChild(dataGrid);
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
	delRowFromTableBut.addEventListener(MouseEvent.CLICK, delRowFromTable);
	HButtonBox.addChild(delRowFromTableBut);

	var query:Query = new Query();
	query.where = "HOLEID = " + holeObjId;
	query.outFields = ["*"];
	geol.outFields = ["*"];
	geol.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));

	index.ws1.addChild(dataGrid);
	index.ws1.addChild(HButtonBox);
	index.ws1.label = "Stratigraphic Informations";
	index.ws1.visible = true;
	

	
	function onQueryResultHandler(featureSet:FeatureSet, token:Object = null):void
	{
		onQueryResult(featureSet,  columns, geolEditsStarted);
	}
	function onQueryFaultHandler(fault:Fault, token:Object = null):void
	{
		onQueryFault(fault);
	}
	
	function addRowToTableHandler(event:MouseEvent):void
	{					
		addRowToTable(holeObjId, geolEditsFault, geolEditsCompleted);
	}
	
	function geolEditsFault(ev:FaultEvent):void
	{
		geol.removeEventListener(FaultEvent.FAULT, geolEditsFault);
		geol.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
		callLater(reloadIfFault);
		geol.refresh();
		
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
		
		query.where = "HOLEID = " + holeObjId;
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

		dataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgItemEditEnd);
		
		addRowToTableBut.addEventListener(MouseEvent.CLICK,addRowToTableHandler);
		addRowToTableBut.enabled = true;
		delRowFromTableBut.addEventListener(MouseEvent.CLICK,delRowFromTable);
		delRowFromTableBut.enabled = true;
	}
	
	function geolEditsStarted(ev:FeatureLayerEvent):void
	{
		if(!geol.willTrigger(FaultEvent.FAULT))
		{
			geol.addEventListener(FaultEvent.FAULT, geolEditsFault);
		}
		
		if(!geol.willTrigger(FeatureLayerEvent.EDITS_COMPLETE))
		{
			geol.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
		}
		
		dataGrid.removeEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);
		dataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgItemEditEnd);
		addRowToTableBut.removeEventListener(MouseEvent.CLICK,addRowToTableHandler);
		delRowFromTableBut.removeEventListener(MouseEvent.CLICK,delRowFromTable);
		addRowToTableBut.enabled = false;
		delRowFromTableBut.enabled = false;
		geol.removeEventListener(FeatureLayerEvent.EDITS_STARTING,geolEditsStarted);	
	}
	
	function geolEditsCompleted(ev:FeatureLayerEvent):void
	{
		
		geol.removeEventListener(FaultEvent.FAULT, geolEditsFault);
		geol.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
		cursorManager.removeBusyCursor();
		if(ev.featureEditResults.addResults.length > 0)
		{
			addResults = geolGridSource.length;
			var query:Query = new Query();
			query.where = "HOLEID = " + holeObjId;
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
			query.where = "HOLEID = " + holeObjId;
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
		
		callLater(addAllListener);
	}
	
}//END displayGeolTable
