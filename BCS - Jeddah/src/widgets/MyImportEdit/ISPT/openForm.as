import com.esri.ags.FeatureSet;
import com.esri.ags.tasks.supportClasses.Query;

import mx.containers.Grid;
import mx.controls.Alert;
import mx.controls.Label;
import mx.controls.Text;
import mx.events.IndexChangedEvent;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;

import spark.components.TextArea;
import spark.components.TextInput;


// ActionScript file
private function openISPTForm(rowIndex:Number, gridSPT:Grid):void
{
	var query:Query = new Query();
	query.objectIds = [isptGridSource.getItemAt(rowIndex).OBJECTID];
	query.outFields = ["*"];
	ispt.queryFeatures(query, new AsyncResponder(onISPTFormQueryResult, onISPTFormQueryFault));
}

private function onISPTFormQueryResult(featureSet:FeatureSet, token:Object = null):void
{
	if(featureSet.features.length == 1) 
	{
		var gridSPT:Grid = index.ws2.getChildAt(0) as Grid;
		for(var id:String in featureSet.features[0].attributes) {
			
			var val:Object = featureSet.features[0].attributes[id];
			var value:String = val != null? val.toString():"0";
			//Alert.show(id + " = " + value);

			switch (id)
			{
				case "ISPT_TOP":
					var tmp1:Object = new Object();
					tmp1 = gridSPT.getChildAt(0) as Object; //GridRow1
					var ti1:spark.components.TextInput = tmp1.getChildAt(1).getChildAt(0) as spark.components.TextInput; //GridItem -> TextInput
					ti1.text = value;
				break;
				case "ISPT_TYPE":
					
				break;
				case "ISPT_ERAT":
					var tmp2:Object = new Object();
					tmp2 = gridSPT.getChildAt(0) as Object;
					var ti2:spark.components.TextInput = tmp2.getChildAt(5).getChildAt(0) as spark.components.TextInput;
					ti2.text = value;
				break;
				case "ISPT_INC1":
					var tmp3:Object = new Object();
					tmp3 = gridSPT.getChildAt(1) as Object;
					var ti3:spark.components.TextInput = tmp3.getChildAt(1).getChildAt(0) as spark.components.TextInput;
					ti3.text = value;
				break;
				case "ISPT_PEN1":
					var tmp4:Object = new Object();
					tmp4 = gridSPT.getChildAt(1) as Object;
					var ti4:spark.components.TextInput = tmp4.getChildAt(3).getChildAt(0) as spark.components.TextInput;
					ti4.text = value;
				break;
				case "ISPT_INC3":
					var tmp5:Object = new Object();
					tmp5 = gridSPT.getChildAt(2) as Object;
					var ti5:spark.components.TextInput = tmp5.getChildAt(1).getChildAt(0) as spark.components.TextInput;
					ti5.text = value;
				break;
				case "ISPT_PEN3":
					var tmp6:Object = new Object();
					tmp6 = gridSPT.getChildAt(2) as Object;
					var ti6:spark.components.TextInput = tmp6.getChildAt(3).getChildAt(0) as spark.components.TextInput;
					ti6.text = value;
				break;
				case "ISPT_INC5":
					var tmp7:Object = new Object();
					tmp7 = gridSPT.getChildAt(3) as Object;
					var ti7:spark.components.TextInput = tmp7.getChildAt(1).getChildAt(0) as spark.components.TextInput;
					ti7.text = value;
				break;
				case "ISPT_PEN5":
					var tmp8:Object = new Object();
					tmp8 = gridSPT.getChildAt(3) as Object;
					var ti8:spark.components.TextInput = tmp8.getChildAt(3).getChildAt(0) as spark.components.TextInput;
					ti8.text = value;
				break;
				case "ISPT_NVAL":
					var tmp9:Object = new Object();
					tmp9 = gridSPT.getChildAt(4) as Object;
					var ti9:Label = tmp9.getChildAt(1).getChildAt(0) as Label;
					ti9.text = value;
				break;
				case "ISPT_REP":
					var tmp10:Object = new Object();
					tmp10 = gridSPT.getChildAt(4) as Object;
					var ti10:Label = tmp10.getChildAt(3).getChildAt(0) as Label;
					ti10.text = value;
				break;
				case "ISPT_REM":
					var tmp11:Object = new Object();
					tmp11 = gridSPT.getChildAt(5) as Object;
					var ta:spark.components.TextArea = tmp11.getChildAt(1).getChildAt(0) as spark.components.TextArea;
					ta.text = value;
				break;
			}
			//TODO switch case on attributes displayed on gridSPT! index.ws2.getChildAt(0) :)
		}
		
	}
	else
	{
		Alert.show("An error occured, try to redo operation or actualise the browser");
	}
}

private function onISPTFormQueryFault(fault:Fault, token:Object = null):void
{
	//isptGridSource.removeAll();
	//Alert.show("FAUTE !!!");
	var error:Text = new Text();
	error.text = "Aucune entité trouvée pour cet object";
	index.ws2.addElement(error);
	//tablePanel.addElement(error);
}
