package dffconnector.core {

	import dffconnector.constants.COMMANDS;
	import flash.events.TimerEvent;
	import flash.utils.Timer;


	public class Block extends Object {


		public var blocked		:Boolean;
		public var name			:String;
		public var command		:String;
		public var args			:Array;
		public var callBack		:Function;
		public var faultBack		:Function;
		public var data			:Object;
		public var timer		:Array;
		public var retryings		:uint;
	
		private var _timerCallBack	:Function;
		
		public function Block(){
			super();
			init();
		}

		
		private function init():void{
			blocked 	= false;
			timer		= new Array();
			args		= new Array();
		}

		
		public function reset():void{
			blocked 	= false;
			timer[name].stop();
			name		= null;
			callBack	= null;
			faultBack	= null;
			data		= null;
			retryings	= 0;
		}

		
		public function addTimer(_callBack:Function):void{
			_timerCallBack	= _callBack;
			timer[name] = new Timer(4000);
			timer[name].addEventListener(TimerEvent.TIMER, timerCallBack);
			timer[name].start();
		}
		
		
		private function timerCallBack(data:*):void{
			retryings++;
			if (retryings<3){
				_timerCallBack(data);				
			}else {
				executeFaultBack("ERROR max retryings reached"+retryings);
			}

		}

		
		public function executeCallBack(result:*):void{
			if (callBack is Function){
				callBack(data, result);
			}
		}

		
		public function executeFaultBack(result:*):void{
			if (faultBack is Function){
				faultBack(result);
				reset();
			}
		}
	}
//EOF
}

