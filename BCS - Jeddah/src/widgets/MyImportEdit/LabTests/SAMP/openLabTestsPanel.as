import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.layers.FeatureLayer;
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
import mx.events.IndexChangedEvent;
import mx.graphics.ImageSnapshot;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.rpc.AsyncResponder;
import mx.rpc.events.FaultEvent;
import mx.styles.CSSStyleDeclaration;

import spark.components.Panel;
import spark.events.GridEvent;
import spark.events.GridSelectionEvent;

import customRenderer.MyTabComponent;

// ActionScript file
private function seeRelatedTests():void
{
	//Alert.show(event.rowIndex.toString());
	if(sampDataGrid.selectedItems.length == 0 || sampDataGrid.selectedItems.length > 1 )
	{
		Alert.show("Please select only 1 row before")
	} 
	else
	{
		//var sampleObjectID:Number = new Number();
		//sampleObjectID = sampGridSource.getItemAt(sampDataGrid.selectedIndex).OBJECTID;
		openLabTestsPanel(sampGridSource.getItemAt(sampDataGrid.selectedIndex).OBJECTID, sampDataGrid.selectedIndex);
	}
}

private function openLabTestsPanel(sampObjectID:Number, rowInd:Number):void
{
	//Alert.show("test");
	//tablePanel.removeElement(sampDataGrid);
	//hSampChoiceBox.removeChild(vButtonBox);
	//hSampChoiceBox.removeChildAt(1);
	/*tablePanel.title = "Sample Informations for SAMP: " + sampGridSource.getItemAt(rowInd).OBJECTID;
	
	var sampSumUp:HBox = new HBox();
	var labelSampID:Label = new Label();
	labelSampID.text = "SAMP_ID: " +  sampObjectID;
	
	sampSumUp.addChild(labelSampID);
	sampSumUp.setStyle("color", 0xd22228);
	
	vboxInfo.addChild(sampSumUp);*/
	
	
	/*var buttonBack:Button = new Button();
	buttonBack.label =  "Back to SAMP";
	buttonBack.addEventListener(MouseEvent.CLICK,backToSampTable);
	
	hSampChoiceBox.addChild(buttonBack);*/
	
	//countRelatedsEntity(sampObjectID);
	
	var myVerticalTab:MyTabComponent = new MyTabComponent();
	
	myVerticalTab.percentWidth = 220;
	myVerticalTab.setStyle("tabWidth",100);
	myVerticalTab.autoLayout = true;
	myVerticalTab.addChild(pan1);
	myVerticalTab.addChild(pan2);
	myVerticalTab.addChild(pan3);
	
	myVerticalTab.addEventListener(IndexChangedEvent.CHANGE, indexChangeEventHandler);
	index.ws2.removeAllChildren();
	index.ws2.visible = true;
	index.ws2.label = "Laboratory tests for sample id: " + sampDataGrid.selectedItem.SAMP_ID + ", " + sampObjectID.toString();
	index.ws2.addChild(myVerticalTab);
	
	loadGragGratTables(sampObjectID);
	
	/*function backToSampTable(ev:MouseEvent):void
	{
		sampGridSource.removeAll();
		//tablePanel.removeAllElements();
		var ind:Number;
		for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
		{
			if(featLayer.graphicProvider[id].attributes.OBJECTID == (index.ws0.label).split(", ")[1])
			{
				ind = id;
				break;
			}
		}
		
		displaySAMPPanel(featLayer.graphicProvider[ind].attributes.OBJECTID);
	}*/
	
	sampDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_IN, selectNewSampID);
	
	function selectNewSampID(ev:DataGridEvent):void
	{
		if(ev.rowIndex != rowInd)
		{
			sampDataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_IN, selectNewSampID);
			openLabTestsPanel(sampDataGrid.selectedItem.OBJECTID, ev.rowIndex);
		}
	}

	
	function indexChangeEventHandler(ev:IndexChangedEvent):void
	{
		if(ev.newIndex == 0)
		{
			loadGragGratTables(sampObjectID);
		}
	}//END indexChangeEventHandler
	
	function loadGragGratTables(sId:Number):void
	{
		var url:String = samp.url;
		var indGrag:int;
		var j:int = 0;
		
		label1:
		do 
		{
			if(samp.layerDetails.relationships[j].name == "Attributes from GRAG")
			{
				indGrag= samp.layerDetails.relationships[j].relatedTableId;
				url = url.split("Feature")[0];
				url += "FeatureServer/" + indGrag;
				grag = new FeatureLayer(url, null, null);
				grag.token = configData.opLayers[0].token;
				grag.addEventListener(LayerEvent.LOAD, gragLoaded);
				
				var indGrat:int;
				var k:int = 0;
				function gragLoaded(ev:LayerEvent):void
				{
					
					label2:
					do 
					{
						if(grag.layerDetails.relationships[k].name == "Attributes from GRAT")
						{
							indGrat= grag.layerDetails.relationships[k].relatedTableId;
							var url:String = featLayer.url;
							url = url.split("Feature")[0];
							url += "FeatureServer/" + indGrat;
							grat = new FeatureLayer(url, null, null);
							grat.token = configData.opLayers[0].token;
							displayGrainSizeAnalysisTable(grag,grat,sId);
							break label2;
						}
						else if(k == grag.layerDetails.relationships.length - 1)
						{
							Alert.show("Can't find GRAT table, sorry... Please contact administrator");	
							break label2;
						}
						else
						{
							k++;
						}
						
					} while (j<grag.layerDetails.relationships.length)
				}
				break label1;
			}
			else if(j == samp.layerDetails.relationships.length - 1)
			{
				Alert.show("Can't find GRAG table, sorry... Please contact administrator");	
				break label1;
			}
			else
			{
				j++;
			}
			
		} while (j<samp.layerDetails.relationships.length)
	}//END loadGragGratTables
	//var marley:Number;
	//var bob:Number;

	
}//END openGragGratPanel
