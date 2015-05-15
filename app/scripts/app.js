(function(window, $, undefined) {
	'use strict';
	
	// Global variables
	//var appContext = $('[data-app-name="araport-geneslider"]');

	// Functions

	// Load the GeneSlider pde file
	function loadPDE() {
		var allScripts, i, re, pdeURL;
		allScripts = document.querySelectorAll('script');
		re = /^(.*)(\/araport_bower_test[^\/]*)\/(.*)hello\.js??(.*)?$/;
		for (i = 0; i < allScripts.length && ! pdeURL; i++) {
		 	if (re.test(allScripts[i].src)) {	  
				var match = re.exec(allScripts[i].src);
				pdeURL = match[1] + match[2] + '/app.pde';
			}
		}

		if (pdeURL) {
			$('#araport-geneslider-canvas').attr('data-processing-sources', pdeURL);
		} else {
			window.alert('PDE file not found!');
		}
	}


	// Run the script
	loadPDE();
})(window, jQuery);
