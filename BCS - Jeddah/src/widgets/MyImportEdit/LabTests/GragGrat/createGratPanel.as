import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.tasks.supportClasses.Query;

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
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.Text;
import mx.core.ClassFactory;
import mx.events.DataGridEvent;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.styles.CSSStyleDeclaration;

// ActionScript file

private function createGratPanel(i:Number):void
{
	var tmp:Object = content.getChildAt(i) as Object;
	tmp = tmp.getChildAt(0)//get Vcanvas
	tmp = tmp.getChildByName("grid"); //get grid
	tmp = tmp.getChildAt(2); //get gridRow3
	tmp = tmp.getChildByName("invisibleID"); // get invisibleID
	tmp = tmp.getChildAt(0);
	//Add the part of Grat table...
	//Query with the inisible ObjectID as GRAG_ID
	var gratPanel:HBox = new HBox();
	gratPanel.percentWidth = 100;
	gratPanel.percentHeight = 80; 
	gratPanel.name = "gratPanel";
	
	/*var tmpBis:Object = content.getChildAt(i) as Object;
	tmpBis = tmpBis.getChildAt(0)//get Vcanvas
	tmpBis.addChild(gratPanel);*/
	
	var queryGratFeat:Query =  new Query();
	//queryGragFeatObj.objectIds = [ev.featureEditResults.addResults[0].objectId];
	queryGratFeat.where = "GRAG_ID = " + tmp.text;
	grat.outFields = ["*"];
	grat.queryFeatures(queryGratFeat, new AsyncResponder(onQueryGratResHandler, onQueryGratFault));
	
	
	function onQueryGratResHandler(gratResult:FeatureSet, token:Object = null):void
	{
		onQueryGratRes(gratResult, gratPanel, i, token);		
	}// END onQueryGratResHandler
	
	function onQueryGratFault(gratFault:Fault, token:Object = null):void
	{
		Alert.show(gratFault.message.toString());
	}
	
}//End createGratPanel
