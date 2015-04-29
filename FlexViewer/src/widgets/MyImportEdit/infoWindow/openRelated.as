import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.layers.FeatureLayer;

import mx.controls.Alert;
import mx.events.MenuEvent;
import mx.utils.object_proxy;

// ActionScript file
private function editRelatedFeatures(ev:MenuEvent):void
{
	lastClicked = ev.label;
	switch (ev.label){
		case "Stratigraphy":
			//Get la table Geol
			var url:String = featLayer.url;
			var indGeol:int;
			for(var i:int=0; i<featLayer.layerDetails.relationships.length; i++)
			{
				if(featLayer.layerDetails.relationships[i].name == "BCS_Baku.DBO.GEOL")
				{
					indGeol = featLayer.layerDetails.relationships[i].relatedTableId;
					url = url.split("Feature")[0];
					url += "FeatureServer/" + indGeol;
					geol = new FeatureLayer(url, null, null) as FeatureLayer;
					geol.token = configData.opLayers[0].token;
					geol.disableClientCaching = true;
					geol.refresh();
					var ind:Number;
					for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
					{
						if(featLayer.graphicProvider[id].attributes.OBJECTID == (index.ws0.label).split(", ")[1])
						{
							ind = id;
							break;
						}
					}
					displayGeolTable(featLayer.graphicProvider[ind].attributes.OBJECTID);
					ifMatched();
					break;
				} 
				else 
				{
					Alert.show("Can't find Geol table, sorry... Please contact administrator");	
				}
			}
			break;
		case "Lab Tests":
			var url:String = featLayer.url;
			var indSamp:int;
			var j:int = 0;
			label1:
			do 
			{
				if(featLayer.layerDetails.relationships[j].name == "Attributes from SAMP")
				{
					indSamp = featLayer.layerDetails.relationships[j].relatedTableId;
					url = url.split("Feature")[0];
					url += "FeatureServer/" + indSamp;
					samp = new FeatureLayer(url, null, null);
					samp.token = configData.opLayers[0].token;
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
					ifMatched();
					break label1;
				}
				else if(j == featLayer.layerDetails.relationships.length)
				{
					Alert.show("Can't find SAMP table, sorry... Please contact administrator");	
					break label1;
				}
				else
				{
					j++;
				}
				
			} while (j<20)
			break;
		case "SPT":
			//displayPiezTable(event.features[k].attributes.OBJECTID);
			var url:String = featLayer.url;
			var indIspt:int;
			for(var i:int=0; i<featLayer.layerDetails.relationships.length; i++)
			{
				if(featLayer.layerDetails.relationships[i].name == "Attributes from ISPT")
				{
					indIspt = featLayer.layerDetails.relationships[i].relatedTableId;
					url = url.split("Feature")[0];
					url += "FeatureServer/" + indIspt;
					ispt = new FeatureLayer(url, null, null) as FeatureLayer;
					ispt.token = configData.opLayers[0].token;
					ispt.disableClientCaching = true;
					ispt.refresh();
					var ind:Number;
					for (var id:Number = 0; id < featLayer.graphicProvider.length; id++)
					{
						if(featLayer.graphicProvider[id].attributes.OBJECTID == (index.ws0.label).split(", ")[1])
						{
							ind = id;
							break;
						}
					}
					displaySPTTable(featLayer.graphicProvider[ind].attributes.OBJECTID);
					ifMatched();
					break;
				} 
				else if(i ==  featLayer.layerDetails.relationships.length - 1)
				{
					Alert.show("Can't find SPT table, sorry... Please contact administrator");	
				}
			}
			break;
		case "Coring Information":
		var url:String = featLayer.url;
			var indCore:int;
			for(var i:int=0; i<featLayer.layerDetails.relationships.length; i++)
			{
				if(featLayer.layerDetails.relationships[i].name == "Attributes from CORE")
				{
					indCore = featLayer.layerDetails.relationships[i].relatedTableId;
					url = url.split("Feature")[0];
					url += "FeatureServer/" + indCore;
					core = new FeatureLayer(url, null, null) as FeatureLayer;
					core.token = configData.opLayers[0].token;
					core.disableClientCaching = true;
					core.refresh();
					displayCoreTable(parseFloat((index.ws0.label).split(", ")[1]));
					ifMatched();
					break;
				} 
				else if(i ==  featLayer.layerDetails.relationships.length - 1)
				{
					Alert.show("Can't find CORE table, sorry... Please contact administrator");	
				}
			}
			break;

	}
	
	function ifMatched():void
	{
		index.ws2.visible = index.ws3.visible = false;
		if(clickToAdd){
			clickToAdd = false;
		}
		if (clickToMove)
		{
			clickToMove =  false;
		}
	}
	
} // END OF FUNCTION editRelatedFeatures