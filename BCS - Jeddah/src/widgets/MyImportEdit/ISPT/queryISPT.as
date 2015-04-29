import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.events.FeatureLayerEvent;

import mx.controls.Text;
import mx.rpc.Fault;

// ActionScript file
private function onISPTQueryResult(featureSet:FeatureSet, columns:Array, isptEditsStarted:Function, token:Object = null):void
{
	if(!ispt.willTrigger(FeatureLayerEvent.EDITS_STARTING))
	{
		ispt.addEventListener(FeatureLayerEvent.EDITS_STARTING, isptEditsStarted);
	}
	
	//geol.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,geolEditsCompleted);
	if(featureSet.features.length>0)
	{
		if(!isptDataGrid.columnCount > 0)
		{
			for each(var att:Object in featureSet.fields)
			{
				if (att.name != "LOCA_ID" 
					&& att.name != "ISPT_SEAT"
					&& att.name != "ISPT_MAIN"
					&& att.name != "ISPT_NPEN"
					&& att.name != "ISPT_CAS"
					&& att.name != "ISPT_WAT"
					&& att.name != "ISPT_HAM"
					&& att.name != "ISPT_SWP"
					&& att.name != "ISPT_INC2"
					&& att.name != "ISPT_INC4"
					&& att.name != "ISPT_INC6"
					&& att.name != "ISPT_PEN2"
					&& att.name != "ISPT_PEN4"
					&& att.name != "ISPT_PEN6"
					&& att.name != "ISPT_ROCK"
					&& att.name != "ISPT_ENV"
					&& att.name != "ISPT_METH"
					&& att.name != "ISPT_CRED"
					&& att.name != "FILE_FSET") // TEST_STAT sert à enregistrer la valuer de ForcedValue? (boolean)
				{
					
					//var col:DataGridColumn = new DataGridColumn(att.name) as DataGridColumn;
					var col:DataGridToolTipColumn = new DataGridToolTipColumn(att.name) as DataGridToolTipColumn;
					//col.setStyle("color",0xffffff);
					col.dataField = att.name;
					col.headerText = att.name;
					col.headerToolTip = att.alias;
					col.headerToolTipPosition = "above";
					col.draggable = false;
					col.dataTipField = "z";
					switch(att.name)
					{
						case "OBJECTID":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "a";
							break;
						
						case "ISPT_TOP":
							col.editable = false;
							col.width = 80;
							col.dataTipField = "b";
							break;
						
						case "ISPT_NVAL":
							col.editable = false;
							col.width = 80;
							col.dataTipField = "c";
							break;
						case "ISPT_REP":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "d";
							break;
						case "ISPT_TYPE":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "e";
							break;
						case "ISPT_ERAT":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "f";
							break;
						case "ISPT_INC1":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "g";
							break;
						case "ISPT_PEN1":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "h";
							break;
						case "ISPT_INC3":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "i";
							break;
						case "ISPT_PEN3":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "j";
							break;
						case "ISPT_INC5":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "k";
							break;
						case "ISPT_PEN5":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "l";
							break;
						case "ISPT_REM":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "m";
							break;
						case "TEST_STAT":
							col.visible = false;
							col.editable = false;
							col.dataTipField = "n";
							break;
						
					}

					columns.push(col);
					columns.sortOn("dataTipField");
				
				}
			}
			isptDataGrid.columns = columns;
			//dataGridDefaultSort(dataGrid,1);
			
		}
		
		var virRegExp:RegExp = /[.]/gi;
		for each(var gr:Graphic in featureSet.features)
		{
			if(gr != null)
			{
				if((gr.attributes.ISPT_TOP != null) && (gr.attributes.ISPT_TOP).toString().search(virRegExp) > -1)
				{
					gr.attributes.ISPT_TOP = (gr.attributes.ISPT_TOP).toString().replace(virRegExp, ",");
				}
				if((gr.attributes.ISPT_NVAL != null) && (gr.attributes.ISPT_NVAL).toString().search(virRegExp) > -1)
				{
					gr.attributes.ISPT_NVAL = (gr.attributes.ISPT_NVAL).toString().replace(virRegExp, ",");
				}
			}
			
			isptGridSource.addItem(gr.attributes);
			isptGridCopie.addItem(gr.attributes);
		}
		isptGridSource.refresh();	
		isptGridCopie.refresh();

		//tablePanel.addElement(dataGrid);
	}
	
	/*if(index.btn.label == 'Open'){
	//var ext:Extent = map.extent;
	//var cent:MapPoint = new MapPoint(map.center.x, map.center.y);
	panelOut.play();
	//map.width = screenWidth - index.panelPopUp.width;
	//Alert.show("test2");
	//AppEvent.dispatch(AppEvent.MAP_RESIZE,{right: index.panelPopUp.width});
	//AppEvent.dispatch(AppEvent.MINIMIZE_VC);
	//map.zoomTo(cent);
	//ViewerContainer.getInstance().width = screenWidth - index.panelPopUp.width;
	
	
	index.btnArrow.setStyle("upSkin",rightArrow);
	index.btnArrow.setStyle("downSkin",rightArrow);
	index.btnArrow.setStyle("overSkin",rightArrow);
	index.btnArrow.setStyle("disableSkin",rightArrow);
	}*/
}//End function: OnQueryResult

private function onISPTQueryFault(fault:Fault, token:Object = null):void
{
	isptGridSource.removeAll();
	//Alert.show("FAUTE !!!");
	var error:Text = new Text();
	error.text = "Aucune entité trouvée pour cet object";
	index.ws1.addElement(error);
	//tablePanel.addElement(error);
}//END Function onQueryFault
