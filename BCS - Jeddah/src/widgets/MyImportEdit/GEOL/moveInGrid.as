import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

// ActionScript file

private function manageKey(event:KeyboardEvent):void
{
	var evt:MouseEvent = new MouseEvent(MouseEvent.CLICK);
	
	if(event.keyCode == 38){
		if(dataGrid.editedItemPosition.rowIndex != 0 || dataGrid.selectedIndex != 0){
			dataGrid.editedItemPosition = {rowIndex: dataGrid.editedItemPosition.rowIndex - 1, columnIndex: dataGrid.editedItemPosition.columnIndex}; 
		}
	}
		
	else if(event.keyCode == 40){
		if(dataGrid.editedItemPosition.rowIndex != geolGridSource.length - 1 || dataGrid.selectedIndex != geolGridSource.length - 1){
			dataGrid.editedItemPosition = {rowIndex: dataGrid.editedItemPosition.rowIndex + 1, columnIndex: dataGrid.editedItemPosition.columnIndex}; 
		}
	}
}