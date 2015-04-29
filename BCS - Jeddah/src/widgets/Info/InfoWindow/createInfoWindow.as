import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.SpatialReference;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.layers.OpenStreetMapLayer;
import com.esri.ags.symbols.SimpleFillSymbol;
import com.esri.ags.symbols.SimpleLineSymbol;
import com.esri.ags.tasks.supportClasses.ProjectParameters;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.ags.utils.GraphicUtil;
import com.esri.viewer.AppEvent;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.collections.ArrayCollection;
import mx.containers.Form;
import mx.containers.FormItem;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.core.ScrollPolicy;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.formatters.DateFormatter;
import mx.formatters.NumberFormatter;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;

import spark.components.CheckBox;
import spark.components.DataGrid;
import spark.components.Label;
import spark.components.TextArea;

import flexlib.containers.WindowShade;

import mySkins.MySkins2;

import widgets.MyWidget.MyFirstWidget;

public function createInfoWindow(k:uint,event:FeatureLayerEvent, ndFeatSel:Number):void
{
	
	AppEvent.addListener(AppEvent.COLLAPSE_PANEL_RESIZE, resizeFormHandler);
	
	openAttachTable();
	openStructTable();
	openCondTable();
	getInd();
	
//	featLayerGraphic = featLayer.graphicProvider[k] as Graphic;
	
	var locNF:NumberFormatter = new NumberFormatter();
	locNF.decimalSeparatorFrom = ",";
	locNF.decimalSeparatorTo = ",";
	locNF.precision = 3;
	locNF.useThousandsSeparator = false;
	
	var twoNF:NumberFormatter = new NumberFormatter();
	twoNF.decimalSeparatorFrom = ",";
	twoNF.decimalSeparatorTo = ",";
	twoNF.precision = 2;
	twoNF.useThousandsSeparator = false;
	
	var virRegExp:RegExp = /[.]/gi;
	var allRegExp:RegExp = /[^0-9,-]/gi;
	var reExp:RegExp = /[.]/gi;
	
//	if(configXML.USER == "Validateur")
//	{
//		
//	}
	
	form = new Form();
	form.id = "testWindow";
	
	
	index.ws0.width = index.collapsingPanel.explicitWidth;
	index.ws0.label = "Edit building information, "+event.features[k].attributes.OBJECTID.toString();
	form.setStyle('horizontalScrollPolicy', ScrollPolicy.AUTO);
	form.name = "testWindow";
	
	if (ndFeatSel>1)
	{
		var nextPrevBut:FormItem = new FormItem();
		var hBox11:HBox = new HBox();
		var next:Button = new Button(); 
		next.label=">";
		var prev:Button = new Button(); 
		prev.label="<";
		var num:Text = new Text();
		num.text = (k+1).toString() +"/" + ndFeatSel.toString();
		hBox11.addChild(prev);
		hBox11.addChild(num);
		hBox11.addChild(next);
		form.addChild(hBox11);
		next.addEventListener(MouseEvent.CLICK,nextWindowToDisplay);
		prev.addEventListener(MouseEvent.CLICK,prevWindowToDisplay);
		
		function nextWindowToDisplay(ev:MouseEvent):void
		{
			if(k==(ndFeatSel-1)){
				k=0;
			}else{
				k++;
			}
			
			createInfoWindow(k,event,ndFeatSel);
		}
		
		function prevWindowToDisplay(ev:MouseEvent):void
		{
			if(k==0){
				k=ndFeatSel-1;
			}else{ 
				k--;
			}
			createInfoWindow(k,event,ndFeatSel);
		}
	}
	
	var hbox12:HBox = new HBox();
	
	var IDItem:FormItem = new FormItem();
	IDItem.label="Building Code";
	var IDText:mx.controls.TextInput = new mx.controls.TextInput();
	IDText.setStyle('color',0x000000);
	IDText.width = 100;
	if (event.features[k].attributes.CODE == null)
	{
		IDText.text = "";
	}
	else
	{
		IDText.text = event.features[k].attributes.CODE;
	}
//	IDText.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	IDText.editable = false;
	IDText.name = "IDTBC";
//	IDItem.required = true;
	//IDItem.setStyle('indicatorGap',43);
	IDItem.setStyle('paddingRight',13);
	IDItem.addChild(IDText);
	
	var gridItemDate:GridItem = new GridItem();
	gridItemDate.setStyle("verticalAlign","middle");
	var dateLabel:mx.controls.Label = new mx.controls.Label();
	dateLabel.text = "Date of survey : ";
	gridItemDate.addChild(dateLabel);
	
	var dateChooseItem:GridItem = new GridItem();
	dateChooseItem.setStyle("verticalAlign","middle");
	var dateChoose:DateField = new DateField();
	dateChoose.setStyle("color","0x000000");
	dateChoose.formatString = "YYYY-MM-DD";
	if (event.features[k].attributes.DATE_SURVEY != null)
	{
		var myDate:Date = new Date(event.features[k].attributes.DATE_SURVEY);
		var myDF:DateFormatter = new DateFormatter();
		myDF.formatString = "YYYY-MM-DD";
		
		dateChoose.text = myDF.format(myDate);
	}
	dateChoose.yearNavigationEnabled = false;
	dateChoose.setStyle('paddingRight',13);
//	dateChoose.addEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
	dateChoose.editable = false;
	dateChoose.enabled = false;
	dateChooseItem.addChild(gridItemDate);
	dateChooseItem.addChild(dateChoose);
	
	var IDName:FormItem = new FormItem();
	IDName.label="Name of surveyor";
	var IDTxt:mx.controls.TextInput = new mx.controls.TextInput();
	IDTxt.setStyle('color',0x000000);
	IDTxt.width = 100;
	if (event.features[k].attributes.NAME_SURVEY == null)
	{
		IDTxt.text = "";
	}
	else
	{
		IDTxt.text = event.features[k].attributes.NAME_SURVEY
	}
	IDTxt.width = 100;
//	IDTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	IDTxt.editable = false;
	IDTxt.name = "IDTName";
	//	IDItem.required = true;
	//IDItem.setStyle('indicatorGap',43);
	IDItem.setStyle('paddingRight',13);
	IDName.addChild(IDTxt);
	
	hbox12.addChild(IDItem);
	hbox12.addChild(dateChooseItem);
	hbox12.addChild(IDName);
	
	var hboxAddress:HBox = new HBox();
	
	var AddLab:FormItem = new FormItem();
	AddLab.label="Address ";
	var AddTxt:mx.controls.TextInput = new mx.controls.TextInput();
	AddTxt.setStyle('color',0x000000);
	if (event.features[k].attributes.Address == null)
	{
		AddTxt.text = "";
	}
	else
	{
		AddTxt.text = event.features[k].attributes.Address;
	}
	AddTxt.width = 500;
//	AddTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	AddTxt.editable = false;
	AddTxt.name = "AddTxt";
	//	IDItem.required = true;
	AddLab.setStyle('indicatorGap',51);
	AddLab.setStyle('paddingRight',13);
	AddLab.addChild(AddTxt);
	hboxAddress.addChild(AddLab);
	
	var hboxContact:HBox = new HBox();
	var ContactLab:FormItem = new FormItem();
	ContactLab.label="Contact person ";
	var ContactTxt:mx.controls.TextInput = new mx.controls.TextInput();
	ContactTxt.setStyle('color',0x000000);
	if (event.features[k].attributes.Contact == null)
	{
		ContactTxt.text = "";
	}
	else
	{
		ContactTxt.text = event.features[k].attributes.Contact;
	}
	ContactTxt.width = 500;
//	ContactTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	ContactTxt.editable = false;
	ContactTxt.name = "ContactTxt";
	//	IDItem.required = true;
	//IDItem.setStyle('indicatorGap',43);
	IDItem.setStyle('paddingRight',13);
	ContactLab.addChild(ContactTxt);
	hboxContact.addChild(ContactLab);
	
	var hBoxAttach:HBox = new HBox();
	var attachButGene:Button = new Button();
	attachButGene.name = "attachButGene";
	attachButGene.label = "Edit attachments";
	attachButGene.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
	hBoxAttach.addChild(attachButGene);
	hBoxAttach.visible = false;
	
	var hBoxBas:HBox = new HBox();
	hBoxBas.name = "hBoxBas";
	
	var hBoxBtn:HBox = new HBox();
	hBoxBtn.setStyle('paddingRight',100);
	
	var GnrlBtn:Button = new Button();
	GnrlBtn.name = "general";
	GnrlBtn.label = "General";
	GnrlBtn.addEventListener(MouseEvent.CLICK,onButtClick);
	
	var StructBtn:Button = new Button();
	StructBtn.name = "structure";
	StructBtn.label = "Structure";
	StructBtn.addEventListener(MouseEvent.CLICK,onButtClick);
	
	var CdtnBtn:Button = new Button();
	CdtnBtn.name = "condition";
	CdtnBtn.label = "Condition";
	CdtnBtn.addEventListener(MouseEvent.CLICK,onButtClick);
	
	hBoxBtn.addChild(GnrlBtn);
	hBoxBtn.addChild(StructBtn);
	hBoxBtn.addChild(CdtnBtn);
	
	var hBoxGenRem:HBox = new HBox();
	hBoxGenRem.name = "gridRow8";
	var genRemItem:GridItem = new GridItem();
	genRemItem.setStyle("verticalAlign", "middle");
	var genLabel:mx.controls.Label = new mx.controls.Label();
	genLabel.text = "General remarks : ";
	genRemItem.addChild(genLabel);
	hBoxGenRem.addChild(genRemItem);
	
	var genRemValue:GridItem = new GridItem();
	var genRemInput:spark.components.TextArea = new spark.components.TextArea();
	
	genRemInput.setStyle('color', 0x000000);
	if (event.features[k].attributes.Comments == null)
	{
		genRemInput.text = "";
	}
	else
	{
		genRemInput.text = event.features[k].attributes.Comments;
	}
	genRemValue.colSpan = (4);
	genRemInput.name = "genRemInput";
//	genRemInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genRemInput.editable = false;
	genRemInput.percentWidth = 100;
	genRemInput.height = 60;
	genRemValue.addChild(genRemInput);
	
	hBoxGenRem.addChild(genRemValue);
	
	var hBoxCB:HBox = new HBox();
	
	var completeCheck:spark.components.CheckBox = new spark.components.CheckBox();
	completeCheck.label = "Terminated";
	completeCheck.addEventListener(MouseEvent.CLICK, changeStatusHandler);
	completeCheck.setStyle('skinClass', Class(mySkins.MySkins2));
	
	hBoxCB.addChild(completeCheck);
	
	var checkCheck:spark.components.CheckBox = new spark.components.CheckBox();
	checkCheck.label = "Returned";
	checkCheck.addEventListener(MouseEvent.CLICK, changeStatusHandler);
	checkCheck.setStyle('skinClass', Class(mySkins.MySkins2));
	
	hBoxCB.addChild(checkCheck);
	
	var validCheck:spark.components.CheckBox = new spark.components.CheckBox();
	validCheck.label = "Validated";
	validCheck.addEventListener(MouseEvent.CLICK, changeStatusHandler);
	validCheck.setStyle('skinClass', Class(mySkins.MySkins2));
	
	hBoxCB.addChild(validCheck);
	
	var reportCheck:spark.components.CheckBox = new spark.components.CheckBox();
	reportCheck.label = "Report";
	reportCheck.addEventListener(MouseEvent.CLICK, changeStatusHandler);
	reportCheck.setStyle('skinClass', Class(mySkins.MySkins2));
	
	hBoxCB.addChild(reportCheck);
	completeCheck.selected = event.features[k].attributes.Terminated == "OUI" ? true : false; 
	checkCheck.selected = event.features[k].attributes.Returned == "OUI" ? true : false; 
	validCheck.selected = event.features[k].attributes.Validated == "OUI" ? true : false; 
	reportCheck.selected = event.features[k].attributes.Returned == "OUI" ? true : false;
	
	if (configXML.USER == "Prestataire")
	{
		checkCheck.visible = false;
		validCheck.visible = false;
		reportCheck.visible = false;
		
		
	} else if (configXML.USER == "Consulte")
	{
//		completeCheck.visible = completeCheck.selected ? true : false;
//		checkCheck.visible = checkCheck.selected ? true : false;
//		validCheck.visible = validCheck.selected ? true : false;
//		reportCheck.visible = reportCheck.selected ? true : false;
//		hBoxAttach.visible = true;
//		
//		IDText.editable = false;
//		IDTxt.editable = false;
//		AddTxt.editable = false;
//		ContactTxt.editable = false;
//		genRemInput.editable = false;
//		dateChoose.editable = false;
	}
	
	completeCheck.enabled = false;
	checkCheck.enabled = false; 
	validCheck.enabled = false; 
	reportCheck.enabled = false;
	
	
	hBoxBas.addChild(hBoxBtn);
	hBoxBas.addChild(hBoxCB);
	
	form.addChild(hbox12);
	form.addChild(hboxAddress);
	form.addChild(hboxContact);
	form.addChild(hBoxGenRem);
	form.addChild(hBoxAttach);
	form.addChild(hBoxBas);
	
	if(index.collapsingPanel.collapsed)
		index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK)); 
	
	if(!index.collapsingPanel.collapsed) 
	{
		index.ws0.removeAllChildren(); 
		index.ws0.visible = true; 
		index.ws0.width = index.collapsingPanel.explicitWidth; 
		form.width = index.ws0.width - 10; index.ws0.addChild(form); 
		index.ws0.opened = true; AppEvent.dispatch(AppEvent.COLLAPSE_PANEL_RESIZE); 
	} 
	AppEvent.addListener(AppEvent.COLLAPSE_PANEL_OPENED_END, openWS0Handler); 
	
	if(index.ws1.visible)
	{
		index.ws1.removeAllChildren();
		index.ws1.visible = false;
	}
	
	function openWS0Handler(ev:AppEvent):void 
	{ 
		index.ws0.removeAllChildren(); 
		index.ws0.visible = true; 
		index.ws0.addChild(form); 
		index.ws0.width = index.collapsingPanel.explicitWidth; 
		index.ws0.opened = true; 
		AppEvent.removeListener(AppEvent.COLLAPSE_PANEL_OPENED_END, openWS0Handler); 
	}// fin de openWS0Handler
	
	function onCbChangeHandler(ev:ListEvent):void
	{
		Alert.show("Nouvel Item selectionné : ","Changement d'Item");
	}// fin de onCbChangeHandler
	
	function editAttachFeaturesHandler(ev:MouseEvent):void
	{
		editAttachFeatures();
	}
	
	function onButtClick(ev:Event):void
	{
		switch (ev.target.name)
		{
			case "general":
				if (isGene)
				{
					var query:Query = new Query();
					query.objectIds = [event.features[k].attributes.OBJECTID];
					query.outFields = ["*"];
					featLayer.clearSelection();
					featLayer.refresh();
					featLayer.selectFeatures(query);
					//					isGene = false;
				}
				displayGeneralInfo(k,event,12);
				break;
			case "structure":
				if (isNotFStruct)
				{
					var query:Query = new Query();
					query.where = "IDBATI = " + [event.features[k].attributes.OBJECTID];
					query.outFields = ["*"];
					struct.clearSelection();
					struct.refresh();
					struct.selectFeatures(query);
				}
				displayStructTable(k,event,42);
				break;
			case "condition":
				if (isNotFCond)
				{
					var query:Query = new Query();
					query.where = "IDBATI = " + [event.features[k].attributes.OBJECTID];
					query.outFields = ["*"];
					cond.clearSelection();
					cond.refresh();
					cond.selectFeatures(query);
				}
				displayConditionTable(k,event,23);
				break;
		}
	}// fin de onButtClick
	
	function resizeFormHandler(ev:AppEvent):void
	{
		if(index.collapsingPanel.fullScreen)
		{
			if(index.ws0.owns(bord))
				index.ws0.removeChild(bord);
			
			form.percentWidth = 100; 
			
			bordbis.setStyle("borderStyle","solid");
			bordbis.setStyle("borderColor", 0xd22228);
			bordbis.setStyle("borderThickness", 10);
			bordbis.setStyle("cornerRadius",40);
			if (!bord.owns(bordbis))
				bord.addChild(bordbis);
			
			bord.horizontalScrollPolicy = ScrollPolicy.OFF;
			bord.verticalScrollPolicy = ScrollPolicy.OFF;
			bord.setStyle("borderStyle","solid");
			bord.setStyle("borderColor", 0xd22228);
			bord.setStyle("borderThickness", 3);
			bord.setStyle("cornerRadius",40);
			index.ws0.addChild(bord);
			bord.minWidth = 150;
			bord.percentWidth = bordbis.percentWidth = 100;
			bord.height = bordbis.height = form.height - 10;
			myMiniMap.percentHeight = 100;
			myMiniMap.visible = true;
			myMiniMap.navigationClass = null;
			
//			minLayer = new FeatureLayer(featLayer.url, featLayer.proxyURL, featLayer.token) as FeatureLayer;
						
			minLayer = new FeatureLayer(featLayer.url, featLayer.proxyURL, featLayer.token) as FeatureLayer;
			var ind:Number;
			for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
			{
				if(featLayer.graphicProvider[id].attributes.OBJECTID == (index.ws0.label).split(", ")[1])
				{
					ind = id;
//					featInd = id;
					break;
				}
			}
			
			//			var minLayer = map.getLayer("BatiValidated") as FeatureLayer;
			//			var minLayer:FeatureLayer = featLayer;
			var myGraphicPic:Graphic = new Graphic(featLayer.graphicProvider[ind].geometry);
			if (completeCheck.selected){var pictureMarker:SimpleFillSymbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0xffaa00, 1);}
			else if (checkCheck.selected){var pictureMarker:SimpleFillSymbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0xff0000, 1);} 
			else if	(validCheck.selected){var pictureMarker:SimpleFillSymbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0x4ce600, 1);} 
			else if	(reportCheck.selected){var pictureMarker:SimpleFillSymbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0x000000, 1);}
			else {var pictureMarker:SimpleFillSymbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0xffff00, 1);}
			pictureMarker.outline = new SimpleLineSymbol("solid",0x00ffff,1,3);
			myGraphicPic.symbol = pictureMarker;
			myGraphicsLayer.add(myGraphicPic);
			
			myMiniMap.addLayer(new OpenStreetMapLayer());
			myMiniMap.addLayer(minLayer);
			myMiniMap.addLayer(myGraphicsLayer);
			
			myMiniMap.zoomTo(event.features[k].geometry);
			myMiniMap.extent = event.features[k].geometry.extent.expand(1.5);
			
			myMiniMap.logoVisible = false;
			myMiniMap.scaleBarVisible = false;
			myMiniMap.zoomSliderVisible = false;
			
			myMiniMap.attributionVisible = false;
			
			if (!bord.owns(myMiniMap))
				bord.addChild(myMiniMap);
		}
		else
		{
			if(index.ws0.owns(bord))
			{
				myGraphicsLayer.clear();
				myMiniMap.removeLayer(minLayer);
				//bord.removeChild(myMiniMap);
				index.ws0.removeChild(bord); 
				form.percentWidth = index.ws0.percentWidth;
			}
		}
	}// fin de resizeFormHandler
	
	function getInd():void
	{
		for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
		{
			if(featLayer.graphicProvider[id].attributes.OBJECTID == event.features[k].attributes.OBJECTID)
			{
				featInd = id;
				break;
			}
		}
	}
	
	function saveDatesEditedHandler(ev:CalendarLayoutChangeEvent):void
	{
		saveDatesEdited(ev, event, k, dateChoose);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
	}// fin de saveDatesEditedHandler
	
	function saveInfoEditedHandler(ev:FlexEvent):void
	{
		saveInfoEdited(ev, event, k);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
	}// fin de saveInfoEditedHandler
	
	function changeStatusHandler(ev:MouseEvent):void
	{
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
		changeStatus(event, ev, k);
	}// fin de changeStatusHandler
	
	function myFeatureLayer_editsStarted(ev:FeatureLayerEvent):void
	{
		featLayer.removeEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayer_updateEditsComplete);
		IDText.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		IDTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		AddTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		ContactTxt.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genRemInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		dateChoose.removeEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
		
		completeCheck.removeEventListener(MouseEvent.CLICK,changeStatusHandler);
		validCheck.removeEventListener(MouseEvent.CLICK,changeStatusHandler);
		checkCheck.removeEventListener(MouseEvent.CLICK,changeStatusHandler);
		reportCheck.removeEventListener(MouseEvent.CLICK,changeStatusHandler);
		
		completeCheck.enabled = false
		checkCheck.enabled = false;
		validCheck.enabled = false;
		reportCheck.enabled = false;
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
				
//				map.getLayer("BatiInEdition").refresh();
				map.getLayer("BatiValidated").refresh();
				
				featLayer.addEventListener(LayerEvent.UPDATE_END, featLayer_updateEndHandler); 
				
				function featLayer_updateEndHandler(evt:LayerEvent):void
				{
					var ind:Number;
					for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
					{
						if(featLayer.graphicProvider[id].attributes.OBJECTID == event.features[k].attributes.OBJECTID)
						{
							ind = id;
							break;
						}
					}
					event.features[k] = (!isNaN(ind))?featLayer.graphicProvider[ind]:event.features[k];
					
					if(changedStatus)
					{
						changedStatus = false;
						if(configXML.USER == "Validateur")
						{
							completeCheck.enabled = true;
							checkCheck.enabled = completeCheck.selected;
							validCheck.enabled = checkCheck.selected;
						}
						else  // Presta case
						{
							if(!isNaN(ind))
							{	
								if(featLayer.graphicProvider[ind].attibutes.COMPLETE == 'NON')
								{
									completeCheck.enabled = true;
								}
							}
							else if((index.collapsingPanel.fullScreen||!index.collapsingPanel.collapsed) && isNaN(ind))
							{
								index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
							}
							checkCheck.enabled = false;
							validCheck.enabled = false;
							//completeCheck.enabled = false;
						}
					}				
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
				
//				map.getLayer("BatiInEdition").refresh();
				map.getLayer("BatiValidated").refresh();
				
				var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
				toastMessage.imageSource = "assets/images/trash.png";
				toastMessage.sampleCaption = "Borehole deleted";
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
	
	
	function addInfoWindListener():void
	{
		IDText.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		IDTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		AddTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		ContactTxt.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genRemInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		dateChoose.addEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
		
		completeCheck.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		validCheck.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		checkCheck.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		reportCheck.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		
//		moveBut.addEventListener(MouseEvent.CLICK,moveFeatureHandler);
//		relatedBut.addEventListener(MenuEvent.ITEM_CLICK,editRelatedFeaturesHandler);
//		attachBut.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
//		deleteBut.enabled = true;
//		moveBut.enabled = true;
//		relatedBut.enabled = true;
		if(configXML.USER == "Validateur")
		{
//			completeCheck.enabled = true;
//			checkCheck.enabled = completeCheck.selected;
//			validCheck.enabled = checkCheck.selected;
		}
		else  // Presta case
		{
//			//TODO voir si complete est OUI ou NON pour l'enable ou non
//			if(event.features[k].attributes.COMPLETE == 'NON')
//			{
//				completeCheck.enabled = true;
//			}
//			checkCheck.enabled = false;
//			validCheck.enabled = false;
		}
	}// fin de addInfoWindListener
	
	
	map.infoWindow.addEventListener(flash.events.Event.CLOSE, infoWindowCloseButtonClickHandler);
	setStructArray(k,event);
	setCondArray(k,event);
//	setBatiArray(k,event);
	
	if (configXML.USER == "Consulte")
	{
		IDText.editable = false;
		IDTxt.editable = false;
		AddTxt.editable = false;
		ContactTxt.editable = false;
		genRemInput.editable = false;
		dateChoose.editable = false;
		
		index.collapsingPanel.fullScreen = true;
	}
	
	
}

function openAttachTable():void
{
	var url:String = featLayer.url;
	var indAttach:int;
	for(var i:int=0; i<featLayer.layerDetails.relationships.length; i++)
	{
		if(featLayer.layerDetails.relationships[i].name == "BCS_Baku.DBO.AttachInfo")// relation avec la table d'info des PJ
		{
			indAttach = featLayer.layerDetails.relationships[i].relatedTableId;
			url = url.split("Feature")[0];
			url += "FeatureServer/" + indAttach;
			attachFeat = new FeatureLayer(url, null, null) as FeatureLayer;
			attachFeat.token = configData.opLayers[0].token;
			attachFeat.disableClientCaching = true;
			attachFeat.refresh();
			var ind:Number;
			break;
		} 
		else 
		{
			//			Alert.show("Can't find Structure table, sorry... Please contact administrator \n"+featLayer.layerDetails.relationships[0].name+
			//				"\n"+featLayer.layerDetails.relationships[1].name+"\n"+featLayer.layerDetails.relationships[2].name);	
		}
	}
}

function setAttachArray(k:uint,event:FeatureLayerEvent)
{
	var query:Query = new Query();
	query.where = "IDBATI = '" + event.features[k].attributes.CODE.toString()+"'";
	//	query.where = "IDBATI = " + (index.ws0.label).split(", ")[2];
	//	query.where = "IDBATI = '17'";
	query.outFields = ["*"];
	attachFeat.outFields = ["*"];
	attachFeat.queryFeatures(query,new AsyncResponder(onQueryAttachResultHandler, onQueryAttachFaultHandler));
}

function onQueryAttachResultHandler(featureSet:FeatureSet, token:Object = null):void
{
	onQueryAttachResult(featureSet, attachEditsStarted,attachEditsCompleted);
}
function onQueryAttachFaultHandler(fault:Fault, token:Object = null):void
{
	onQueryAttachFault(fault);
}

function attachEditsStarted(ev:FeatureLayerEvent):void
{
	if(!attachFeat.willTrigger(FaultEvent.FAULT))
	{
		attachFeat.addEventListener(FaultEvent.FAULT, attachEditsFault);
	}
	
	if(!attachFeat.willTrigger(FeatureLayerEvent.EDITS_COMPLETE))
	{
		attachFeat.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, attachEditsCompleted);
	}
	
	//		dataGrid.removeEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);
	//		dataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgItemEditEnd);
	//		addRowToTableBut.removeEventListener(MouseEvent.CLICK,addRowToTableHandler);
	//		delRowFromTableBut.removeEventListener(MouseEvent.CLICK,delRowFromTable);
	//		addRowToTableBut.enabled = false;
	//		delRowFromTableBut.enabled = false;
	attachFeat.removeEventListener(FeatureLayerEvent.EDITS_STARTING,attachEditsStarted);	
}

function attachEditsCompleted(ev:FeatureLayerEvent):void
{
	attachFeat.removeEventListener(FaultEvent.FAULT, attachEditsFault);
	attachFeat.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, attachEditsCompleted);
	cursorManager.removeBusyCursor();
	
	attachFeat.clearSelection();
	attachFeat.refresh()
	
	if(ev.featureEditResults.addResults.length > 0)
	{
		var query:Query = new Query();
		query.where = "IDBATI = '" + (index.ws0.label).split(", ")[2] + "'";
		query.outFields = ["*"];
		attachFeat.outFields = ["*"];
		attachFeat.queryFeatures(query,new AsyncResponder(onQueryAttachResultHandler, onQueryAttachFaultHandler));
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/save.png";
		toastMessage.sampleCaption = "Added";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
		
	}
	else if(ev.featureEditResults.deleteResults.length > 0)
	{
		var query:Query = new Query();
		query.where = "IDBATI = '" + (index.ws0.label).split(", ")[2] + "'";
		query.outFields = ["*"];
		attachFeat.outFields = ["*"];
		attachFeat.queryFeatures(query,new AsyncResponder(onQueryAttachResultHandler, onQueryAttachFaultHandler));
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/trash.png";
		toastMessage.sampleCaption = "Deleted";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
		
		
	}
	else //cas du update
	{
		var query:Query = new Query();
		query.where = "IDBATI = '" + (index.ws0.label).split(", ")[2] + "'";
		query.outFields = ["*"];
		attachFeat.outFields = ["*"];
		attachFeat.queryFeatures(query,new AsyncResponder(onQueryAttachResultHandler, onQueryAttachFaultHandler));
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/save.png";
		toastMessage.sampleCaption = "Updated";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
	}
	
	//	callLater(addAllListener);
}

function attachEditsFault(ev:FaultEvent):void
{
	//		geol.removeEventListener(FaultEvent.FAULT, geolEditsFault);
	//		geol.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
	//		callLater(reloadIfFault);
	//		geol.refresh();
	attachFeat.removeEventListener(FaultEvent.FAULT, condEditsFault);
	attachFeat.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, attachEditsCompleted);
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/error.png";
	toastMessage.sampleCaption = ev.fault.faultCode + ev.fault.faultDetail;
	toastMessage.timeToLive = 2;
	index.simpleToaster.toast(toastMessage);
}

function openStructTable():void
{
	var url:String = featLayer.url;
	var indStruct:int;
	for(var i:int=0; i<featLayer.layerDetails.relationships.length; i++)
	{
		if(featLayer.layerDetails.relationships[i].name == "BCS_Baku.DBO.Structure")
		{
			indStruct = featLayer.layerDetails.relationships[i].relatedTableId;
			url = url.split("Feature")[0];
			url += "FeatureServer/" + indStruct;
			struct = new FeatureLayer(url, null, null) as FeatureLayer;
			struct.token = configData.opLayers[0].token;
			struct.disableClientCaching = true;
			struct.refresh();
			var ind:Number;
			break;
		} 
		else 
		{
//			Alert.show("Can't find Structure table, sorry... Please contact administrator");	
		}
	}
}

function openCondTable():void
{
	var url:String = featLayer.url;
	var indCond:int;
	for(var i:int=0; i<featLayer.layerDetails.relationships.length; i++)
	{
		if(featLayer.layerDetails.relationships[i].name == "BCS_Baku.DBO.Condition")
		{
			indCond = featLayer.layerDetails.relationships[i].relatedTableId;
			url = url.split("Feature")[0];
			url += "FeatureServer/" + indCond;
			cond = new FeatureLayer(url, null, null) as FeatureLayer;
			cond.token = configData.opLayers[0].token;
			cond.disableClientCaching = true;
			cond.refresh();
			var ind:Number;
			break;
		} 
		else 
		{
//			Alert.show("Can't find Condition table, sorry... Please contact administrator");	
		}
	}
}

function setCondArray(k:uint,event:FeatureLayerEvent)
{
	var query:Query = new Query();
	query.where = "IDBATI = " + event.features[k].attributes.OBJECTID.toString();
	query.outFields = ["*"];
	cond.outFields = ["*"];
	cond.queryFeatures(query,new AsyncResponder(onQueryCondResultHandler, onQueryCondFaultHandler));
}

function onQueryCondResultHandler(featureSet:FeatureSet, token:Object = null):void
{
	onQueryCondResult(featureSet, condEditsStarted);
}
function onQueryCondFaultHandler(fault:Fault, token:Object = null):void
{
	onQueryCondFault(fault);
}

function condEditsStarted(ev:FeatureLayerEvent):void
{
	if(!geol.willTrigger(FaultEvent.FAULT))
	{
		cond.addEventListener(FaultEvent.FAULT, condEditsFault);
	}
	
	if(!geol.willTrigger(FeatureLayerEvent.EDITS_COMPLETE))
	{
		cond.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, condEditsCompleted);
	}
	
	//		dataGrid.removeEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);
	//		dataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgItemEditEnd);
	//		addRowToTableBut.removeEventListener(MouseEvent.CLICK,addRowToTableHandler);
	//		delRowFromTableBut.removeEventListener(MouseEvent.CLICK,delRowFromTable);
	//		addRowToTableBut.enabled = false;
	//		delRowFromTableBut.enabled = false;
			cond.removeEventListener(FeatureLayerEvent.EDITS_STARTING,condEditsStarted);	
}

function condEditsCompleted(ev:FeatureLayerEvent):void
{
	
	cond.removeEventListener(FaultEvent.FAULT, condEditsFault);
	cond.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, condEditsCompleted);
	cursorManager.removeBusyCursor();
	
	cond.clearSelection();
	cond.refresh()
	
	if(ev.featureEditResults.addResults.length > 0)
	{
		var query:Query = new Query();
		query.where = "IDBATI = " + condArray[1];
		query.outFields = ["*"];
		cond.outFields = ["*"];
		cond.queryFeatures(query,new AsyncResponder(onQueryCondResultHandler, onQueryCondFaultHandler));
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/trash.png";
		toastMessage.sampleCaption = "Added";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
		
	}
	else if(ev.featureEditResults.deleteResults.length > 0)
	{
		var query:Query = new Query();
		//		query.where = "IDBATI = " + event.features[k].attributes.OBJECTID;
		query.outFields = ["*"];
		cond.outFields = ["*"];
		cond.queryFeatures(query,new AsyncResponder(onQueryCondResultHandler, onQueryCondFaultHandler));
		
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
	
	//	callLater(addAllListener);
}

function condEditsFault(ev:FaultEvent):void
{
	//		geol.removeEventListener(FaultEvent.FAULT, geolEditsFault);
	//		geol.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
	//		callLater(reloadIfFault);
	//		geol.refresh();
	cond.removeEventListener(FaultEvent.FAULT, structEditsFault);
	cond.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, structEditsCompleted);
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/error.png";
	toastMessage.sampleCaption = ev.fault.faultCode + ev.fault.faultDetail;
	toastMessage.timeToLive = 2;
	index.simpleToaster.toast(toastMessage);
}

function setStructArray(k:uint,event:FeatureLayerEvent)
{
	var query:Query = new Query();
	query.where = "IDBATI = " + event.features[k].attributes.OBJECTID.toString();
	query.outFields = ["*"];
	struct.outFields = ["*"];
	struct.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
}

function onQueryResultHandler(featureSet:FeatureSet, token:Object = null):void
{
	onQueryResult(featureSet, structEditsStarted);
}
function onQueryFaultHandler(fault:Fault, token:Object = null):void
{
	onQueryFault(fault);
}

function structEditsStarted(ev:FeatureLayerEvent):void
{
	if(!struct.willTrigger(FaultEvent.FAULT))
	{
		struct.addEventListener(FaultEvent.FAULT, structEditsFault);
	}
	
	if(!struct.willTrigger(FeatureLayerEvent.EDITS_COMPLETE))
	{
		struct.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, structEditsCompleted);
	}
	
	//		dataGrid.removeEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);
	//		dataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT,dgItemEditEnd);
	//		addRowToTableBut.removeEventListener(MouseEvent.CLICK,addRowToTableHandler);
	//		delRowFromTableBut.removeEventListener(MouseEvent.CLICK,delRowFromTable);
	//		addRowToTableBut.enabled = false;
	//		delRowFromTableBut.enabled = false;
			struct.removeEventListener(FeatureLayerEvent.EDITS_STARTING,structEditsStarted);	
}

function structEditsCompleted(ev:FeatureLayerEvent):void
{
	
	struct.removeEventListener(FaultEvent.FAULT, structEditsFault);
	struct.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, structEditsCompleted);
	cursorManager.removeBusyCursor();
	
	struct.clearSelection();
	struct.refresh();
	
	if(ev.featureEditResults.addResults.length > 0)
	{
		addResults = geolGridSource.length;
		var query:Query = new Query();
		query.where = "IDBATI = " + structArray[2];
		query.outFields = ["*"];
		struct.outFields = ["*"];
		struct.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
		
		var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
		toastMessage.imageSource = "assets/images/trash.png";
		toastMessage.sampleCaption = "Added";
		toastMessage.timeToLive = 2;
		index.simpleToaster.toast(toastMessage);
		
	}
	else if(ev.featureEditResults.deleteResults.length > 0)
	{
		var query:Query = new Query();
		//		query.where = "IDBATI = " + event.features[k].attributes.OBJECTID;
		query.outFields = ["*"];
		struct.outFields = ["*"];
		struct.queryFeatures(query,new AsyncResponder(onQueryResultHandler, onQueryFaultHandler));
		
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
	
	//	callLater(addAllListener);
}

function structEditsFault(ev:FaultEvent):void
{
	//		geol.removeEventListener(FaultEvent.FAULT, geolEditsFault);
	//		geol.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, geolEditsCompleted);
	//		callLater(reloadIfFault);
	//		geol.refresh();
	struct.removeEventListener(FaultEvent.FAULT, structEditsFault);
	struct.removeEventListener(FeatureLayerEvent.EDITS_COMPLETE, structEditsCompleted);
	
	var toastMessage:ToastMessageUbuntu = new ToastMessageUbuntu;
	toastMessage.imageSource = "assets/images/error.png";
	toastMessage.sampleCaption = ev.fault.faultCode + ev.fault.faultDetail;
	toastMessage.timeToLive = 2;
	index.simpleToaster.toast(toastMessage);
}


