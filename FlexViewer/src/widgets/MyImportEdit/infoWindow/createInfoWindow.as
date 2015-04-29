import widgets.MyImportEdit.MyEditWidget;

import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.SpatialReference;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.layers.GraphicsLayer;
import com.esri.ags.layers.Layer;
import com.esri.ags.layers.OpenStreetMapLayer;
import com.esri.ags.symbols.SimpleMarkerSymbol;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.ags.tools.DrawTool;
import com.esri.ags.utils.WebMercatorUtil;
import com.esri.viewer.AppEvent;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.collections.ArrayCollection;
import mx.containers.Canvas;
import mx.containers.Form;
import mx.containers.FormItem;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.Label;
import mx.controls.Menu;
import mx.controls.PopUpMenuButton;
import mx.controls.Text;
import mx.controls.TextArea;
import mx.controls.TextInput;
import mx.core.ScrollPolicy;
import mx.core.mx_internal;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.ResizeEvent;
import mx.events.StateChangeEvent;
import mx.formatters.DateFormatter;
import mx.formatters.NumberFormatter;
import mx.managers.PopUpManager;
import mx.rpc.AsyncResponder;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;
import mx.skins.halo.HaloBorder;

import spark.components.CheckBox;
import spark.components.RichText;
import spark.components.TextArea;
import spark.components.TitleWindow;
import spark.components.VGroup;

import flexlib.containers.WindowShade;

import mySkins.MySkins2;

import widgets.MapSwitcher.Basemap;
import widgets.MyImportEdit.MyEditWidget;
import widgets.Samples.TestOpenClose.TestOpenCloseWidget;

// ActionScript file

public function createInfoWindow(k:uint,event:FeatureLayerEvent, ndFeatSel:Number):void
{	
	
	AppEvent.addListener(AppEvent.COLLAPSE_PANEL_RESIZE, resizeFormHandler);
  
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
	
	
	if(configXML.USER == "Validateur")
	{
		var service:HTTPService = new HTTPService(); 
		service.resultFormat = "e4x";
		service.url = "https://sygdev.systra.info/LOCA_LOCA.xml";
		service.addEventListener(ResultEvent.RESULT, resultHandlerHoleType); 
		service.send(); 
		
		
		var siteLocaList:mx.controls.ComboBox = new ComboBox();
		function resultHandlerHoleType(evt:ResultEvent):void
		{
			if(dpSiteLocation.length > 1)
			{
				dpSiteLocation = new ArrayCollection();
				dpSiteLocation.addItem({label:"Other", data:""});
			}
			//Remplissage de dpValue
			var xmlResult:XML = new XML(evt.result);
			for each(var s:XML in xmlResult.Site)
			{						
				var tmpObj: Object = {label:s, data: s};
				dpSiteLocation.addItem(tmpObj);
			}
			
			siteLocaList.setStyle('color', 0x000000);
			siteLocaList.dataProvider = dpSiteLocation;
			cursorManager.removeBusyCursor();
		}
	}
	
	
	form = new Form();
	form.id="editform";
	index.ws0.width = index.collapsingPanel.explicitWidth;
	form.setStyle('horizontalScrollPolicy', ScrollPolicy.AUTO);

	form.name = "editForm";
	if (ndFeatSel>1) // Si plusieurs "feat" de sélectionner => ajout des boutons précédent et suivant
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
	
	var hBox12:HBox = new HBox();
	
	var reExp:RegExp = /[.]/gi;
	
	
	//Mise en place hBox12: Id & Type
	var holeIDItem:FormItem = new FormItem();
	holeIDItem.label = "ID_LOCA";
	var locaId:mx.controls.TextInput = new mx.controls.TextInput();
	locaId.setStyle('color', 0x000000);
	if (event.features[k].attributes.HOLE_ID != null)
	{
		locaId.text = event.features[k].attributes.HOLE_ID;
	}
	else
	{
		locaId.text = "";
	}
	locaId.width = 100;
	locaId.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	locaId.name = "locaId";
	holeIDItem.required = true;
	holeIDItem.setStyle('indicatorGap', 43);
	holeIDItem.setStyle('paddingRight',13);
	holeIDItem.addChild(locaId);
	hBox12.addChild(holeIDItem);
	var holeTypeItem:FormItem = new FormItem();
	holeTypeItem.label = "Hole Type";
	holeTypeItem.setStyle('indicatorGap', 54);
	var holeTypeList:mx.controls.ComboBox = new ComboBox();
	holeTypeList.setStyle('color', 0x000000);
	holeTypeList.dataProvider = index.holeType.dataProvider;				
//	if (event.features[k].attributes.HOLE_TYPE != null)
//	{
//		holeTypeList.selectedIndex = 0;
//		var len:int = index.holeType.dataProvider.length;
//		for (var j:int = 0; j < len; j++) 
//		{
//			if (holeTypeList.dataProvider[j].data == event.features[k].attributes.HOLE_TYPE) 
//			{
//				holeTypeList.selectedIndex = j;
//				break;
//			}
//		}
//	}
//	else
//	{
		holeTypeList.selectedIndex = 0;
//	}
	holeTypeList.name = "holeTypeList";
	holeTypeList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
	holeTypeItem.addChild(holeTypeList);
	hBox12.addChild(holeTypeItem);
	form.addChild(hBox12);
	
	
	// Mise en place de la Grid:
	grid = new Grid();
	grid.name = "gird";
	
	var gridRow1:GridRow = new GridRow();
	gridRow1.name = "gridRow1";
	gridRow1.height = 25;
	
	var projItem:GridItem = new GridItem();
	projItem.setStyle("verticalAlign", "middle");
	var projLabel:Label = new Label();
	projLabel.text = "Project Name:";
	projItem.addChild(projLabel);
	gridRow1.addChild(projItem);
	
	//if(configXML.USER != "Validateur"){
		
		var projChooseItem:GridItem = new GridItem();
		projChooseItem.setStyle('indicatorGap', 54);
		var projList:mx.controls.ComboBox = new ComboBox();
		projList.setStyle('color', 0x000000);
		projList.dataProvider = MyEditWidget.dpProj;				
//		if (event.features[k].attributes.PROJ_ID != null)
//		{
//			projList.selectedIndex = 0;
//			var len:int = MyEditWidget.dpProj.length;
//			for (var j:int = 0; j < len; j++) 
//			{
//				if (MyEditWidget.dpProj[j].data == event.features[k].attributes.PROJ_ID) 
//				{
//					projList.selectedIndex = j;
//					break;
//				}
//			}
//		}
//		else
//		{
			projList.selectedIndex = 0;
//		}
		projList.name = "projList";
		projList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		projChooseItem.addChild(projList);
		
		gridRow1.addChild(projChooseItem);
	//}
	/*else
	{
		var projChooseItem:GridItem = new GridItem();
		projChooseItem.setStyle('indicatorGap', 54);
		var projList:mx.controls.ComboBox = new ComboBox();
		projList.setStyle('color', 0x000000);
		projList.dataProvider = MyEditWidget.dpProj;				
		if (event.features[k].attributes.PROJ_ID != null)
		{
			projList.selectedIndex = 0;
			var len:int = MyEditWidget.dpProj.length;
			for (var j:int = 0; j < len; j++) 
			{
				if (MyEditWidget.dpProj[j].data == event.features[k].attributes.PROJ_ID) 
				{
					projList.selectedIndex = j;
					break;
				}
			}
		}
		else
		{
			projList.selectedIndex = 0;
		}
		projList.name = "projList";
		projList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		projChooseItem.addChild(projList);
		
		gridRow1.addChild(projChooseItem);
	}*/
	
	grid.addChild(gridRow1);
	
	var gridRow3:GridRow = new GridRow();
	gridRow3.name = "gridRow3";
	var eastingItem:GridItem = new GridItem();
	eastingItem.setStyle("verticalAlign", "middle");
	var eastingValue:GridItem = new GridItem();
	eastingValue.setStyle("verticalAlign", "middle");
	
	var eastingLabel:Label = new Label();
	eastingLabel.text = "Easting (m) : ";
	eastingItem.addChild(eastingLabel);
	var eastingLabelValue:Label = new Label();
	var eastVal:String = (event.features[k].geometry.x).toFixed(3).toString();
	if((event.features[k].geometry.x).toFixed(3).toString().search(reExp) > -1)
	{
		eastVal = (event.features[k].geometry.x).toFixed(3).toString().replace(reExp,",");
	}
	eastingLabelValue.text = eastVal;
	eastingLabelValue.setStyle('color', 0x000000);
	eastingValue.addChild(eastingLabelValue);
	
	gridRow3.addChild(eastingItem);
	gridRow3.addChild(eastingValue);
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	
	gridRow3.addChild(gridItemEmpty);
	
	var localXItem:GridItem = new GridItem();
	localXItem.setStyle("verticalAlign", "middle");
	
	var localXLabel:Label = new Label();
	localXLabel.text = "Local X (m) : "
	localXItem.addChild(localXLabel);
	
	gridRow3.addChild(localXItem);
	
	var localXValue:GridItem = new GridItem();
	localXValue.setStyle("verticalAlign", "middle");
	
	var localXInput:mx.controls.TextInput = new mx.controls.TextInput();
	localXInput.setStyle('color', 0x000000);
	if (event.features[k].attributes.HOLE_LOCX == null)
	{
		localXInput.text = "";
	}
	else
	{
		var locX:String = parseFloat(event.features[k].attributes.HOLE_LOCX).toFixed(3).toString();
		if(locX.search(reExp) > -1)
		{
			locX = locX.replace(reExp,",");
		}
		
		localXInput.text = locX;
	}
	localXInput.name = "localXInput";
	localXInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	localXValue.addChild(localXInput);
	
	gridRow3.addChild(localXValue);
	
	grid.addChild(gridRow3);
	
	var gridRow4:GridRow = new GridRow();
	gridRow4.name = "gridRow4";
	var northingItem:GridItem = new GridItem();
	
	northingItem.setStyle("verticalAlign", "middle");
	var northingValue:GridItem = new GridItem();
	northingValue.setStyle("verticalAlign", "middle");
	
	var northingLabel:Label = new Label();
	northingLabel.text = "Northing (m) : "
	northingItem.addChild(northingLabel);
	var northingLabelValue:Label = new Label();
	northingLabelValue.setStyle('color', 0x000000);
	var northVal:String = (event.features[k].geometry.y).toFixed(3).toString();
	if((event.features[k].geometry.y).toFixed(3).toString().search(reExp) > -1)
	{
		northVal = (event.features[k].geometry.y).toFixed(3).toString().replace(reExp,",");
	}
	
	northingLabelValue.text = northVal;
	northingValue.addChild(northingLabelValue);
	
	gridRow4.addChild(northingItem);
	gridRow4.addChild(northingValue);
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow4.addChild(gridItemEmpty);
	
	var localYItem:GridItem = new GridItem();
	localYItem.setStyle("verticalAlign", "middle");
	
	var localYLabel:Label = new Label();
	localYLabel.text = "Local Y (m) : "
	localYItem.addChild(localYLabel);
	
	gridRow4.addChild(localYItem);
	
	
	var localYValue:GridItem = new GridItem();
	localYValue.setStyle("verticalAlign", "middle");
	var localYInput:mx.controls.TextInput = new mx.controls.TextInput();
	localYInput.setStyle('color', 0x000000);
	
	if (event.features[k].attributes.HOLE_LOCY == null)
	{
		localYInput.text = "";
	}
	else
	{
		var locY:String = parseFloat(event.features[k].attributes.HOLE_LOCY).toFixed(3).toString();
		if(locY.search(reExp) > -1)
		{
			locY = locY.replace(reExp,",");
		}
		localYInput.text = locY;
	}
	localYInput.name = "localYInput";
	localYInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	localYValue.addChild(localYInput);
	
	gridRow4.addChild(localYValue);
	
	grid.addChild(gridRow4);
	
	
	var gridRow5:GridRow = new GridRow();
	gridRow5.name = "gridRow5";
	
	var groundLevelItem:GridItem = new GridItem();
	groundLevelItem.setStyle("verticalAlign", "middle");
	
	var groundLabel:Label = new Label();
	groundLabel.text = "Ground Level (m) :  ";
	groundLevelItem.addChild(groundLabel);
	gridRow5.addChild(groundLevelItem);
	
	var groundLevelValue:GridItem = new GridItem();
	groundLevelValue.setStyle("verticalAlign", "middle");
	var groundLevelInput:mx.controls.TextInput = new mx.controls.TextInput();
	groundLevelInput.setStyle('color', 0x000000);
	groundLevelInput.width = 72;
//	if (event.features[k].attributes.LOCA_GL == null)
//	{
		groundLevelInput.text = "";
//	}
//	else
//	{
//		var grdLev:String = parseFloat(event.features[k].attributes.LOCA_GL).toFixed(2).toString();
//		if(grdLev.search(reExp) > -1)
//		{
//			grdLev = grdLev.replace(reExp,",");
//		}
//		groundLevelInput.text = grdLev;
//	}
	
	groundLevelInput.name = "groundLevelInput";
	groundLevelInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	
	groundLevelValue.addChild(groundLevelInput);
	gridRow5.addChild(groundLevelValue);
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow5.addChild(gridItemEmpty);
	
	var localZItem:GridItem = new GridItem();
	localZItem.setStyle("verticalAlign", "middle");
	
	var localZLabel:Label = new Label();
	localZLabel.text = "Local Z (m) : "
	localZItem.addChild(localZLabel);
	
	gridRow5.addChild(localZItem);
	
	var localZValue:GridItem = new GridItem();
	localZValue.setStyle("verticalAlign", "middle");
	var localZInput:mx.controls.TextInput = new mx.controls.TextInput();
	localZInput.setStyle('color', 0x000000);
	if (event.features[k].attributes.HOLE_LOCZ == null)
	{
		localZInput.text = "";
	}
	else
	{
		var locZ:String = parseFloat(event.features[k].attributes.HOLE_LOCZ).toFixed(3).toString();
		if(locZ.search(reExp) > -1)
		{
			locZ = locZ.replace(reExp,",");
		}
		localZInput.text = locZ;
	}
	localZInput.name = "localZInput";
	localZInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	localZValue.addChild(localZInput);
	
	gridRow5.addChild(localZValue);
	
	grid.addChild(gridRow5);
	
	
	var gridRow6:GridRow = new GridRow();
	gridRow6.name = "gridRow6";
	
	var holeDepthItem:GridItem = new GridItem();
	holeDepthItem.setStyle("verticalAlign", "middle");
	
	var holeDepthLabel:Label = new Label();
	holeDepthLabel.text = "Hole depth (m) : "
	holeDepthItem.addChild(holeDepthLabel);
	gridRow6.addChild(holeDepthItem);
	
	var holeDepthValue:GridItem = new GridItem();
	holeDepthValue.setStyle("verticalAlign", "middle");
	var holeDepthInput:mx.controls.TextInput = new mx.controls.TextInput();
	holeDepthInput.setStyle('color', 0x000000);
	holeDepthInput.width = 72;
	if (event.features[k].attributes.HOLE_FDEP == null)
	{
		holeDepthInput.text = "";
	}
	else
	{
		var holeDep:String = parseFloat(event.features[k].attributes.HOLE_FDEP).toFixed(2).toString();
		if(holeDep.search(reExp) > -1)
		{
			holeDep = holeDep.replace(reExp,",");
		}
		holeDepthInput.text = holeDep;
	}
	holeDepthInput.name = "holeDepthInput";
	holeDepthInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	holeDepthValue.addChild(holeDepthInput);
	
	var helpHoleDepthLabel:Label = new Label();
	helpHoleDepthLabel.text = " (>0)";
	holeDepthValue.addChild(helpHoleDepthLabel);
	
	gridRow6.addChild(holeDepthValue);
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow6.addChild(gridItemEmpty);
	
	var CoordSysItem:GridItem = new GridItem();
	CoordSysItem.setStyle("verticalAlign", "middle");
	
	
	var CoordSysLabel:Label = new Label();
	CoordSysLabel.text = "Coordinate System :  "
	CoordSysItem.addChild(CoordSysLabel);
	gridRow6.addChild(CoordSysItem);
	
	var CoordSysValue:GridItem = new GridItem();
	CoordSysValue.setStyle("verticalAlign", "middle");
	
	var CoordSysInput:mx.controls.TextInput = new mx.controls.TextInput();
	CoordSysInput.setStyle('color', 0x000000);
//	if (event.features[k].attributes.LOCA_LREF == null)
//	{
		CoordSysInput.text = "";
//	}
//	else
//	{
//		CoordSysInput.text = event.features[k].attributes.LOCA_LREF;
//	}
	CoordSysInput.name = "CoordSysInput";
	CoordSysInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	CoordSysValue.addChild(CoordSysInput);
	gridRow6.addChild(CoordSysValue);
	
	grid.addChild(gridRow6);
	
	
	var gridRow7:GridRow = new GridRow();
	gridRow7.name = "gridRow7";
	
	var startDateItem:GridItem = new GridItem();
	startDateItem.setStyle("verticalAlign", "middle");
	
	
	var startDateLabel:Label = new Label();
	startDateLabel.text = "Starting Date : "
	startDateItem.addChild(startDateLabel);
	gridRow7.addChild(startDateItem);
	
	var startDateValue:GridItem = new GridItem();
	startDateValue.setStyle("verticalAlign", "middle");
	
	
	var startDateChoose:DateField = new DateField();
	startDateChoose.setStyle('color', 0x000000);
	startDateChoose.formatString = "YYYY-MM-DD";
	startDateChoose.yearNavigationEnabled=true;
	
//	if (event.features[k].attributes.LOCA_STAR != null)
//	{
//		var myDate:Date = new Date(event.features[k].attributes.LOCA_STAR);
//		var myDF:DateFormatter = new DateFormatter();
//		myDF.formatString = "YYYY-MM-DD";
//		
//		startDateChoose.text = myDF.format(myDate);
//	}
	startDateChoose.name = "startDateChoose";
	startDateChoose.addEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
	
	startDateValue.addChild(startDateChoose);
	gridRow7.addChild(startDateValue);
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow7.addChild(gridItemEmpty);
	
	var endDateItem:GridItem = new GridItem();
	endDateItem.setStyle("verticalAlign", "middle");
	
	var endDateLabel:Label = new Label();
	endDateLabel.text = "Ending Date : ";
	endDateItem.addChild(endDateLabel);
	gridRow7.addChild(endDateItem);
	
	var endDateValue:GridItem = new GridItem();
	endDateValue.setStyle("verticalAlign", "middle");
	
	
	var endDateChoose:DateField = new DateField();
	endDateChoose.formatString = "YYYY-MM-DD";
	endDateChoose.yearNavigationEnabled=true;

	endDateChoose.setStyle('color', 0x000000);
	
//	if (event.features[k].attributes.LOCA_ENDD != null)
//	{
//		var myEndDate:Date = new Date(event.features[k].attributes.LOCA_ENDD);
//		var myEndDF:DateFormatter = new DateFormatter();
//		myEndDF.formatString = "YYYY-MM-DD";
//		
//		endDateChoose.text = myEndDF.format(myEndDate);
//	}
	endDateChoose.name = "endDateChoose";
	endDateChoose.addEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
	
	
	
	endDateValue.addChild(endDateChoose);
	gridRow7.addChild(endDateValue);
	
	grid.addChild(gridRow7);
	
	var gridRow8:GridRow = new GridRow();
	gridRow8.name = "gridRow8";
	var genRemItem:GridItem = new GridItem();
	genRemItem.setStyle("verticalAlign", "middle");
	var genLabel:Label = new Label();
	genLabel.text = "General remarks : ";
	genRemItem.addChild(genLabel);
	gridRow8.addChild(genRemItem);
	
	var genRemValue:GridItem = new GridItem();
	var genRemInput:spark.components.TextArea = new spark.components.TextArea();
	
	genRemInput.setStyle('color', 0x000000);
//	if (event.features[k].attributes.LOCA_REM == null)
//	{
		genRemInput.text = "";
//	}
//	else
//	{
//		genRemInput.text = event.features[k].attributes.LOCA_REM;
//	}
	genRemValue.colSpan = (4);
	genRemInput.name = "genRemInput";
	genRemInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
	genRemInput.percentWidth = 100;
	genRemInput.height = 60;
	genRemValue.addChild(genRemInput);
	
	gridRow8.addChild(genRemValue);
	grid.addChild(gridRow8);
	
	var gridRow8Bis:GridRow = new GridRow();
	gridRow8Bis.name = "gridRow8Bis";
	gridRow8Bis.height = 10;
	grid.addChild(gridRow8Bis);
	
	if(configXML.USER == "Validateur"){
		
		var gridRow9:GridRow = new GridRow();
		gridRow9.name = "gridRow9";
		var gridRow10:GridRow = new GridRow();
		gridRow10.name = "gridRow10";
		var siteLocaItem:GridItem = new GridItem();
		var siteLocaLabel:Label = new Label();
		siteLocaLabel.text = "Site location : ";
		siteLocaItem.addChild(siteLocaLabel);
		gridRow9.addChild(siteLocaItem);
		
		var siteLocaValue:GridItem = new GridItem();
		
		
		var otherSiteLoca:mx.controls.TextInput = new mx.controls.TextInput();
		otherSiteLoca.visible = false;
		
//		if (event.features[k].attributes.LOCA_LOCA != null)
//		{
//			siteLocaList.selectedIndex = 0;
//			otherSiteLoca.visible = true;
//			
//			var len:int = siteLocaList.dataProvider.length;
//			for (var j:int = 0; j < len; j++) 
//			{
//				if (siteLocaList.dataProvider[j].label == event.features[k].attributes.LOCA_LOCA) 
//				{
//					siteLocaList.selectedIndex = j;
//					otherSiteLoca.visible = false;
//					break;
//				}
//			}					
//		}
//		else
//		{
			siteLocaList.selectedIndex = 0;
			otherSiteLoca.visible = true;
//		}
		siteLocaList.name = "siteLocaList";
		siteLocaList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
		otherSiteLoca.name = "otherSiteLoca";
		otherSiteLoca.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		
		siteLocaValue.addChild(siteLocaList);
		gridRow9.addChild(siteLocaValue);
		
		var gridItemEmpty:GridItem = new GridItem();
		gridItemEmpty.width = 15;
		
		gridRow9.addChild(gridItemEmpty);
		
		var investPhaseItem:GridItem = new GridItem();
		var investPhaseLabel:Label = new Label();
		investPhaseLabel.text = "Investigation phase : ";
		investPhaseItem.addChild(investPhaseLabel);
		var investPhaseValue:GridItem = new GridItem();
		var investPhaseInput:mx.controls.TextInput = new mx.controls.TextInput();
		investPhaseInput.setStyle('color', 0x000000);
//		if (event.features[k].attributes.LOCA_CLST == null)
//		{
			investPhaseInput.text = "";
//		}
//		else
//		{
//			investPhaseInput.text = event.features[k].attributes.LOCA_CLST;
//		}
		investPhaseInput.name = "investPhaseInput";
		investPhaseInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		investPhaseValue.addChild(investPhaseInput);
		gridRow9.addChild(investPhaseItem);
		gridRow9.addChild(investPhaseValue);
		grid.addChild(gridRow9);
		
		var gridItemEmpty:GridItem = new GridItem();
		gridRow10.addChild(gridItemEmpty);
		
		var otherSiteItem:GridItem = new GridItem();
		otherSiteItem.colSpan = 4;
		otherSiteItem.addChild(otherSiteLoca);
		gridRow10.addChild(otherSiteItem);
		
		
		grid.addChild(gridRow10);
		
	}
	
	grid.setStyle("horizontalGap", 0);
	grid.setStyle("verticalGap",2);
	form.addChild(grid);
	
	
	var hBoxStatus:HBox = new HBox();
	hBoxStatus.name = "hBoxStatus";
	var completeCheck:spark.components.CheckBox = new spark.components.CheckBox();
	completeCheck.label = "Completed";
	completeCheck.addEventListener(MouseEvent.CLICK, changeStatusHandler);
	completeCheck.setStyle('skinClass', Class(mySkins.MySkins2));

	hBoxStatus.addChild(completeCheck);

	var checkCheck:spark.components.CheckBox = new spark.components.CheckBox();
	checkCheck.label = "Checked";
	checkCheck.addEventListener(MouseEvent.CLICK, changeStatusHandler);
	checkCheck.setStyle('skinClass', Class(mySkins.MySkins2));

	hBoxStatus.addChild(checkCheck);

	var validCheck:spark.components.CheckBox = new spark.components.CheckBox();
	validCheck.label = "Validated";
	validCheck.addEventListener(MouseEvent.CLICK, changeStatusHandler);
	validCheck.setStyle('skinClass', Class(mySkins.MySkins2));

	hBoxStatus.addChild(validCheck);
//	completeCheck.selected = event.features[k].attributes.COMPLETE == "OUI" ? true : false; 
//	checkCheck.selected = event.features[k].attributes.CHECK_ == "OUI" ? true : false; 
//	validCheck.selected = event.features[k].attributes.VALID == "OUI" ? true : false; 

	completeCheck.selected = false; 
	checkCheck.selected = false; 
	validCheck.selected = false; 
	
	if(configXML.USER == "Validateur")
	{
		checkCheck.enabled = completeCheck.selected;
		validCheck.enabled = checkCheck.selected;
	}
	else  // Presta case
	{
		checkCheck.enabled = false;
		validCheck.enabled = false;
	}

	var hBoxBas:HBox = new HBox();
	hBoxBas.name = "hBoxBas";
	
	var buttonItem:FormItem = new FormItem();
	buttonItem.name = "butItem";

	var deleteBut:Button = new Button();
	deleteBut.label="Delete";
	hBoxBas.addChild(deleteBut);
	deleteBut.addEventListener(MouseEvent.CLICK,deleteFeatureHandler);

	var moveBut:Button = new Button();
	moveBut.label="Move";
	hBoxBas.addChild(moveBut);
	moveBut.addEventListener(MouseEvent.CLICK,moveFeatureHandler);

	
	var relatedBut:PopUpMenuButton = new PopUpMenuButton();
	relatedBut.name = "relatedBut";
	relatedBut.dataProvider = myMenuData;
	relatedBut.labelField = "@label";
	relatedBut.showRoot = false;
	hBoxBas.addChild(relatedBut);
	relatedBut.addEventListener(MenuEvent.ITEM_CLICK,editRelatedFeaturesHandler);

	
	var attachBut:Button = new Button();
	attachBut.name = "editAttach";
	attachBut.label = "Edit attachments";
	hBoxBas.addChild(attachBut);
	attachBut.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);

	
	buttonItem.addChild(hBoxStatus);
	buttonItem.addChild(hBoxBas);
	
	form.addChild(buttonItem);
	if (event.features[k].attributes.HOLE_ID != null)
	{
		index.ws0.label = event.features[k].attributes.HOLE_ID.toString() +", "+ event.features[k].attributes.OBJECTID.toString() ;
	}
	else
	{
		index.ws0.label = "No Title, " + event.features[k].attributes.OBJECTID.toString() ;
	}

	map.infoWindowContent = null;
	var infoPoint:MapPoint = event.features[k].geometry;
	var rt:RichText = new RichText();
	rt.text = event.features[k].attributes.HOLE_ID.toString();
	map.infoWindow.label = rt.text;
	map.infoWindow.show(infoPoint);
	
	myGraphicsLayer.clear(); 
	if(!index.collapsingPanel.collapsed)
	{
		index.ws0.removeAllChildren();
		index.ws0.visible = true;
		index.ws0.width = index.collapsingPanel.explicitWidth;
		index.ws0.addChild(form);
		
		index.ws0.opened = true;
		
		if(index.collapsingPanel.fullScreen)
		{
			bord.minWidth = 150;
			bordbis.percentWidth = bord.percentWidth;
			bordbis.height = bord.height;
			index.ws0.addChild(bord);
			index.ws0.getChildByName("bord").getChildAt(1).zoomTo(event.features[k].geometry);
			if(index.ws0.getChildByName("bord").getChildAt(1).getLayer(minLayer) != null)
			{
				index.ws0.getChildByName("bord").getChildAt(1).addLayer(minLayer, 0);
			}
			
			var myGraphicPic:Graphic = new Graphic(event.features[k].geometry);
			var pictureMarker:SimpleMarkerSymbol = new SimpleMarkerSymbol("circle", 15, 0xd22228)
			myGraphicPic.symbol = pictureMarker;
			myGraphicsLayer.add(myGraphicPic);
		}
	}
	else
	{
		index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}

	if(index.ws1.visible)
	{
		var menu:Menu = new Menu();
		menu.showRoot = false;
		menu.dataProvider = myMenuData;
		relatedBut.dispatchEvent(new MenuEvent(MenuEvent.ITEM_CLICK, false, true, null, menu, XML, null, lastClicked,0));
	}

	AppEvent.addListener(AppEvent.COLLAPSE_PANEL_OPENED_END, openWS0Handler);
	
	function openWS0Handler(ev:AppEvent):void
	{
		index.ws0.removeAllChildren();
		index.ws0.visible = true;
		index.ws0.addChild(form);
		index.ws0.width = index.collapsingPanel.explicitWidth;
		form.percentWidth = index.ws0.percentWidth;
		index.ws0.opened = true;
		AppEvent.removeListener(AppEvent.COLLAPSE_PANEL_OPENED_END, openWS0Handler);

	}
	
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
			//myMiniMap.mask = bordbis;
			myMiniMap.visible = true;
			myMiniMap.navigationClass = null;
			
			minLayer = new FeatureLayer(featLayer.url, featLayer.proxyURL, featLayer.token) as FeatureLayer;
			
			var ind:Number;
			for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
			{
				if(featLayer.graphicProvider[id].attributes.OBJECTID == (index.ws0.label).split(", ")[1])
				{
					ind = id;
					break;
				}
			}
			
			var myGraphicPic:Graphic = new Graphic(featLayer.graphicProvider[ind].geometry);
			var pictureMarker:SimpleMarkerSymbol = new SimpleMarkerSymbol("circle", 15, 0xd22228)
			myGraphicPic.symbol = pictureMarker;
			myGraphicsLayer.add(myGraphicPic);
			
			myMiniMap.addLayer(new OpenStreetMapLayer());
			myMiniMap.addLayer(myGraphicsLayer);
			myMiniMap.addLayer(minLayer);
			myMiniMap.center = featLayer.graphicProvider[ind].geometry;
			
			
			myMiniMap.logoVisible = false;
			myMiniMap.scaleBarVisible = false;
			myMiniMap.zoomSliderVisible = false;
			
			myMiniMap.attributionVisible = false;
			myMiniMap.scale = map.scale;
			
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
	}
	
	function changeStatusHandler(ev:MouseEvent):void
	{
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
		changeStatus(event, ev, k);
	}
	
	function onCbChangeHandler(ev:ListEvent):void
	{
		onCbChange(ev, event, k, otherSiteLoca);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted); 
		}	
	}
	
	function editAttachFeaturesHandler(ev:MouseEvent):void
	{
		editAttachFeatures();
	}
	
	function editRelatedFeaturesHandler(ev:MenuEvent):void
	{
		relatedBut.label = ev.label;
		editRelatedFeatures(ev);
	}
	
	function saveDatesEditedHandler(ev:CalendarLayoutChangeEvent):void
	{
		saveDatesEdited(ev, event, k, startDateChoose, endDateChoose);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
	}
	
	function saveInfoEditedHandler(ev:FlexEvent):void
	{
		saveInfoEdited(ev, event, k, service);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
	}
	
	function deleteFeatureHandler(ev:MouseEvent):void
	{
		deleteFeature(event,k);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
	} 
	
	function moveFeatureHandler(ev:MouseEvent):void
	{
		moveFeature(event, k);
		if(!willTrigger(FeatureLayerEvent.EDITS_STARTING))
		{
			featLayer.addEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		}
	} 
	
	function myFeatureLayer_editsStarted(ev:FeatureLayerEvent):void
	{
		featLayer.removeEventListener(FeatureLayerEvent.EDITS_STARTING, myFeatureLayer_editsStarted);
		featLayer.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,featLayer_updateEditsComplete);
		locaId.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		holeTypeList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		projList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
		localXInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		localYInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		groundLevelInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		localZInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		holeDepthInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		CoordSysInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		genRemInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		startDateChoose.removeEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
		endDateChoose.removeEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
		
		if(configXML.USER == "Validateur")
		{
			siteLocaList.removeEventListener(ListEvent.CHANGE, onCbChangeHandler);
			otherSiteLoca.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			investPhaseInput.removeEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
		}
		
		deleteBut.removeEventListener(MouseEvent.CLICK,deleteFeatureHandler);
		completeCheck.removeEventListener(MouseEvent.CLICK,changeStatusHandler);
		validCheck.removeEventListener(MouseEvent.CLICK,changeStatusHandler);
		checkCheck.removeEventListener(MouseEvent.CLICK,changeStatusHandler);
		moveBut.removeEventListener(MouseEvent.CLICK,moveFeatureHandler);
		relatedBut.removeEventListener(MenuEvent.ITEM_CLICK,editRelatedFeatures);
		attachBut.removeEventListener(MouseEvent.CLICK,editAttachFeatures);
		deleteBut.enabled = false;
		moveBut.enabled = false;
		relatedBut.enabled = false;
		attachBut.enabled = false;
		completeCheck.enabled = false
		checkCheck.enabled = false;
		validCheck.enabled = false;
	}
	
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
					
//					if(changedStatus)
//					{
//						changedStatus = false;
//						if(configXML.USER == "Validateur")
//						{
//							completeCheck.enabled = true;
//							checkCheck.enabled = completeCheck.selected;
//							validCheck.enabled = checkCheck.selected;
//						}
//						else  // Presta case
//						{
//							if(!isNaN(ind))
//							{	
//								if(featLayer.graphicProvider[ind].attibutes.COMPLETE == 'NON')
//								{
//									completeCheck.enabled = true;
//								}
//							}
//							else if((index.collapsingPanel.fullScreen||!index.collapsingPanel.collapsed) && isNaN(ind))
//							{
//								index.collapsingPanel.collapseButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//							}
//							checkCheck.enabled = false;
//							validCheck.enabled = false;
//							//completeCheck.enabled = false;
//						}
//					}				
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
		
	}
	
	
	function addInfoWindListener():void
	{
		if(!localXInput.willTrigger(FlexEvent.VALUE_COMMIT))
		{
			locaId.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			holeTypeList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
			projList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
			localXInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			localYInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			groundLevelInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			localZInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			holeDepthInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			CoordSysInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			genRemInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			startDateChoose.addEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
			endDateChoose.addEventListener(CalendarLayoutChangeEvent.CHANGE, saveDatesEditedHandler);
			
			if(configXML.USER == "Validateur")
			{
				siteLocaList.addEventListener(ListEvent.CHANGE, onCbChangeHandler);
				otherSiteLoca.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
				investPhaseInput.addEventListener(FlexEvent.VALUE_COMMIT, saveInfoEditedHandler);
			}
		}
		deleteBut.addEventListener(MouseEvent.CLICK,deleteFeatureHandler);
		//statusbut.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		
		completeCheck.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		validCheck.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		checkCheck.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		
		moveBut.addEventListener(MouseEvent.CLICK,moveFeatureHandler);
		relatedBut.addEventListener(MenuEvent.ITEM_CLICK,editRelatedFeaturesHandler);
		attachBut.addEventListener(MouseEvent.CLICK,editAttachFeaturesHandler);
		deleteBut.enabled = true;
		moveBut.enabled = true;
		relatedBut.enabled = true;
		attachBut.enabled = true;
		//statusbut.enabled = true;
		if(configXML.USER == "Validateur")
		{
			completeCheck.enabled = true;
			checkCheck.enabled = completeCheck.selected;
			validCheck.enabled = checkCheck.selected;
		}
		else  // Presta case
		{
			//TODO voir si complete est OUI ou NON pour l'enable ou non
//			if(event.features[k].attributes.COMPLETE == 'NON')
//			{
//				completeCheck.enabled = true;
//			}
//			checkCheck.enabled = false;
//			validCheck.enabled = false;
		}
	}
	
	map.infoWindow.addEventListener(flash.events.Event.CLOSE, infoWindowCloseButtonClickHandler);
	
}//End createInfoWindow
