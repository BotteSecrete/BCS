import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.tasks.supportClasses.Query;

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
import mx.events.DataGridEvent;
import mx.graphics.ImageSnapshot;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.rpc.AsyncResponder;
import mx.rpc.events.FaultEvent;
import mx.styles.CSSStyleDeclaration;

var ctrlBar:HBox =  new HBox();
var grainTestNume : Label = new Label();
var GrainTestNumb : Label = new Label();
var addGrainTest:Button = new Button();
var deleteGrainTest:Button = new Button();

private function onQueryGragRes(result:FeatureSet, token:Object = null):void
{
	
	ctrlBar.percentWidth = 100;
	ctrlBar.name = "ctrlBar";
	
	
	grainTestNume.text = "";
	grainTestNume.name = "grainTestNume"
	grainTestNume.setStyle("color", 0xd22228);
	
	GrainTestNumb.text = "";
	GrainTestNumb.setStyle("color", 0xd22228);
	
	
	addGrainTest.label = "New Grain Analysis Test";
	
	
	deleteGrainTest.label = "Delete this test";
	
	ctrlBar.addChild(grainTestNume);
	ctrlBar.addChild(GrainTestNumb);
	ctrlBar.addChild(addGrainTest);
	ctrlBar.addChild(deleteGrainTest);
	
	//Alert.show("add event");
	grag.addEventListener(FeatureLayerEvent.EDITS_COMPLETE, gragCompleteEdits);
	grag.addEventListener(FaultEvent.FAULT, faultgragEdit);
	countRelatedsEntity(sampGridSource.getItemAt(sampDataGrid.selectedIndex).OBJECTID); //Mettre à jour les onglets (hover)
	
	if(!goToRightCan.hasEventListener(MouseEvent.CLICK)){
		goToRightCan.addEventListener(MouseEvent.CLICK, animate);
		goToLeftCan.addEventListener(MouseEvent.CLICK, animate);
	}
	if(nextToPrev.owns(goToLeftCan))
	{
		nextToPrev.removeChild(goToLeftCan);
		nextToPrev.removeChild(goToRightCan);
	}
	if(!pan1.owns(nextToPrev))
	{
		pan1.addChild(nextToPrev);
	}
	
	var childPan:DisplayObject = pan1.getChildByName("ctrlBar");
	if (childPan != null)
	{
		if(pan1.owns(childPan))
		{
			pan1.removeChild(childPan);
			addGrainTest.removeEventListener(MouseEvent.CLICK,addGrainAnalysisTest);
			deleteGrainTest.removeEventListener(MouseEvent.CLICK, delThisGrainTest); 
		}
	}
	if(content.numChildren > 0)
	{
		content.removeAllChildren();
	}
	if(nextToPrev.owns(content))
	{
		nextToPrev.removeChild(content);
	}
	
	pan1.addChild(ctrlBar);
	//Alert.show("adding ctrl bar: " + sampID.toString());
	grainTestNume.text = "";
	GrainTestNumb.text = "No features here";
	addGrainTest.addEventListener(MouseEvent.CLICK,addGrainAnalysisTest);
	deleteGrainTest.addEventListener(MouseEvent.CLICK, delThisGrainTest); 
	
	
	if(result.features.length > 0)
	{
		nextToPrev.removeAllChildren();
		if(result.features.length == 1)
		{
			grainTestNume.text = "";
			GrainTestNumb.text = "Only one test one this sample";
			nextToPrev.addChild(content);
			content.selectedIndex = 0;
			createGragPanel(0, result);
			//createGratPanel(0);
			content.percentWidth = 100;
			
		}
		else
		{
			if(!nextToPrev.owns(goToLeftCan))
			{
				nextToPrev.addChild(goToLeftCan);
				nextToPrev.addChild(content);
				nextToPrev.addChildAt(goToRightCan,2);
			}
			
			for (var i:Number = 0; i<result.features.length; i++)
			{
				createGragPanel(i, result);//le plus long
			}
			content.selectedIndex = 0;
			grainTestNume.text = (content.selectedIndex + 1).toString();
			GrainTestNumb.text = " / " + result.features.length.toString() + " tests on this sample";
			content.percentWidth = 90;
		}
	}
	else
	{
		//content.removeAllChildren()
		var noFeatures:Canvas = new Canvas();
		noFeatures.percentHeight = 100;
		noFeatures.percentWidth = 100;
		noFeatures.setStyle("showEffect",showEffect);
		var noFeaturesBox:Box = new Box();
		noFeaturesBox.percentWidth = 100;
		noFeaturesBox.percentHeight = 100;
		noFeaturesBox.setStyle("horizontalAlign","center");
		noFeaturesBox.setStyle("verticalAlign","middle");
		
		var noFeaturesText:Label = new Label();
		noFeaturesText.text = "No grain analysis test found for this sample";
		noFeaturesText.setStyle("color", 0xd22228);
		noFeaturesBox.addChild(noFeaturesText);
		noFeatures.addChild(noFeaturesBox);
		content.addChild(noFeatures);
		nextToPrev.addChild(content);
		
	}
}//End onQueryGragResHandler

