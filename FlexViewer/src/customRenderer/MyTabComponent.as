package customRenderer
{
	import mx.containers.BoxDirection;
	import mx.containers.TabNavigator;
	import mx.core.INavigatorContent;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	public class MyTabComponent extends TabNavigator
	{
		public function MyTabComponent()
		{
			super();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(tabBar!=null)
			{
				tabBar.direction = BoxDirection.VERTICAL;
				
				for (var i:int = 0; i < numChildren; i++)
				{
					var containerChild:INavigatorContent =
					getChildAt(i) as INavigatorContent;
					
					if (containerChild)
					{
						containerChild.move(tabBar.width, 0);
						containerChild.setActualSize(unscaledWidth - tabBar.width, unscaledHeight);
					}
				}
				border.move(tabBar.width, 0);
				border.setActualSize(unscaledWidth - tabBar.width, unscaledHeight);
			}
		}

	}
}