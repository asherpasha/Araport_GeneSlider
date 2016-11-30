////////////////////////////////////////////////////////////////////////////////
// This is the javascript file for GeneSlider program
// Date: June 21, 2016
////////////////////////////////////////////////////////////////////////////////

// Global Variables
var pjs;	// Processing js object
var bound;	// If Processing is bound
var jsonClone;	// This will have data for gff
var search;	// The JSON object for search
var alignment = '';	// The entire alignment
var alnStart = 0; // Start of alignment
var alnEnd = 0;	// End of alignment
var serviceURL = 'https://api.araport.org/community/v0.3/asher-live/geneslider_v0.0.1/access/'

////////////////////////////////////////////////////////////
/// Misc functions for this page

function GObutton_selectByGene() {
	if ($('#user_agi').val() == "")   {
		$("#oopsModal").modal('show');
	}
	else {
		goToOutputPage();
		loadAGIDataFromGoButton();
	}
}


function GObutton_selectByRegion() {
	if ($('#bpStart').val() + $('#bpEnd').val() == "")   {
		$("#oopsModal").modal('show');
	}
	else {
		goToOutputPage();
		loadAlignmentDataFromGoButton();
	}
}


function goToOutputPage() {
	$("#inputPage").fadeOut("fast", function() {
		// when fade is complete
		$("#outputPage").fadeIn("fast");

		// now that we've been to the output page at least once, enable the returnToOutputScreenButton
		$("#returnToOutputScreenButton").css("display","block");
	});
	// Enable GFF upload button
	$('#gffUploadButton').css('display', 'inline-flex');
	$('#gffUploadButton').css('visibility', '');
	// Disable file upload button
	$('#fileUploadButton').css('display', 'none');
	$('#fileUploadButton').css('visibility', 'false');

}

function backToInputPage() {
	$("#outputPage").fadeOut("fast", function() {
		// when fade is complete
		$("#inputPage").fadeIn("fast");
	});
	// Enable GFF upload button
	$('#gffUploadButton').css('display', 'none');
	$('#gffUploadButton').css('visibility', 'false');
	// Disable file upload button
	$('#fileUploadButton').css('display', 'inline-flex');
	$('#fileUploadButton').css('visibility', '');

}

// Functions
// Bind processing
function bindjs() {
	pjs = Processing.getInstanceById('araport-geneslider-canvas');
	if (pjs != null) {
		pjs.bindJavascript(this);
		bound = true;
	}
	if (!bound) { 
		setTimeout(bindjs, 250);
	}
}

// Load and example
function loadExample() {

	// Check processing
	if (!bound) {
		bindjs();
	}

	// Now get data using AJAX
	$.ajax({
		url:"http://bar.utoronto.ca/geneslider/test.txt",
		async:false,
		cache:false,
		success:function(data) {
			// Now load the data
			pjs.resetData();
			pjs.setFastaData(data, "");
		},
	});
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
	var seq = /o|u/i;

	// Converts big string into arrays
	fileDataArray = fileData.split("\n");

	// Checks for ">" in the first line first sentence
	if (!(startPattern.test(fileDataArray[0]))) {
		alert("This is not a FASTA file.");
		$("#fileNameWindow").val("")
		return false;
	}

	// Check for number of lines
	if (fileDataArray.length <= 3) {
		alert("Atleast 2 seqeunces are needed.");
		$("#fileNameWindow").val("")
		return false;
	}
	
	// Check for sequence lengths
	// lengths of all sequences must be the same
	seqLength = fileDataArray[1].length;	// Get the length of the first sequence
	alnEnd = seqLength - 1; // This is also aligment end

	for (var i=0; i < fileDataArray.length - 1; i++) {
		if (!(startPattern.test(fileDataArray[i]))) {
			// Get the length of the sequence and check it against the length of first sequence
			var length = fileDataArray[i].length;
			if (length != seqLength) {
				alert("The lengths of the sequences are not equal.");
				$("#fileNameWindow").val("")
				return false;
			}

			// Check for digits
			if (digits.test(fileDataArray[i])) {
				alert("The sequences should not have digits.");
				$("#fileNameWindow").val("")
				return false;
			}

			// Check for DNA/Protein Sequence
			if (seq.test(fileDataArray[i])) {
				alert("The file has non DNA/Protein sequence.");	
				$("#fileNameWindow").val("")
				return false;
			}

			// Check for special character
			if (special.test(fileDataArray[i])) {
				alert("The sequence should not have special characters.");
				$("#fileNameWindow").val("")
				return false;
			}
		}
	}
	
	// All tests passed
	return true;
}

// Parse GFF3 Araport11 file uploaded by user
function parseGFFFile(gffData) {
	var lines = gffData.split(/\n|\r/);
	var finalData = new Object();	// Start building the final data.
	var Temp = new Object();
	var motifs = new Object();
	var currentGI = "";
	var match = "";
	var transcripts = 0;
	var maxTranscript = 0;
	var userChr = '';
	var pValue = "0";
	var consensus = "NULL";
	var motifId = "Motif_1";

	// Initialize
	finalData.gff = [];	// Initialize Array of arrays
	motifs.geneId = "AT0G00000";
	motifs.data = [];
	
	// Add other variables
	// If we already have a start or end
	if (typeof(jsonClone) !== 'undefined') {
		finalData.start = jsonClone.start;
	} else {
		finalData.start = alnStart;
	}
	if (typeof(jsonClone) !== 'undefined') {
		finalData.end = jsonClone.end;
	} else {
		finalData.end = alnEnd;
	}

	// Check if chromosome is defined
	var agi = querystring('agi').toString();
	var chr = querystring('chr').toString();
	if (agi) {
		userChr = 'Chr' + agi.charAt(2);
	} else if (chr) {
		userChr = 'Chr' + chr;
	}

	// For each line of gff Data
	for (var i = 0; i < lines.length; i++) {
		// Skip comments
		if (/^#/.test(lines[i])) {
			continue;
		}

		// Skip empty lines
		if (/^\s*$/.test(lines[i])) {
			continue;
		}

		var columns = lines[i].split(/\t/);
		// check for chromosome
		if (userChr !== '') {
			if (columns[0] !== userChr) {
				continue;
			}
		}
		
		// check start and end
		if ((columns[3] >= finalData.start && columns[4] <= finalData.end) || (columns[4] >= finalData.end && columns[3] <= finalData.end) || (columns[3] <= finalData.start && columns[4] >= finalData.start)) {

			// We found a gene
			if (columns[2] == "gene") {
				if (currentGI == "") {
					Temp = new Object();
				} else {
					finalData.gff.push(Temp);
					Temp = new Object();
					currentGI = "";
				}
				
				// Get Gene ID
				match = /ID=(.*?);/.exec(columns[8]);
				if (!(match)) {
					match = /ID=([^;]*)$/.exec(columns[8]); // lines with no ;
				}
				if (match) {
					Temp.geneId = match[1];
					Temp.data = [["gene", columns[3], columns[4], columns[6], null, "",""]];
					finalData.gff.push(Temp);
					transcripts += 1;	

				} else {
					match = "";
					console.log("Error: Line not matched: " + columns[8]);
				}
				match = "";					
			}

			// Now the mRNA
			if (columns[2] == "mRNA") {
				if (currentGI == "") {
					Temp = new Object();
				} else {
					// New isoform

					// Save previous isoform
					finalData.gff.push(Temp);
					Temp = new Object();
				}
									
				// Get Gene ID
				match = /ID=(.*?);/.exec(columns[8]);
				if (!(match)) {
					match = /ID=([^;]*)$/.exec(columns[8]); // lines with no ;
				}

				Temp.geneId = match[1];
				currentGI = match[1];
				match = "";			
				
				// Now check for max .* isoform
				match = /\.(\d)$/.exec(currentGI);
				if (parseInt(match[1],10) > maxTranscript) {
					maxTranscript = parseInt(match[1], 10);
				}
				Temp.data = [["mRNA", columns[3], columns[4], columns[6], null, "",""]];
				transcripts += 1;
			}

			// Now the CDS
			if (columns[2] == "CDS") {
				if (currentGI != "") {

					// Get parrent
					match = /Parent=(.*?)[;]/.exec(columns[8]);
					if (!(match)) {
						match = /Parent=([^;]*)$/.exec(columns[8]); // lines with no ;
					}

					// If known add the CDS line
					if (match[1] == currentGI) {
						Temp.data.push(["CDS", columns[3], columns[4], columns[6], null, "", ""]);
					}
				}
			}


			// Now the exon
			if (columns[2] == "exon") {
				if (currentGI != "") {

					// Get parrent
					match = /Parent=(.*?)[;]/.exec(columns[8]);
					if (!(match)) {
						match = /Parent=([^;]*)$/.exec(columns[8]); // lines with no ;
					}
					// If known add the CDS line
					if (match[1] == currentGI) {
						Temp.data.push(["exon", columns[3], columns[4], columns[6], null, "", ""]);
					}
				}
			}	
			
			// Now check for JASPAR or Weirauch et al 2014 or Motif
			if (columns[2] == "JASPAR" || columns[2] == "Weirauch et al. 2014" || columns[2] == "Motif") {

				// Get Motif
				match = /MotifID=(.*?)[;]/.exec(columns[8]);
				if (match) {
					motifId = match[1];
				}
				match = "";

				// Get Match
				match = /Match=(.*?)[;]/.exec(columns[8]);
				if (match) {
					consensus = match[1];
				}
				match = "";

				// match p-value
				match = /p-value=(.*?)[;]/.exec(columns[8]);
				if (match) {
					pValue = match[1];
				}
				match = "";

				// Get 
				motifs.data.push([columns[2], columns[3], columns[4], columns[6], pValue, consensus, motifId]);

				// Back to default
				pValue = "0";
				consensus = "NULL";
				motifId = "Motif_1";
			}							
		} // If check for data within range.
	} // For loop for lines

	// Add final object
	finalData.gff.push(Temp);

	// Add Motifs object if exists (in the beginning!
	if (motifs.data.length > 0) {
		finalData.gff.unshift(motifs);
		transcripts += 1;
	}

	finalData.maxTranscript = maxTranscript.toString();
	finalData.transcripts = transcripts.toString();	
	
	return finalData;
}

// Read FASTA file from user
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
				parts[0] = ">" + parts[0] + "\n";
				components[i] = parts.join('');
				components[i] = components[i].toUpperCase();
				components[i] = components[i] + "\n";
			}
			contents = components.join('');
			
			// Check validity of FASTA data, and send it to GeneSlider
			if (checkFastaSeq(contents)) {
				pjs.resetData()
				pjs.setFastaData(contents, $("#fileNameWindow").val());	// Set fasta data
				alnStart = 0;	// Set start

				// if everything is valid, switch to output screen
				goToOutputPage();
				$('#gffUploadButton').css('display', 'inline-flex');
				$('#gffUploadButton').css('visibility', '');
				$('#fileUploadButton').css('display', 'none');
				$('#fileUploadButton').css('visibility', 'false');
			}
		}
		inputFile.readAsText(file);
	}
}

// Read the GFF Data
function readGFFFile(evt) {
	var file = evt.files[0];

	// Gene Slider is running at this time, so no need to check for processing.
	if (file) {
		var inputFile = new FileReader();
		var contents;

		inputFile.onload = function(e) {
			contents = e.target.result;
			var data = parseGFFFile(contents);

			// If GFF Panel is open, it means we have annotations
			if (pjs.isgffPanelOpen()) {
				// JSON data is already defined. Just add motif data
				jsonClone.gff.unshift(data.gff[0]);
				// Increment max transcripts
				jsonClone.transcripts = (parseInt(jsonClone.transcripts, 10) + 1).toString();
			} else {
				// Add data to JSON clone
				jsonClone = JSON.parse(JSON.stringify(data));
			}

			pjs.setgffPanelOpen(true);
			pjs.setAlnStart(jsonClone.start);
			pjs.addMotifPosition();	// This is very important to draw Motifs in zoomed view
			pjs.redraw();
		}
		inputFile.readAsText(file);
	}
}

// Load an AGI into GeneSlider
function agiLoader(agi, before, after, zoomFrom, zoomTo, Bitscore, alnIndicator, cistome) {
	 // first, hide the carousel
	 hideCarousel(); 

	function bind() {
		pjs = Processing.getInstanceById('araport-geneslider-canvas');
	
		if (pjs != null) {
			pjs.bindJavascript(this);
			bound = true;
			pjs.setWelcome();
			// Runs the webservice that fetches data using AGI
			$.ajax({
				beforeSend: function(request) {
					request.setRequestHeader('Authorization', 'Bearer ' + Agave.token.accessToken);
				},
				type: "GET",
				dataType: 'json',
				url: serviceURL + "alignmentByAgi.cgi?agi=" + agi + "&before=" + before + "&after=" + after,
			}).done(function(data) {
				jsonClone = JSON.parse(JSON.stringify(data));
				if (data.fileData != "") {
					pjs.setWelcome();
					pjs.resetData();
					pjs.setAlnStart(data.start);
					pjs.setSessionData("CNSData", agi, before, after, Bitscore, alnIndicator, cistome);

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
					pjs.setFastaData(data.fileData, "");

					// This is for downloading alignment feature
					alignment = data.fileData;

					$('#gffUploadButton').css('display', 'inline-flex');
					$('#gffUploadButton').css('visibility', '');
					$('#fileUploadButton').css('display', 'none');
					$('#fileUploadButton').css('visibility', 'false');
							
					// Set the search query
					if (search) {
						if (search.length > 0 && search.length < 7) {
							for (var i = 0; i < search.length; i++) {
								for (var j = 0; j < search[i].length; j++) {
									// Set in Processing goes here
									for (key in search[i][j]) {
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
		if (!bound) {
			setTimeout(bind, 250);
		} 
	}
	bind();
}

// Load a single CNS Alignment
function alignmentLoader(chr, start, end, zoomFrom, zoomTo, Bitscore, alnIndicator, cistome) {
	 // first, hide the carousel
	 hideCarousel(); 
	function bind() {
		pjs = Processing.getInstanceById('araport-geneslider-canvas');
	
		if (pjs != null) {
			pjs.bindJavascript(this);
			bound = true;
			pjs.setWelcome();
			// Runs the webservice that fetches data using AGI
			$.ajax({
				beforeSend: function(request) {
					request.setRequestHeader('Authorization', 'Bearer ' + Agave.token.accessToken);
				},
				type: "GET",
				dataType: 'json',
				url: serviceURL + "alignmentByRegion.cgi?chr=" + chr + "&start=" + start + "&end=" + end,
			}).done(function(data) {
				jsonClone = JSON.parse(JSON.stringify(data));
				if (data.fileData != "") {
					pjs.setWelcome();
					pjs.resetData();
					pjs.setAlnStart(data.start);
					pjs.setSessionData("CNSData", "", before, after, Bitscore, alnIndicator, cistome);

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
					pjs.setFastaData(data.fileData, "");

					// This is for downloading alignment feature
					alignment = data.fileData;
					
					// Set the search query
					if (search) {
						if (search.length > 0 && search.length < 7) {
							for (var i = 0; i < search.length; i++) {
								for (var j = 0; j < search[i].length; j++) {
									// Set in Processing goes here
									for (key in search[i][j]) {
										pjs.setSearch(parseInt(i,10), parseInt(j, 10), key, parseFloat(search[i][j][key]));
									}
								}
							}
						}
					}
	
					// Enable GFF upload button
					$('#gffUploadButton').css('display', 'inline-flex');
					$('#gffUploadButton').css('visibility', '');
					// Disable file upload button
					$('#fileUploadButton').css('display', 'none');
					$('#fileUploadButton').css('visibility', 'false');

					setTimeout(pjs.updateURLSearchResults, 100);

				}
			});
		}
		if (!bound) {
			setTimeout(bind, 250);
		} 
	}
	bind();
}

// Grab parameters from URL if there are any
// From eFP 2.0 and http://stackoverflow.com/questions/2627163/query-string-in-javascript?rq=1
function querystring(key) {
	var re = new RegExp('(?:\\?|&)'+key+'=(.*?)(?=&|$)','gi');
	var r = [], m;
	while ((m = re.exec(document.location.search)) != null) r[r.length] = m[1];
	return r;
}

// Get Upstreams URL and load it
function goUpstream() {
	if (!bound) {
		bindjs();
	}

	if (pjs != null) {
		// Get the URL
		var url = pjs.goUpstream();
		window.open(url, "_self");
	} else {
		alert("Error connecting of PDE file.");
	}
}

// Get Upstreams URL and load it
function goDownstream() {
	if (!bound) {
		bindjs();
	}

	if (pjs != null) {
		// Get the URL
		var url = pjs.goDownstream();
		window.open(url, "_self");
	} else {
		alert("Error connecting of PDE file.");
	}
}

// Jamie's new functions: 
// This function toggles display of the carousel slider and the GeneSliderDiv
function hideCarousel() {
    $('#carouselSlider').slideUp(function() {
    	$('#carouselSlider').css("display", "none");
    });

    $('#upstreamDownstreamButtons').css('display','block')
}

// Get data using AGI
function loadAGIDataFromGoButton() {
	var before;
	var after;
	var agi;
	var zoomFrom = 99;
	var zoomTo=164;
	var weightedBitscore = true;
	var alnIndicator = true;
	var cistome = false;

	if ($('#user_agi').val() != '') {
		agi = $('#user_agi').val();
	} else {
		window.alert("No AGI provided!");
		return;
	}
	if ($('#bpBefore').val() != '') {
		before = $('#bpBefore').val();
	} else {
		before = 0;
	}
	if ($('#bpAfter').val() != '') {
		after = $('#bpAfter').val();
	} else {
		after = 0;
	}

	// Load AGI's in GeneSlider
	agiLoader(agi, parseInt(before, 10), parseInt(after, 10), parseInt(zoomFrom, 10), parseInt(zoomTo, 10), weightedBitscore, alnIndicator, cistome);
	$('#topPageText').hide();
	createButton('Download Alignment');
	createButton('Download Sequences');
}

// Get data using Region
function loadAlignmentDataFromGoButton() {
	var chr;
	var bpStart;
	var bpEnd;
	var weightedBitscore = true;
	var alnIndicator = true;
	var cistome = false;


	if ($('#bpChr').val() != '') {
		chr = $('#bpChr').val();
	} else {
		chr = 1;
	}

	// Get Start
	if ($('#bpStart').val() == '') {
		bpStart = 3500;
	} else {
		bpStart = $('#bpStart').val();
	}

	// Get End
	if ($('#bpEnd').val() == '') {
		bpEnd = 6000;
	} else {
		bpEnd = $('#bpEnd').val();
	}
	alignmentLoader(chr, parseInt(bpStart, 10), parseInt(bpEnd, 10), parseInt(bpStart, 10), parseInt(bpEnd, 10), weightedBitscore, alnIndicator, cistome);
}

// Create full download button
function createButton(text) {
    var button = document.createElement('input');
    button.type = 'button';
    button.value = text;
	button.style.marginRight = '1px';
	button.style.marginLeft = '1px';
	button.className = 'btn btn-xs btn-default';
	if (text == 'Download Alignment') {
	    button.onclick = downloadFullAlignment;
	} else {
		button.onclick = downloadSequences;
	}
	$('#Downloads').append(button);
}

// Download function for full alignment
function downloadFullAlignment() {
	if (alignment == '') {
		return;
	}
	var fullAln = alignment.split(/\r\n|\r|\n/g);
	for (var i = 0; i < fullAln.length; i++) {
		fullAln[i] = fullAln[i].replace(/(\r\n|\n|\r)/gm,"");
		if (fullAln[i].match(/^>/g)) {
			if (i == 0) {
				fullAln[i] = fullAln[i] + "\n";
			} else {
				fullAln[i] = "\n" + fullAln[i] + "\n";
			}
		}
	}
	fullAln = fullAln.join("");
	
	var hiddenElement = document.createElement('a');
	hiddenElement.href = 'data:attachment/text,' + encodeURI(fullAln);
	hiddenElement.target = '_blank';
	hiddenElement.download = 'alignment.fa';
	document.body.appendChild(hiddenElement);
	hiddenElement.click();
	document.body.returnChild(hiddenElement);
}

// Download just the sequences
function downloadSequences() {
	if (alignment == '') {
		return;
	}

	var fullAln = alignment.split(/\r\n|\r|\n/g);
	for (var i = 0; i < fullAln.length; i++) {
		fullAln[i] = fullAln[i].replace(/(\r\n|\n|\r|-)/gm,"");
		if (fullAln[i].match(/^>/g)) {
			if (i == 0) {
				fullAln[i] = fullAln[i] + "\n";
			} else {
				fullAln[i] = "\n" + fullAln[i] + "\n";
			}
		}
	}
	fullAln = fullAln.join("");
	
	var hiddenElement = document.createElement('a');
	hiddenElement.href = 'data:attachment/text,' + encodeURI(fullAln);
	hiddenElement.target = '_blank';
	hiddenElement.download = 'sequences.fa';
	hiddenElement.click();

}

////////////////////////////////////////////////////////////////////////////////
// The main program flow 
//////////////////////////////////////////////////////////////////////////////// 
// Main

(function(window, $, undefined) {

	// Functions
	// Load the GeneSlider pde file
	function loadPDE() {
		var allScripts, i, re, pdeURL;
		allScripts = document.querySelectorAll('script');
		re = /^(.*)(\/geneslider_bower_package[^\/]*)\/(.*)geneSlider\.js??(.*)?$/i;
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

	// Load jQuery-UI
	function loadUI() {
		var allScripts, i, uiCore, uiWidget, uiAccordion, uiCss, re, el;

		// Load the dependances: The new way. Thanks for AIP staff for this
		allScripts = document.querySelectorAll( 'script' );
		re = /^(.*)(\/jquery_ui_1[^\/]*)\/(.*)jquery-ui\.js??(.*)?$/;
		for ( i = 0; i < allScripts.length && ! uiCore; i++ ) {
			if ( re.test( allScripts[i].src ) ) {
				var match = re.exec( allScripts[i].src );
				uiCore = match[1] + match[2] + '/ui/core.js';
				uiWidget = match[1] + match[2] + '/ui/widget.js';
				uiAccordion = match[1] + match[2] + '/ui/accordion.js';
				uiCss = match[1] + match[2] + '/themes/smoothness/jquery-ui.min.css';
			}
		}
		
		// Add core.js
		if ( uiCore ) {
			el = document.createElement( 'script' );
			el.src = uiCore;
			el.type = 'text/javascript';
			document.body.appendChild( el );
		}

		// Add widget.js
		if ( uiWidget ) {
			el = document.createElement( 'script' );
			el.src = uiWidget;
			el.type = 'text/javascript';
			document.body.appendChild( el );
		}

		// Add Accordion.js
		if ( uiAccordion ) {
			el = document.createElement( 'script' );
			el.src = uiAccordion;
			el.type = 'text/javascript';
			document.body.appendChild( el );
		}

		// Add CSS
		if ( uiCss ) {
			el = document.createElement( 'link' );
			el.href = uiCss;
			el.rel = 'stylesheet';
			document.body.appendChild( el );
		}
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


	// Run the script
	loadPDE();

	// Load jQuery-UI
	loadUI();

	// Bind
	bindjs();

	window.addEventListener('Agave::ready', function() {
		ready = true;	// Agave ready
		$(document).ready(function() {
			// Agave and jQuery are ready
			backToInputPage();
		});
	});
})(window, jQuery);

