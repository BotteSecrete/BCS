import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;

import mx.controls.Text;
import mx.rpc.Fault;

import spark.components.Panel;

// ActionScript file
private function onQuerySAMPResult(featureSet:FeatureSet, columns:Array, addedRow:Boolean, token:Object = null):void
{
	if(featureSet.features.length>0)
	{
		if(!sampDataGrid.columnCount > 0)
		{
			for each(var att:Object in featureSet.fields)
			{
				if (att.name != "SAMP_DTIM" 
					&& att.name!= "SAMP_REF"
					&& att.name!= "SAMP_UBLO"
					&& att.name!= "SAMP_CONT"
					&& att.name!= "SAMP_PREP"
					&& att.name!= "SAMP_SDIA" 
					&& att.name!= "SAMP_WDEP" 
					&& att.name!= "SAMP_RECV" 
					&& att.name!= "SAMP_TECH" 
					&& att.name!= "SAMP_MATX" 
					&& att.name!= "SAMP_TYPC" 
					&& att.name!= "SAMP_WHO" 
					&& att.name!= "SAMP_WHY" 
					&& att.name!= "SAMP_REM" 
					&& att.name!= "SAMP_DESD" 
					&& att.name!= "SAMP_LOG" 
					&& att.name!= "SAMP_COND" 
					&& att.name!= "SAMP_CLSS" 
					&& att.name!= "SAMP_BAR" 
					&& att.name!= "SAMP_TEMP" 
					&& att.name!= "SAMP_PRES"
					&& att.name!= "SAMP_FLOW"
					&& att.name!= "SAMP_ETIM"
					&& att.name!= "SAMP_DURN"
					&& att.name!= "SAMP_CAPT"
					&& att.name!= "SAMP_LINK"
					&& att.name!= "FILE_FSET"
					&& att.name!= "LOCA_ID"
					&& att.name!= "GEOL_STAT"
				)
				{
					
					//var col:DataGridColumn = new DataGridColumn(att.name) as DataGridColumn;
					var col:DataGridToolTipColumn = new DataGridToolTipColumn(att.name) as DataGridToolTipColumn;
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
						case "SAMP_TOP":
							col.sortCompareFunction = numericSortByField("SAMP_TOP");
							col.width = 80;
							col.dataTipField = "c";
						case "SAMP_BASE":
							col.width = 80;
							col.dataTipField = "b";
							break;
						case "SAMP_ID" :
							col.width = 80;
							col.dataTipField = "d";
							break;
						case "SAMP_DESC":
							col.dataTipFunction = buildToolTip;
							col.showDataTips = true;
							col.dataTipField = "g";
							break;
						case "SAMP_TYPE":
							col.width = 80;
							col.dataTipField = "h";
							break;
					}
					columns.push(col);
				}
			}
			
			columns.sortOn("dataTipField");
			
			sampDataGrid.columns = columns;
			//dataGridDefaultSort(sampDataGrid,1);
			
		}
		
		var virRegExp:RegExp = /[.]/gi;
		for each(var gr:Graphic in featureSet.features)
		{
			if(gr != null)
			{
				if((gr.attributes.SAMP_BASE != null) && (gr.attributes.SAMP_BASE).toString().search(virRegExp) > -1)
				{
					gr.attributes.SAMP_BASE = (gr.attributes.SAMP_BASE).toString().replace(virRegExp, ",");
				}
				if((gr.attributes.SAMP_TOP != null) && (gr.attributes.SAMP_TOP).toString().search(virRegExp) > -1)
				{
					gr.attributes.SAMP_TOP = (gr.attributes.SAMP_TOP).toString().replace(virRegExp, ",");
				}
			}
			sampGridSource.addItem(gr.attributes);
			sampGridCopie.addItem(gr.attributes);
		}
		sampGridSource.refresh();	
		sampGridCopie.addItem(gr.attributes);
		if(addedRow)
		{
			sampDataGrid.editedItemPosition = { rowIndex: sampGridSource.length - 1, columnIndex: 2 };
			addedRow = false;
		}
		/*if(!tablePanel.owns(sampDataGrid))
		{
			tablePanel.addElement(sampDataGrid);
		}*/
	}
	
	
	/*if(index.btn.label == 'Open'){
		panelOut.play();
		//Alert.show(index.btnArrow.setStyle("upSkin",rightArrow));
		index.btnArrow.setStyle("upSkin",rightArrow);
		index.btnArrow.setStyle("downSkin",rightArrow);
		index.btnArrow.setStyle("overSkin",rightArrow);
		index.btnArrow.setStyle("disableSkin",rightArrow);
	}*/
	
}//End function: OnQueryResult

private	function onQuerySAMPFault(fault:Fault, token:Object = null):void
{
	sampGridSource.removeAll();
	//Alert.show("FAUTE !!!");
	var error:Text = new Text();
	error.text = "Aucune entité trouvée pour cet object";
	index.ws1.addElement(error);
	
}//END Function onQueryFault