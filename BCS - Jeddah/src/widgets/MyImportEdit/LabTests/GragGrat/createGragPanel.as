import com.esri.ags.FeatureSet;

import mx.containers.Canvas;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.VBox;
import mx.controls.Label;
import mx.controls.TextInput;

// ActionScript file

private function createGragPanel(i:Number, result:FeatureSet):void
{
	var resultCanvas:Canvas = new Canvas();
	resultCanvas.percentHeight = 90;
	resultCanvas.percentWidth = 100;
	resultCanvas.setStyle("showEffect",showEffect);
	
	var vCanvasBox:VBox = new VBox();
	vCanvasBox.percentHeight = 100;
	vCanvasBox.percentWidth = 100;
	
	var grid:Grid = new Grid();
	grid.name = "grid";
	grid.setStyle("color", 0xd22228);
	var gridRow1:GridRow = new GridRow();
	
	var gragCLAYItem:GridItem = new GridItem();
	
	gragCLAYItem.setStyle("verticalAlign", "middle");
	var gragCLAYLabel:Label = new Label();
	gragCLAYLabel.text = "Clay %:";
	gragCLAYItem.addChild(gragCLAYLabel);
	gridRow1.addChild(gragCLAYItem);
	
	var gragCLAYValue:GridItem = new GridItem();
	gragCLAYValue.name = "gragCLAYValue";
	gragCLAYValue.setStyle("verticalAlign", "middle");
	var gragCLAYInput:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_CLAY != null)
	{
		gragCLAYInput.text = result.features[i].attributes.GRAG_CLAY.toString();
	}
	else
	{
		gragCLAYInput.text = "";
	}
	gragCLAYInput.width = 100;
	gragCLAYValue.addChild(gragCLAYInput);
	gridRow1.addChild(gragCLAYValue);
	

	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow1.addChild(gridItemEmpty);
	
	var gragSILTItem:GridItem = new GridItem();
	gragSILTItem.setStyle("verticalAlign", "middle");
	var gragSILTLabel:Label = new Label();
	gragSILTLabel.text = "Silt %:";
	gragSILTItem.addChild(gragSILTLabel);
	gridRow1.addChild(gragSILTItem);
	
	var gragSILTValue:GridItem = new GridItem();
	gragSILTValue.name = "gragSiltValue";
	gragSILTValue.setStyle("verticalAlign", "middle");
	var gragSILTInput:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_SILT != null)
	{
		gragSILTInput.text = result.features[i].attributes.GRAG_SILT.toString();
	}
	else
	{
		gragSILTInput.text = "";
	}
	gragSILTInput.width = 100;
	gragSILTValue.addChild(gragSILTInput);
	gridRow1.addChild(gragSILTValue);
	
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow1.addChild(gridItemEmpty);
	
	var gragSANDItem:GridItem = new GridItem();
	gragSANDItem.setStyle("verticalAlign", "middle");
	var gragSANDLabel:Label = new Label();
	gragSANDLabel.text = "Sand %:";
	gragSANDItem.addChild(gragSANDLabel);
	gridRow1.addChild(gragSANDItem);
	
	var gragSANDValue:GridItem = new GridItem();
	gragSANDValue.name = "gragSandValue";
	gragSANDValue.setStyle("verticalAlign", "middle");
	var gragSANDInput:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_SAND != null)
	{
		gragSANDInput.text = result.features[i].attributes.GRAG_SAND.toString();
	}
	else
	{
		gragSANDInput.text = "";
	}
	gragSANDInput.width = 100;
	gragSANDValue.addChild(gragSANDInput);
	gridRow1.addChild(gragSANDValue);
	
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow1.addChild(gridItemEmpty);
	
	
	var gragGRAVItem:GridItem = new GridItem();
	gragGRAVItem.setStyle("verticalAlign", "middle");
	var gragGRAVLabel:Label = new Label();
	gragGRAVLabel.text = "Gravel %:";
	gragGRAVItem.addChild(gragGRAVLabel);
	gridRow1.addChild(gragGRAVItem);
	
	
	var gragGRAVValue:GridItem = new GridItem();
	gragGRAVValue.name = "gragGravValue";
	gragGRAVValue.setStyle("verticalAlign", "middle");
	var gragGRAVInput:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_GRAV != null)
	{
		gragGRAVInput.text = result.features[i].attributes.GRAG_GRAV.toString();
	}
	else
	{
		gragGRAVInput.text = "";
	}
	gragGRAVInput.width = 100;
	gragGRAVValue.addChild(gragGRAVInput);
	gridRow1.addChild(gragGRAVValue);
	

	grid.addChild(gridRow1);
	
	var gridRow2:GridRow = new GridRow();
	
	var gragD10Item:GridItem = new GridItem();
	gragD10Item.setStyle("verticalAlign", "middle");
	var gragD10Label:Label = new Label();
	gragD10Label.text = "D10: ";
	gragD10Item.addChild(gragD10Label);
	gridRow2.addChild(gragD10Item);
	
	var gragD10Value:GridItem = new GridItem();
	gragD10Value.name = "gragD10Value";
	gragD10Value.setStyle("verticalAlign", "middle");
	var gragD10Input:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_UC != null)
	{
		gragD10Input.text = result.features[i].attributes.GRAG_D10.toString();
	}
	else
	{
		gragD10Input.text = "";
	}
	gragD10Input.width = 100;
	gragD10Value.addChild(gragD10Input);
	gridRow2.addChild(gragD10Value);
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow2.addChild(gridItemEmpty);
	
	var gragD30Item:GridItem = new GridItem();
	gragD30Item.setStyle("verticalAlign", "middle");
	var gragD30Label:Label = new Label();
	gragD30Label.text = "D30: ";
	gragD30Item.addChild(gragD30Label);
	gridRow2.addChild(gragD30Item);
	
	var gragD30Value:GridItem = new GridItem();
	gragD30Value.name = "gragD30Value";
	gragD30Value.setStyle("verticalAlign", "middle");
	var gragD30Input:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_UC != null)
	{
		gragD30Input.text = result.features[i].attributes.GRAG_D30.toString();
	}
	else
	{
		gragD30Input.text = "";
	}
	gragD30Input.width = 100;
	gragD30Value.addChild(gragD30Input);
	gridRow2.addChild(gragD30Value);
	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow2.addChild(gridItemEmpty);
	
	var gragD60Item:GridItem = new GridItem();
	gragD60Item.setStyle("verticalAlign", "middle");
	var gragD60Label:Label = new Label();
	gragD60Label.text = "D60: ";
	gragD60Item.addChild(gragD60Label);
	gridRow2.addChild(gragD60Item);
	
	var gragD60Value:GridItem = new GridItem();
	gragD60Value.name = "gragD60Value";
	gragD60Value.setStyle("verticalAlign", "middle");
	var gragD60Input:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_UC != null)
	{
		gragD60Input.text = result.features[i].attributes.GRAG_D60.toString();
	}
	else
	{
		gragD60Input.text = "";
	}
	gragD60Input.width = 100;
	gragD60Value.addChild(gragD60Input);
	gridRow2.addChild(gragD60Value);
	
	grid.addChild(gridRow2);
	
	var gridRow3:GridRow = new GridRow();
	
	var gragUCItem:GridItem = new GridItem();
	gragUCItem.setStyle("verticalAlign", "middle");
	var gragUCLabel:Label = new Label();
	gragUCLabel.text = "Uniformity coeff:";
	gragUCItem.addChild(gragUCLabel);
	gridRow3.addChild(gragUCItem);
		
	var gragUCValue:GridItem = new GridItem();
	gragUCValue.name = "gragUCValue";
	gragUCValue.setStyle("verticalAlign", "middle");
	var gragUCInput:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_UC != null)
	{
		gragUCInput.text = result.features[i].attributes.GRAG_UC.toString();
	}
	else
	{
		gragUCInput.text = "";
	}
	gragUCInput.width = 100;
	gragUCValue.addChild(gragUCInput);
	gridRow3.addChild(gragUCValue);

	
	var gridItemEmpty:GridItem = new GridItem();
	gridItemEmpty.width = 15;
	gridRow3.addChild(gridItemEmpty);
	
	var gragCCItem:GridItem = new GridItem();
	gragCCItem.setStyle("verticalAlign", "middle");
	var gragCCLabel:Label = new Label();
	gragCCLabel.text = "Curvature coeff:";
	gragCCItem.addChild(gragCCLabel);
	gridRow3.addChild(gragCCItem);
	
	var gragCCValue:GridItem = new GridItem();
	gragCCValue.name = "gragCCValue";
	gragCCValue.setStyle("verticalAlign", "middle");
	var gragCCInput:mx.controls.Label = new mx.controls.Label();
	if(result.features[i].attributes.GRAG_CC != null)
	{
		gragCCInput.text = result.features[i].attributes.GRAG_CC.toString();
	}
	else
	{
		gragCCInput.text = "";
	}
	gragCCInput.width = 100;
	gragCCValue.addChild(gragCCInput);
	gridRow3.addChild(gragCCValue);
	

	var invisibleID:GridItem = new GridItem();
	invisibleID.name = "invisibleID";
	invisibleID.visible = false;
	var gragIDLabel:Label = new Label();
	gragIDLabel.text = result.features[i].attributes.OBJECTID.toString();
	invisibleID.addChild(gragIDLabel);
	gridRow3.addChild(invisibleID);
	
	grid.addChild(gridRow3);
	
	grid.top = 5;
	vCanvasBox.addChild(grid);	

	
	resultCanvas.addChild(vCanvasBox);
	content.addChildAt(resultCanvas,i);
	createGratPanel(i);
}//END of CreateGragGratPanel
