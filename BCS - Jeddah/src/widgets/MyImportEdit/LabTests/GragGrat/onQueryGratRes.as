import com.esri.ags.Graphic;
import com.esri.ags.layers.supportClasses.Field;
import com.esri.viewer.AppEvent;

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
import mx.containers.Grid;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Button;
import mx.controls.DataGrid;
import mx.controls.Text;
import mx.core.ClassFactory;
import mx.events.DataGridEvent;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.styles.CSSStyleDeclaration;

var claySource:ArrayCollection;
var sandSource:ArrayCollection;
var siltSource:ArrayCollection;
var gravSource:ArrayCollection;


var gratGridCopie:ArrayCollection = new ArrayCollection();

// ActionScript file
private function onQueryGratRes(gratResult:FeatureSet, gratPanel:HBox, i:Number, token:Object = null):void
{

	var gratGridSource:ArrayCollection = new ArrayCollection();
	var vLeftBox:VBox =  new VBox();
	vLeftBox.name = "vLeftBox";
	vLeftBox.percentWidth = 40;
	vLeftBox.left = 10;
	var gratDataGrid:DataGrid = new DataGrid();		
	var headerStyleName:CSSStyleDeclaration=new CSSStyleDeclaration;
	headerStyleName.setStyle("color",0xd22228); //FONCTIONNE PAS
	gratDataGrid.setStyle("headerStyleName", headerStyleName);	
	
	//var testArrayCol:ArrayCollection = new ArrayCollection();
	
	
	var columnsGrat:Array = new Array();
	gratGridSource.removeAll();
	//gratDataGrid.removeChildren();
	gratDataGrid.setStyle("alternatingItemColors",[0xF7F7F7,0xFFFFFF]);
	gratDataGrid.setStyle("selectionColor",0x959595);
	gratDataGrid.setStyle("color",0xd22228);
	//gratDataGrid.percentWidth = 30;
	//gratDataGrid.percentHeight = 100;
	gratDataGrid.id = "gratTable";
	gratDataGrid.name = "gratTable";
	gratDataGrid.dataProvider = gratGridSource;
	gratDataGrid.editable = true;
	gratDataGrid.draggableColumns = true;
	gratDataGrid.allowMultipleSelection = true;
	gratDataGrid.allowDragSelection = true;
	
	dataGrid.id = "geolTable";
	/*gratDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT, dgItemEditEnd);
	gratDataGrid.addEventListener(KeyboardEvent.KEY_UP, manageKey);
	gratDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dgItemEditEnd);*/
	gratDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, gratDgItemEditEnd);
	

	
	if(gratResult.features.length>0)
	{
		if(!gratDataGrid.columnCount > 0)
		{
			for each(var att:Object in gratResult.fields)
			{
				if (att.name != "LOCA_ID" 
					&& att.name != "GRAG_ID"
					&& att.name!= "SAMP_TOP"
					&& att.name!= "SAMP_REF"
					&& att.name!= "SAMP_TYPE"
					&& att.name!= "SAMP_ID" 
					&& att.name!= "SPEC_REF" 
					&& att.name!= "SPEC_DPTH" 
					&& att.name!= "GRAT_TYPE" 
					&& att.name!= "FILE_FSET"
				)
				{
					
					//var col:DataGridColumn = new DataGridColumn(att.name) as DataGridColumn;
					var colGrat:DataGridToolTipColumn = new DataGridToolTipColumn(att.name) as DataGridToolTipColumn;
					colGrat.dataField = att.name;
					colGrat.headerText = att.name;
					colGrat.headerToolTip = att.alias;
					colGrat.headerToolTipPosition = "above";
					colGrat.draggable = false;
					colGrat.dataTipField = "z";
					switch(att.name)
					{
						case "OBJECTID":
							colGrat.visible = false;
							colGrat.editable = false;
							colGrat.dataTipField = "a";
							break;
						case "GRAT_SIZE":
							colGrat.sortCompareFunction = numericSortByField("GRAT_SIZE");
							colGrat.width = 80;
							colGrat.dataTipField = "c";
							break;
						case "GRAT_PERP":
							colGrat.width = 80;
							colGrat.dataTipField = "d";
							break;
						
					}
					columnsGrat.push(colGrat);
				}
			}
			
			columnsGrat.sortOn("dataTipField");
			
			gratDataGrid.columns = columnsGrat;
			dataGridDefaultSort(gratDataGrid,1);
			
		}
		
		var virRegExp:RegExp = /[.]/gi;
		for each(var gr:Graphic in gratResult.features)
		{
			if(gr != null)
			{
				if((gr.attributes.GRAT_BASE != null) && (gr.attributes.GRAT_BASE).toString().search(virRegExp) > -1)
				{
					gr.attributes.GRAT_BASE = (gr.attributes.GRAT_BASE).toString().replace(virRegExp, ",");
				}
				if((gr.attributes.GRAT_TOP != null) && (gr.attributes.GRAT_TOP).toString().search(virRegExp) > -1)
				{
					gr.attributes.GRAT_TOP = (gr.attributes.GRAT_TOP).toString().replace(virRegExp, ",");
				}
			}
			gratGridSource.addItem(gr.attributes);
			gratGridCopie.addItem(gr.attributes);
			
		}
		gratGridSource.refresh();
		gratGridCopie.refresh();
	}
	
	var addGratToTable : Button = new Button();
	addGratToTable.label = "+";
	addGratToTable.setStyle("textRollOverColor", 0xd22228); 
	addGratToTable.setStyle("textSelectedColor", 0xd22228); 
	addGratToTable.addEventListener(MouseEvent.CLICK, addGratRowToTableHandler);
	
	var delGratFromTable:Button = new Button();
	delGratFromTable.label = "-";
	delGratFromTable.setStyle("textRollOverColor", 0xd22228); 
	delGratFromTable.setStyle("textSelectedColor", 0xd22228); 
	delGratFromTable.addEventListener(MouseEvent.CLICK,delGratRowFromTableHandler);
	
	var hBotBox:HBox =  new HBox();
	hBotBox.addChild(addGratToTable);
	hBotBox.addChild(delGratFromTable);
	
	//testArrayCol.refresh();
	var tmpBis:Object = content.getChildAt(i) as Object;
	tmpBis = tmpBis.getChildAt(0)//get Vcanvas
	if(!tmpBis.owns(gratPanel))
	{
		tmpBis.addChild(gratPanel);
		vLeftBox.addChild(gratDataGrid);
		vLeftBox.addChild(hBotBox);
	}
	
	gratPanel.addChild(vLeftBox);
	
	var standard:Text = new Text();
	standard.text = configData.configXML.GrainStandard.toString();
	
	//vLeftBox.addChild(cbStandChart);
	//Draw chart
	
	var s1:SolidColorStroke = new SolidColorStroke(0x0000ff,2);
	var sc1:SolidColor = new SolidColor(0x0000ff,1);
	var s2:SolidColorStroke = new SolidColorStroke(0x000000,.5);
	var sc2:SolidColor = new SolidColor(0x0B610B,.2);
	var sc3:SolidColor = new SolidColor(0x0A2A22,.2);
	var sc4:SolidColor = new SolidColor(0xAEB404,.2);
	var sc5:SolidColor = new SolidColor(0x28888d,.1);
	claySource = new ArrayCollection([{Clay_GRAT_PERP:100, Clay_GRAT_SIZE:0.001},
		{Clay_GRAT_PERP:100, Clay_GRAT_SIZE:0.002}]);
	siltSource = new ArrayCollection([{GRAT_PERP:100, GRAT_SIZE:0.002},
		{GRAT_PERP:100, GRAT_SIZE:0.063}]);
	sandSource = new ArrayCollection([{GRAT_PERP:100, GRAT_SIZE:0.063},
		{GRAT_PERP:100, GRAT_SIZE:2}]);
	gravSource = new ArrayCollection([{GRAT_PERP:100, GRAT_SIZE:2},
		{GRAT_PERP:100, GRAT_SIZE:10}]);
	
	
	if(standard.text == "British")
	{
		claySource.getItemAt(0).Clay_GRAT_SIZE = 0.001;
		claySource.getItemAt(1).Clay_GRAT_SIZE = 0.002;
		claySource.refresh();
		siltSource.getItemAt(0).GRAT_SIZE = 0.002;
		siltSource.getItemAt(1).GRAT_SIZE = 0.063;
		siltSource.refresh();
		sandSource.getItemAt(0).GRAT_SIZE = 0.063;
		sandSource.getItemAt(1).GRAT_SIZE = 2;
		sandSource.refresh();
		gravSource.getItemAt(0).GRAT_SIZE = 2;
		gravSource.getItemAt(1).GRAT_SIZE = 10;
		gravSource.refresh();
		
	} 
	else if (standard.text == "American")
	{
		claySource.getItemAt(0).Clay_GRAT_SIZE = 0.001;
		claySource.getItemAt(1).Clay_GRAT_SIZE = 0.00475;
		claySource.refresh();
		siltSource.getItemAt(0).GRAT_SIZE = 0.00475;
		siltSource.getItemAt(1).GRAT_SIZE = 0.075;
		siltSource.refresh();
		sandSource.getItemAt(0).GRAT_SIZE = 0.075;
		sandSource.getItemAt(1).GRAT_SIZE = 4.75;
		sandSource.refresh();
		gravSource.getItemAt(0).GRAT_SIZE = 4.75;
		gravSource.getItemAt(1).GRAT_SIZE = 10;
		gravSource.refresh();
		
	}
	
	
	var gragSource:ArrayCollection = new ArrayCollection([{GRAT_PERP:0, GRAT_SIZE:claySource.getItemAt(1).Clay_GRAT_SIZE},
		{GRAT_PERP:0, GRAT_SIZE:siltSource.getItemAt(1).GRAT_SIZE},
		{GRAT_PERP:0, GRAT_SIZE:sandSource.getItemAt(1).GRAT_SIZE}]);
	
	calculateGragResult(i, gratGridSource, gragSource);
	

	
	var gratChart:AreaChart = new AreaChart();
	gratChart.setStyle("color",0xd22228);
	
	var bge:Array = new Array();
	var chartLines:GridLines = new GridLines();
	chartLines.setStyle("gridDirection","both");
	//chartLines.setStyle("verticalChangeCount",0.1);
	bge.push(chartLines);
	gratChart.dataProvider = gratGridSource;
	gratChart.showDataTips = true;
	gratChart.percentHeight = 100;
	gratChart.percentWidth = 100;
	gratChart.backgroundElements = bge;
	//gratChart.type = "100%";
	
	var hAxis:LogAxis = new LogAxis();
	//var hAxis:LinearAxis = new LinearAxis();
	
	hAxis.title = "Size (mm)";
	hAxis.minimum = 0.001
	//hAxis.minimum = -1;
	//hAxis.maximum = 6;
	var vAxis:LinearAxis = new LinearAxis();
	vAxis.title = "PERP (%)";
	vAxis.maximum = 100;
	vAxis.direction = "normal";
	vAxis.baseAtZero = true;
	
	
	//hAxis.interval = 10;
	//hAxis.maximum = 100;
	gratChart.horizontalAxis = hAxis;
	gratChart.verticalAxis = vAxis;
	
	
	/*var chartParam:ArrayCollection=new ArrayCollection([
	{caption:"Grain Analysis"},
	{xAxisName:"Size (mm)"},
	{yAxisName:"PERP (%)"},
	{yAxisMaxValue:'100'},
	{shownames:"1"},
	{showvalues:"0"},
	{decimals:"0"},
	{animation:"1"}
	]);
	var fc:FusionCharts = new FusionCharts();
	fc.FCChartType = "LogMSLine";
	fc.FCData(testArrayCol);
	fc.FCDebugMode = true;
	fc.FCParams(chartParam);
	fc.FCRender();*/
	
	var mySeries:Array=new Array();
	
	var series1:LineSeries = new LineSeries();
	series1.dataProvider = gratGridSource;
	series1.xField="GRAT_SIZE";
	series1.setStyle("showDataEffect",interpolateIn);
	series1.yField="GRAT_PERP";
	series1.setStyle("lineStroke",s1);
	//series1.setStyle("areaFill",sc1);
	series1.setStyle("form","curve");
	series1.displayName = "Grain Analysis";
	
	mySeries.push(series1);
	
	
	
	var series2:AreaSeries = new AreaSeries();
	//series2.interpolateValues = true;
	series2.dataProvider = claySource;
	series2.setStyle("showDataEffect",interpolateIn);
	series2.setStyle("lineStroke",s2);
	series2.setStyle("areaFill",sc2);
	series2.xField="Clay_GRAT_SIZE";
	series2.yField="Clay_GRAT_PERP";
	//series2.setStyle("form","vertical");
	series2.displayName = "Clay limit";
	mySeries.push(series2);
	
	var series3:AreaSeries = new AreaSeries();
	//series3.interpolateValues = true;
	series3.dataProvider = siltSource;
	series3.setStyle("showDataEffect",interpolateIn);
	series3.setStyle("lineStroke",s2);
	series3.setStyle("areaFill",sc3);
	series3.xField="GRAT_SIZE";
	series3.yField="GRAT_PERP";
	series3.setStyle("form","vertical");
	series3.displayName = "Silt limit";
	mySeries.push(series3);
	
	var series4:AreaSeries = new AreaSeries();
	//series4.interpolateValues = true;
	series4.dataProvider = sandSource;
	series4.setStyle("showDataEffect",interpolateIn);
	series4.setStyle("lineStroke",s2);
	series4.setStyle("areaFill",sc4);
	series4.xField="GRAT_SIZE";
	series4.yField="GRAT_PERP";
	series4.setStyle("form","vertical");
	series4.displayName = "Sand limit";
	mySeries.push(series4);
	var series5:AreaSeries = new AreaSeries();
	//series4.interpolateValues = true;
	series5.dataProvider = gravSource;
	series5.setStyle("showDataEffect",interpolateIn);
	series5.setStyle("lineStroke",s2);
	series5.setStyle("areaFill",sc5);
	series5.xField="GRAT_SIZE";
	series5.yField="GRAT_PERP";
	series5.setStyle("form","vertical");
	series5.displayName = "Grav limit";
	mySeries.push(series5);
	//series1.x = 0.063;
	//Alert.show("x: " + series1.x.toString() +  " et y: " + series1.y.toString());
	gratChart.series = mySeries;
	gratChart.name = "gratChart";
	
	/*var mySeriesBis:Array=new Array();
	mySeriesBis.push(series1);
	mySeriesBis.push(series2);
	mySeriesBis.push(series3);
	mySeriesBis.push(series4);
	mySeriesBis.push(series5);
	
	var gratLegChart:AreaChart = new AreaChart();
	gratLegChart.series = mySeriesBis;*/
	
	
	var chartPanel:VBox = new VBox;
	chartPanel.percentHeight = 100;
	chartPanel.name = "chartPanel";
	chartPanel.maxHeight = 400;
	chartPanel.percentWidth = 65;
	chartPanel.addChild(gratChart);

	var legChart:Legend = new Legend();
	legChart.direction = "horizontal";
	legChart.dataProvider = gratChart;
	legChart.setStyle("color", 0xd22228);
	//gratPanel.addChild(fc);
	chartPanel.addChild(legChart);
	
	var series1b:PlotSeries = new PlotSeries();
	//series1.interpolateValues = true;
	series1b.dataProvider = gratGridSource;
	series1b.setStyle("fill", 0x0000ff);
	
	series1b.setStyle("itemRenderer",  new ClassFactory(mx.charts.renderers.CircleItemRenderer));
	
	series1b.interactive = false;
	series1b.xField="GRAT_SIZE";
	series1b.setStyle("showDataEffect",interpolateIn);
	series1b.yField="GRAT_PERP";
	//series1.setStyle("lineStroke",s1);
	//series1.setStyle("areaFill",sc1);
	//series1.setStyle("form","curve");
	
	//series1.displayName = "Grain Analysis";
	mySeries.push(series1b);
	
	var series1c:PlotSeries = new PlotSeries();
	//series1.interpolateValues = true;
	series1c.dataProvider = gragSource;
	series1c.setStyle("fill", 0xff0000);
	
	series1c.setStyle("itemRenderer",  new ClassFactory(mx.charts.renderers.CircleItemRenderer));
	
	series1c.interactive = true;
	series1c.xField="GRAT_SIZE";
	series1c.setStyle("showDataEffect",interpolateIn);
	series1c.yField="GRAT_PERP";
	//series1.setStyle("lineStroke",s1);
	//series1.setStyle("areaFill",sc1);
	//series1.setStyle("form","curve");
	
	//series1.displayName = "Grain Analysis";
	mySeries.push(series1c);
	gratChart.series = mySeries;
	
	gratPanel.addChild(chartPanel);
	
	function addGratRowToTableHandler(evt:MouseEvent):void
	{
		AppEvent.dispatch(AppEvent.ADD_GRAT_ROW, {datagrid: gratDataGrid, number: i}); 	
	}
	
	function delGratRowFromTableHandler(evt:MouseEvent):void
	{
		AppEvent.dispatch(AppEvent.DEL_GRAT_ROW, {datagrid: gratDataGrid, number :i});
	}
}



private function onQueryGratRes2(gratResult:FeatureSet, gratPanel:HBox, token:Object = null):void
{
	
	
	var i:Number = content.selectedIndex;
	//gratDataGrid dans vLeftBox
	var vLeftBox:VBox =  gratPanel.getChildByName("vLeftBox") as VBox;
	

	
	

	var gratDataGrid:DataGrid = vLeftBox.getChildByName("gratTable") as DataGrid;		

	var gratGridSource:ArrayCollection = gratDataGrid.dataProvider as ArrayCollection;
	gratGridSource.removeAll();
	
	if(gratResult.features.length>0)
	{
		if(!gratDataGrid.columnCount > 0)
		{
			var columnsGrat:Array = new Array();
			for each(var att:Object in gratResult.fields)
			{
				if (att.name != "LOCA_ID" 
					&& att.name != "GRAG_ID"
					&& att.name!= "SAMP_TOP"
					&& att.name!= "SAMP_REF"
					&& att.name!= "SAMP_TYPE"
					&& att.name!= "SAMP_ID" 
					&& att.name!= "SPEC_REF" 
					&& att.name!= "SPEC_DPTH" 
					&& att.name!= "GRAT_TYPE" 
					&& att.name!= "FILE_FSET"
				)
				{
					
					//var col:DataGridColumn = new DataGridColumn(att.name) as DataGridColumn;
					var colGrat:DataGridToolTipColumn = new DataGridToolTipColumn(att.name) as DataGridToolTipColumn;
					colGrat.dataField = att.name;
					colGrat.headerText = att.name;
					colGrat.headerToolTip = att.alias;
					colGrat.headerToolTipPosition = "above";
					colGrat.draggable = false;
					colGrat.dataTipField = "z";
					switch(att.name)
					{
						case "OBJECTID":
							colGrat.visible = false;
							colGrat.editable = false;
							colGrat.dataTipField = "a";
							break;
						case "GRAT_SIZE":
							colGrat.sortCompareFunction = numericSortByField("GRAT_SIZE");
							colGrat.width = 80;
							colGrat.dataTipField = "c";
							break;
						case "GRAT_PERP":
							colGrat.width = 80;
							colGrat.dataTipField = "d";
							break;
						
					}
					columnsGrat.push(colGrat);
				}
			}
			
			columnsGrat.sortOn("dataTipField");
			
			gratDataGrid.columns = columnsGrat;
			dataGridDefaultSort(gratDataGrid,1);
			
		}
		var virRegExp:RegExp = /[.]/gi;
		for each(var gr:Graphic in gratResult.features)
		{
			if(gr != null)
			{
				if((gr.attributes.GRAT_BASE != null) && (gr.attributes.GRAT_BASE).toString().search(virRegExp) > -1)
				{
					gr.attributes.GRAT_BASE = (gr.attributes.GRAT_BASE).toString().replace(virRegExp, ",");
				}
				if((gr.attributes.GRAT_TOP != null) && (gr.attributes.GRAT_TOP).toString().search(virRegExp) > -1)
				{
					gr.attributes.GRAT_TOP = (gr.attributes.GRAT_TOP).toString().replace(virRegExp, ",");
				}
			}
			gratGridSource.addItem(gr.attributes);
			gratGridCopie.addItem(gr.attributes);
			
		}
		gratGridSource.refresh();
		gratGridCopie.refresh();
	}

	
	
	
	var standard:Text = new Text();
	standard.text = configData.configXML.GrainStandard.toString();
	
	//vLeftBox.addChild(cbStandChart);
	//Draw chart
	
	var s1:SolidColorStroke = new SolidColorStroke(0x0000ff,2);
	var sc1:SolidColor = new SolidColor(0x0000ff,1);
	var s2:SolidColorStroke = new SolidColorStroke(0x000000,.5);
	var sc2:SolidColor = new SolidColor(0x0B610B,.2);
	var sc3:SolidColor = new SolidColor(0x0A2A22,.2);
	var sc4:SolidColor = new SolidColor(0xAEB404,.2);
	var sc5:SolidColor = new SolidColor(0x28888d,.1);
	claySource = new ArrayCollection([{Clay_GRAT_PERP:100, Clay_GRAT_SIZE:0.001},
		{Clay_GRAT_PERP:100, Clay_GRAT_SIZE:0.002}]);
	siltSource = new ArrayCollection([{GRAT_PERP:100, GRAT_SIZE:0.002},
		{GRAT_PERP:100, GRAT_SIZE:0.063}]);
	sandSource = new ArrayCollection([{GRAT_PERP:100, GRAT_SIZE:0.063},
		{GRAT_PERP:100, GRAT_SIZE:2}]);
	gravSource = new ArrayCollection([{GRAT_PERP:100, GRAT_SIZE:2},
		{GRAT_PERP:100, GRAT_SIZE:10}]);
	
	
	if(standard.text == "British")
	{
		claySource.getItemAt(0).Clay_GRAT_SIZE = 0.001;
		claySource.getItemAt(1).Clay_GRAT_SIZE = 0.002;
		claySource.refresh();
		siltSource.getItemAt(0).GRAT_SIZE = 0.002;
		siltSource.getItemAt(1).GRAT_SIZE = 0.063;
		siltSource.refresh();
		sandSource.getItemAt(0).GRAT_SIZE = 0.063;
		sandSource.getItemAt(1).GRAT_SIZE = 2;
		sandSource.refresh();
		gravSource.getItemAt(0).GRAT_SIZE = 2;
		gravSource.getItemAt(1).GRAT_SIZE = 10;
		gravSource.refresh();
		
	} 
	else if (standard.text == "American")
	{
		claySource.getItemAt(0).Clay_GRAT_SIZE = 0.001;
		claySource.getItemAt(1).Clay_GRAT_SIZE = 0.00475;
		claySource.refresh();
		siltSource.getItemAt(0).GRAT_SIZE = 0.00475;
		siltSource.getItemAt(1).GRAT_SIZE = 0.075;
		siltSource.refresh();
		sandSource.getItemAt(0).GRAT_SIZE = 0.075;
		sandSource.getItemAt(1).GRAT_SIZE = 4.75;
		sandSource.refresh();
		gravSource.getItemAt(0).GRAT_SIZE = 4.75;
		gravSource.getItemAt(1).GRAT_SIZE = 10;
		gravSource.refresh();
		
	}
	
	
	var gragSource:ArrayCollection = new ArrayCollection([{GRAT_PERP:0, GRAT_SIZE:claySource.getItemAt(1).Clay_GRAT_SIZE},
		{GRAT_PERP:0, GRAT_SIZE:siltSource.getItemAt(1).GRAT_SIZE},
		{GRAT_PERP:0, GRAT_SIZE:sandSource.getItemAt(1).GRAT_SIZE}]);
	
	calculateGragResult(i, gratGridSource, gragSource);
	
}

private function calculateGragResult(i:Number, gratGridSource:ArrayCollection, gragSource:ArrayCollection):void
{
	var claySizeInf:Number;
	var claySizeSup:Number;
	var siltSizeInf:Number;
	var siltSizeSup:Number;
	var sandSizeInf:Number;
	var sandSizeSup:Number;
	var gravSizeInf:Number;
	var gravSizeSup:Number;
	var clayPerpInf:Number;
	var clayPerpSup:Number;
	var siltPerpInf:Number;
	var siltPerpSup:Number;
	var sandPerpInf:Number;
	var sandPerpSup:Number;
	var gravPerpInf:Number;
	var gravPerpSup:Number;
	
	for(var k:Number = 0; k < gratGridSource.length - 1; k++)
	{
		if(parseFloat(claySource.getItemAt(1).Clay_GRAT_SIZE) > parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE))
		{
			claySizeInf = parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE);
			claySizeSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_SIZE);
			clayPerpInf = parseFloat(gratGridSource.getItemAt(k).GRAT_PERP);
			clayPerpSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_PERP);
		}
		
		if(parseFloat(siltSource.getItemAt(1).GRAT_SIZE) > parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE))
		{
			siltSizeInf = parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE);
			siltSizeSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_SIZE);
			siltPerpInf = parseFloat(gratGridSource.getItemAt(k).GRAT_PERP);
			siltPerpSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_PERP);
		}
		
		if(parseFloat(sandSource.getItemAt(1).GRAT_SIZE) > parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE))
		{
			sandSizeInf = parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE);
			sandSizeSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_SIZE);
			sandPerpInf = parseFloat(gratGridSource.getItemAt(k).GRAT_PERP);
			sandPerpSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_PERP);
		}
		if(parseFloat(gravSource.getItemAt(1).GRAT_SIZE) > parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE))
		{
			gravSizeInf = parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE);
			gravSizeSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_SIZE);
			gravPerpInf = parseFloat(gratGridSource.getItemAt(k).GRAT_PERP);
			gravPerpSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_PERP);
		}
	}
	
	var aClay:Number = (clayPerpSup/100 - clayPerpInf/100)/((Math.log(claySizeSup)*Math.LOG10E)-(Math.log(claySizeInf)*Math.LOG10E));
	var bClay:Number = clayPerpSup/100 - aClay*(Math.log(claySizeSup)*Math.LOG10E);
	var aSilt:Number = (siltPerpSup/100 - siltPerpInf/100)/((Math.log(siltSizeSup)*Math.LOG10E)-(Math.log(siltSizeInf)*Math.LOG10E));
	var bSilt:Number = siltPerpSup/100 - aSilt*(Math.log(siltSizeSup)*Math.LOG10E);
	var aSand:Number = (sandPerpSup/100 - sandPerpInf/100)/((Math.log(sandSizeSup)*Math.LOG10E)-(Math.log(sandSizeInf)*Math.LOG10E));
	var bSand:Number = sandPerpSup/100 - aSand*(Math.log(sandSizeSup)*Math.LOG10E);
	var aGrav:Number = (gravPerpSup/100 - gravPerpInf/100)/((Math.log(gravSizeSup)*Math.LOG10E)-(Math.log(gravSizeInf)*Math.LOG10E));
	var bGrav:Number = gravPerpSup/100 - aGrav*(Math.log(gravSizeSup)*Math.LOG10E);
	
	//Fill GRAG values:
	var tmpClay:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpClay = tmpClay.getChildAt(0)//get Vcanvas
	tmpClay = tmpClay.getChildByName("grid"); //get grid
	tmpClay = tmpClay.getChildAt(0); //get gridRow2
	tmpClay = tmpClay.getChildByName("gragCLAYValue"); // get gragCLAYValue
	tmpClay = tmpClay.getChildAt(0);//get textInput;
	tmpClay.text = (aClay * Math.log(parseFloat(claySource.getItemAt(1).Clay_GRAT_SIZE))*Math.LOG10E + bClay) * 100;
	
	var tmpSilt:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpSilt = tmpSilt.getChildAt(0)//get Vcanvas
	tmpSilt = tmpSilt.getChildByName("grid"); //get grid
	tmpSilt = tmpSilt.getChildAt(0); //get gridRow2
	tmpSilt = tmpSilt.getChildByName("gragSiltValue"); // get gragCLAYValue
	tmpSilt = tmpSilt.getChildAt(0);//get textInput;
	tmpSilt.text = (aSilt * Math.log(parseFloat(siltSource.getItemAt(1).GRAT_SIZE))*Math.LOG10E + bSilt) * 100;
	
	var tmpSand:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpSand = tmpSand.getChildAt(0)//get Vcanvas
	tmpSand = tmpSand.getChildByName("grid"); //get grid
	tmpSand = tmpSand.getChildAt(0); //get gridRow1
	tmpSand = tmpSand.getChildByName("gragSandValue"); // get gragCLAYValue
	tmpSand = tmpSand.getChildAt(0);//get textInput;
	tmpSand.text = (aSand * Math.log(parseFloat(sandSource.getItemAt(1).GRAT_SIZE))*Math.LOG10E + bSand) * 100;
	
	var tmpGrav:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpGrav = tmpGrav.getChildAt(0)//get Vcanvas
	tmpGrav = tmpGrav.getChildByName("grid"); //get grid
	tmpGrav = tmpGrav.getChildAt(0); //get gridRow1
	tmpGrav = tmpGrav.getChildByName("gragGravValue"); // get gragCLAYValue
	tmpGrav = tmpGrav.getChildAt(0);//get textInput;
	tmpGrav.text = (aGrav * Math.log(parseFloat(gravSource.getItemAt(1).GRAT_SIZE))*Math.LOG10E + bGrav) * 100;
	
	/*gragSource = new ArrayCollection([{GRAT_PERP:tmpClay.text, GRAT_SIZE:claySource.getItemAt(1).Clay_GRAT_SIZE},
	{GRAT_PERP:tmpSilt.text, GRAT_SIZE:siltSource.getItemAt(1).GRAT_SIZE},
	{GRAT_PERP:tmpSand.text, GRAT_SIZE:sandSource.getItemAt(1).GRAT_SIZE}]);*/
	
	gragSource.getItemAt(0).GRAT_PERP = tmpClay.text;
	gragSource.getItemAt(1).GRAT_PERP = tmpSilt.text;
	gragSource.getItemAt(2).GRAT_PERP = tmpSand.text;
	gragSource.refresh();
	
	
	//Calculate D10, D30, D60
	var d10SizeInf:Number;
	var d10SizeSup:Number;
	var d30SizeInf:Number;
	var d30SizeSup:Number;
	var d60SizeInf:Number;
	var d60SizeSup:Number;
	var d10PerpInf:Number;
	var d10PerpSup:Number;
	var d30PerpInf:Number;
	var d30PerpSup:Number;
	var d60PerpInf:Number;
	var d60PerpSup:Number;
	
	for(var k:Number = 0; k < gratGridSource.length - 1; k++)
	{
		if(10 > parseFloat(gratGridSource.getItemAt(k).GRAT_PERP))
		{
			d10SizeInf = parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE);
			d10SizeSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_SIZE);
			d10PerpInf = parseFloat(gratGridSource.getItemAt(k).GRAT_PERP);
			d10PerpSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_PERP);
		}
		
		if(30 > parseFloat(gratGridSource.getItemAt(k).GRAT_PERP))
		{
			d30SizeInf = parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE);
			d30SizeSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_SIZE);
			d30PerpInf = parseFloat(gratGridSource.getItemAt(k).GRAT_PERP);
			d30PerpSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_PERP);
		}
		
		if(60 > parseFloat(gratGridSource.getItemAt(k).GRAT_PERP))
		{
			d60SizeInf = parseFloat(gratGridSource.getItemAt(k).GRAT_SIZE);
			d60SizeSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_SIZE);
			d60PerpInf = parseFloat(gratGridSource.getItemAt(k).GRAT_PERP);
			d60PerpSup = parseFloat(gratGridSource.getItemAt(k+1).GRAT_PERP);
		}
	}
	
	var aD10:Number = (d10PerpSup/100 - d10PerpInf/100)/((Math.log(d10SizeSup)*Math.LOG10E)-(Math.log(d10SizeInf)*Math.LOG10E));
	var bD10:Number = d10PerpSup/100 - aD10*(Math.log(d10SizeSup)*Math.LOG10E);
	var aD30:Number = (d30PerpSup/100 - d30PerpInf/100)/((Math.log(d30SizeSup)*Math.LOG10E)-(Math.log(d30SizeInf)*Math.LOG10E));
	var bD30:Number = d30PerpSup/100 - aD30*(Math.log(d30SizeSup)*Math.LOG10E);
	var aD60:Number = (d60PerpSup/100 - d60PerpInf/100)/((Math.log(d60SizeSup)*Math.LOG10E)-(Math.log(d60SizeInf)*Math.LOG10E));
	var bD60:Number = d60PerpSup/100 - aD60*(Math.log(d60SizeSup)*Math.LOG10E);
	
	var d10:Number = Math.pow(10,((0.1-bD10)/aD10));
	var d30:Number = Math.pow(10,((0.3-bD30)/aD30));
	var d60:Number = Math.pow(10,((0.6-bD60)/aD60));
	
	var tmpUC:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpUC = tmpUC.getChildAt(0)//get Vcanvas
	tmpUC = tmpUC.getChildByName("grid"); //get grid
	tmpUC = tmpUC.getChildAt(2); //get gridRow3
	tmpUC = tmpUC.getChildByName("gragUCValue"); // get gragUCValue
	tmpUC = tmpUC.getChildAt(0);//get textInput;
	tmpUC.text = d60/d10;
	
	var tmpUC:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpUC = tmpUC.getChildAt(0)//get Vcanvas
	tmpUC = tmpUC.getChildByName("grid"); //get grid
	tmpUC = tmpUC.getChildAt(2); //get gridRow3
	tmpUC = tmpUC.getChildByName("gragCCValue"); // get gragUCValue
	tmpUC = tmpUC.getChildAt(0);//get textInput;
	tmpUC.text = d30*d30/(d60*d10);
	
	var tmpUC:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpUC = tmpUC.getChildAt(0)//get Vcanvas
	tmpUC = tmpUC.getChildByName("grid"); //get grid
	tmpUC = tmpUC.getChildAt(1); //get gridRow2
	tmpUC = tmpUC.getChildByName("gragD10Value"); // get gragUCValue
	tmpUC = tmpUC.getChildAt(0);//get textInput;
	tmpUC.text = d10;
	
	var tmpUC:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpUC = tmpUC.getChildAt(0)//get Vcanvas
	tmpUC = tmpUC.getChildByName("grid"); //get grid
	tmpUC = tmpUC.getChildAt(1); //get gridRow2
	tmpUC = tmpUC.getChildByName("gragD30Value"); // get gragUCValue
	tmpUC = tmpUC.getChildAt(0);//get textInput;
	tmpUC.text = d30;
	
	var tmpUC:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpUC = tmpUC.getChildAt(0)//get Vcanvas
	tmpUC = tmpUC.getChildByName("grid"); //get grid
	tmpUC = tmpUC.getChildAt(1); //get gridRow2
	tmpUC = tmpUC.getChildByName("gragD60Value"); // get gragUCValue
	tmpUC = tmpUC.getChildAt(0);//get textInput;
	tmpUC.text = d60;
	

	
	
	/*for(var j:Number = 0; j < gratGridSource.length; j++)
	{
	if(testArrayCol.length != gratGridSource.length)
	{
	var tmp:Object = new Object();
	tmp.GRAT_SIZE = gratGridSource.getItemAt(j).GRAT_SIZE;
	tmp.GRAT_PERP = gratGridSource.getItemAt(j).GRAT_PERP
	testArrayCol.addItem(tmp); 
	}
	else
	{
	testArrayCol.getItemAt(j).GRAT_SIZE = parseFloat(gratGridSource.getItemAt(j).GRAT_SIZE);
	testArrayCol.getItemAt(j).GRAT_PERP = parseFloat(gratGridSource.getItemAt(j).GRAT_PERP);
	}
	}*/
	
	//Alert.show(d10.toString());											
}//END calculateGragResult


private function gratDgItemEditEnd(evt:DataGridEvent):void
{
	var updates:Array = [];
	var attributes:Object = {};
	var indRow = evt.rowIndex;
	var field = evt.dataField;
	attributes.OBJECTID = evt.currentTarget.dataProvider.getItemAt(indRow).OBJECTID;
	
	
	var newData:String=mx.controls.TextInput(evt.currentTarget.itemEditorInstance).text;
	
	var myFormatter:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
	myFormatter.useThousandsSeparator = false;
	myFormatter.decimalSeparatorFrom = ","
	myFormatter.decimalSeparatorTo = ",";
	myFormatter.precision = 4;
	myFormatter.useThousandsSeparator = false;
	
	var myFormatterBis:mx.formatters.NumberFormatter = new mx.formatters.NumberFormatter();
	myFormatterBis.useThousandsSeparator = false;
	myFormatterBis.decimalSeparatorFrom = "."
	myFormatterBis.decimalSeparatorTo = ".";
	myFormatterBis.precision = 4;
	myFormatterBis.useThousandsSeparator = false;
	var virRegExp:RegExp = /[.]/gi;
	var ptRegExp:RegExp = /[,]/gi;
	var regExp:RegExp = /[^0-9,]/gi;
	
	if((newData != null) && (newData.search(virRegExp)>-1))
	{
		newData = newData.replace(virRegExp,",");
		mx.controls.TextInput(evt.currentTarget.itemEditorInstance).text = newData;
	}
	
	if((newData != null) && (newData.search(regExp)>-1))
	{
		newData = ""
		mx.controls.TextInput(evt.currentTarget.itemEditorInstance).text = newData;
		evt.preventDefault();
		mx.controls.TextInput(evt.currentTarget.itemEditorInstance).errorString = "Enter a valid number.";
		return;
	}
	else
	{
		if(newData != "")
		{
			mx.controls.TextInput(evt.currentTarget.itemEditorInstance).text = myFormatter.format(newData);
			if((gratGridCopie.getItemAt(indRow)[evt.dataField] != myFormatter.format(newData)) && (myFormatter.format(gratGridCopie.getItemAt(indRow)[evt.dataField])!=  myFormatter.format(newData)))
			{
				evt.currentTarget.dataProvider.getItemAt(indRow)[evt.dataField] =  myFormatter.format(newData);
				attributes[field] = evt.currentTarget.dataProvider.getItemAt(indRow)[evt.dataField];
				var feature:Graphic = new Graphic(null, null, attributes);
				updates.push(feature);
				dontDisplay = true;
				grat.applyEdits(null,updates,null);
			}
		}
	}
	
	//mx.controls.TextInput(evt.currentTarget.itemEditorInstance).text = myFormatter.format(newData);
	if((evt.currentTarget.dataProvider.getItemAt(indRow)[evt.dataField]).search(ptRegExp)>-1)
	{ 
		evt.currentTarget.dataProvider.getItemAt(indRow)[evt.dataField]	=  (evt.currentTarget.dataProvider.getItemAt(indRow)[evt.dataField]).replace(ptRegExp,".");
		mx.controls.TextInput(evt.currentTarget.itemEditorInstance).text = (evt.currentTarget.dataProvider.getItemAt(indRow)[evt.dataField]).replace(ptRegExp,".");
	}
	
	
	evt.currentTarget.dataProvider.getItemAt(evt.rowIndex).GRAT_SIZE = parseFloat(evt.currentTarget.dataProvider.getItemAt(evt.rowIndex).GRAT_SIZE);
	evt.currentTarget.dataProvider.getItemAt(evt.rowIndex).GRAT_PERP = parseFloat(evt.currentTarget.dataProvider.getItemAt(evt.rowIndex).GRAT_PERP);
	evt.currentTarget.dataProvider.refresh();
	
	var gragSource:ArrayCollection = new ArrayCollection;
	
	var tmpBis:Object = content.getChildAt(content.selectedIndex) as Object;
	tmpBis = tmpBis.getChildAt(0)//get Vcanvas
	tmpBis = tmpBis.getChildByName("gratPanel");//get the panel
	tmpBis = tmpBis.getChildByName("chartPanel");//get the panel
	tmpBis = tmpBis.getChildByName("gratChart");
	var mySeries:Array = tmpBis.series;//get the Chart
	gragSource = mySeries[6].dataProvider;
	//get gragSource
	
	evt.currentTarget.dataProvider.refresh();
	
	calculateGragResult(content.selectedIndex, evt.currentTarget.dataProvider, gragSource);
}
