 /*{
comment:[class String]= "0", 
name:[class String]= "omata", 
type:[class String]= "page", 
picture:[class String]= "", 
tnid:[class String]= "0", 
revision_uid:[class String]= "1", 
taxonomy:[class Array]= [
], 
moderate:[class String]= "0", 
teaser:[class String]= "Cuerpo de la página nodo, cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página  ", 
format:[class String]= "2", 
vid:[class String]= "6", 
sticky:[class String]= "0", 
language:[class String]= "es", 
translate:[class String]= "0", 
body:[class String]= "<p>Cuerpo de la página nodo, cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página  </p>
", 
created:[class String]= "1232731738", 
data:[class String]= "a:0:{}", 
log:[class String]= "", 
userid:[class String]= "1", 
changed:[class String]= "1232731738", 
status:[class String]= "1", 
promote:[class String]= "0", 
revision_timestamp:[class String]= "1232731738", 
body_value:[class String]= "Cuerpo de la página nodo, cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página , cuerpo de la página  ", 
nid:[class String]= "6", 
title:[class String]= "Excelente título para una página nodo"
}*/


package dffconnector.datatypes {

	import com.carlcalderon.arthropod.Debug;

dynamic public class Node extends Object {

	
	public var comment		: String = "yeah!";	// number of comments 
	public var name			: String = "";	// owner name 
	public var type			: String = "";  // node type (ex: "page")
	public var picture		: String = "";  // picture url
	public var tnid			: String = "";  // ???
	public var revision_uid		: String = "";  // number of revisions 
	public var taxonomy		: Array  = [];  // taxonomy add to node
	public var moderate		: String = "";  // boolean flag moderated
	public var teaser		: String = "";  // teaser content
	public var format		: String = "";  //  ???
	public var vid			: String = "";  // ??? same as uid
	public var sticky		: String = "";  // boolean flag sticky
	public var language		: String = "";  // language value (ex: "es", "en"...)
	public var translate		: String = "";  // boolean flag translate 
	public var body			: String = "";  // html content of body
	public var created		: String = "";  // date of creation
	public var data			: String = "";  // ???
	public var log 			: String = "";  // ???
	public var userid		: String = "";  // user id
	public var changed		: String = "";  // date of last node edition
	public var status		: String = "";  // ??? status of node (published or draft)?
	public var promote		: String = "";  // boolean flag promoted
	public var revision_timestamp	: String = ""; // date of last node revision
	public var body_value		: String = "";  // raw data body value
	public var nid 			: String = "";  // node id 
	public var title		: String = "";  // title value
	
	private var _contentAsString	: String="";
	private var _isNode		: Boolean;
	
	
	public function Node(obj:Object){
		super();
		_isNode = objectToNode(obj);
	}
	
	
	private function objectToNode(obj:Object):Boolean{
		if (obj){
			for (var i:* in obj){
				if (this[i]!=undefined){
					this[i]=obj[i];
					_contentAsString += i +"=" + this[i] +";\n";
				}else {
					Debug.error("!!!!!"+i+"!!!!!");
					return false;
				}
			}
		}else {
			Debug.error("vacio")
			return false;
		}
		return true;
	}


	public function get isNode():Boolean{
		return _isNode;
	}

	
	public function get contentAsString():String{
		return _contentAsString;
	}
}
//EOF
}

