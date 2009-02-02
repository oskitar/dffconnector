package dffconnector.services {


	import dffconnector.constants.COMMANDS;
	import dffconnector.constants.SERVICES;
	import dffconnector.core.DrupalConnector;
	import dffconnector.utils.string.objectToString;

	
	public class DAS_taxonomy extends DrupalConnector {
		
	
		public var CATEGORIES	:Array;	
		public var NODELIST	:Array;
		private var CALLBACK	:Function;
		private var COMMAND	:String;
		private var BLOCKNAME	:String;

		
	// CONSTRUCTOR
		public function DAS_taxonomy(){
			super();
			init();
		}


		private function init():void{
			CATEGORIES	= new Array();
			NODELIST	= new Array();
		}


		public function connect(_gatewayUrl:String = '', apiKey:String = ''):Boolean{
			return _connect(_gatewayUrl,apiKey, SERVICES.TAXONOMY);
		}

		
	// CATEGORIES MANIPULATION METHODS 
		public function taxonomy_getTree(callback:Function, faultback:Function, vid:int , reload:Boolean = false):Boolean {
			
			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.TAXONOMY_GETTREE;
			BLOCKNAME	=	"taxonomy_getTree_"+ String(vid);
			
			if (CATEGORIES[BLOCKNAME] && CATEGORIES[BLOCKNAME] is Object && !reload) {
				log('DrupalSite: info: Using cache data for view ' + BLOCKNAME);
				CALLBACK(CATEGORIES[BLOCKNAME]);
				return true;
			}
			return startBlocking(onData, faultback, BLOCKNAME, COMMAND, vid);
		}
		

		public function taxonomy_getNodes(callback:Function, faultback:Function, vid:Array , reload:Boolean = false):Boolean {
			
			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.TAXONOMY_GETNODES;
			BLOCKNAME	=	"taxonomy_getNodes_"+ String(vid[0]);
			
			return startBlocking(onData, faultback, BLOCKNAME, COMMAND, vid);
		}

		
	//ONDATA
		private function onData(result:Object):void {
			//dispatchEvent(new DrupalEvents(DrupalEvents.DRUPAL_DATA));
			switch (COMMAND){
				case COMMANDS.TAXONOMY_GETTREE:{
					exec_taxonomy_getTree(result);
					break;
				}
				case COMMANDS.TAXONOMY_GETNODES:{
					exec_taxonomy_getNodes(result);
					break;
				}
				default:break;
			}
		}

	
	// ONDATA 
		private function exec_taxonomy_getNodes(result:Object):void{
			if (result){
				for (var i:* in result ){
					NODELIST.push(result[i]);
					log('cached NODE data for taxonomy vid:: ' + i);
				}
				super.stopBlocking();
				CALLBACK(result);
			}else {
				log('Empty return taxonomy:' + BLOCKNAME, "error");
				super.stopBlocking();
			}
			
		}
		

		private function exec_taxonomy_getTree(result:Object):void{
			if (result){
				for (var i:int = 0; i < result.length; i++) {
					if (!CATEGORIES[BLOCKNAME] || !(CATEGORIES[BLOCKNAME] is Array)) {
						CATEGORIES[BLOCKNAME] = new Array();
					}
					if (result[i].tid) {
						CATEGORIES[BLOCKNAME][result[i].tid] = result[i];
					}
				}
				log('cached data for taxonomy tree: ' + BLOCKNAME);
				super.stopBlocking();
				CALLBACK(result);
			}else {
				log('bad formatted taxonomy tree: ' + BLOCKNAME, "error");
				super.stopBlocking();
			}
			
		}
	}	
//EOF
}


