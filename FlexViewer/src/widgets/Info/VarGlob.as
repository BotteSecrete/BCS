import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.SpatialReference;
import com.esri.ags.components.supportClasses.InfoWindow;
import com.esri.ags.events.FeatureLayerEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.events.MapMouseEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.layers.GraphicsLayer;
import com.esri.ags.layers.Layer;
import com.esri.ags.layers.supportClasses.FeatureEditResults;
import com.esri.ags.portal.supportClasses.PopUpFieldFormat;
import com.esri.ags.skins.supportClasses.AttachmentMouseEvent;
import com.esri.ags.symbols.Symbol;
import com.esri.ags.tasks.QueryTask;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.ags.tools.DrawTool;
import com.esri.ags.utils.WebMercatorUtil;
import com.esri.viewer.AppEvent;
import com.esri.viewer.ViewerContainer;
import com.esri.viewer.managers.WidgetManager;
import com.fnicollet.toaster.message.avast.ToastMessageAvast;
import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;

import flash.filters.GlowFilter;
import flash.net.navigateToURL;
import flash.sampler.NewObjectSample;
import flash.utils.setTimeout;

import mx.charts.AreaChart;
import mx.charts.AxisRenderer;
import mx.charts.CategoryAxis;
import mx.charts.GridLines;
import mx.charts.Legend;
import mx.charts.LineChart;
import mx.charts.LinearAxis;
import mx.charts.LogAxis;
import mx.charts.chartClasses.AxisBase;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.renderers.CircleItemRenderer;
import mx.charts.series.AreaSeries;
import mx.charts.series.LineSeries;
import mx.charts.series.PlotSeries;
import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.containers.Box;
import mx.containers.Canvas;
import mx.containers.Form;
import mx.containers.FormItem;
import mx.containers.Grid;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.HBox;
import mx.containers.TitleWindow;
import mx.containers.VBox;
import mx.containers.VDividedBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.DataGrid;
import mx.controls.DateField;
import mx.controls.Menu;
import mx.controls.PopUpMenuButton;
import mx.controls.Text;
import mx.controls.TextArea;
import mx.controls.TextInput;
import mx.controls.ToolTip;
import mx.core.ClassFactory;
import mx.core.ScrollPolicy;
import mx.core.UITextField;
import mx.effects.easing.Bounce;
import mx.effects.easing.Exponential;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.CloseEvent;
import mx.events.CollectionEvent;
import mx.events.DataGridEvent;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.ResizeEvent;
import mx.formatters.DateFormatter;
import mx.formatters.NumberFormatter;
import mx.graphics.ImageSnapshot;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncResponder;
import mx.rpc.AsyncToken;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;
import mx.states.AddChild;
import mx.utils.Base64Encoder;
import mx.utils.ObjectUtil;
import mx.utils.object_proxy;
import mx.validators.NumberValidator;

import spark.components.Panel;
import spark.components.TitleWindow;
import spark.components.VGroup;

import DataGridToolTipColumn;

import ImageRadioButton;

import customRenderer.MyTabComponent;
import customRenderer.RadioDgRenderer;
import customRenderer.SizeRenderer;

import flashx.textLayout.debug.assert;

import flexlib.charts.HorizontalAxisDataSelector;

import widgets.Edit.EditWidgetAttachmentInspectorSkin;
import widgets.MyWidget.eventHandlerAttach.EventHandler;


// Define a variable to hold the cursor ID.
private var cursorID:Number = 0;

private var lastClicked:String;

[Embed(source='assets/images/rightArrow.png')]
private static var rightArrow:Class;

[Embed(source='assets/images/leftArrow.png')]
private static var leftArrow:Class;
// Embed the cursor symbol.

[Embed(source="assets/images/ajax-loader.gif")]
private var waitCursorSymbol:Class;	

[Bindable] 
public var attachmentsLabel:String;

[Bindable] 
public static var featLayer:FeatureLayer;

private var geol:FeatureLayer;
private var samp:FeatureLayer;
private var grag:FeatureLayer;
private var grat:FeatureLayer;
private var ispt:FeatureLayer;
private var core:FeatureLayer;
private var cond:FeatureLayer;
private var struct:FeatureLayer;
private var attachFeat:FeatureLayer;


var qResultsFI:Array = [];
var qResultsUIZ:Array = [];
var qResultsUB:Array = [];
var qResultsHB:Array = [];
var qResultsBC:Array = [];
var qResultsSR:Array = [];
var qResultsRT:Array = [];
var qResultsSI:Array = [];
var qResultsFM:Array = [];
var qResultsSRS:Array = [];
var qResultsSRD:Array = [];
var qResultsFMS:Array = [];
var qResultsFMD:Array = [];
var qResultsDR:Array = [];
var qResultsTF:Array = [];
var qResultsOD:Array = [];
var qResultsCD:Array = [];

var batiArray:Array = [];
var structArray:Array = [];
var condArray:Array = [];
var attachArray:Array = [];

var field:String;
var indRow:Number;


var isIn:Boolean;
var isInCond:Boolean;
var isInAttach:Boolean;

[Bindable]
public static var dpProj:Array = [];



[Bindable]
public static var isOpened:Boolean;

private var dpSiteLocation:ArrayCollection =  new ArrayCollection();			
[Bindable]

private var featLayerGraphic:Graphic;

private var changedStatus:Boolean;
private var clickToAdd:Boolean;
private var coordToMove:Boolean;
private var clickToMove:Boolean;
private var objectIdToMove:Number;
private var dontDisplay:Boolean = false;
private var opened:Boolean = false;
public static var index:Object = new Object();
private var HButtonBox:HBox = new HBox();
private var addResults:Number = -1;
private var VPanelBox:VBox = new VBox();
private var tooltip:mx.controls.ToolTip;  
private var form:Form = new Form();
private var grid:Grid = new Grid();
private var sampGridSource:ArrayCollection = new ArrayCollection();
private var sampGridCopie:ArrayCollection = new ArrayCollection();		
private var geolGridSource:ArrayCollection = new ArrayCollection();
private var geolGridCopie:ArrayCollection = new ArrayCollection();
private var isptGridSource:ArrayCollection = new ArrayCollection();
private var isptGridCopie:ArrayCollection = new ArrayCollection();
private var sizeRen:ClassFactory;
private var coreGridSource:ArrayCollection = new ArrayCollection();
private var coreGridCopie:ArrayCollection = new ArrayCollection();
var bord:Canvas = new Canvas();
var bordbis:Canvas = new Canvas();
var myMiniMap:Map = new Map();
var myGraphicsLayer:GraphicsLayer = new GraphicsLayer();
var minLayer:FeatureLayer; 

var featInd:Number;

var attachEventDispatch:EventHandler = new EventHandler();

var attachGen:Boolean = false;
var attachStruct:Boolean = false;
var attachCond:Boolean = false;

var isFirstAttachGen:Boolean = true;
var isFirstAttachCond:Boolean = true;
var isFirstAttachStruct:Boolean = true;

var isGene:Boolean = false;
var isNotFStruct:Boolean = false;
var isNotFCond:Boolean = false;
var isAtt:Boolean = false;

var isLocalisation:Boolean = false;
var isOverview:Boolean = false;
var isDescription = false;
var isSketches = false;
var isAttach = false;
var isPlan = false;

[Bindable]
private var screenWidth:Number;

[Bindable]
private var screenHeight:Number;