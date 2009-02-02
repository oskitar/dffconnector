package dffconnector.services {

	import dffconnector.constants.COMMANDS;
	import dffconnector.constants.SERVICES;
	import dffconnector.core.DrupalConnector;
	import dffconnector.utils.string.objectToString;
	
	
	
	public class DAS_view extends DrupalConnector {
		
	
		private var VIEWS	:Array;	
		private var CALLBACK	:Function;
		private var COMMAND	:String;
		private var BLOCKNAME	:String;
		
	// CONSTRUCTOR
		public function DAS_view(){
			super();
			init();
		}

		private function init():void{
			VIEWS	= new Array();
		}


		public function connect(_gatewayUrl:String = '', apiKey:String = ''):Boolean{
			return _connect(_gatewayUrl,apiKey, SERVICES.VIEWS);
		}
		
	// VIEWS MANIPULATION METHODS 
		
		public function view_get(callback:Function, faultback:Function, name:String , reload:Boolean = false):Boolean {
			
			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.VIEW_GET;
			BLOCKNAME	=	"view_" + String(name)
			
			if (VIEWS[BLOCKNAME] && VIEWS[BLOCKNAME] is Object && !reload) {
				log('DrupalSite: info: Using cache data for view ' + name);
				CALLBACK(VIEWS[BLOCKNAME]);
				return true;
			}
			return startBlocking(onData, faultback, BLOCKNAME, COMMAND, name);
		}

		
	//ONDATA
		private function onData(result:Object):void {
			//dispatchEvent(new DrupalEvents(DrupalEvents.DRUPAL_DATA));
			switch (COMMAND){
				case COMMANDS.VIEW_GET:{
					exec_view_get(result);
					break;
				}
				default:break;
			
			}
		}
	
	// ONDATA 	
		private function exec_view_get(result:Object):void{
			if (result){
				VIEWS[BLOCKNAME] = result;
				log('cached data for view ' + BLOCKNAME);
				CALLBACK(result);
			}else {
				log('bad formatted view:' + BLOCKNAME, "error");
				
			}
			super.stopBlocking();
		}

	}
//EOF
}
