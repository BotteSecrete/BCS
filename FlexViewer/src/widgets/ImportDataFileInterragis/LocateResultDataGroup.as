////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package widgets.ImportDataFile
{

	import mx.core.ClassFactory;
	
	import spark.components.DataGroup;
	
	// these events bubble up from the LocateResultItemRenderer
	[Event(name="locateResultClick", type="flash.events.Event")]
	[Event(name="locateResultDelete", type="flash.events.Event")]
	[Event(name="locateResultSave", type="flash.events.Event")]
	[Event(name="LayerVisiblity", type="flash.events.Event")]
	[Event(name="HeatRadius", type="flash.events.Event")]
	[Event(name="ShowPoints", type="flash.events.Event")]
	[Event(name="ChangeHeatType", type="flash.events.Event")]
	
	public class LocateResultDataGroup extends DataGroup
	{
	    public function LocateResultDataGroup()
	    {
	        super();
	
	        this.itemRenderer = new ClassFactory(LocateResultItemRenderer);
	    }
	}
}