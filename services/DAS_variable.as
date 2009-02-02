package dffconnector.services {

	
	import dffconnector.constants.COMMANDS;
	import dffconnector.constants.SERVICES;
	import dffconnector.core.DrupalConnector;
	import dffconnector.utils.string.objectToString;



	public class DAS_variable extends DrupalConnector {


		public var VARLIST	:Array;	
		private var CALLBACK	:Function;
		private var COMMAND	:String;
		private var BLOCKNAME	:String;


	// CONSTRUCTOR
		public function DAS_variable(){
			super();
			init();
		}


		private function init():void{
			VARLIST	= new Array();
		}


		public function connect(_gatewayUrl:String = '', apiKey:String = ''):Boolean{
			return _connect(_gatewayUrl,apiKey, SERVICES.SYSTEM);
		}


	// VARIABLE MANIPULATION METHODS 
		public function variable_set(callback:Function, faultback:Function, variable:Object , reload:Boolean = false):Boolean {

			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.SYSTEM_SET_VARIABLE;
			BLOCKNAME	=	"variable_set_"+ String(variable[0]);

			if (VARLIST[variable["name"]]  && !reload) {
				VARLIST[variable["name"]]=variable["value"];
				log('DrupalSite: info: Using cache data for variable::'+variable["name"] +"=" +VARLIST[variable["name"]]);
				CALLBACK(true);
				return true;
			}
			
			return startBlocking(onData, faultback, BLOCKNAME, COMMAND,variable["name"],variable["value"]);
		}
		

		public function variable_get(callback:Function, faultback:Function, variable:Object , reload:Boolean = false):Boolean {

			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.SYSTEM_GET_VARIABLE;
			BLOCKNAME	=	"variable_get_"+ String(variable.name);

			return startBlocking(onData, faultback, BLOCKNAME, COMMAND, variable);
		}


	//ONDATA
		private function onData(result:Object):void {
			//dispatchEvent(new DrupalEvents(DrupalEvents.DRUPAL_DATA));
			log ("-------"+result);
			switch (COMMAND){
				case COMMANDS.SYSTEM_GET_VARIABLE:{
					exec_variable_get(result);
					break;
				}
				case COMMANDS.SYSTEM_SET_VARIABLE:{
					exec_variable_set(result);
					break;
				}
				
				default:break;
			}
		}


	// ONDATA
	
		private function exec_variable_get(result:Object):void{
			if (result){
				super.stopBlocking();
				CALLBACK(result);
			}else {
				log(BLOCKNAME + ' not get.'+ "error");
				super.stopBlocking();
			}
			
		}
		
		private function exec_variable_set(result:Object):void{
			if (result){
				super.stopBlocking();
				CALLBACK(result);
			}else {
				log(BLOCKNAME + ' not set.'+ "error");
				super.stopBlocking();
			}
		}
	}	
//EOF
}


