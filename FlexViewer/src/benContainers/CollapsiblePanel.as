/*
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in
compliance with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS"
basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
License for the specific language governing rights and limitations
under the License.

The Original Code is: www.iwobanas.com code samples.

The Initial Developer of the Original Code is Iwo Banas.
Portions created by the Initial Developer are Copyright (C) 2009
the Initial Developer. All Rights Reserved.

Contributor(s):
*/
package benContainers
{
	import flash.events.MouseEvent;
	
	import spark.components.Button;Button;
	import spark.components.Panel;
	import com.esri.viewer.ViewerContainer;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import spark.skins.spark.mediaClasses.normal.FullScreenButtonSkin;

	import spark.skins.spark.mediaClasses.fullScreen.FullScreenButtonSkin;
import mx.core.mx_internal;
import spark.effects.Resize;
import spark.effects.easing.Power;
import spark.effects.Move;
import com.esri.viewer.AppEvent;

	/**
	 * The CollapsiblePanel class adds support for collapsing (minimizing) to the Spark Panel.
	 */
	
	public class CollapsiblePanel extends Panel
	{
		[SkinPart(required="false")]
		
		/**
		 *  The skin part that defines the appearance of the 
		 *  button responsible for collapsing/uncollapsing the panel.
		 */
		
		
		//private var _open:Boolean = true;
		public var collapseButton:Button;
		[SkinPart(required="false")]
		public var fullScreenButton:Button;
		protected var uncollapsedPercentWidth:Number = NaN;
		protected var uncollapsedExplicitWidth:Number = NaN;
		


		
		/**
		 * Flag indicating whether this panel is collapsed (minimized) or not.
		 */ 
		public function get collapsed():Boolean
		{
			return _collapsed;
		}
		/**
		 * @private
		 */
		public function set collapsed(value:Boolean):void
		{
			if (value)
			{
				uncollapsedExplicitWidth = explicitWidth;
				uncollapsedPercentWidth = percentWidth;
				explicitWidth = NaN;
				percentWidth = NaN;
			}
			else
			{
				explicitWidth = uncollapsedExplicitWidth;
				percentWidth = uncollapsedPercentWidth;
				

			}
			_collapsed = value;
			invalidateSkinState();
		}
		
		public function get fullScreen():Boolean
		{
			return _fullScreen;
		}
		/**
		 * @private
		 */
		public function set fullScreen(value:Boolean):void
		{
			_fullScreen = value;
			invalidateSkinState();
		}
		
		/**
		 * @private
		 * Toggle collapsed state on collapseButton click event.
		 */
		protected function collapseButtonClickHandler(event:MouseEvent):void
		{
			collapsed = !collapsed;
			this.explicitWidth = this._collapsed ? this.explicitWidth : ((50 * stage.stageWidth / 100) > 950 ?  (50 * stage.stageWidth / 100) : stage.stageWidth - 950);

			var easer0:Power = new Power(0);
			var easer1:Power = new Power(1);
			var move:Move = new Move(ViewerContainer.getInstance());
			move.xTo = collapsed ? 30 : this.explicitWidth;
			move.easer = collapsed ? easer1 : easer0;
			move.play([ViewerContainer.getInstance()]);
			var rsVC:Resize =  new Resize(ViewerContainer.getInstance());
			rsVC.easer = collapsed ? easer1 : easer0;
			rsVC.widthTo = collapsed ? (stage.stageWidth - 30) : (stage.stageWidth - this.explicitWidth);
			rsVC.play([ViewerContainer.getInstance()]);
			var pan:Number = !collapsed ? this.explicitWidth/2 : this.width/2;
			//lancer AppEvent pour move Map
			AppEvent.dispatch(AppEvent.MIN_PAN_MAP, {pan: pan, collapsed:collapsed});
			
			if (fullScreen)
			{
				fullScreen = !fullScreen;
				fullScreenButton.setStyle('skinClass', Class(spark.skins.spark.mediaClasses.normal.FullScreenButtonSkin));
			}
		}
		
		protected function fullScreenButtonClickHandler(event:MouseEvent):void
		{
			fullScreen = !fullScreen;
			
			AppEvent.dispatch(AppEvent.COLLAPSE_PANEL_RESIZE);

			if (fullScreen)
			{
				fullScreenButton.setStyle('skinClass', Class(spark.skins.spark.mediaClasses.fullScreen.FullScreenButtonSkin));
				this.explicitWidth = stage.stageWidth;
			}
			else
			{
				fullScreenButton.setStyle('skinClass', Class(spark.skins.spark.mediaClasses.normal.FullScreenButtonSkin));
				this.explicitWidth = this._collapsed ? this.explicitWidth : ((50 * stage.stageWidth / 100) > 950 ?  (50 * stage.stageWidth / 100) : stage.stageWidth - 950);  
			}
			
			

		}
		
		/**
		 * @private
		 * storage variable for <code>collapsed</code>property.
		 * Add collapeButton click listener.
		 */
		protected var _collapsed:Boolean;
		protected var _fullScreen:Boolean;
		

		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if (instance == collapseButton)
			{
				Button(instance).addEventListener(MouseEvent.CLICK, collapseButtonClickHandler);
			} 
			else if (instance == fullScreenButton)
			{
				Button(instance).addEventListener(MouseEvent.CLICK, fullScreenButtonClickHandler);
			}
		}
		
		/**
		 * @private
		 * Remove collapeButton click listener.
		 */
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			if (instance == collapseButton)
			{
				Button(instance).removeEventListener(MouseEvent.CLICK, collapseButtonClickHandler);
			}
			else if (instance == fullScreenButton)
			{
				Button(instance).removeEventListener(MouseEvent.CLICK, fullScreenButtonClickHandler);
			}
			super.partRemoved(partName, instance);
		}
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{
			if (collapsed)
				return "collapsed";
			
			if (fullScreen)
				return "fullScreen";
			
			return super.getCurrentSkinState();
		}
		
	}
}