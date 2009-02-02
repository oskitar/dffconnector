package dffconnector.services {

	import dffconnector.constants.COMMANDS;
	import dffconnector.constants.SERVICES;
	
	import dffconnector.core.DrupalConnector;
	import dffconnector.datatypes.Node;

	import dffconnector.utils.string.objectToString;
	
	
	
	public class DAS_node extends DrupalConnector {
		
	
		private var NODES	:Array;	
		private var CALLBACK	:Function;
		private var COMMAND	:String;
		private var BLOCKNAME	:String;
		
	// CONSTRUCTOR
		public function DAS_node(){
			super();
			init();
		}

		private function init():void{
			NODES	= new Array();
		}


		public function connect(_gatewayUrl:String = '', apiKey:String = ''):Boolean{
			return _connect(_gatewayUrl,apiKey, SERVICES.NODE);
		}
		
	// NODE MANIPULATION METHODS 
		public function node_save(callback:Function, faultback:Function, node:Object):Boolean {
			
			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.NODE_SAVE;
			BLOCKNAME	=	"save";
			
			return startBlocking(onData,faultback, BLOCKNAME, COMMAND, node);
		}
		
		
		public function node_edit(callback:Function, faultback:Function, node:Object):Boolean {
			//TO DO Pendiente de implementar el modo correcto de editar un nodo 
			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.NODE_EDIT;
			BLOCKNAME	=	"edit"+ node.nid;
			
			return startBlocking(onData,faultback, BLOCKNAME, COMMAND, node);
		}
		
		
		public function node_delete(callback:Function,faultback:Function, nid:int):Boolean {
			
			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.NODE_DELETE;
			BLOCKNAME	=	"delete" + String(nid);
			
			return startBlocking(onData, faultback, BLOCKNAME, COMMAND, nid);
		}


		public function node_get(callback:Function, faultback:Function, nid:int , reload:Boolean = false):Boolean {
			
			CALLBACK	=	callback;
			COMMAND		=	COMMANDS.NODE_GET;
			BLOCKNAME	=	"node" + String(nid)
			
			if (NODES[BLOCKNAME] && NODES[BLOCKNAME] is Object && !reload) {
				log('DrupalSite: info: Using cache data for node ' + nid);
				CALLBACK(NODES[BLOCKNAME]);
				return true;
			}
			return startBlocking(onData, faultback, BLOCKNAME, COMMAND, nid);
		}

		
	//ONDATA
		private function onData(result:Object):void {
			//log(result);
			//dispatchEvent(new DrupalEvents(DrupalEvents.DRUPAL_DATA));
			switch (COMMAND){
				case COMMANDS.NODE_GET:{
					exec_node_get(result);
					break;
				}
				case COMMANDS.NODE_SAVE:{
					exec_node_save(result);
					break;
				}
				case COMMANDS.NODE_EDIT:{
					exec_node_edit(result);
					break;
				}
				case COMMANDS.NODE_DELETE:{
					exec_node_delete(result);
					break;
				}
				default:break;
			}
		}
	
	// ONDATA 	
		private function exec_node_get(result:Object):void{
			if (result.nid){
				NODES[BLOCKNAME] = result;
				log('cached data for node ' + BLOCKNAME);
				CALLBACK(result);
			}else {
				log('bad formatted node:' + BLOCKNAME, "error");
				
			}
			super.stopBlocking();
		}

		
		private function exec_node_delete(result:*):void{
			CALLBACK(result);
			super.stopBlocking();
		}


		private function exec_node_save(result:*):void{
			CALLBACK(result);
			super.stopBlocking();
		}
		
		private function exec_node_edit(result:*):void{
			//TO DO Pendiente de implementar el modo correcto de editar un nodo 
			CALLBACK(result);
			super.stopBlocking();
		}	
	}
//EOF
}