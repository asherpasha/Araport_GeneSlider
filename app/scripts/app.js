/*globals Processing*/
var jsonClone;	// This will have data for gff
(function(window, $, Processing, undefined) {
	'use strict';
	
	// Global variables
	//var appContext = $('[data-app-name="araport-geneslider"]');
	var pjs;	// Processing js object
	var bound;	// If Processing is bound
	var search;	// The JSON object for search
	var ready = false;	// Is the system ready
	var before = 0;	// Upstream
	var after = 0;	// Downstream

	// Functions
	// Load the GeneSlider pde file
	function loadPDE() {
		var allScripts, i, re, pdeURL;
		allScripts = document.querySelectorAll('script');
		re = /^(.*)(\/geneslider_bower_package[^\/]*)\/(.*)geneSlider\.js??(.*)?$/;
		for (i = 0; i < allScripts.length && ! pdeURL; i++) {
		 	if (re.test(allScripts[i].src)) {	  
				var match = re.exec(allScripts[i].src);
				pdeURL = match[1] + match[2] + '/GeneSlider.pde';
			}
		}

		if (pdeURL) {
			$('#araport-geneslider-canvas').attr('data-processing-sources', pdeURL);
		} else {
			window.alert('PDE file not found!');
		}
	}

	// Bind processing
	function bindjs() {
		pjs = Processing.getInstanceById('araport-geneslider-canvas');
		if (pjs) {
			pjs.bindJavascript(this);
			bound = true;
		}
		if (!bound) { 
			setTimeout(bindjs, 1000);
		}
	}

	// Load an AGI into GeneSlider
	function agiLoader(agi, before, after, zoomFrom, zoomTo, Bitscore, alnIndicator) {
		var query;
		var response;
	
		function bind() {
			pjs = Processing.getInstanceById('araport-geneslider-canvas');

			// Runs the webservice that fetches data using AGI
			function addData() {
				query = {
					locus: agi,
					before: before,
					after: after
				};

				window.Agave.api.adama.search({
					'namespace':'asher', 'service':'araport_geneslider_alignmentbyagi_v0.1.0', 'queryParams': query
				}, function(response) {
					// Check for server errors
					if (response.status !== 200) {
						window.alert('Error in backend webservice!');
						return;
					}


					// Check for error from webservice
					if (response.obj.status === 'failed') {
						window.alert('An error returned by webservice!');
						return;
					}

					jsonClone = JSON.parse(JSON.stringify(response.obj.result));
					if (response.obj.result.fileData !== '') {
						pjs.resetData();
						pjs.setAlnStart(response.obj.result.start);
						pjs.setSessionData('CNSData', agi, before, after, Bitscore, alnIndicator);
	
						// Set the start digit
						if (zoomFrom < 0) {
							pjs.setStartDigit(before);
						} else {
							pjs.setStartDigit(zoomFrom);
						}
	
						// Set the end digit
						if (zoomTo < 0) {
							pjs.setEndDigit(before + 20);
						} else {
							pjs.setEndDigit(zoomTo);
						}
	
						pjs.setgffPanelOpen(true);
						pjs.setFastaData(response.obj.result.fileData);
						
						// Set the search query
						if (search) {
							if (search.length > 0 && search.length < 7) {
								for (var i = 0; i < search.length; i++) {
									for (var j = 0; j < search[i].length; j++) {
										// Set in Processing goes here
										for (var key in search[i][j]) {
											pjs.setSearch(parseInt(i,10), parseInt(j, 10), key, parseFloat(search[i][j][key]));
										}
									}
								}
							}
						}
						setTimeout(pjs.updateURLSearchResults, 100);	
					}
				});
			}

			if (pjs) {
				pjs.bindJavascript(this);
				bound = true;

				addData();
			}
			if (!bound) {
				setTimeout(bind, 250);
			} 
		}
		bind();
	}

	// Load data
	function loadDataFromGoButton() {
		// Variable
		var agi = $('#araport-geneslider-user_agi').val();
		var zoomFrom = -1;
		var zoomTo = -1;
		var weightedBitscore = 'true';
		var alnIndicator = 'true';

		// Load AGI
		if (ready) {
			agiLoader(agi, parseInt(before, 10), parseInt(after, 10), parseInt(zoomFrom, 10), parseInt(zoomTo, 10), weightedBitscore, alnIndicator);
		} else {
			alert('Agave not ready. Please try again.');
		}
	}


	// Run the script
	loadPDE();

	// Bind
	bindjs();


	window.addEventListener('Agave::ready', function() {
		ready = true;	// Agave ready
		$(document).ready(function() {
			$(document).on('click', '#araport-geneslider-go', loadDataFromGoButton);
			$('#araport-geneslider-afterSlider').change(function() {
				var newVal = this.value;
		    	document.getElementById('araport-geneslider-afterlabel').innerHTML='After ('+newVal+')';
				after = Math.abs(newVal);
			});

			$('#araport-geneslider-beforeSlider').change(function() {
				var newVal = this.value;
		    	document.getElementById('araport-geneslider-beforelabel').innerHTML='Before ('+newVal+')';
				before = Math.abs(newVal);		
			});
		});
	});

})(window, jQuery, Processing);
