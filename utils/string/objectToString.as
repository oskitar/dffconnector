package dffconnector.utils.string {

	/**
	 *	@desc Shows the object data structure & values.
	 *	This function should be used only for debug/develop purposes only.
	 *	@param obj the object to read.
	 *	
	 *	@usage trace (objectToString(readable_dynamic_Object));
	 */
	
	public function objectToString ( obj:*, _level:String=""): String {
		if (obj is Object){
			var s: String = "";
			if (obj is Function){
				s += "{...}";
			}else if (obj is String ){
				s += "String = "+'"' + obj + '"';
				
			}else if (obj is Number){
			
				s+= "Number = " + obj;
			}else {
				var objData :String="";
				for(var item:* in obj) {
					objData += "\n"+_level + item +":" + obj[item].constructor +"= " + ((obj[item] is String )?"\""+obj[item]+"\"":(obj[item] is Number )?obj[item] : objectToString (obj[item],_level+"\t")) + ", ";
				}
				s+= objData.substring(0,objData.length-2)+"\n"+(_level.substring(0,_level.length-1));
				if (obj is Array){
					s = ("[" + s) + "]";
				}else {
					s = ("{" + s) + "}";
				}
			}
			//same as
			/*return (obj is Function)?"function"+ obj.toString():(((obj is String)||(obj is Number))?obj:(((obj is Array)?"[":"{") + objData.substring(0,objData.length-2)+"\n"+_level+((obj is Array)?"]":"}")));*/
			return s;
		}else{
			return null;
		} 
	}
//EOF
}

