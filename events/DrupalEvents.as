package dffconnector.events {

import flash.events.Event;

	public  class DrupalEvents extends Event {

		
		static public var DRUPAL_DATA:String		= 'drupal_event_data';
		
		static public var DRUPAL_ERROR:String		= 'drupal_event_error';
		
		static public var DRUPAL_COMPLETE:String	= 'drupal_event_complete';
		
		static public var DRUPAL_READY:String		= 'drupal_event_ready';

	
		public function DrupalEvents( type:String){
			super(type);
		}

	
		override public function clone():Event{
			return new DrupalEvents(type);
		}
	}
//EOF
}

