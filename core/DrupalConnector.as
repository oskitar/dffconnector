package dffconnector.core {

	import dffconnector.constants.INFO;
	import dffconnector.constants.COMMANDS;

	import dffconnector.core.Block;

//	import dffconnector.datatypes.Node;

	import dffconnector.errors.GATEWAY_ERROR;
	import dffconnector.errors.CONNECTION_FAULT;

	import dffconnector.events.DrupalEvents;

	import dffconnector.services.AmfService;

	import dffconnector.utils.string.objectToString;
	import dffconnector.utils.string.URLValidator;
	import dffconnector.utils.string.KEYValidator;


	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;

	import com.carlcalderon.arthropod.Debug;

	public class DrupalConnector implements IEventDispatcher {
		// PUBLIC PROPERTIES
		public var GATEWAYURL	:String = '';
		public var SESSIONID	:String = '';
		public var SERVICE_TYPE	:String;
		public var KEY		:String;
		public var CONNECTED	:Boolean;
		public var UID		:int;
		public var USER		:Object;


		// PRIVATE VARIABLES
		private var VERBOSE	:Boolean = true;
		private var VIEWS	:Array;
		private var CATEGORIES	:Array;
		private var BLOCK	:Block;
		private var AMF		:AmfService;
		private var dispatcher	:EventDispatcher;
		
		
	// CONSTRUCTOR
		public function DrupalConnector():void{
			super();
			log(INFO.NAME + "\n" + INFO.VERSION + "\n" + INFO.DATE + "\n" + INFO.LICENSE);
			init();
		}

		
	// PRIVATE FUNCTIONS
		private function init():void{
			CONNECTED	=	false;
			UID		=	0;
			dispatcher	=	new EventDispatcher();
			BLOCK		=	new Block();
		}


		protected function _connect(_gatewayUrl:String = '', apiKey:String = '', service_type:String =''):Boolean{
			log('Attempting to connect to AMFPHP interface at URL: ' + _gatewayUrl);
			if (URLValidator.isURL(_gatewayUrl)) {
				this.GATEWAYURL	=	_gatewayUrl;
				AMF		=	new AmfService(GATEWAYURL);							
			}else {
				log(GATEWAY_ERROR.BAD_URL);
				return false;
			}
			
			if (service_type !=""){
				SERVICE_TYPE= service_type;
			}else {
				log (CONNECTION_FAULT.SERVICE_UNKNOW)
				return false;
			}
			
			if (KEYValidator.isKEY(apiKey)) {
				KEY	=	apiKey;				
			}else {
				log('Warning: No API key specified.');
			}
			
			log ("SERVICE_TYPE:: "+SERVICE_TYPE);
			return startBlocking(onConnect, onConnectFault, 'connect', COMMANDS.SYSTEM_CONNECT);
		}

		private function isModule():Boolean {
			return startBlocking(onIsModule, onIsModuleFault, 'exist', COMMANDS.SYSTEM_MODULE_EXIST, SERVICE_TYPE);
		}



	// BLOCKING METHODS
		protected function startBlocking(callback:Function, faultback:Function, name:String, cmd:String, ... args):Boolean {
			if (BLOCK.blocked) {
				log('DrupalSite: info: Service call already running');
				return false;
			}
			log ("STARTBLOCKING:: name=" + name + ";  command=" + cmd +"\n" + objectToString(args));
			BLOCK.blocked	= true;
			BLOCK.name	= name;
			BLOCK.callBack	= callback ;
			BLOCK.faultBack	= faultback || onConnectFault;
//			BLOCK.maxtryings= 3;
//			BLOCK.maxtryings_faultBack;
			
//			BLOCK.data	= ""//data;
			BLOCK.command	= cmd;
			BLOCK.args	= args;
		
			AMF.service(BLOCK.callBack, BLOCK.faultBack, BLOCK.command, BLOCK.args);

			BLOCK.addTimer(checkBlocking);
			return true;
		}
		
		
		private  function checkBlocking(ev:TimerEvent):void {
			log('DrupalSite: info: Retrying service call ' + BLOCK.command);
			// service method will overwrite arguments variable
			/*var temp:Array = new Array();
			for (var i:int = 0; i < BLOCK.args.length; i++) {
				temp[i] = BLOCK.args[i];
			}*/
			AMF.service(BLOCK.callBack, BLOCK.faultBack, BLOCK.command, BLOCK.args);
		}
		
		
		protected function stopBlocking():void {
			BLOCK.reset();
			log("reset","error");
		}


	// CALLBACKS	
		private function onConnect (result:Object):void{
			log('Flash is connected to AMFPHP interface.');
			SESSIONID = result.sessid;
			CONNECTED = true;
			if (result.user is Object) {
				
				UID = result.user.userid;
				log(String(UID));
				USER = result.user;
				log (objectToString(USER));
			}
			stopBlocking();
			isModule();
			//dispatchEvent(new DrupalEvents(DrupalEvents.DRUPAL_READY));
		}

		
		private function onIsModule (result:Object):void{
			if (result){
				log('MODULE EXIST'+objectToString(result));
				stopBlocking();
				dispatchEvent(new DrupalEvents(DrupalEvents.DRUPAL_READY));
			}else {
				onConnectFault(result);
			}
		}

		
		private function onIsModuleFault(e:*):void{
			log('MODULE NOT EXIST',"error");
		}
	

	// ERROR HANDLER
		private function onConnectFault(error:Object):void{
			log(CONNECTION_FAULT.SERVICE_ERROR);
			if (BLOCK.blocked) {
				BLOCK.faultBack(error);
				stopBlocking();
			}
			//dispatchEvent(new DrupalEvents(DrupalEvents.DRUPAL_ERROR));
		}
	
	
	// EVENT DISPATCHER
		public function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		public function dispatchEvent(evt:Event):Boolean {
			return dispatcher.dispatchEvent(evt);
		}
		public function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
	
	
	// LOG
		/**
		* Sends debug information to the Output panel.
		*
		* @param message Message to send to output log.
		*/
		protected function log(message:String,type:String=''):void{
			if (VERBOSE) {
				switch (type){
					case "error":{
						Debug.error(message);
						break;
					}
					case "log":
					default:{
						Debug.log(message);
						break;
					}
				}
			}
		}
	}	
//EOF
}

