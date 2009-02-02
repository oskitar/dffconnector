package dffconnector.services {

	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;

	import dffconnector.constants.COMMANDS;
	import dffconnector.errors.GATEWAY_ERROR;




	public class AmfService {

	// PRIVATE VARIABLES
		private var netconnection	:NetConnection;
		private var callback		:Function;
		private var faultback		:Function;
		private var gatewayUrl		:String;
	//CONSTRUCTOR
		public function AmfService(_gatewayUrl:String){
			super();
			gatewayUrl	=	_gatewayUrl; 
		}


		public function service(onSuccess:Function, onFault:Function, command:String, ... args):Boolean {
			callback	= onSuccess	;//|| onAmfConnect;
			faultback	= onFault	;//|| onAmfFault;
			if (gatewayUrl.length < 1) {
				faultback(GATEWAY_ERROR.NOT_PRIOR);
				return false;
			}
			if (!(netconnection is NetConnection)) {
				netconnection = new NetConnection();
				netconnection.addEventListener(NetStatusEvent.NET_STATUS, onServiceStatus);
				netconnection.objectEncoding = ObjectEncoding.AMF3;
				netconnection.connect(gatewayUrl);
			}
			if (args is Array && args.length == 1 && args[0] is Array) {
				args = args[0];
			}
			
			var responder:Responder = new Responder(onSuccess, onFault);
			args.unshift(responder);
			args.unshift(command);
			netconnection.call.apply(netconnection, args);
			return true;
		}


		private function onServiceStatus(_status:NetStatusEvent):void{
			if (_status.info is Object && _status.info.code is String) {
				switch (_status.info.code) {
					case 'NetConnection.Call.Failed':
						faultback(GATEWAY_ERROR.CONNECTION_ERROR+ "status.info.code: " + _status.info.code);
						break;
					default:
						faultback(GATEWAY_ERROR.UNHANDLED_ERROR + "status.info.code: " + _status.info.code);
						break;
				}
			}
		}
		
		private function onAmfConnect(e:Object):void{	}
		private function onAmfFault(e:Object):void{		}
	}
//EOF
}
