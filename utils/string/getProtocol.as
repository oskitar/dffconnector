package dffconnector.utils.string {

	public function getProtocol(path:String):String {
		var index:int = path.indexOf('://', 1);
		if (index > 0) {
			return path.substr(0, index);
		}
		return null;
	}

//EOF
}
