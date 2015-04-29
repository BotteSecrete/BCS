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


private function onCoreQueryResult(featureSet:FeatureSet, columns:Array, coreEditsStarted:Function, token:Object = null):void
{
	if(!core.willTrigger(FeatureLayerEvent.EDITS_STARTING))
	{
		core.addEventListener(FeatureLayerEvent.EDITS_STARTING, coreEditsStarted);
	}
	
	//geol.addEventListener(FeatureLayerEvent.EDITS_COMPLETE,geolEditsCompleted);
	if(featureSet.features.length>0)
	{
		if(!coreDataGrid.columnCount > 0)
		{
			for each(var att:Object in featureSet.fields)
			{
				if (att.name != "LOCA_ID" 
					&& att.name != "CORE_DURN" 
					&& att.name != "FILE_FSET")
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
						
						case "CORE_TOP":
							//col.sortCompareFunction = numericSortByField("GEOL_BASE");
							col.width = 80;
							col.dataTipField = "b";
							break;

						case "CORE_BASE":
							//col.sortCompareFunction = numericSortByField("GEOL_BASE");
							col.width = 80;
							col.dataTipField = "c";
							break;

						case "CORE_PREC":
							//col.sortCompareFunction = numericSortByField("GEOL_BASE");
							col.width = 80;
							col.dataTipField = "d";
							break;

						case "CORE_SREC":
							//col.sortCompareFunction = numericSortByField("GEOL_BASE");
							col.width = 80;
							col.dataTipField = "e";
							break;

 						case "CORE_RQD":
							//col.sortCompareFunction = numericSortByField("GEOL_BASE");
							col.width = 80;
							col.dataTipField = "f";
							break;

						case "CORE_DIAM":
							//col.sortCompareFunction = numericSortByField("GEOL_BASE");
							col.width = 80;
							col.dataTipField = "g";
							break;

						case "CORE_REM":
							col.dataTipFunction = buildToolTip;
							col.showDataTips = true;
							col.dataTipField = "h";
							break;
						
						
					}
					columns.push(col);
					columns.sortOn("dataTipField");
				}
			}
			coreDataGrid.columns = columns;
			//dataGridDefaultSort(dataGrid,1);
			
		}
		
		var virRegExp:RegExp = /[.]/gi;
		for each(var gr:Graphic in featureSet.features)
		{
			if(gr != null)
			{
				if((gr.attributes.CORE_BASE != null) && (gr.attributes.CORE_BASE).toString().search(virRegExp) > -1)
				{
					gr.attributes.CORE_BASE = (gr.attributes.CORE_BASE).toString().replace(virRegExp, ",");
				}
				if((gr.attributes.CORE_TOP != null) && (gr.attributes.CORE_TOP).toString().search(virRegExp) > -1)
				{
					gr.attributes.CORE_TOP = (gr.attributes.CORE_TOP).toString().replace(virRegExp, ",");
				}
			}
			
			coreGridSource.addItem(gr.attributes);
			coreGridCopie.addItem(gr.attributes);
		}
		coreGridSource.refresh();	
		coreGridCopie.refresh();
		
		if(addResults != -1)
		{
			coreDataGrid.editedItemPosition = {columnIndex:1, rowIndex: addResults};
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

private function onCoreQueryFault(fault:Fault, token:Object = null):void
{
	coreGridSource.removeAll();
	//Alert.show("FAUTE !!!");
	var error:Text = new Text();
	error.text = "Aucune entité trouvée pour cet object";
	index.ws1.addElement(error);
	//tablePanel.addElement(error);
}//END Function onQueryFault
