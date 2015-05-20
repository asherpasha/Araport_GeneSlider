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

	// This function check the validity of the fasta file.
	// then be analized in JavaScript or Processing.
	function checkFastaSeq(fileData) {
		// Variables
		var fileDataArray;	// This array will hold the data from the user file
		var seqLength;	// The length of sequences in the file
	
		// RegEx patterns
		var startPattern = /^>/;
		var digits = /\d/;
		// Special character * is now allowed
		var special = /\[|\]|\^|\$|\.|\||\?|\+|\(|\)|~|\`|\!|\@|\#|\%|\&|\_|\+|\=|\{|\}|\'|\"|<|\>|\:|\;|\,/;
		// Sequence X is allow allowed!
		var seq = /b|j|o|u|z/i;
	
		// Converts big string into arrays
		fileDataArray = fileData.split('\n');
	
		// Checks for ">" in the first line first sentence
		if (!(startPattern.test(fileDataArray[0]))) {
			window.alert('This is not a FASTA file.');
			return false;
		}
	
		// Check for number of lines
		if (fileDataArray.length <= 2) {
			window.alert('Atleast 2 seqeunces are needed.');
			return false;
		}
		
		// Check for sequence lengths
		// lengths of all sequences must be the same
		seqLength = fileDataArray[1].length;	// Get the length of the first sequence
		for (var i=0; i < fileDataArray.length - 1; i++) {
			if (!(startPattern.test(fileDataArray[i]))) {
				// Get the length of the sequence and check it against the length of first sequence
				var length = fileDataArray[i].length;
				if (length !== seqLength) {
					window.alert('The lengths of the sequences are not equal.');
					return false;
				}
	
				// Check for digits
				if (digits.test(fileDataArray[i])) {
					window.alert('The sequences should not have digits.');
					return false;
				}
	
				// Check for DNA/Protein Sequence
				if (seq.test(fileDataArray[i])) {
					window.alert('The file has non DNA/Protein sequence.');	
					return false;
				}

				// Check for special character
				if (special.test(fileDataArray[i])) {
					window.alert('The sequence has special characters.');
					return false;
				}
			}
		}
		
		// All tests passed
		return true;
	}

	// Bind processing
	function bindjs() {
		pjs = Processing.getInstanceById('araport-geneslider-canvas');
		if (pjs) {
			/*jshint validthis:true */
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
				/*jshint validthis:true */
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

	// Read file from user
	function readFile(evt) {
		var file = evt.files[0];
	
		// Check Processing
		if (!bound) {
			bindjs();
		}
	
		// Load the user supplied file
		if (file) {
			var inputFile = new FileReader();
			var contents;	// The contents of the file as one big string
			
			inputFile.onload = function(e) {
				contents = e.target.result;	// Get the file contents
	
				// Fix FASTA files with multiple lines
				var components = contents.split('>');
				var parts;
				components.shift();
				for (var i = 0; i < components.length; i++) {
					parts = components[i].split(/\n|\r/);
					parts[0] = '>' + parts[0] + '\n';
					components[i] = parts.join('');
					components[i] = components[i].toUpperCase();
					components[i] = components[i] + '\n';
				}
				contents = components.join('');
				
				// Check validity of FASTA data, and send it to GeneSlider
				if (checkFastaSeq(contents)) {
					pjs.resetData();
					pjs.setFastaData(contents);	// Set fasta data
				}
			};
			inputFile.readAsText(file);
		}
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
			window.alert('Agave not ready. Please try again.');
		}
	}


	// Run the script
	loadPDE();

	// Bind
	bindjs();


	window.addEventListener('Agave::ready', function() {
		ready = true;	// Agave ready
		$(document).ready(function() {
			// Go Button to load alignment from AGI
			$(document).on('click', '#araport-geneslider-go', loadDataFromGoButton);

			// Downstream slider
			$('#araport-geneslider-afterSlider').change(function() {
				var newVal = this.value;
		    	document.getElementById('araport-geneslider-afterlabel').innerHTML='After ('+newVal+')';
				after = Math.abs(newVal);
			});

			// Upstream slider
			$('#araport-geneslider-beforeSlider').change(function() {
				var newVal = this.value;
		    	document.getElementById('araport-geneslider-beforelabel').innerHTML='Before ('+newVal+')';
				before = Math.abs(newVal);		
			});

			// FASTA file upload
			$('#araport-geneslider-fileUpload').change(function () {
			    if ($('#araport-geneslider-fileUpload').val() === '') {
        			return;
    			}
				readFile(this);
    			$('#araport-geneslider-fileUpload').val('');
			});
			
			// About
			$(document).on('click', '#araport-geneslider-about', function() {
				window.alert('Araport GeneSlider was developed by the BAR team with support from the Araport team. GeneSlider is funded by Genome Canada.');
			});
		});
	});

})(window, jQuery, Processing);
