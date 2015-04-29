import flash.display.Bitmap;
import flash.events.MouseEvent;

import mx.graphics.ImageSnapshot;

// ActionScript file
private function animate(ev:MouseEvent) : void
{
	goToRightCan.removeEventListener(MouseEvent.CLICK, animate);
	goToLeftCan.removeEventListener(MouseEvent.CLICK, animate);
	switch (ev.currentTarget.id)
	{
		case "goToRightCan":
			nextToPrev.addChildAt(animateImage,1);
			animateImage.width = content.width;
			animateImage.height = content.height;
			animateImage.x = content.x;
			animateImage.y = content.y;
			animateImage.source = new Bitmap(ImageSnapshot.captureBitmapData(content));
			animateImage.visible = true;
			//animateImage.includeInLayout = true;
			
			contentMove.xFrom = content.width;
			contentMove.xTo = 0;
			contentMove.yFrom = 0;
			contentMove.yTo = 0;
			
			imageMove.xFrom = 0;
			imageMove.xTo = -content.width;
			imageMove.yFrom = 0;
			imageMove.yTo = 0;
			
			toggleVisibilityRight();
			break;
		
		case "goToLeftCan":
			//Alert.show(content.numChildren.toString());
			nextToPrev.addChildAt(animateImage,1);
			animateImage.width = content.width;
			animateImage.height = content.height;
			animateImage.x = content.x;
			animateImage.y = content.y;
			animateImage.source = new Bitmap(ImageSnapshot.captureBitmapData(content));
			animateImage.visible = true;
			//animateImage.includeInLayout = true;
			
			contentMove.xFrom = - content.width;
			contentMove.xTo = 0;
			contentMove.yFrom = 0;
			contentMove.yTo = 0;
			
			imageMove.xFrom = animateImage.x;
			imageMove.xTo = content.width + animateImage.x;
			imageMove.yFrom = 0;
			imageMove.yTo = 0;
			
			toggleVisibilityLeft();
			break;
	}
}//End animate


private function toggleVisibilityLeft():void
{
	content.selectedIndex = (content.selectedIndex-1 < 0)? content.numChildren-1 : (content.selectedIndex-1)%content.numChildren;
	contentMove.target = content.selectedChild;
	var tmp:Object = pan1.getChildByName("ctrlBar") as Object;
	var tmpBis:Object = tmp.getChildByName("grainTestNume") as Object;
	tmpBis.text = (content.selectedIndex + 1).toString();
	goToRightCan.addEventListener(MouseEvent.CLICK, animate);
	goToLeftCan.addEventListener(MouseEvent.CLICK, animate);
}

private function toggleVisibilityRight():void
{
	content.selectedIndex = (content.selectedIndex+1)%content.numChildren;
	contentMove.target = content.selectedChild;
	var tmp:Object = pan1.getChildByName("ctrlBar") as Object;
	var tmpBis:Object = tmp.getChildByName("grainTestNume") as Object;
	tmpBis.text = (content.selectedIndex + 1).toString();
	goToRightCan.addEventListener(MouseEvent.CLICK, animate);
	goToLeftCan.addEventListener(MouseEvent.CLICK, animate);
}


