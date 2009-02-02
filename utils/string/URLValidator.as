package dffconnector.utils.string {

	public final class URLValidator{
	
		static public function protocol(URL:String):String{
			return new RegExp(/(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/).exec(URL)[1];
		}
		static public function isURL(URL:String):Boolean{
			return (new RegExp(/(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/).exec(URL))?true:false;
		}
	}
//EOF
}