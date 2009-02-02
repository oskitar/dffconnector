package dffconnector.services {

	
	import dffconnector.constants.COMMANDS;
	import dffconnector.constants.SERVICES;
	import dffconnector.core.DrupalConnector;
	import dffconnector.utils.string.objectToString;



	public class DAS_mail extends DrupalConnector {


		public var MAILOBJECT	:Object;	
		private var CALLBACK	:Function;
		private var COMMAND	:String;
		private var BLOCKNAME	:String;


	// CONSTRUCTOR
		public function DAS_mail(){
			super();
			init();
		}


		private function init():void{
			MAILOBJECT	=	{
							MAILKEY	:'service-system-mail',
							ADDRTO	:"",
							SUBJECT	:"SUBJECT UNDEFINED",
							BODY	:"NO BODY",
							ADDRFROM:'NO SENDER',
							HEADERS	: new Array()
						};
		}


		public function connect(_gatewayUrl:String = '', apiKey:String = ''):Boolean{
			return _connect(_gatewayUrl,apiKey, SERVICES.SYSTEM);
		}


	// MAIL MANIPULATION METHODS 
		

		public function mail_send(callback:Function, faultback:Function, mail:Object):Boolean {

			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.SYSTEM_SEND_MAIL;
			
			MAILOBJECT.MAILKEY	=	mail.mailKey	|| MAILOBJECT.MAILKEY; 
			MAILOBJECT.ADDRTO	=	mail.addrTo	|| MAILOBJECT.ADDRTO;
			MAILOBJECT.SUBJECT	=	mail.subject	|| MAILOBJECT.SUBJECT;
			MAILOBJECT.BODY		=	mail.body	|| MAILOBJECT.BODY;
			MAILOBJECT.ADDRFROM	=	mail.addrfrom	|| MAILOBJECT.ADDRFROM;
			MAILOBJECT.HEADERS	=	mail.headers	|| MAILOBJECT.HEADERS;

			BLOCKNAME	=	"mail_send_to_"+ String(MAILOBJECT.ADDRTO);

			return startBlocking(onData, faultback, BLOCKNAME, COMMAND, MAILOBJECT.MAILKEY, MAILOBJECT.ADDRTO, MAILOBJECT.SUBJECT, MAILOBJECT.BODY, MAILOBJECT.ADDRFROM, MAILOBJECT.HEADERS );
			
		}


	//ONDATA
		private function onData(result:Object):void {
			//dispatchEvent(new DrupalEvents(DrupalEvents.DRUPAL_DATA));
			log ("-------"+result);
			switch (COMMAND){
				case COMMANDS.SYSTEM_SEND_MAIL:{
					exec_mail_send(result);
					break;
				}
				default:break;
			}
		}


	// ONDATA
	
		private function exec_mail_send(result:Object):void{
			if (result){
				super.stopBlocking();
				CALLBACK(result);
			}else {
				log(BLOCKNAME + ' not send .'+ "error");
				super.stopBlocking();
			}
		}
	}	
//EOF
}