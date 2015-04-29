
package widgets.MyWidget.eventHandlerAttach
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class EventHandler extends EventDispatcher
	{
		private var dispatchList:Array;
		private var eventList:Array;
		
		/***
		 * Purpose: default constructor
		 * Precondition: a reference to the object with event handlers registered to it
		 * Postcondition: a list of the event listeners has been created
		 ***/
		public function EventHandler()
		{
			this.eventList = [];
			this.dispatchList = [];
		}
		
		/***
		 * Purpose: add an event listener
		 * Precondition: type of listener, function, use capture, priority and weak reference
		 * Postcondition: event listener added to the object and the list
		 ***/
		public function addEvtListener(dispatch:*, type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void
		{
			if (!dispatch.hasEventListener(type))
			{
				dispatchList.push({func:dispatch, name:dispatch.name});
				eventList.push({type:type, listener:listener, useCapture:useCapture});
				dispatch.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			else
				trace("EventHandler Error: " + type + " already exists for " + dispatch.name);
		}
		
		/***
		 * Purpose: remove an event listener
		 * Precondition: the type, listener and use capture
		 * Postcondition: event listener removed from the object and list
		 ***/
		public function removeEvtListener(dispatcher:*, type:String, listener:Function, useCapture:Boolean=false):void
		{
			var obj:Object;
			var dispatch:*;
			var i:uint = 0;
			
			while(i < eventList.length)
			{
				obj = eventList[i];
				dispatch = dispatchList[i].func;
				
				if (dispatch == dispatcher && obj.type == type && obj.listener == listener && obj.useCapture == useCapture)
				{
					dispatch.removeEventListener(type, listener, useCapture);
					dispatchList.splice(i, 1);
					eventList.splice(i, 1);
					break;
				}
				++i;
			}
			
			dispatch = null;
			obj = null;
		}
		
		/***
		 * Purpose: remove all event listeners on this object
		 * Precondition: the object to remove listeners from
		 * Postcondition: all listeners have been removed
		 ***/
		public function removeAllEventListeners():void
		{
			var obj:Object;
			var dispatch:*;
			var i:uint = 0;
			
			while(i < eventList.length)
			{
				obj = eventList[i];
				dispatch = dispatchList[i].func;
				dispatch.removeEventListener(obj.type, obj.listener, obj.useCapture);
				++i;
			}
			
			obj = null;
			dispatch = null;
			dispatchList = [];
			eventList = [];
		}
		
		/***
		 * Purpose: returns a list of all current event listeners
		 * Precondition: the object you want listeners for
		 * Postcondition: an array of listeners is returned
		 ***/
		public function getAllEventListeners():Array
		{
			var i:uint = 0;
			var arr:Array = [];
			
			while(i < eventList.length)
			{
				arr.push(dispatchList[i].name + ": " + eventList[i].type);
				++i;
			}
			
			return arr;
		}
		
	} //end class
} //end package