package customRenderer
{
	import mx.controls.List;
	
	public class ListSearch extends List{
		
		private var previous:Number;
		private var current:Number;
		private var pressed:String="";
		
		protected override function findKey(eventCode:int):Boolean{
			current = new Date().time;
			if ((current-previous)>500)
			{
				previous = current;
				pressed = String.fromCharCode(eventCode);
				return super.findKey(eventCode);
			}
			else
			{
				previous = current;
				pressed = pressed + String.fromCharCode(eventCode);
				return findString(pressed);
			}
		}
	}
}