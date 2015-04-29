import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.MapEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.viewer.AppEvent;
import com.esri.viewer.ViewerContainer;
import com.esri.viewer.components.toc.utils.MapUtil;
import com.esri.viewer.managers.MapManager;

import mx.controls.Alert;
import mx.controls.Text;
import mx.rpc.Fault;

import spark.components.Panel;

import widgets.MapSwitcher.MapSwitcherWidget;
import widgets.OverviewMap.OverviewMapComponent;
import widgets.OverviewMap.OverviewMapWidget;

// ActionScript file


private function onQueryResult(featureSet:FeatureSet, columns:Array, geolEditsStarted:Function, token:Object = null):void
{
	if(!geol.willTrigger(FeatureLayerEvent.EDITS_STARTING))
	{
		geol.addEventListener(FeatureLayerEvent.EDITS_STARTING, geolEditsStarted);
	}
	
	//geol.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,geolEditsCompleted);
	if(featureSet.features.length>0)
	{
		if(!dataGrid.columnCount > 0)
		{
			for each(var att:Object in featureSet.fields)
			{
				if (att.name != "GEOL_TOP" 
					&& att.name != "created_user" 
					&& att.name != "created_date" 
					&& att.name != "last_edited_user" 
					&& att.name != "last_edited_date" 
					&& att.name!= "LOCA_ID"
					&& att.name!= "GEOL_BGS"
					&& att.name!= "GEOL_FORM"
					&& att.name!= "Shape"
					&& att.name!= "FILE_FSET" 
					&& att.name!= "GEOL_STAT")
				{
					
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
						
						case "GEOL_LEG":
							col.rendererIsEditor = true;
							col.editorDataField = "result";
							col.itemRenderer =  sizeRen;
							col.width = 190;
							col.dataTipField = "d";
							break;
						
						case "GEOL_BASE":
							col.sortCompareFunction = numericSortByField("GEOL_BASE");
							col.width = 80;
							col.dataTipField = "b";
							break;
						
						case "GEOL_GEOL":
							col.width = 80;
							col.dataTipField = "e";
							if(configXML.USER != "Validateur")
							{
								col.visible = false;
							}
							break;
						
						case "GEOL_TOP" :
							col.width = 80;
							col.dataTipField = "f";
							if(configXML.USER != "Validateur")
							{
								col.visible = false;
							}
							break;
						
						case "GEOL_DESC":
							col.dataTipFunction = buildToolTip;
							col.showDataTips = true;
							col.dataTipField = "c";
							break;
						
						
					}
					columns.push(col);
					columns.sortOn("dataTipField");
				}
			}
			dataGrid.columns = columns;
			//dataGridDefaultSort(dataGrid,1);
			
		}
		
		var virRegExp:RegExp = /[.]/gi;
		for each(var gr:Graphic in featureSet.features)
		{
			if(gr != null)
			{
				if((gr.attributes.GEOL_BASE != null) && (gr.attributes.GEOL_BASE).toString().search(virRegExp) > -1)
				{
					gr.attributes.GEOL_BASE = (gr.attributes.GEOL_BASE).toString().replace(virRegExp, ",");
				}
			}
			
			geolGridSource.addItem(gr.attributes);
			geolGridCopie.addItem(gr.attributes);
		}
		geolGridSource.refresh();	
		geolGridCopie.refresh();
		
		if(addResults != -1)
		{
			dataGrid.editedItemPosition = {columnIndex:1, rowIndex: addResults};
			addResults = -1;
		}
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

private function onQueryFault(fault:Fault, token:Object = null):void
{
	geolGridSource.removeAll();
	//Alert.show("FAUTE !!!");
	var error:Text = new Text();
	error.text = "Aucune entité trouvée pour cet object";
	index.ws1.addElement(error);
	//tablePanel.addElement(error);
}//END Function onQueryFault
