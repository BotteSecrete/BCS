import mx.events.MenuEvent;
import mx.controls.Alert;

protected function myPopUpMenuButton_itemClickHandler(event:MenuEvent):void
{
	
	Alert.show("Vous avez cliqué sur "+ event.label.toString() +" !","Hello");
	
}