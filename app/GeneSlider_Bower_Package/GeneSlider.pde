///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////                          GENE SLIDER                      /////////////////////////////
///////////////////                        by Jamie Waese,                    /////////////////////////////
///////////////////                          Asher Pasha,                     /////////////////////////////
///////////////////                      and Nicholas Provart                 /////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

// JS or Processing mode
boolean JS = true;

// Global variables to be saved and reset every time a sequence is loaded
String fastaData = "";
int startDigit = 0;
int endDigit = 30;
int alnStart = 0;    // Start of the sequence relative the AT
int currentColorScheme = 0;
boolean alignmentCountIndicator = false;
boolean showWeightedBitScore = true;
int currentFont = 0;
boolean searchPanelOpen = false;  // This is set to false, so that zoomed in display would work.
boolean gffPanelOpen = false;
int currentSearchPanel=0;
String[] fastaHeaders;
int horizontalBarWidth = 876;
int horizontalBarHeight = 20;
PImage horizontalBar;

// Canvas Data
float canvasWidth = 1000;
float canvasHeight = 590;

// These variables will remain internal to Processing, but has to be reset 
// after everytime data is reloaded.
int numNucleotides;        // The number of Nucleotides or Amino acids in a single alignment
int numSequences;        // The number of Sequences in a single alignment
Digit[] digit;            // This is a a single position of the alignment
//String[] seqNames;        // The header of the FASTA files
boolean DNA = true;

// Program gsStatus. The following are it's values
// gsStatus = 0;    Show start screen
// gsStatus = 1;    Show load data
// gsStatus = 2;    A gsStatus display for users
// gsStatus = 10;    Loop Status
int gsStatus = 0;
String mouseOverButton;
float bounce = 0;    // This is for the growing vine
// Global fonts
color[][] colorScheme = { 
    { 
        #99CC00, #FFAD15, #02D3C7, #F22E2E, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #818181, #F22E2E, #818181, #818181, #818181, #818181
    }
    , 
    { 
        #02D3C7, #02D3C7, #99CC00, #99CC00, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #99CC00, #000000, #000000, #000000, #000000
    }
    , 
    { 
        #000000, #99CC00, #818181, #99CC00, #99CC00, #818181, #818181, #99CC00, #818181, #F22E2E, #F22E2E, #000000, #99CC00, #02D3C7, #000000, #818181, #02D3C7, #000000, #000000, #818181, #000000, #99CC00, #02D3C7, #99CC00, #818181, #000000, #000000, #818181, #818181
    }
    , 
    { 
        #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000
    }
    , 
    { 
        #262727, #262727, #989898, #989898, #000000, #111111, #222222, #333333, #444444, #555555, #666666, #777777, #888888, #999999, #AAAAAA, #BBBBBB, #CCCCCC, #DDDDDD, #EEEEEE, #454545, #555555, #656565, #757575, #858585, #989898, #A5A5A5, #B5B5B5, #C5C5C5, #D5D5D5
    }
    ,
};
float fontSize = 50;
PFont[] font = { 
    createFont("Helvetica", fontSize, true), createFont("Times", fontSize, true), createFont("Courier", fontSize, true)
    };
float[] fontHeightMultiplier = { 
    .72, .67, .58
};

float fontHeight = fontSize * fontHeightMultiplier[0];
float fontWidth = fontSize * fontHeightMultiplier[0];
PFont helvetica18 = createFont("Helvetica", 18, true);
PFont helvetica10 = createFont("Helvetica", 10, true);
PFont courier10 = createFont("Courier", 10, true);

// Slider Bar variables
int sliderBarPaddingFromSide = 60;    // How far it is from sides
int sliderBarPaddingFromTop = 440;    // How far it is from top
float sliderRectStart;
float sliderRectEnd;
boolean mouseLockScroll = false;
boolean mouseLockZoomRight = false;
boolean mouseLockZoomLeft = false;
int lastDrawnNumberXpos = 0;

// Search Pannel
String[] searchPanelText = { 
    "", "", "", "", "", ""
};
int backgroundFade = 150;
color transparentWhite = color(255, 0);
color transparentCyan = color(0, 222, 218, backgroundFade);
color transparentPink = color(200, 0, 17, backgroundFade);
color transparentPurple = color(132, 0, 250, backgroundFade);
color transparentBrown = color(255, 222, 0, backgroundFade);
color transparentGreen = color(45, 255, 0, backgroundFade);
color transparentOrange = color(255, 96, 0, backgroundFade);
color[] digitBackground = { 
    transparentWhite, transparentCyan, transparentPink, transparentPurple, transparentBrown, transparentGreen, transparentOrange
}; 

boolean[] checkBoxOn = new boolean[6];
String buttonLock = "";
String[][] searchMotifText; 
int[] searchOffset;
int[] numSearchColumns;
int[][] searchMotifStart;
int[][] searchMotifEnd;

// GUI objects
// Triangle Buttons
TriangleButton triButton_scrollLeft;
TriangleButton triButton_scrollRight;
TriangleButton triButton_sliderStartIncrease;
TriangleButton triButton_sliderStartDecrease;
TriangleButton triButton_sliderEndIncrease;
TriangleButton triButton_sliderEndDecrease;
TriangleButton triButton_jumpToStart;
TriangleButton triButton_jumpToEnd;
TriangleButton triButton_resetZeroDown;
TriangleButton triButton_resetZeroUp;
TriangleButton triButton_displayColumnLeft;
TriangleButton triButton_displayColumnFastLeft;
TriangleButton triButton_displayColumnRight;
TriangleButton triButton_displayColumnFastRight;

// Round Buttons
RoundButton roundButton_showMore;
RoundButton roundButton_showLess;
RoundButton roundButton_searchPanel;
RoundButton roundButton_showAll;
RoundButton roundButton_zoomWayIn;
RoundButton roundButton_cancelSearch;
RoundButton roundButton_textEnter;
RoundButton roundButton_backspace;

// Rectangle Buttons
RectButton rectButton_screenGrab;
RectButton rectButton_font;
RectButton rectButton_colorScheme;
RectButton rectButton_alignmentCount;
RectButton rectButton_bitscore;
RectButton rectButton_share;
RectButton rectButton_regulome;
RectButton rectButton_legend;

// Checkboxes for search pannel
CheckBox[] checkBoxes = new CheckBox[6];

// Search Digit
SearchDigit[][] searchDigit;
char[][] searchString;
float[][] searchValue;
float searchHeight;

// Column data
boolean displayColumnData = false;
String displayColumnFadeStatus = "fadeOut";
int displayColumnFadeValue = 0;
int displayColumn = 0;
int columnDataStart = 0;
int columnDataDisplayHowMany = 27;
int numLines;
int linesDisplayed = 0;

// Saving session
String agi = "";
String source = "";
int before = 0;
int after = 0;
boolean showWelcome = true;

// Motifs
HashMap motifs = new HashMap();    // Hashmap to store motifs and their colors
int motifCounter = 0;    // Counter to pick colors
boolean displayLegend = false;
int motifOffset = 0;    // Y offset to avoid overlapping motifs
int motifEnd = 0;    // When to off set
int motifStart = 0;    // When to offset
boolean cistome = false;    // Check if we are comming from cistome

// Popup annotation
String popupData = "";
boolean popupOn = false;

// Temporary variables

// Main functions

// Javascript interface
interface JavaScript {
}
JavaScript javascript;
void bindJavascript(JavaScript js) {
    javascript = js;
}

// The main setup function
void setup() {
    size(1000, 590);
    smooth();
    background(255);
    initializeGUI();
}

void draw() {
    //println(frameRate);
    //println(gsStatus);
    // Clear screen

    background(255);
    // Mouse down function, which processing doesn't have
    if (mousePressed == true) {
        if (gsStatus > 2) {
            gsStatus = 2;
        }

        myMousePressed();
    }

    if (gsStatus == 0) {       
        if (fastaData == "") {
            if (showWelcome) {
                displayIntro();
            }
        } else {
            gsStatus = 1;
        }
    } else if (gsStatus == 1) {
        // Define some variables
        searchString = new char[6][8];
        searchValue = new float[6][8];
        searchOffset = new int[6];
        numSearchColumns = new int[6];

        // Intialize
        dataLoader();

        // Set Search letters
        for (int i = 0; i < 6; i++) {
            searchPanelText[i] = "";
            for (int j = 0; j < 8; j++) {
                if (DNA) {
                    searchDigit[i][j].sd_letter = 'N';
                } else {
                    searchDigit[i][j].sd_letter = '*';
                }
            }
        }

        gsStatus = 2;
    } else if (gsStatus >= 2) {
        textAlign(CENTER);
        textFont(helvetica18, 50);

        // Draw stuff
        drawGUI();
        drawDigits();
        drawSliderBar();
        drawLegend();
        drawAxis();
        if (gffPanelOpen) {
            showgffPanel();
            showZoomedGff();
        }
        drawSearchPanel();
        drawTextInputBox();
        drawColumnData();
        //drawPointedRectangle(mouseX, mouseY, 500, "AT1G01010", "-", 128);
        if ((gffPanelOpen) && (popupOn)) {
            displaygffMessage(popupData);
            popupOn = false;
        }
        if (displayLegend) {
            drawMotifLegend();
        }

        if (gsStatus == 10) {
            noLoop();
        } else {
            loop();
        }
    } else {
        println("Weird program gsStatus.");
    }
}

void mousePressed() {
    redraw();
}

// Mouse is pressed and held down
void myMousePressed() {
    if (JS && gsStatus < 2) {
        return;
    }

    if (gsStatus > 2) {
        gsStatus = 2;
    }
    if (!JS) {
        fastaData = ">1\nATG\n>2\nATG\n>3\nAAG\n>4\nAAC";
    }

    if (displayLegend) {
        displayLegend = false;
    }

    // Column Pressed
    columnPressed();

    // Slide sequence using Triangle buttons
    slideSeq();

    // Sequence Zooming using Round buttons
    zoomSeq();

    // Rectangle buttons for Color Scheme, Fonts, Alignment Indicator
    rectPressed();

    // Search Pannel
    searchPanelButtons();

    // Search Panel Checkboxes
    checkBoxPressed();
}

void mouseMoved() {
    // Hack to fix button lock problem
    if (mouseX < canvasWidth/2-270 || mouseX > canvasWidth/2-270 + 540 || mouseY > 100) {
        buttonLock = "";
    }
    if (JS && gsStatus == 2) {
        gsStatus = 10;
    }
    redraw();
}

void mouseReleased() {
    if (JS && gsStatus < 2) {
        return;
    }
    mouseOverButton = "";
    buttonLock = "";
    mouseLockScroll = false;    // Release mouse lock from slider bar
    mouseLockZoomLeft = false;
    mouseLockZoomRight = false;
    if (gsStatus > 2) {
        gsStatus = 10;
    }
    gsStatus = 10;
    updateSearchResults();
    redraw();
}

void mouseDragged() {
    //// try to prevent wild errors if mouse goes out of bounds :(
    int nextMove;    // This will fix some weird slider moves
    float searchBottom=105 + 35; 

    //// Vertical Slider in show column data view
    if ( displayColumnData ) {
        if (mouseY > pmouseY) {
            // move mouse slowly and distance will be small, move it quickly and it will be large
            columnDataStart+= dist(width/2, mouseY, width/2, pmouseY);
            //  columnDataStart+= dist(width/2, mouseY, width/2, pmouseY) * map(numSequences, 1, 4000, 1, 30); //** map function works here in Java mode but causes a crash in JavaScript
            if (columnDataStart > numLines-linesDisplayed) { 
                columnDataStart = numLines-linesDisplayed;
            }
        } else if (mouseY < pmouseY) {
            columnDataStart-= dist(width/2, mouseY, width/2, pmouseY);
            //  columnDataStart-= dist(width/2, mouseY, width/2, pmouseY) * map(numSequences, 1, 4000, 1, 30); //** map function works here in Java mode but causes a crash in JavaScript
            if (columnDataStart < 0) { 
                columnDataStart = 0;
            }
        }
    }

    if (mouseX>=5 && mouseX<=canvasWidth-5 && mouseY>=5 && mouseY <= canvasHeight-5) {
        int displayDigitHowMany = endDigit - startDigit;

        // Lock mouse to control sliders.
        if (((mouseX > sliderRectStart+3 && mouseX < sliderRectEnd-3) && (mouseY > sliderBarPaddingFromTop-15 && mouseY < sliderBarPaddingFromTop+10)) && mouseLockZoomLeft == false && mouseLockZoomRight == false) {
            mouseLockScroll = true;
            mouseLockZoomLeft = false;
            mouseLockZoomRight = false;
        } else if (((mouseX > sliderRectStart-15 && mouseX < sliderRectStart+2) && (mouseY > sliderBarPaddingFromTop-15 && mouseY < sliderBarPaddingFromTop+5)) && mouseLockScroll == false && mouseLockZoomRight == false) {
            mouseLockZoomLeft = true;
            mouseLockScroll = false;
            mouseLockZoomRight = false;
        } else if (((mouseX > sliderRectEnd-2 && mouseX < sliderRectEnd+20) && (mouseY > sliderBarPaddingFromTop-15 && mouseY < sliderBarPaddingFromTop+5)) && mouseLockScroll == false && mouseLockZoomLeft == false) {
            mouseLockZoomRight = true;
            mouseLockScroll = false;
            mouseLockZoomLeft = false;
        }

        // Drag the scroll bar
        if (mouseLockScroll == true) {
            // if resetting position wouldn't push the start or end past the edge
            if ( (int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))-int(displayDigitHowMany/2)) > 0  ) {
                nextMove = int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))-int(displayDigitHowMany/2);
                if ((endDigit >= numNucleotides - 2) && (nextMove > startDigit)) {
                } else {
                    startDigit = nextMove;
                }
                endDigit = startDigit + displayDigitHowMany;
                if (endDigit >= numNucleotides - 2) {
                    endDigit = numNucleotides;
                }
            } else if ((int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))-int(displayDigitHowMany/2)) < 0 ) {
                startDigit = 0;
                endDigit = startDigit + displayDigitHowMany;
            } else if ( (int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))+int(displayDigitHowMany/2)) > numNucleotides  ) {
                endDigit = numNucleotides;
                startDigit = endDigit - displayDigitHowMany;
            } else {
            }
        } 

        // Move left
        if (mouseLockZoomLeft == true) {
            if (int(map( mouseX, sliderBarPaddingFromSide - 15, canvasWidth - sliderBarPaddingFromSide, 0, numNucleotides)) >= 0) {
                startDigit = int(map(mouseX, sliderBarPaddingFromSide - 15, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides));
            }
        }

        // Move Right
        if (mouseLockZoomRight == true) {
            if (int(map( mouseX, sliderBarPaddingFromSide + 20, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides)) >= 0) {
                nextMove = int(map(mouseX, sliderBarPaddingFromSide + 20, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides));
                if ((startDigit < endDigit - 3)) {
                    endDigit = nextMove;
                } else {
                    if (nextMove > endDigit) {
                        endDigit = nextMove;
                    }
                }
            }
        }

        ////////// Search Panel Sliders //////////////  
        //checkBoxOn[currentSearchPanel] = false;
        for (int i=0; i<8; i++) {
            if (!displayColumnData && mousePressed == true && buttonLock.equals("searchDigitControlBar"+i)) {
                searchString[currentSearchPanel][i]=searchDigit[currentSearchPanel][i].sd_letter;
                searchValue[currentSearchPanel][i] = mouseY;
                if (DNA) {
                    searchValue[currentSearchPanel][i]=map(constrain(mouseY, searchBottom-20-searchHeight, searchBottom-20), searchBottom-20, searchBottom-20-searchHeight, 0, 2);
                } else {
                    searchValue[currentSearchPanel][i]=map(constrain(mouseY, searchBottom-20-searchHeight, searchBottom-20), searchBottom-20, searchBottom-20-searchHeight, 0, 4.32);
                }

                if (DNA) {
                    if (searchValue[currentSearchPanel][i] == 0) { 
                        searchDigit[currentSearchPanel][i].sd_letter = 'N';
                    }
                } else {
                    if (searchValue[currentSearchPanel][i] == 0) { 
                        searchDigit[currentSearchPanel][i].sd_letter = '*';
                    }
                }
                updateSearchResults();
            }
        }
    }
    redraw();
}

void keyPressed() {
    if (searchPanelOpen && gsStatus == 10) {

        String[] searchStartingColumn;
        String[] searchEndingColumn;
        searchStartingColumn = new String[6];
        searchEndingColumn = new String[6];

        /////////// Begin by clearing all the backgrounds before re-processing them //////////
        //Update background colors
        for (int k=0; k<numNucleotides; k++) {
            digit[k].digitBackgroundColor[currentSearchPanel] = 0; //background colors
        }
        //if backspace then delete last entry and reprocess
        if (key != CODED && keyCode == BACKSPACE || keyCode == DELETE || keyCode == LEFT) {
            if (searchPanelText[currentSearchPanel].length()>0 ) {
                searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel].substring(0, searchPanelText[currentSearchPanel].length()-1);       
                /// remove the last search slider
                int lastSlider = 0;
                for (int i=0; i<8; i++) {
                    if (searchValue[currentSearchPanel][i] > 0) {
                        lastSlider = i;
                    }
                }
                for (int i=lastSlider; i<8; i++) {
                    searchValue[currentSearchPanel][i] = 0;
                    searchString[currentSearchPanel][i] = '\u0000';
                    if (DNA) {
                        searchDigit[currentSearchPanel][i].sd_letter = 'N';
                    } else {
                        searchDigit[currentSearchPanel][i].sd_letter = '*';
                    }
                } 

                /// if text box is now empty, clear all search results
                if (searchPanelText[currentSearchPanel].equals("")) { 
                    checkBoxOn[currentSearchPanel] = false;
                    for (int i=0; i<8; i++) {
                        searchValue[currentSearchPanel][i] = 0;
                        searchString[currentSearchPanel][i] = '\u0000';
                        if (DNA) {
                            searchDigit[currentSearchPanel][i].sd_letter = 'N';
                        } else {
                            searchDigit[currentSearchPanel][i].sd_letter = '*';
                        }
                    }
                    for (int k=0; k<numNucleotides; k++) {
                        searchMotifText[currentSearchPanel][k] = "";
                        searchMotifStart[currentSearchPanel][k] = -1;
                        searchMotifEnd[currentSearchPanel][k] = -1; 
                        digit[k].digitBackgroundColor[currentSearchPanel] = 0;
                    }
                }
            }
        } 

        //process new key
        //if DNA mode
        if (DNA) {
            if ( (key == 'a' ||key == 'c' || key == 't' || key == 'g' || key == 'n' || key == 'x' || key == 'r' || key == 'y' ||key == 'A' ||key == 'C' || key == 'T' || key == 'G' || key == 'N' || key == 'X'|| key == 'R' || key == 'Y' || key == '-')  &&  searchPanelText[currentSearchPanel].length()<=8) {
                searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel] + str(key);

                // clear old motif
                for (int i=0; i<8; i++) {
                    searchString[currentSearchPanel][i] = ' ';
                    searchDigit[currentSearchPanel][i].sd_letter = 'N';
                    searchValue[currentSearchPanel][i] = 0;
                }
                //println(searchPanelText[currentSearchPanel]);

                // add new motif
                for (int i=0; i<searchPanelText[currentSearchPanel].length (); i++) {
                    searchString[currentSearchPanel][i] = searchPanelText[currentSearchPanel].substring(i, i+1).charAt(0);
                    searchDigit[currentSearchPanel][i].sd_letter = searchPanelText[currentSearchPanel].substring(i, i+1).charAt(0);

                    // convert dashes to N
                    if (searchPanelText[currentSearchPanel].substring(i, i+1).equals("-")) {
                        searchValue[currentSearchPanel][i] = .001;
                        searchDigit[currentSearchPanel][i].sd_letter = 'n';
                        checkBoxOn[currentSearchPanel] = true;
                    }

                    //if capital letter make value 2
                    else if ( searchPanelText[currentSearchPanel].substring(i, i+1).equals(searchPanelText[currentSearchPanel].substring(i, i+1).toUpperCase() ) ) {
                        searchValue[currentSearchPanel][i] = 2;
                        checkBoxOn[currentSearchPanel] = true;
                    }
                    // if small letter, make value .25
                    else {
                        searchValue[currentSearchPanel][i] = .25;
                        checkBoxOn[currentSearchPanel] = true;
                    }
                }
            }
        } else {

            if ( (key == 'a' ||key == 'A' || key == 'b' || key == 'B' || key == 'c' || key == 'C' || key == 'd' || key == 'D' 
                || key == 'e' ||key == 'E' || key == 'f' || key == 'F' || key == 'g' || key == 'G' || key == 'h' || key == 'H'    
                || key == 'i' ||key == 'I' || key == 'j' || key == 'J' || key == 'k' || key == 'K' || key == 'l' || key == 'L'  
                || key == 'm' ||key == 'M' || key == 'n' || key == 'N' || key == 'o' || key == 'O' || key == 'p' || key == 'P'  
                || key == 'q' ||key == 'Q' || key == 'r' || key == 'R' || key == 's' || key == 'S' || key == 't' || key == 'T'  
                || key == 'u' ||key == 'U' || key == 'v' || key == 'V' || key == 'w' || key == 'W' || key == 'x' || key == 'X'
                || key == 'y' ||key == 'Y' || key == 'z' || key == 'Z' || key == '*' || key == '-'  
                &&  searchPanelText[currentSearchPanel].length() <= 8 ) ) {
                searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel] + str(key);


                // clear old motif
                for (int i=0; i<8; i++) {
                    searchString[currentSearchPanel][i] = ' ';
                    searchDigit[currentSearchPanel][i].sd_letter = '*';
                    searchValue[currentSearchPanel][i] = 0;
                }

                // add new motif
                for (int i=0; i<searchPanelText[currentSearchPanel].length (); i++) {
                    searchString[currentSearchPanel][i] = searchPanelText[currentSearchPanel].substring(i, i+1).charAt(0);
                    searchDigit[currentSearchPanel][i].sd_letter = searchPanelText[currentSearchPanel].substring(i, i+1).charAt(0);

                    // convert dashes to N
                    if (searchPanelText[currentSearchPanel].substring(i, i+1).equals("-")) {
                        searchValue[currentSearchPanel][i] = .001;
                        searchDigit[currentSearchPanel][i].sd_letter = '*';
                        checkBoxOn[currentSearchPanel] = true;
                    }

                    //if capital letter make value 4.32
                    else if ( searchPanelText[currentSearchPanel].substring(i, i+1).equals(searchPanelText[currentSearchPanel].substring(i, i+1).toUpperCase() ) ) {
                        searchValue[currentSearchPanel][i] = 4.32;
                        checkBoxOn[currentSearchPanel] = true;
                    }
                    // if small letter, make value .25
                    else {
                        searchValue[currentSearchPanel][i] = .25;
                        checkBoxOn[currentSearchPanel] = true;
                    }
                }
            }
        }

        //// reprocess sliders based on new information
        numSearchColumns[currentSearchPanel] = 0;
        String whichColumns="";
        for (int i=0; i<8; i++) {
            ///track how many searchDigits are active at the moment? (concotinate a string that contains each)
            if (searchValue[currentSearchPanel][i] > 0) {
                whichColumns=whichColumns + str(i);
            }
        }

        if (whichColumns.length() > 0) { // now figure out which is first, which is last, and what the difference is between
            searchStartingColumn[currentSearchPanel] = whichColumns.substring(0, 1);
            searchEndingColumn[currentSearchPanel] = whichColumns.substring(whichColumns.length()-1);
            searchOffset[currentSearchPanel] = int(searchStartingColumn[currentSearchPanel]);
            if (whichColumns.length() > 1) { // and that's how many search columns are active
                numSearchColumns[currentSearchPanel] = int(searchEndingColumn[currentSearchPanel]) - int(searchStartingColumn[currentSearchPanel]) + 1;
            } else {
                numSearchColumns[currentSearchPanel] = 1;
            }
        }

        // then reprocess background
        updateSearchResults();
    }
    redraw();
}

// These are the classes for GeneSlider
// File: GSClasses.pde

// This class Draws an individual character
class CharacterBit {
    // descriptor variables
    char ch_letter; // what letter is it?
    float ch_frequency; // what's it's frequency (height)?
    color ch_color;

    // character bit constructor
    CharacterBit (char _ch_letter, float _ch_frequency ) {
        ch_letter = _ch_letter;
        ch_frequency = _ch_frequency;
        //println(ch_letter + " " + ch_frequency);
    }

    /////// functions
    void ch_display(float ch_x, float ch_y, float ch_w, float ch_h, color _ch_color ) {    
        ch_color = _ch_color; // desired color
        //float fontWidth = textWidth(ch_letter);

        textFont(font[currentFont]);
        textAlign(LEFT);
        //make sure width and height is greater than 0 so we don't crash
        // Size small than 0.0004941547632979568 cause bugs in JS mode (fill sized character is displayed!)
        if (ch_w/fontWidth > 0 && (ch_frequency * ch_h)/fontHeight > 0 && (ch_frequency * ch_h)/fontHeight > 0.0004941547632979568) {
            //now draw the letter as requested
            fill(ch_color);            
            pushMatrix();
            translate(ch_x, ch_y);
            scale(ch_w / fontWidth, (ch_frequency * ch_h) / fontHeight); // scale width and height according to size needs and frequency
            //println(ch_w + " " + ch_h + " " + fontWidth + " " + ch_h + " " + fontHeight);
            if ( ch_w/fontWidth > .255) {
                text(ch_letter, 0, 0);
            } else if ( ch_w/fontWidth > .1) {
                fill(ch_color, map(ch_w/fontWidth, .1, .255, 255, 0  ) ) ; //fade in bg rectangle behind letter
                rect(0, 0, fontWidth, -fontHeight);
                fill(ch_color, 255);
                text(ch_letter, 0, 0);
            } else {      // if too narrow, just draw a rectangle
                //fill(ch_color,255);
                rect(0, 0, fontWidth, -fontHeight);
            }
            popMatrix();
        } else {
            pushMatrix();
            if (ch_w / fontWidth != 0 && (ch_frequency*ch_h)/fontHeight !=0) {
                translate(ch_x, ch_y);
                scale(ch_w / fontWidth, (ch_frequency*ch_h)/fontHeight);
                fill(ch_color);
                rect(-fontWidth/2, 0, fontWidth, -fontHeight);
            }
            popMatrix();
        }
    }
}

// this draws a series of CharacterBits one on top of the other at a given position, width, height, font and color
class Digit {
    // an object that contains several CharacterBits
    CharacterBit[] d_characterBits;
    CharaterBit d_characterBitAt;
    int d_index = 0;        // This is the index of DNA/AA in alignment
    char[] digitColumn;    // This is all the DNA/AA chars in the alignment
    float entropy = 0;        // The entropy
    float bitScore = 0;    // The bit score
    float weightedBitScore = 0;    // The weighted bit score
    char[] sortedChars;
    float[] sortedHeights;
    float numLettersInColumn = 0;    // Number of letters in a column
    float d_x, d_y, d_w, d_h ; // incoming position variables for digit
    int[] digitBackgroundColor;
    String unique;
    float d_thisDigitHeight = 0; // calculated height of this digit
    boolean d_mouseOverFlag;
    boolean backgroundColored = false;    // True if background is not coloured

    // digit constructor
    Digit(int _d_index, char[] d_digitColumn) {
        // These are the variable we have received
        d_index = _d_index;    // The index of the nucleotide or aminoacid in the alignment
        String uniqueDigitsInColumn = "";  // This is a string of unqiue character at an alignment position.
        digitBackgroundColor = new color[6];

        digitColumn = new char[d_digitColumn.length];
        arrayCopy(d_digitColumn, digitColumn);    // The list of letters in the alignment



        // Data processor
        // Calculate unique data
        uniqueDigitsInColumn = calcUniqueData();
        //println(uniqueDigitsInColumn);

        // Calculate entropy and bit scores
        calcEntropy(uniqueDigitsInColumn);

        initCharBits(uniqueDigitsInColumn);

        d_miniDisplay();
    } 

    // This function returns the unique DNA/AA letters in the alignment
    String calcUniqueData() {
        String symbols = "AGCTNXRYBDEFGHIJKLMOPQSUVWZ";
        String uniqueDigitsInColumn = "";    // This is the string where unique DNA/AA will be store
        for (int i = 0; i < digitColumn.length; i++) {
            String[] m1 = match(symbols, str(digitColumn[i]));
            if (m1 != null) {
                String[] m2 = match(uniqueDigitsInColumn, str(digitColumn[i]));
                if (m2 == null) {
                    uniqueDigitsInColumn += digitColumn[i];
                }
                numLettersInColumn += 1;
            }
        }
        unique = uniqueDigitsInColumn;
        return uniqueDigitsInColumn;
    }

    void calcEntropy (String uniqueDigitsInColumn) {
        float eachOverAll = 0;    

        // For each unique character
        for (int i = 0; i < uniqueDigitsInColumn.length (); i++) {

            eachOverAll = getFreq(uniqueDigitsInColumn.substring(i, i+1)) / numLettersInColumn;
            entropy += eachOverAll * log2(eachOverAll);
        } 

        if (DNA) {
            bitScore = log2(4) + entropy;
        } else {
            bitScore = log2(20) + entropy;
        }
        weightedBitScore = bitScore * numLettersInColumn/numSequences;
    }

    // Returnt the number of times a letter appeared in digitColumn
    float getFreq(String uniqueDigits) {
        float count = 0;
        for (int i = 0; i < digitColumn.length; i++) {
            if (digitColumn[i] == uniqueDigits.charAt(0)) {
                count++;
            }
        }
        return count;
    } 

    // This function calculates the log2 for entropy
    float log2 (float n) {
        return (log(n) / log(2));
    }

    // This function initialize the character bits
    void initCharBits(String uniqueDigits) {
        sortedChars = new char[uniqueDigits.length()];    // The character are sorted from lowest bit score to largest
        sortedHeights = new float[uniqueDigits.length()];    // The will the sorted heights of the letters.
        float tmpHeight = 0;    // Stores height temporarily
        String[] tmpAllSorted = new String[uniqueDigits.length()];    // Temporarily hold sorted characters
        String[] tmpSplit;    // This will store data when tmpAllSorted is split 

            // Put everything in an array of string to sort it link this: "0.2,A"
        for (int i = 0; i < uniqueDigits.length (); i++) {
            if (showWeightedBitScore) {
                tmpHeight = ( getFreq(uniqueDigits.substring(i, i + 1)) / numLettersInColumn) * weightedBitScore;
            } else {
                tmpHeight = ( getFreq(uniqueDigits.substring(i, i + 1)) / numLettersInColumn) * bitScore;
            }
            tmpAllSorted[i] = str(tmpHeight) + "," + uniqueDigits.substring(i, i + 1);
        }

        // Now sort the string
        tmpAllSorted = sort(tmpAllSorted);

        // Now fill in the sorted Chars and sorted heights
        for (int i = 0; i < tmpAllSorted.length; i++) {
            tmpSplit = split(tmpAllSorted[i], ",");
            sortedChars[i] = tmpSplit[1].charAt(0);
            sortedHeights[i] = float(tmpSplit[0]);
        }

        // Now intialize the Character bits
        d_characterBits = new CharacterBit[uniqueDigits.length()];
        for (int i = 0; i < uniqueDigits.length (); i++) {
            d_characterBits[i] = new CharacterBit(sortedChars[i], sortedHeights[i]);
            d_thisDigitHeight = d_thisDigitHeight + sortedHeights[i];
        }

        // Display AT sequence
        d_characterBitAt = new CharacterBit(digitColumn[0], 1);
    }

    ///////draw the digit
    void d_display(float _d_x, float _d_y, float _d_w, float _d_h) { 
        d_x = _d_x;
        d_y = _d_y;
        d_w = _d_w;
        d_h = _d_h;
        float superScript = 0;
        color d_chColor = 0;
        String symbols = "AGCTNXRY-BDEFGHIJKLMOPQSUVWZ*"; 

        /// background first  
        noStroke();      


        /// adjust size multiplier depending on mode
        float adjustmentForDNAorProtein;
        if (DNA) {
            adjustmentForDNAorProtein = 2;
        } else {
            adjustmentForDNAorProtein = 4.32;
        }

        /// background first  
        // draw each search panel background, one at a time
        int backgroundOffset = 0;
        //d_backgroundActive = false;
        for (int i=0; i<6; i++) {
            if (checkBoxOn[i]) { 
                backgroundOffset++;
            }
            noStroke();      
            if (digitBackgroundColor[i]>0 ) {    
                fill(digitBackground[i+1]);  
                //if both previous digit and next digit are white, curve the top and bottom of all corners corners (only check digits above zero and less than numNucleotides-1)
                if (d_index==0 && digit[d_index].digitBackgroundColor[i] >=1 && digit[d_index + 1].digitBackgroundColor[i] != digit[d_index].digitBackgroundColor[i] || d_index > 0 && digit[d_index-1].digitBackgroundColor[i] != digit[d_index].digitBackgroundColor[i] && d_index<numNucleotides-1 && digit[d_index+1].digitBackgroundColor[i] != digit[d_index].digitBackgroundColor[i] ) {
                    rect(d_x-(d_w/2), (d_y-d_h*adjustmentForDNAorProtein)-((backgroundOffset+1)*5), d_w, ((backgroundOffset+1)*5)+d_h*adjustmentForDNAorProtein + 10, 20, 20, 20, 20); //corner radius
                }      
                //if previous digit is white, curve the top and bottom left corners
                else if (d_index == 0 && digit[d_index].digitBackgroundColor[i] >=1 || d_index>0 && digit[d_index-1].digitBackgroundColor[i] != digit[d_index].digitBackgroundColor[i] ) {
                    rect(d_x-(d_w/2), (d_y-d_h*adjustmentForDNAorProtein)-((backgroundOffset+1)*5), d_w, ((backgroundOffset+1)*5)+d_h*adjustmentForDNAorProtein + 10, 20, 0, 0, 20); // corner radius
                }
                //if next digit is white, curve the top and bottom right corners (only check digits up to numNucleotides-1)
                else if (d_index<numNucleotides-1 && digit[d_index+1].digitBackgroundColor[i] != digit[d_index].digitBackgroundColor[i] ) {
                    rect(d_x-(d_w/2), (d_y-d_h*adjustmentForDNAorProtein)-((backgroundOffset+1)*5), d_w, ((backgroundOffset+1)*5)+d_h*adjustmentForDNAorProtein + 10, 0, 20, 20, 0); //corner radius
                }

                //otherwise don't curve any corners 
                else { 
                    rect(d_x-(d_w/2), (d_y-d_h*adjustmentForDNAorProtein)-((backgroundOffset+1)*5), d_w, ((backgroundOffset+1)*5)+d_h*adjustmentForDNAorProtein + 10);
                }

                //// if we're not in display Column Data mode and user clicks on a digit, set mouseOverButton
                //if (!displayColumnData && d_mouseOverFlag) {           
                //    mouseOverButton = "digit"+str(d_index);
                //}
            }
        }

        /// now draw the digit..      
        superScript = 0;
        noStroke();
        for (int i = 0; i < sortedHeights.length; i++) {
            pushMatrix();
            translate(d_x, d_y);

            //determine color mode
            if (!alignmentCountIndicator) {
                d_chColor = color(colorScheme[currentColorScheme][ symbols.indexOf(sortedChars[i])], map(numLettersInColumn, 1, numSequences, 40, 255)); //scale color opacity according to num letters in column
            } else {
                d_chColor = color(colorScheme[currentColorScheme][symbols.indexOf(sortedChars[i]) ]);
            }
            d_characterBits[i].ch_display(0 - (d_w/2), superScript, d_w, d_h, d_chColor);
            if (i == 0) {
                d_characterBitAt.ch_display(0 - (d_w/2), 15, d_w, 5, d_chColor);
            }
            superScript = superScript - (sortedHeights[i] * d_h);
            popMatrix();
        }

        // if mouse over the digit, draw tiny dots above and below the digit
        if (d_mouseOverFlag) {
            fill(220);
            noStroke();
            //bottom one
            ellipse(d_x, d_y + 13, 6, 6);
            //top one
            ellipse(d_x, d_y-(d_h*adjustmentForDNAorProtein)-13, 6, 6);
        }
        d_numberBelowDigit();
        d_mouseOver();
    } 
    //////////////////////////////////////////
    // draw the identifying numbers below each digit 
    //////////////////////////////////////////
    void d_numberBelowDigit() { 
        int numToDisplay = alnStart + d_index;
        int displayDigitHowMany = endDigit - startDigit;

        // This is done so that AT sequence can be displayed
        d_y = d_y + 12;

        fill(200);
        textAlign(CENTER);
        textFont (helvetica18, 12);
        if (mouseX > d_x-(d_w/2) && mouseX < d_x+d_w/2 && mouseY > d_y+10 && mouseY < d_y+20) {
            fill(60);
        } else {
            fill(200);
        }    

        //////////////////////////////////////////
        // deterimine if we should draw a number or skip based on 
        //////////////////////////////////////////
        if (lastDrawnNumberXpos > d_x) {
            lastDrawnNumberXpos = d_x; // reset if we’re at the beginning of the cycle
        }
        pushMatrix();
        translate(d_x, d_y);
        if (d_x - lastDrawnNumberXpos > textWidth(numToDisplay)+50 && numToDisplay % 5 == 0) {
            text(numToDisplay, 0, 20);
            lastDrawnNumberXpos = d_x;
        } else if (((d_x - lastDrawnNumberXpos) + 5) > textWidth(numToDisplay) + 10 &&  numToDisplay % 5 == 0) {
            text(".", -15, 16);
        }             
        popMatrix();

        d_y = d_y - 12;
    }

    /*
    //////////////////////////////////////////
     // draw the identifying numbers below each digit 
     //////////////////////////////////////////
     void d_numberBelowDigit() { 
     int numToDisplay = alnStart + d_index;
     int displayDigitHowMany = endDigit - startDigit;
     
     // This is done so that AT sequence can be displayed
     d_y = d_y + 12;
     
     fill(200);
     textAlign(CENTER);
     textFont (helvetica18, 12);
     if (mouseX > d_x-(d_w/2) && mouseX < d_x+d_w/2 && mouseY > d_y+10 && mouseY < d_y+20) {
     fill(60);
     } else {
     fill(200);
     }    
     
     //////////////////////////////////////////
     // deterimine if we should draw a number, a dot, or skip
     //////////////////////////////////////////
     pushMatrix();
     translate(d_x, d_y);
     //Choose the frequency of numbers to display depending on how many are being displayed
     if (displayDigitHowMany <= 30) { //if less than 30 display all
     text(numToDisplay, 0, 20);
     } else if (displayDigitHowMany > 30 && displayDigitHowMany <= 100 && (numToDisplay) % 5 == 0) { //if less than 100 display every fifth
     text(numToDisplay, 0, 20);
     } else if (displayDigitHowMany > 100 && displayDigitHowMany <= 300 && (numToDisplay) % 25 == 0) { //if greater than 100 and less than 300 display every twentyfive
     text(numToDisplay, 0, 20);
     } else if (displayDigitHowMany > 30 && displayDigitHowMany <= 150 && (numToDisplay) % 5 != 0) { //if greater than 30 and less than 150, and not divisible by five put dots
     text(".", 0, 14);
     } else if (displayDigitHowMany > 150 && displayDigitHowMany <= 300 && (numToDisplay) % 5 == 0) { //if greater than 150 and less than 300, and not divisible by five put dots
     text(".", 0, 14);
     } else if (displayDigitHowMany > 300 && displayDigitHowMany <= 1600 && (numToDisplay) % 50 == 0) { //if greater than 300 and less than 1600 display every fifty
     text(numToDisplay, 0, 20);
     } else if (displayDigitHowMany > 1600 && (numToDisplay) % 100 == 0) { //if greater than 1600 display every hundred
     text(numToDisplay, 0, 20);
     } else if (displayDigitHowMany > 300 && (numToDisplay) % 25 == 0) { //if greater than 300 put dots every 25
     text(".", 0, 14);
     }  
     popMatrix();
     
     d_y = d_y - 12;
     } */

    void d_showNumLettersInColumn() { 

        int alignmentIndicatorThickness = 4;    
        if (alignmentCountIndicator) {
            fill(200);
            noStroke();

            /// adjust size multiplier depending on mode
            float adjustmentForDNAorProtein;
            if (DNA) {
                adjustmentForDNAorProtein = 2;
            } else {
                adjustmentForDNAorProtein = 4.32;
            }

            //if it's appropriate to draw a vertical connecting bar on the left side of the digit, do so
            if (d_index > 0) { //avoid null pointer exception

                float previousNumLettersInColumn = digit[d_index-1].numLettersInColumn;
                if (previousNumLettersInColumn != numLettersInColumn) {

                    rectMode(CORNERS);
                    rect(d_x-(d_w/2), d_y-((previousNumLettersInColumn/numSequences)*d_h*adjustmentForDNAorProtein)+alignmentIndicatorThickness, d_x-(d_w/2)+alignmentIndicatorThickness, d_y-((numLettersInColumn/numSequences)*d_h*adjustmentForDNAorProtein) );
                    rectMode(CORNER);
                }
            }        
            /////////////////////
            //horizontal bar
            /////////////////////
            //rect(d_x-(d_w/2), d_y*dampening-((numLettersInColumn/numSequences)*d_h*dampening*adjustmentForDNAorProtein), d_w+alignmentIndicatorThickness, alignmentIndicatorThickness); 
            rect(d_x-(d_w/2), d_y-((numLettersInColumn/numSequences)*d_h*adjustmentForDNAorProtein), d_w+alignmentIndicatorThickness, alignmentIndicatorThickness);
            /////////////////////
            /// if this is the last digit, extend the horizontal bar into the legend
            if (d_index == endDigit) {
                rectMode(CORNERS);
                fill(230);
                rect(d_x+(d_w/2), d_y-((numLettersInColumn/numSequences)*d_h*adjustmentForDNAorProtein), canvasWidth-32, d_y-((numLettersInColumn/numSequences)*d_h*adjustmentForDNAorProtein)+alignmentIndicatorThickness); 
                rectMode(CORNER);


                /////////////////////
                /// draw actual number next to the axis
                fill(200);
                textAlign(RIGHT);
                textFont (helvetica18, 15); 
                if ( numLettersInColumn < .9*numSequences) {
                    text(int(numLettersInColumn), canvasWidth-37, d_y-((numLettersInColumn/numSequences)*d_h*adjustmentForDNAorProtein)-2 );
                } else {
                    text(int(numLettersInColumn), canvasWidth-37, d_y-((numLettersInColumn/numSequences)*d_h*adjustmentForDNAorProtein)+16 );
                }
            }
        }
    }

    // Draw the mini digit display
    void d_miniDisplay() {
        int dm_x;
        int dm_width = 1;    // If less than 880;
        float dm_h;
        color shade;
        if (showWeightedBitScore) {
            dm_h = 4.32 * weightedBitScore;
        } else {
            dm_h = 4.32 * bitScore;
        }

        if (DNA) {
            dm_h *= 2;
        } else {
            dm_h *= 0.93;
        }
        dm_h += 3;

        noStroke();
        shade = color(#BBBBBB, map(numLettersInColumn, 1, numSequences, 40, 240));
        dm_x = int(map(d_index, 1, numNucleotides, 1, horizontalBarWidth));

        // If there are less than 880 nucleotides, precaution need to be taken
        if (numNucleotides < 880) {
            dm_width = int(map(1, 1, numNucleotides, 1, horizontalBarWidth)) - int(map(0, 1, numNucleotides, 1, horizontalBarWidth));
        }

        for (int y=horizontalBarHeight-1; y>horizontalBarHeight-dm_h; y--) {
            horizontalBar.pixels[y*horizontalBarWidth+dm_x] = shade;
            // Drawing the complete rectangle for case with less than 880 nucleotides
            if (numNucleotides < 880) {
                for (int x = 0; x < dm_width; x++) {
                    horizontalBar.pixels[y*horizontalBarWidth+dm_x+x] = shade;
                }
            }
        }
    }

    //////////////////////////////////////////
    /// draw the miniature lines that represent digits in the slider bar
    //////////////////////////////////////////
    void d_searchHighlight(float dm_x, float dm_y) { 

        //////////////////////////////////////////
        /// dot beneath track (used to be background) first  
        //////////////////////////////////////////
        noStroke();      
        fill(digitBackground[digitBackgroundColor[0]]);
        for (int i=0; i<6; i++) { 
            noStroke();      
            if (digitBackgroundColor[i]>0 ) {
                fill(digitBackground[i+1]);
            }
        }
        //rect(dm_x, dm_y+10, dm_w, -dm_digitHeight*2-10);
        rect(dm_x, dm_y, 2, 10);
        rectMode(CORNER);
    }

    boolean matchChecker(int searchColumnNumber) {
        /// columnNumber is the nucleotide column from the data
        /// searchColumnNumber is the search column in the search panel
        int indexOfMatchedLetter=0;

        // if string is empty, return False
        if (searchString[currentSearchPanel][searchColumnNumber] == ' ' ) { 
            return false; //if blank, no match
        } 

        /// if DNA mode
        if (DNA) {
            // if string is not N and appears in the column and value is sufficient, return True
            String[] m1 = match(unique, str(searchString[currentSearchPanel][searchColumnNumber]).toUpperCase());
            if (m1 != null) {
                for (int i=0; i< sortedChars.length; i++) {
                    if (m1[0].equals(str(sortedChars[i]))) {
                        indexOfMatchedLetter = i;
                        break;
                    }
                }
                if (searchValue[currentSearchPanel][searchColumnNumber] <= sortedHeights[indexOfMatchedLetter]) {  
                    return true;
                }
            }
            // if string is N or X and value is high enough, return True
            else if ( (str(searchString[currentSearchPanel][searchColumnNumber]).toUpperCase().equals("N") || str(searchString[currentSearchPanel][searchColumnNumber]).toUpperCase().equals("X")) ) {
                for (int i=0; i< sortedChars.length; i++) {
                    if (searchValue[currentSearchPanel][searchColumnNumber] <= sortedHeights[indexOfMatchedLetter]) {  
                        return true;
                    }
                }
            }
            //IU Pac codes. If string is R ---> (A or G) and value is high enough, return True
            else if ( str(searchString[currentSearchPanel][searchColumnNumber]).toUpperCase().equals("r") || str(searchString[currentSearchPanel][searchColumnNumber]).toUpperCase().equals("R") ) {   
                for (int i=0; i< sortedChars.length; i++) {
                    if (str(sortedChars[i]).toUpperCase().equals("A") || str(sortedChars[i]).toUpperCase().equals("G")) {
                        indexOfMatchedLetter = i;
                        //println("Match");
                        if (searchValue[currentSearchPanel][searchColumnNumber] <= sortedHeights[indexOfMatchedLetter]) {  
                            return true;
                        }
                        break;
                    }
                }
            } 
            //IU Pac codes. If string is Y ----> (C or T) and value is high enough, return True
            else if ( str(searchString[currentSearchPanel][searchColumnNumber]).toUpperCase().equals("y") || str(searchString[currentSearchPanel][searchColumnNumber]).toUpperCase().equals("Y") ) {   
                for (int i=0; i< sortedChars.length; i++) {
                    if (str(sortedChars[i]).toUpperCase().equals("C") || str(sortedChars[i]).toUpperCase().equals("T") ) {
                        indexOfMatchedLetter = i;
                        if (searchValue[currentSearchPanel][searchColumnNumber] <= sortedHeights[indexOfMatchedLetter]) {  
                            return true;
                        }
                        break;
                    }
                }
            }
        } else {  

            // if string is * and value is high enough, return True
            if ( str(searchString[currentSearchPanel][searchColumnNumber]).equals("*")) {
                for (int i=0; i< sortedChars.length; i++) {
                    if (searchValue[currentSearchPanel][searchColumnNumber] <= sortedHeights[i]) {  
                        return true;
                    }
                }
            } else {
                String[] m1 = match(unique, str(searchString[currentSearchPanel][searchColumnNumber]).toUpperCase());
                if (m1 != null) {
                    for (int i=0; i< sortedChars.length; i++) {
                        //println(columnNumber+" "+digit[columnNumber].sortedChars[i]+" "+m1[0]);
                        if (m1[0].equals(str(sortedChars[i]))) {
                            indexOfMatchedLetter = i;
                            //println("Match");
                            break;
                        }
                    }
                    if (searchValue[currentSearchPanel][searchColumnNumber] <= sortedHeights[indexOfMatchedLetter]) {  
                        return true;
                    }
                }
            }
        }
        return false;
    }

    void d_searchLabel(String d_searchLabelText, int d_searchStart, int d_searchEnd, int d_searchPanel, int d_superScript) {
        if (d_searchLabelText == null) { 
            return;
        }

        /// adjust size multiplier depending on mode
        float adjustmentForDNAorProtein;
        if (DNA) {
            adjustmentForDNAorProtein = 2;
        } else {
            adjustmentForDNAorProtein = 4.32;
        }

        ///////////// calculate padding depending whether message is odd or even
        if ( d_index == int((d_searchEnd+d_searchStart)/2) ) {
            textAlign(CENTER);
            textFont (helvetica18, 12);
            //if search block is even, add a some padding to the label
            int d_textPadding = 0;
            if ((d_searchEnd-d_searchStart) % 2 != 0 ) { 
                d_textPadding = int(d_w/2);
            }
            //}
            ///////background & line first
            rectMode(CENTER);
            fill(digitBackground[d_searchPanel+1]);
            noStroke();
            rect(d_x+d_textPadding, d_y-(d_h * adjustmentForDNAorProtein)-(d_superScript*20), textWidth(d_searchLabelText.toUpperCase())+20, 20, 10);
            stroke(digitBackground[d_searchPanel+1]);
            strokeCap(SQUARE);
            strokeWeight(5);
            line(d_x+d_textPadding, d_y-(d_h*adjustmentForDNAorProtein)-(d_superScript*20)+10, d_x+d_textPadding, (d_y-d_h*adjustmentForDNAorProtein)-((d_superScript)*5)-5 );
            ////// now the text
            fill(60);
            text(d_searchLabelText, d_x+d_textPadding, d_y-(d_h*adjustmentForDNAorProtein)-(d_superScript*20)+4 );
            //println(d_searchLabelText);
        }
    }

    String d_updateColumnData() {
        String columnData = "Column: " + (alnStart + d_index) + "\n";
        columnData += digitColumn.length + " alignment";
        if (digitColumn.length > 1 ) { 
            columnData += "s";
        }
        if (showWeightedBitScore) {
            columnData += "\nIndividual weighted bit scores:\n";
        } else {
            columnData += "\nIndividual bit scores:\n";
        }
        //individual bit scores
        for (int i = sortedChars.length; i>0; i--) {
            columnData += sortedChars[i-1] + "@" + str(rounder(sortedHeights[i-1], 2)) +"\n";
        }
        columnData += "Total bit score: "+str(rounder(bitScore, 2))+"\n";
        columnData += "Total weighted bit score: " + str(rounder(weightedBitScore, 2))+"\n";

        for (int i = 0; i < digitColumn.length; i++) {
            columnData += str(digitColumn[i]) + "@" + fastaHeaders[i] + "\n";
        }
        return columnData;
    }

    //// check mouse over status
    void d_mouseOver() {
        // adjust size multiplier depending on mode
        float adjustmentForDNAorProtein;
        if (DNA) {
            adjustmentForDNAorProtein = 2;
        } else {
            adjustmentForDNAorProtein = 4.32;
        }
        if (mouseX > d_x-(d_w/2) && mouseX < d_x+(d_w/2) && mouseY < d_y && mouseY > d_y-(d_h*adjustmentForDNAorProtein*.85)) { 
            d_mouseOverFlag = true;
        } else {
            d_mouseOverFlag = false;
        }
    }
}

////////////////////// 8. Class Search Digit /////////////////////////////
class SearchDigit {
    float sd_x, sd_y, sd_w, sd_h; // position: x, y, width, height of search digit
    char sd_letter;
    float sd_value; // this is the value we pass back
    float sd_valueYPosition; // this is what the value maps to on screen
    int sd_indexNumber;
    CharacterBit sd_character; // this is the letter it draws
    char[] sd_searchLettersDNA = { 
        'A', 'G', 'C', 'T', 'N', 'R', 'Y'
    };
    char[] sd_searchLettersProtein = { 
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z', '*'
    };
    int sd_proteinLettersStart = 0;
    int sd_proteinLettersEnd = sd_searchLettersProtein.length;

    char sd_mouseOverLetter;
    /////style variables
    color sd_strokeColor = #cccccc;
    color sd_textColor = #222222;
    String sd_toolTip;
    boolean mouseOverSD = false;

    //// Search Digit Constructor
    SearchDigit(int _sd_indexNumber, String _sd_toolTip) {
        sd_indexNumber = _sd_indexNumber;
        if (DNA) {
            sd_letter = 'N';
        } else {
            sd_letter = '*';
        }
        sd_character = new CharacterBit(sd_letter, 0);
        sd_toolTip = _sd_toolTip;
    }

    ///// Display
    void display(float _sd_x, float _sd_y, float _sd_w, float _sd_h) {
        sd_x = _sd_x;
        sd_y = _sd_y;
        sd_w = _sd_w;
        sd_h = _sd_h;  
        sd_value = searchValue[currentSearchPanel][sd_indexNumber];

        if (DNA) { 
            sd_valueYPosition = map(sd_value, 0, 2, sd_y-10, sd_y-sd_h);
        } else {
            sd_valueYPosition = map(sd_value, 0, 4.32, sd_y, sd_y-sd_h);
        }

        searchDigitControlBar();
        searchDigitDrawLetter();
        searchDigitChooseLetter();
    }

    ///// sliding controller bars
    void searchDigitControlBar() {
        //sliding handle
        textFont(helvetica18, 10);
        //if we're not in display column data mode and mouse is over, use darker color /*
        if (!displayColumnData && buttonLock=="searchDigitControlBar"+sd_indexNumber || mouseX > sd_x && mouseX < sd_x+sd_w && mouseY > sd_valueYPosition-40 && mouseY < sd_valueYPosition+3) {
            fill(lerpColor(digitBackground[currentSearchPanel+1], 128, .2)); 
            mouseOverButton = "searchDigitControlBar" + sd_indexNumber;
            buttonLock="searchDigitControlBar" + sd_indexNumber;
            mouseOverSD = true;
        } else if (sd_value == 0) {
            fill(lerpColor(digitBackground[currentSearchPanel+1], #FFFFFF, .6));
            mouseOverSD = true;
        } else { 
            fill(digitBackground[currentSearchPanel+1]); 
            mouseOverSD = false;
        }
        noStroke();
        rectMode(CENTER);
        textAlign(CENTER);
        rect(sd_x+(sd_w/2), sd_valueYPosition-5, sd_w, 5, 3);//horizontal bar
        rect(sd_x+(sd_w/2), sd_valueYPosition-15, 30, 15, 8, 8, 0, 0);
        fill(255);
        rect(sd_x+(sd_w/2), sd_valueYPosition-13, 24, 12, 5, 5, 0, 0); // white patch
        fill(160);
        text(str(rounder(sd_value, 2)), sd_x+(sd_w/2), sd_valueYPosition-9);
        rectMode(CORNER);
    }    
    //////////////////////////////////////////
    //// stretchy letter
    //////////////////////////////////////////
    void searchDigitDrawLetter() {
        String symbols = "AGCTNXRYBDEFGHIJKLMOPQSUVWZ";
        if (symbols.indexOf(str(sd_letter).toUpperCase()) != -1) { //avoid crash                   
            fill(colorScheme[currentColorScheme][ symbols.indexOf( str(sd_letter).toUpperCase() ) ]);
        }
        // if DNA mode
        if (DNA) {
            if (currentFont<3) {
                textFont (font[currentFont]); 
                if (sd_value !=0 ) {
                    pushMatrix();
                    translate(sd_x, sd_y-10);
                    scale(sd_w / fontWidth, (sd_value*(sd_h/2.5))/fontHeight);
                    text(str(sd_letter).toUpperCase(), fontWidth/2, 0);
                    popMatrix();
                }
            } else {
                pushMatrix();
                translate(sd_x, sd_y);
                //scale(sd_w / fontWidth, (sd_value*(sd_h/2))/fontHeight);
                rect(0, -sd_value*sd_h/2, sd_w, sd_value*sd_h/2, 7);
                popMatrix();
            }
        }
        // else if PROTEIN mode
        else {
            if (currentFont<3) {
                textFont (font[currentFont]); 
                if (sd_value !=0 ) {
                    pushMatrix();
                    translate(sd_x, sd_y);
                    scale(sd_w / fontWidth, (sd_value*(sd_h/4.32))/fontHeight);
                    text(str(sd_letter).toUpperCase(), fontWidth/2, 0);
                    popMatrix();
                }
            } else {
                pushMatrix();
                translate(sd_x, sd_y);
                //scale(sd_w / fontWidth, (sd_value*(sd_h/2))/fontHeight);
                rect(0, -sd_value*sd_h/4.32, sd_w, sd_value*sd_h/4.32, 7);
                popMatrix();
            }
        }
    }

    //////////////////////////////////////////  
    //// select new active letter
    ////////////////////////////////////////// 
    void searchDigitChooseLetter() {
        ////// DNA MODE
        if (DNA) {
            textFont(helvetica18, 10);
            textAlign(LEFT);

            //Row 1
            int sd_DNALettersStart = 0;
            //for (int i=0; i<sd_searchLettersDNA.length; i++) {
            for (int i=sd_DNALettersStart; i<sd_DNALettersStart+4; i++) {  
                if (!displayColumnData) { // disable if we're in display column data mode
                    if (str(sd_searchLettersDNA[i]).equals(str(sd_letter).toUpperCase()) || !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) && mouseX>sd_x+(sd_w/4*i*1.2)-3 && mouseX<sd_x+(sd_w/4*i*1.2)+textWidth(sd_searchLettersDNA[i])+3 && mouseY>sd_y-15 && mouseY<sd_y+5 ) {
                        fill(colorScheme[currentColorScheme][ i ]);
                        textFont(helvetica18, 11);
                        sd_mouseOverLetter = sd_searchLettersDNA[i];
                        if (mousePressed && !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) ) { 
                            sd_letter = sd_searchLettersDNA[i]; 
                            searchString[currentSearchPanel][sd_indexNumber]=sd_letter;
                        }
                    } else { 
                        fill(200);
                        textFont(helvetica18, 10);
                        sd_mouseOverLetter = '\u0000';
                    }
                }
                text(sd_searchLettersDNA[i], sd_x+(sd_w/4*i*1.2), sd_y);
            }

            //Row 2
            sd_DNALettersStart = 4;
            //for (int i=0; i<sd_searchLettersDNA.length; i++) {
            for (int i=sd_DNALettersStart; i<sd_searchLettersDNA.length; i++) {  
                if (!displayColumnData) { // disable if we're in display column data mode
                    if (str(sd_searchLettersDNA[i]).equals(str(sd_letter).toUpperCase()) || !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) && mouseX>sd_x+(sd_w/4*(i-sd_DNALettersStart)*1.2)+(sd_w/8)-3 && mouseX<sd_x+(sd_w/4*(i-sd_DNALettersStart)*1.2)+textWidth(sd_searchLettersDNA[i])+(sd_w/8)+3 && mouseY>sd_y && mouseY<sd_y+15 ) {
                        fill(colorScheme[currentColorScheme][ i ]);
                        textFont(helvetica18, 11);
                        sd_mouseOverLetter = sd_searchLettersDNA[i];
                        if (mousePressed && !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) ) { 
                            sd_letter = sd_searchLettersDNA[i]; 
                            searchString[currentSearchPanel][sd_indexNumber]=sd_letter;
                        }
                    } else { 
                        fill(200);
                        textFont(helvetica18, 10);
                        sd_mouseOverLetter = '\u0000';
                    }
                }
                text(sd_searchLettersDNA[i], sd_x+(sd_w/4*(i-sd_DNALettersStart)*1.2)+(sd_w/8), sd_y+10);
            }
        }

        //////// PROTEIN MODE
        else { 
            textFont(helvetica18, 10);
            textAlign(CENTER);    

            float tempPad = 5;

            ///There are 24 symbols so we need to break them into lines. This may be ugly coding but it works...

            //Row 1    
            sd_proteinLettersStart = 0;
            for (int i=sd_proteinLettersStart; i<sd_proteinLettersStart+6; i++) {
                if (!displayColumnData) { // disable if we're in display column data mode
                    if (str(sd_searchLettersProtein[i]).equals(str(sd_letter).toUpperCase()) || !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) && mouseX>sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-10+tempPad && mouseX<sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-5+textWidth(sd_searchLettersProtein[i])+tempPad && mouseY>sd_y+1 && mouseY<sd_y+15 ) {
                        fill(colorScheme[currentColorScheme][ i ]);
                        textFont(helvetica18, 11);
                        sd_mouseOverLetter = sd_searchLettersProtein[i];
                        if (mousePressed && !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) ) { 
                            sd_letter = sd_searchLettersProtein[i]; 
                            searchString[currentSearchPanel][sd_indexNumber]=sd_letter;
                        }
                    } else {
                        fill(200);
                        textFont(helvetica18, 10);
                        sd_mouseOverLetter = '\u0000';
                    }
                }

                text(sd_searchLettersProtein[i], sd_x+(sd_w/6*i*1.2)-5+tempPad, sd_y+13);
            }
            //Row 2
            sd_proteinLettersStart = 6;   
            for (int i=sd_proteinLettersStart; i<sd_proteinLettersStart+6; i++) {
                if (!displayColumnData) { // disable if we're in display column data mode
                    if (str(sd_searchLettersProtein[i]).equals(str(sd_letter).toUpperCase()) || !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) && mouseX>sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-10+tempPad && mouseX<sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-5+textWidth(sd_searchLettersProtein[i])+tempPad && mouseY>sd_y+11 && mouseY<sd_y+25 ) {
                        fill(colorScheme[currentColorScheme][ i ]);
                        textFont(helvetica18, 11);
                        sd_mouseOverLetter = sd_searchLettersProtein[i];
                        if (mousePressed && !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) ) { 
                            sd_letter = sd_searchLettersProtein[i]; 
                            searchString[currentSearchPanel][sd_indexNumber]=sd_letter;
                        }
                    } else {
                        fill(200);
                        textFont(helvetica18, 10);
                        sd_mouseOverLetter = '\u0000';
                    }
                }

                text(sd_searchLettersProtein[i], sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-5+tempPad, sd_y+23);
            }      

            //Row 3
            sd_proteinLettersStart = 12;   
            for (int i=sd_proteinLettersStart; i<sd_proteinLettersStart+6; i++) {
                if (!displayColumnData) { // disable if we're in display column data mode
                    if (str(sd_searchLettersProtein[i]).equals(str(sd_letter).toUpperCase()) || !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) && mouseX>sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-10+tempPad && mouseX<sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-5+textWidth(sd_searchLettersProtein[i])+tempPad && mouseY>sd_y+21 && mouseY<sd_y+35 ) {
                        fill(colorScheme[currentColorScheme][ i ]);
                        textFont(helvetica18, 11);
                        sd_mouseOverLetter = sd_searchLettersProtein[i];
                        if (mousePressed && !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) ) { 
                            sd_letter = sd_searchLettersProtein[i]; 
                            searchString[currentSearchPanel][sd_indexNumber]=sd_letter;
                        }
                    } else {
                        fill(200);
                        textFont(helvetica18, 10);
                        sd_mouseOverLetter = '\u0000';
                    }
                }

                text(sd_searchLettersProtein[i], sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-5+tempPad, sd_y+33);
            }      

            //Row 4
            sd_proteinLettersStart = 18;   
            for (int i=sd_proteinLettersStart; i < sd_searchLettersProtein.length; i++) { // go to the end
                if (!displayColumnData) { // disable if we're in display column data mode
                    if (str(sd_searchLettersProtein[i]).equals(str(sd_letter).toUpperCase()) || !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) && mouseX>sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-10+(tempPad*2) && mouseX<sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-5+textWidth(sd_searchLettersProtein[i])+(tempPad*2) && mouseY>sd_y+31 && mouseY<sd_y+45 ) {
                        fill(colorScheme[currentColorScheme][ i ]);
                        textFont(helvetica18, 11);
                        sd_mouseOverLetter = sd_searchLettersProtein[i];
                        if (mousePressed && !buttonLock.equals("searchDigitControlBar"+sd_indexNumber) ) { 
                            sd_letter = sd_searchLettersProtein[i]; 
                            searchString[currentSearchPanel][sd_indexNumber]=sd_letter;
                        }
                    } else {
                        fill(200);
                        textFont(helvetica18, 10);
                        sd_mouseOverLetter = '\u0000';
                    }
                }
                text(sd_searchLettersProtein[i], sd_x+(sd_w/6*(i-sd_proteinLettersStart)*1.2)-5+(tempPad*2), sd_y+43);
            }      


            /*
            if (myMousePressed && searchValue[currentSearchPanel][sd_indexNumber]== 0 && sd_letter !="*" && sd_letter !="-") { ///* used to be "N"
             searchValue[currentSearchPanel][sd_indexNumber]=4.32;
             } */
        }
    }
}
///////////////// Alex is cool /////////////////////////////////////// Alex is cool //////////////////////

// This file has mouse and keyboard event function
// Authors: Jamie, Asher, Nick.
// Data: 2014
// File: GSEvents.pde

// This function takes care of sliding sequence.
// These are all mutally exclusive event. Hence the use of 'else if'
void slideSeq() {

    // This section controlls the scquence scrolling.
    int increment = dynamicButtonIncrement();    // Number of digits to increase or decrease  

    // If mouse is pressed over scroll right button
    if (triButton_scrollRight.press()) {
        if (endDigit < numNucleotides - increment) {
            startDigit += increment;
            endDigit += increment;
        } else if (endDigit < numNucleotides - 1) {
            startDigit += 1;
            endDigit += 1;
        } else {
        }
    }
    // If mouse is pressed over left scroll button
    else if (triButton_scrollLeft.press()) {
        if (startDigit > increment) {
            startDigit -= increment;
            endDigit -= increment;
        } else if (startDigit >= 1) {
            startDigit -= 1;
            endDigit -=1;
        } else {
        }
    }       
    // If mouse is over slider start decrease button
    else if (triButton_sliderStartDecrease.press()) {
        if (startDigit > increment) {
            startDigit -= increment;
        } else if (startDigit >= 1) {
            startDigit -= 1;
        } else {
        }
    }    
    // If mouse is over slider start increase button
    else if (triButton_sliderStartIncrease.press()) {
        if (startDigit < endDigit - increment) {
            startDigit += increment;
        } else if (startDigit < endDigit - 2) {
            startDigit += 1;
        } else {
        }
    }    
    // If mouse is over slider end decrease button
    else if (triButton_sliderEndDecrease.press()) {
        if (endDigit > startDigit + increment) {
            endDigit -= increment;
        } else if ( endDigit > startDigit + 2) {
            endDigit -= 1;
        } else {
        }
    }    
    // If mouse is over slider end increase button
    else if (triButton_sliderEndIncrease.press()) {
        if (endDigit < numNucleotides - increment) {
            endDigit += increment;
        } else if (endDigit < numNucleotides - 1) {
            endDigit += 1;
        } else {
        }
    }    
    // Advance to start
    else if (triButton_jumpToStart.press()) {
        startDigit = 0;
    }   
    // Advance to End
    else if (triButton_jumpToEnd.press()) {
        endDigit = numNucleotides;
    }    
    ////-Button-//////// Slider Bar  - Click to reset rectangle to that area ////////-Button
    else if (mouseLockScroll == false && mouseLockZoomLeft == false && mouseLockZoomRight == false) { 
        if ( (mouseY < sliderBarPaddingFromTop+20 && mouseY > sliderBarPaddingFromTop-20) && !(( (mouseX > sliderRectStart-15 && mouseX < sliderRectStart+2) && (mouseY > sliderBarPaddingFromTop-15 && mouseY < sliderBarPaddingFromTop+5)) || ((mouseX > sliderRectEnd-2 && mouseX < sliderRectEnd+15) && (mouseY > sliderBarPaddingFromTop-15 && mouseY < sliderBarPaddingFromTop+5)) )) {
            int displayDigitHowMany = endDigit - startDigit;
            // if resetting position wouldn't push the start or end past the edge
            if ( (int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))-int(displayDigitHowMany/2)) > 0
                && (int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))-int(displayDigitHowMany/2)) + displayDigitHowMany < numNucleotides ) {
                startDigit = int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))-int(displayDigitHowMany/2);
                endDigit = startDigit + displayDigitHowMany;
            } else if ((int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))-int(displayDigitHowMany/2)) < 0 ) {
                startDigit = 0;
                endDigit = startDigit + displayDigitHowMany;
            } else if ( (int(map( mouseX, sliderBarPaddingFromSide, canvasWidth-sliderBarPaddingFromSide, 0, numNucleotides))-int(displayDigitHowMany/2)) + displayDigitHowMany > numNucleotides  ) {
                endDigit = numNucleotides;
                startDigit = endDigit - displayDigitHowMany;
            } else {
            }
        }
    } else {
    }
}

// This function is for zooming sequence using Round Button
void zoomSeq() {
    int increment = dynamicButtonIncrement();    // Number of digits to increase or decrease 

    // Zoom into sequence when the user press show more round button
    if (roundButton_showMore.press()) {
        if (startDigit > increment) {
            startDigit -= increment;
        } else if (startDigit >= 1 ) {
            startDigit -= 1;
        } else {
        }

        if (endDigit < numNucleotides - increment) {
            endDigit += increment;
        } else if (endDigit < numNucleotides) {
            endDigit += 1;
        } else {
        }
    }       
    // Zoom out of sequence when the user presses show less round button
    else if (roundButton_showLess.press()) {
        if ( (startDigit < endDigit - increment - 1) && (endDigit > startDigit + increment + 1)) {
            endDigit -= increment;
            startDigit += increment;
        } else if ( (startDigit < endDigit - 2) && (endDigit > startDigit + 2)) {
            endDigit -= 1;
            startDigit += 1;
        } else {
        }
    } 
    // Show the entire sequence
    else if (roundButton_showAll.press()) {
        endDigit = numNucleotides;
        startDigit = 0;
    } 
    // Zoom Way in. Recover from show entire sequence
    else if (roundButton_zoomWayIn.press()) {
        endDigit = int((startDigit + endDigit) / 2) + 10;
        startDigit = int((startDigit + endDigit) / 2) - 10;
    } else {
    }
}

void rectPressed() {
    if (rectButton_font.press()) {
        currentFont += 1;
        if (currentFont > 2) {
            currentFont = 0;
        }
        fontHeightAdjustor();
        mousePressed = false;
    } else if (rectButton_colorScheme.press()) {
        currentColorScheme++;
        if (currentColorScheme > colorScheme.length-1) { 
            currentColorScheme=0;
        }

        if (DNA == true && currentColorScheme == 2) { 
            currentColorScheme=3;
        } //skip the protein color scheme
        else if (DNA == false && currentColorScheme < 2) { 
            currentColorScheme=2;
        } //skip the dna color schemes
        mousePressed = false;
    } else if (rectButton_alignmentCount.press()) {
        alignmentCountIndicator = !alignmentCountIndicator;
        mousePressed = false;
    } else if (rectButton_bitscore.press()) {
        showWeightedBitScore = !showWeightedBitScore;
        noLoop();
        for (int i=0; i < horizontalBar.pixels.length; i++) {
            horizontalBar.pixels[i] = #FFFFFF;
        }
        horizontalBar.updatePixels();
        dataLoader();
        loop();
        mousePressed = false;
    } else if (rectButton_share.press()) {
        String query = getQuery();
        println("Access this view directly using the following link:\n\nhttp://bar.utoronto.ca/geneslider/?datasource=" + source + "&cistome=" + cistome + "&agi=" + agi + "&before=" + before + "&after=" + after + "&zoom_from=" + startDigit + "&zoom_to=" + endDigit
            + "&weightedBitscore=" + showWeightedBitScore + "&alnIndicator=" + alignmentCountIndicator + query);
        mousePressed = false;
    } else if (rectButton_regulome.press()) {
        int start = startDigit + alnStart;
        int end = endDigit + alnStart;
        String url = "https://genome.htseq.org/~plantregulome/cgi-bin/hgTracks?db=TAIR9&position=Chr" + agi.charAt(2) + "%3A" + start + "-" + end + "&pix=896";
        window.open(url, "Regulome", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=1000, height=400");
        mousePressed = false;
    } else if (rectButton_legend.press()) {
        displayLegend = !displayLegend;
        mousePressed = false;
    } else if (rectButton_screenGrab.press()) {
        saveScreenGrab();
        mousePressed = false;
    }
}

void checkBoxPressed() {
    for (int i = 0; i < 6; i++) {
        if (checkBoxes[i].press()) {
            currentSearchPanel = i;
        }
    }
}

// Search panel buttons are pressed
void searchPanelButtons() {

    // Open of close search panel
    if (roundButton_searchPanel.press()) {
        searchPanelOpen = !searchPanelOpen;
        mousePressed = false;
    }

    // Cancel search
    if (roundButton_cancelSearch.press()) {
        searchPanelText[currentSearchPanel] = "";        
        checkBoxOn[currentSearchPanel] = false;
        for (int i=0; i<8; i++) {
            searchValue[currentSearchPanel][i] = 0;
            searchString[currentSearchPanel][i] = ' ';
            if (DNA) {
                searchDigit[currentSearchPanel][i].sd_letter = 'N';
            } else {
                searchDigit[currentSearchPanel][i].sd_letter = '*';
            }
        }
        for (int k=0; k<numNucleotides; k++) {
            searchMotifText[currentSearchPanel][k] = "";
            searchMotifStart[currentSearchPanel][k] = 0;
            searchMotifEnd[currentSearchPanel][k] = 0;
        }
        mousePressed = false;
    }

    // Update search
    if (roundButton_textEnter.press()) {
        updateSearchResults();
        mousePressed = false;
    }

    // Backspace button
    if (roundButton_backspace.press()) {
        if (searchPanelText[currentSearchPanel].length()>0 ) {
            searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel].substring(0, searchPanelText[currentSearchPanel].length()-1);      
            /// remove the last search slider
            int lastSlider = 0;
            for (int i=0; i<8; i++) {
                if (searchValue[currentSearchPanel][i] > 0) {
                    lastSlider = i;
                }
            }
            for (int i=lastSlider; i<8; i++) {
                searchValue[currentSearchPanel][i] = 0;
                searchString[currentSearchPanel][i] = ' ';
                if (DNA) {
                    searchDigit[currentSearchPanel][i].sd_letter = 'N';
                } else {
                    searchDigit[currentSearchPanel][i].sd_letter = '*';
                }
            } 

            /// if text box is now empty, clear all search results
            if (searchPanelText[currentSearchPanel].equals("")) { 
                checkBoxOn[currentSearchPanel] = false;
                for (int i=0; i<8; i++) {
                    searchValue[currentSearchPanel][i] = 0;
                    searchString[currentSearchPanel][i] = ' ';
                    if (DNA) {
                        searchDigit[currentSearchPanel][i].sd_letter = 'N';
                    } else {
                        searchDigit[currentSearchPanel][i].sd_letter = '*';
                    }
                }

                for (int k=0; k<numNucleotides; k++) {
                    searchMotifText[currentSearchPanel][k] = "";
                    searchMotifStart[currentSearchPanel][k] = -1;
                    searchMotifEnd[currentSearchPanel][k] = -1; 
                    digit[k].digitBackgroundColor[currentSearchPanel] = 0;
                }
            }
        }  
        updateSearchResults();
        mousePressed = false;
    }
}

// Column is clicked
void columnPressed() {
    if (gsStatus >= 2) {
        if (displayColumnData && triButton_displayColumnFastRight.press()) {
            displayColumn++;
            columnDataStart = 0;
            if (displayColumn > numNucleotides-1) {
                displayColumn = numNucleotides-1;
            }
            if (displayColumn > endDigit) {
                startDigit++;
                endDigit++;
                if (endDigit > numNucleotides) {
                    endDigit = numNucleotides;
                    startDigit = numNucleotides - (endDigit - startDigit);
                }
            }
        } else if (displayColumnData && triButton_displayColumnFastLeft.press()) {
            displayColumn--;
            columnDataStart = 0;
            if (displayColumn < 0) {
                displayColumn = 0;
            }
            if (displayColumn < startDigit) {
                startDigit--;
                endDigit--;
                if (startDigit < 0) {
                    startDigit = 0;
                    endDigit = startDigit + (endDigit - startDigit);
                }
            }
        } else if (displayColumnData && triButton_displayColumnRight.press()) {
            displayColumn++;
            columnDataStart = 0;
            if (displayColumn > numNucleotides-1) {
                displayColumn = numNucleotides-1;
            }
            if (displayColumn > endDigit) {
                startDigit++;
                endDigit++;
                if (endDigit > numNucleotides) {
                    endDigit = numNucleotides;
                    startDigit = numNucleotides - (endDigit - startDigit);
                }
            }
            mousePressed = false;
        }

        /// left button
        else if (displayColumnData && triButton_displayColumnLeft.press()) {
            displayColumn--;
            columnDataStart = 0;
            if (displayColumn < 0) {
                displayColumn = 0;
            }
            if (displayColumn < startDigit) {
                startDigit--;
                endDigit--;
                if (startDigit < 0) {
                    startDigit = 0;
                    endDigit = startDigit + (endDigit - startDigit);
                }
            }
            mousePressed = false;
        }
        /// if display column mode is on, and mouse is outside display window, and the left/right buttons aren't pressed, begin fade out
        else if (displayColumnData && (mouseX < width/2-140 || mouseX > width/2+140) ) {
            displayColumnFadeStatus = "fadeOut";
        } else {
            for (int i=startDigit; i < startDigit + (endDigit - startDigit) + 1; i++) {
                i = constrain(i, 0, numNucleotides);
                if (i > numNucleotides - 1) {
                    break;
                }
                /// click on a digit to open the column data view
                if (displayColumnData == false && digit[i].d_mouseOverFlag) {
                    displayColumnData = true;
                    displayColumnFadeStatus = "fadeIn";
                    columnDataStart = 0;
                    displayColumn = i;
                    mousePressed = false;
                    //update global columnData string with that digit's value
                    //digit[displayColumn].d_updateColumnData();
                }
            }
        }
    }
}

// File: GSFunctions.pde
// This function intialize the GUI
void initializeGUI() {
    // Variabales for Triangle Buttons: These describe the location and size of triangle buttons
    int homeTriangleButtonHeight = 30;
    int homeTriangleButtonWidth = 18;
    int homeTriangleButtonDistanceFromTop = 45;
    int homeTriangleButtonPaddingFromSide = 40;
    int scrollTriangleButtonHeight = 50;
    int scrollTriangleButtonWidth = 30;
    int scrollTriangleButtonDistanceFromTop = 55;
    int scrollTriangleButtonPaddingFromSide = 60;
    int sliderTriangleButtonHeight = 20;
    int sliderTriangleButtonWidth = 14;
    int sliderTriangleButtonDistanceFromTop = 40;
    int sliderTriangleButtonPaddingFromSide = 125;

    // These variables are for Round buttons
    int roundButtonDistanceFromTop = 35;
    int roundButtonShowLessXPosition = 812;
    int roundButtonShowMoreXPosition = 190;
    int roundButtonSearchPanelX = 250;
    int roundButtonSearchPanelY = 36;
    int roundButtonCancelSearchY = 30 + 35;
    int roundButtonZoomOutX = 155;
    int roundButtonZoomInX = 1000-roundButtonZoomOutX;
    int roundButtonZoomOutY = 55;
    int roundButtonBackspaceX = 700;
    int roundButtonTextEnterX = 730;

    // Variables for Rectangle Button
    int rectButtonScreenGrabXPosition = 5;
    int rectButtonFontXPosition = 95;
    int rectButtonColorSchemeXPosition = 140;
    int rectButtonAlignmentCountXPosition = 190;
    int rectButtonBitScoreXPosition = 295;
    int rectButtonShareXPosition = 400;
    int rectButtonRegulomeXPosition = 455;
    int rectButtonLegendXPosition = 575;
    int rectButtonBottomRow = 480;

    // Variables for checkboxes
    int checkBoxXPos = 237;
    int checkBoxYPos = 90 + 35;
    int checkBoxLineHeight = 15;
    int checkBoxSquareSize = 12;

    // Variables for columns data
    int columnDataButtonHeight = 70; 
    int columnDataButtonWidth = 25;
    int columnDataDistanceFromTop = 215;
    int columnDataPaddingFromSide = 350;
    int columnDataFastForwardPaddingFromButton = 35;

    //Initialze Triangle Buttons
    triButton_scrollLeft          = new TriangleButton(scrollTriangleButtonPaddingFromSide+scrollTriangleButtonWidth, scrollTriangleButtonDistanceFromTop, -scrollTriangleButtonWidth, scrollTriangleButtonHeight, "Scroll Left");
    triButton_scrollRight         = new TriangleButton(width-scrollTriangleButtonWidth-scrollTriangleButtonPaddingFromSide, scrollTriangleButtonDistanceFromTop, scrollTriangleButtonWidth, scrollTriangleButtonHeight, "Scroll Right");
    triButton_sliderStartIncrease = new TriangleButton(sliderTriangleButtonPaddingFromSide+10, sliderTriangleButtonDistanceFromTop, sliderTriangleButtonWidth, sliderTriangleButtonHeight, "Adjust in-point: Increase");
    triButton_sliderStartDecrease = new TriangleButton(sliderTriangleButtonPaddingFromSide, sliderTriangleButtonDistanceFromTop, -sliderTriangleButtonWidth, sliderTriangleButtonHeight, "Adjust in-point: Decrease");
    triButton_sliderEndIncrease   = new TriangleButton(width-sliderTriangleButtonPaddingFromSide, sliderTriangleButtonDistanceFromTop, sliderTriangleButtonWidth, sliderTriangleButtonHeight, "Adjust out-point: Increase");
    triButton_sliderEndDecrease   = new TriangleButton(width-sliderTriangleButtonPaddingFromSide-10, sliderTriangleButtonDistanceFromTop, -sliderTriangleButtonWidth, sliderTriangleButtonHeight, "Adjust out-point: Decrease");
    triButton_jumpToStart         = new TriangleButton(homeTriangleButtonPaddingFromSide, homeTriangleButtonDistanceFromTop, -homeTriangleButtonWidth, homeTriangleButtonHeight, "Move in-point to start");
    triButton_jumpToEnd           = new TriangleButton(width-homeTriangleButtonPaddingFromSide, homeTriangleButtonDistanceFromTop, homeTriangleButtonWidth, homeTriangleButtonHeight, "Move out-point to end");
    triButton_displayColumnLeft   = new TriangleButton(columnDataPaddingFromSide, columnDataDistanceFromTop, -columnDataButtonWidth, columnDataButtonHeight, "Move inspector left");
    triButton_displayColumnRight  = new TriangleButton(canvasWidth-columnDataPaddingFromSide, columnDataDistanceFromTop, columnDataButtonWidth, columnDataButtonHeight, "Move inspector right");
    triButton_displayColumnFastLeft   = new TriangleButton(columnDataPaddingFromSide-columnDataFastForwardPaddingFromButton, columnDataDistanceFromTop-columnDataButtonHeight/4, -columnDataButtonWidth/2, columnDataButtonHeight/2, "Move inspector left... fast");
    triButton_displayColumnFastRight  = new TriangleButton(canvasWidth-columnDataPaddingFromSide+columnDataFastForwardPaddingFromButton, columnDataDistanceFromTop-columnDataButtonHeight/4, columnDataButtonWidth/2, columnDataButtonHeight/2, "Move inspector right... fast");

    // Initialize Round Button
    roundButton_searchPanel   = new RoundButton(roundButtonSearchPanelX, roundButtonSearchPanelY, "", "searchPanel", "Use the sliders in this panel to enter a Seq Logo query. \nGene Slider will automatically find matching regions.");
    roundButton_cancelSearch      = new RoundButton(roundButtonSearchPanelX, roundButtonCancelSearchY, "", "cancelSearch", "Click here to reset the sliders in this search panel.");
    roundButton_showAll           = new RoundButton(roundButtonZoomOutX, roundButtonZoomOutY, "↩", "showAll", "Zoom out all the way to show entire gene.");
    roundButton_zoomWayIn         = new RoundButton(roundButtonZoomInX, roundButtonZoomOutY, "↪", "zoomWayIn", "Zoom in... fast.");
    roundButton_showMore          = new RoundButton(roundButtonShowMoreXPosition, roundButtonDistanceFromTop, "-", "showMore", "Zoom out");
    roundButton_showLess          = new RoundButton(roundButtonShowLessXPosition, roundButtonDistanceFromTop, "+", "showLess", "Zoom in");
    roundButton_textEnter         = new RoundButton(roundButtonTextEnterX, roundButtonSearchPanelY, "✓", "textEnter", "Store text label.\n\nGene Slider accepts the following IUPAC codes:\n • X/N for A or C or T or G\n • Y for C or T\n • R for A or G");
    roundButton_backspace         = new RoundButton(roundButtonBackspaceX, roundButtonSearchPanelY, "←", "backspace", "Delete the last character.");

    // Rectangle Button
    rectButton_screenGrab         = new RectButton(rectButtonScreenGrabXPosition, rectButtonBottomRow, "Screen Grab", "Save a hi-res image of this screen");
    rectButton_font               = new RectButton(rectButtonFontXPosition, rectButtonBottomRow, "Font", "Cycle through available fonts");
    rectButton_colorScheme        = new RectButton(rectButtonColorSchemeXPosition, rectButtonBottomRow, "Color", "Cycle through available color schemes");
    rectButton_alignmentCount     = new RectButton(rectButtonAlignmentCountXPosition, rectButtonBottomRow, "Indicator mode", "How many genes are aligned in this column? \nToggle between line indicator and saturation views.");
    rectButton_bitscore           = new RectButton(rectButtonBitScoreXPosition, rectButtonBottomRow, "Bit Score mode", "Scale height according to weighted or normal bitscore.");
    rectButton_share              = new RectButton(rectButtonShareXPosition, rectButtonBottomRow, "Share", "Share link");
    rectButton_regulome           = new RectButton(rectButtonRegulomeXPosition, rectButtonBottomRow, "Link to Regulome", "Open a new window showing Regulome data");
    rectButton_legend             = new RectButton(rectButtonLegendXPosition, rectButtonBottomRow, "Legend", "Shows legends");

    // Checkboxes
    checkBoxes[0] = new CheckBox( checkBoxXPos, checkBoxYPos-((2)*checkBoxLineHeight), checkBoxSquareSize, checkBoxSquareSize, digitBackground[1], checkBoxOn[0], 0, "Search panel 1" );
    checkBoxes[1] = new CheckBox( checkBoxXPos+checkBoxLineHeight, checkBoxYPos-((2)*checkBoxLineHeight), checkBoxSquareSize, checkBoxSquareSize, digitBackground[2], checkBoxOn[1], 1, "Search panel 2" );
    checkBoxes[2] = new CheckBox( checkBoxXPos, checkBoxYPos-((1)*checkBoxLineHeight), checkBoxSquareSize, checkBoxSquareSize, digitBackground[3], checkBoxOn[2], 2, "Search panel 3" );
    checkBoxes[3] = new CheckBox( checkBoxXPos+checkBoxLineHeight, checkBoxYPos-((1)*checkBoxLineHeight), checkBoxSquareSize, checkBoxSquareSize, digitBackground[4], checkBoxOn[3], 3, "Search panel 4" );
    checkBoxes[4] = new CheckBox( checkBoxXPos, checkBoxYPos-((0)*checkBoxLineHeight), checkBoxSquareSize, checkBoxSquareSize, digitBackground[5], checkBoxOn[4], 4, "Search panel 5" );
    checkBoxes[5] = new CheckBox( checkBoxXPos+checkBoxLineHeight, checkBoxYPos-((0)*checkBoxLineHeight), checkBoxSquareSize, checkBoxSquareSize, digitBackground[6], checkBoxOn[5], 5, "Search panel 6" );

    // Search Digits
    searchDigit = new SearchDigit[6][8];
    for (int k=0; k<6; k++) {
        for (int i=0; i<8; i++) {
            searchDigit[k][i] = new SearchDigit(i, "Adjust sliders and select a letter to tailor your search query.");
        }
    }

    // Horizontal Bar
    horizontalBar = createImage(horizontalBarWidth, horizontalBarHeight, RGB);
    horizontalBar.loadPixels();
    for (int i=0; i < horizontalBar.pixels.length; i++) {
        horizontalBar.pixels[i] = #FFFFFF;
    }
    horizontalBar.updatePixels();
}

// This function Draws the GUI
void drawGUI() {
    // These varaiables are required the draw the lines next to some Triangle buttons
    int homeTriangleButtonHeight = 30;
    int homeTriangleButtonWidth = 18;
    int homeTriangleButtonDistanceFromTop = 45;
    int homeTriangleButtonPaddingFromSide = 40;
    int rectButtonBottomRow = 480; 

    // Reset Rectangle button data for gff pannel
    if (gffPanelOpen) {
        rectButtonBottomRow = 580;
        // Set data
        rectButton_screenGrab.yPosRB = rectButtonBottomRow;
        rectButton_font.yPosRB = rectButtonBottomRow;
        rectButton_colorScheme.yPosRB = rectButtonBottomRow;
        rectButton_alignmentCount.yPosRB = rectButtonBottomRow;
        rectButton_bitscore.yPosRB = rectButtonBottomRow;
        rectButton_share.yPosRB = rectButtonBottomRow;
        rectButton_regulome.yPosRB = rectButtonBottomRow;
        rectButton_legend.yPosRB = rectButtonBottomRow;
    } else {
        rectButtonBottomRow = 480;
        // Set data
        rectButton_font.yPosRB = rectButtonBottomRow;
        rectButton_colorScheme.yPosRB = rectButtonBottomRow;
        rectButton_alignmentCount.yPosRB = rectButtonBottomRow;
        rectButton_bitscore.yPosRB = rectButtonBottomRow;
        rectButton_share.yPosRB = rectButtonBottomRow;
        rectButton_regulome.yPosRB = rectButtonBottomRow;
        rectButton_legend.yPosRB = rectButtonBottomRow;
    }        

    // Draw the Triangles
    strokeWeight(1);    
    stroke(#AAAAAA);
    line(homeTriangleButtonPaddingFromSide-homeTriangleButtonWidth, homeTriangleButtonDistanceFromTop, homeTriangleButtonPaddingFromSide-homeTriangleButtonWidth, homeTriangleButtonDistanceFromTop-homeTriangleButtonHeight);
    triButton_jumpToStart.display();

    //triangle buttons
    triButton_scrollLeft.display();    // scroll left
    triButton_scrollRight.display();    // scroll right
    triButton_sliderStartDecrease.display();    // slider start decrease
    triButton_sliderStartIncrease.display();    // slider start increase
    triButton_sliderEndDecrease.display();    // slider end descrease
    triButton_sliderEndIncrease.display();    // slider end increase

    //triangle button: advance to end
    strokeWeight(1);
    stroke(#AAAAAA);
    line(width-homeTriangleButtonPaddingFromSide+homeTriangleButtonWidth, homeTriangleButtonDistanceFromTop, width-homeTriangleButtonPaddingFromSide+homeTriangleButtonWidth, homeTriangleButtonDistanceFromTop-homeTriangleButtonHeight);
    triButton_jumpToEnd.display();

    // Draw the Round Buttons
    roundButton_showMore.display("in");    // Show More
    roundButton_showLess.display("out");    // Show Less
    roundButton_showAll.display("");    // Show All
    roundButton_zoomWayIn.display("");    // Zoom In
    roundButton_searchPanel.display("");    // Magnifying Glass
    //roundButton_cancelSearch.display("");    // Cancel Search

    // Draw the Rectangle Buttons
    if (!screenGrabMode) {
        rectButton_screenGrab.display();
        rectButton_font.display();
        rectButton_colorScheme.display();
        rectButton_alignmentCount.display();
        rectButton_bitscore.display();
        if (gffPanelOpen) {
            rectButton_share.display();
            rectButton_regulome.display();
            rectButton_legend.display();
        }
    }
}

// Reset all data
void resetData() {
    agi = "AT0G00000";
    gsStatus = 1;
    fastaData = "";
    startDigit = 0;
    endDigit = 30;
    alnStart = 0;    // Start of the sequence relative the AT
    currentColorScheme = 0;
    alignmentCountIndicator = false;
    showWeightedBitScore = true;
    gffPanelOpen = false;

    currentFont = 0;
    searchPanelOpen = false;
    currentSearchPanel=0;
    fastaHeaders = new String[0];

    searchString = new char[6][8];
    searchValue = new float[6][8];
    searchOffset = new int[6];
    numSearchColumns = new int[6];

    String[] searchPanelText = { 
        "", "", "", "", "", ""
    };
    for (int i = 0; i < 6; i++) {
        checkBoxOn[i] = false;
    }

    searchDigit = new SearchDigit[6][8];
    for (int k=0; k<6; k++) {
        for (int i=0; i<8; i++) {
            searchDigit[k][i] = new SearchDigit(i, "Adjust sliders and select a letter to tailor your search query.");
        }
    }

    fastaHeaders = new String[0];

    // Search motif data
    searchMotifText = new String[0][0];
    searchMotifStart = new int[0][0];
    searchMotifEnd = new int[0][0];

    displayColumnData = false;
    displayColumnFadeStatus = "fadeOut";
    displayColumnFadeValue = 0;
    displayColumn = 0;
    columnDataStart = 0;
    columnDataDisplayHowMany = 27;
    numLines = 0;
    linesDisplayed = 0;

    numNucleotides = 0;        // The number of Nucleotides or Amino acids in a single alignment
    numSequences = 0;        // The number of Sequences in a single alignment
    digit = new Digit[0];            // This is a a single position of the alignment

    horizontalBar = createImage(horizontalBarWidth, horizontalBarHeight, RGB);
    horizontalBar.loadPixels();
    for (int i=0; i < horizontalBar.pixels.length; i++) {
        horizontalBar.pixels[i] = #FFFFFF;
    }
    horizontalBar.updatePixels();

    DNA = true;

    motifs.clear();    // Hashmap to store motifs and their colors
    motifCounter = 0;    // Counter to pick colors    
    displayLegend = false;
    motifOffset = 0;    // Y offset to avoid overlapping motifs
    motifEnd = 0;    // When to off set
    motifStart = 0;    // When to offset
}

// Show Introduction
void displayIntro() {
    String[] msg = {    
        "Jamie Waese, Asher Pasha, David Guttman\n& Nicholas Provart\nUniversity of Toronto\n\nVersion 2.0", 
        "Gene Slider visualizes conservation and\n entropy of orthologous DNA and Protein sequences.", 
        "Use it to create one long sequence logo that\n you can zoom in and out of.", 
        "Search for motifs that are hard\n to identify due to wobble and other factors.", 
        "Gene Slider can display\nDNA and Protein FASTA files.", 
        "View conservation of GFF\nand JASPAR motifs.",
    };

    if (frameCount < 300) {
        displayMessage("Gene Slider", msg[0], 255);
    } else if (frameCount < 600) {
        displayMessage("Enter some data to get started.", msg[1], 255);
    } else if (frameCount < 900) {
        displayMessage("Enter some data to get started.", msg[2], 255);
    } else if (frameCount < 1200) {
        displayMessage("Enter some data to get started.", msg[3], 255);
    } else if (frameCount < 1800) {
        displayMessage("Enter some data to get started.", msg[4], 255);
    } else if (frameCount < 2100) {
        displayMessage("Enter some data to get started.", msg[5], 255);
    } else {
        frameCount = 101;
    }
    pointer(750, 2);
}

void pointer (float pointerX, float pointerY) {
    int fade = 255;

    float scaleFactor;
    stroke(#99CC00, fade);
    strokeWeight(3);
    fill(#99CC00, fade);

    ////// compute bouncing up/down position
    float bounceY = 20 + (10 * sin( radians(bounce) ));
    bounce += 1;  

    ////// if a new load, grow vine slowly
    if (bounce < 50) {
        pointerX = canvasWidth/2+152 + map(bounce, 0, 50, 0, pointerX-(canvasWidth/2)-152);
        pointerY =canvasHeight/2 - map(bounce, 0, 50, 0, canvasHeight/2);
        scaleFactor = map(bounce, 0, 50, 0, 30);
    } else {
        scaleFactor = 30;
    }

    ///// big leaf
    beginShape();
    //point
    curveVertex(pointerX-scaleFactor*4, pointerY+scaleFactor+bounceY/2+10);
    curveVertex(pointerX-scaleFactor*4, pointerY+scaleFactor+bounceY/2+10);
    //top curve
    curveVertex(pointerX-15-scaleFactor, pointerY+scaleFactor+bounceY+5);
    curveVertex(pointerX-5, pointerY+scaleFactor+bounceY+25);
    //base
    curveVertex(pointerX, pointerY+scaleFactor+bounceY+75);
    //bottom curve
    curveVertex(pointerX-20-scaleFactor, pointerY+scaleFactor+bounceY+80);
    curveVertex(pointerX-5-(3*scaleFactor), pointerY+scaleFactor+bounceY+20);
    //point
    curveVertex(pointerX-scaleFactor*4, pointerY+scaleFactor+bounceY/2+10);
    curveVertex(pointerX-scaleFactor*4, pointerY+scaleFactor+bounceY/2+10);
    endShape();

    float scaleFactor2 = 65;
    ///// if the stem has fully grown, grow small leaf
    if (bounce>50 && bounce< 90) {
        scaleFactor2 = map(bounce, 50, 90, 0, 65);
    }
    if (bounce>50) {

        ///// small leaf    
        beginShape();
        //point
        curveVertex(pointerX+10+(scaleFactor2), pointerY-scaleFactor2/2+bounceY/2+170);
        curveVertex(pointerX+10+(scaleFactor2), pointerY-scaleFactor2/2+bounceY/2+170);
        //top curve
        curveVertex(pointerX+(scaleFactor2/2)+5, pointerY-scaleFactor2+bounceY+200);
        //base
        curveVertex(pointerX+8, pointerY+bounceY+170);
        //bottom curve
        curveVertex(pointerX+(scaleFactor2/2), pointerY-scaleFactor2/2+bounceY+210);
        curveVertex(pointerX+(scaleFactor2/2)+22, pointerY-scaleFactor2-(scaleFactor2/2)+bounceY+240);
        //point
        curveVertex(pointerX+10+(scaleFactor2), pointerY-scaleFactor2/2+bounceY/2+170);
        curveVertex(pointerX+10+(scaleFactor2), pointerY-scaleFactor2/2+bounceY/2+170);
        endShape();
    }

    //// vine
    noFill();
    stroke(#99CC00, fade);
    strokeWeight(5);
    beginShape();
    curveVertex(pointerX, pointerY+scaleFactor+bounceY+75);
    curveVertex(pointerX, pointerY+scaleFactor+bounceY+75);
    curveVertex(pointerX, (canvasHeight/2)-10);
    curveVertex(canvasWidth/2+152, (canvasHeight/2)+30);
    curveVertex(canvasWidth/2+152, (canvasHeight/2)+30);
    endShape();

    //// vine (duplicate) to thicken base of line
    noFill();
    strokeWeight(5);
    beginShape();
    curveVertex(pointerX, pointerY+scaleFactor+bounceY+75);
    curveVertex(pointerX, pointerY+scaleFactor+bounceY+75);
    curveVertex(pointerX, (canvasHeight/2)-10);
    curveVertex(canvasWidth/2+152, (canvasHeight/2)+25);
    curveVertex(canvasWidth/2+152, (canvasHeight/2)+25);
    endShape();
}

// Provides a window for displaying messages on screen
// messageText is the Title, and lineTwo is the text
void displayMessage(String messageText, String lineTwo, int fade) {
    color textColor = #333333;
    int offset=0;

    stroke(#99CC00, fade);
    strokeWeight(3);
    fill(255, fade);
    rect(canvasWidth/2-150, canvasHeight/2-100, 300, 200, 10);
    fill(textColor, fade); 
    textAlign(CENTER);
    textFont (helvetica18, 16);
    if (lineTwo != "") { 
        offset = 20;
    }

    // Display second Line
    text(messageText, canvasWidth/2, (canvasHeight/2) - offset); 
    textFont(helvetica18, 12);
    text(lineTwo, canvasWidth/2, (canvasHeight/2) + offset);
}

// DNA or protein
void DNAorProtein(char[][] data) {
    for (int j = 0; j < numSequences - 1; j++) {
        for (int i = 0; i < numNucleotides -1; i++) {
            if (!str(data[i][j]).equals("") && !str(data[i][j]).equals("-") && !str(data[i][j]).toUpperCase().equals("A") && !str(data[i][j]).toUpperCase().equals("N") && !str(data[i][j]).toUpperCase().equals("C") && !str(data[i][j]).toUpperCase().equals("T") && !str(data[i][j]).toUpperCase().equals("U") && !str(data[i][j]).toUpperCase().equals("G") ) {
                DNA = false;
                return;
            }
        }
    }
}

// Count the number of sequences
int getNumSeq(String[] fastaDataLines) {
    int number = 0;
    for (int i = 0; i < fastaDataLines.length; i++) {
        if (fastaDataLines[i].substring(0, 1).equals(">")) {
            number++;
        }
    }
    return number;
}  

// This function will load data into digits
void dataLoader() {
    String[] fastaDataLines;
    if (JS) {
        fastaDataLines = split(fastaData, "\n");    // Split the fasta data in lines
    } else {
        fastaDataLines = loadStrings("test.txt");
    }
    numNucleotides = fastaDataLines[1].length();         // Get the number of DNA/AA letters
    numSequences = getNumSeq(fastaDataLines);            // Get the number of Seqeunces

        fastaHeaders = new String[numSequences];

    // Search motif data
    searchMotifText = new String[6][numNucleotides];
    searchMotifStart = new int[6][numNucleotides];
    searchMotifEnd = new int[6][numNucleotides];

    // Fasta Headers for colun data
    for (int i = 0; i < numSequences; i++) {
        fastaHeaders[i] = fastaDataLines[2 * i].substring(1, fastaDataLines[2 * i].length());
    }

    int k = 0;
    char[][] allFastaData = new char[numNucleotides][numSequences];
    for (int i = 1; i < fastaDataLines.length; i += 2) {
        for (int j = 0; j < numNucleotides; j++) {
            allFastaData[j][k] = fastaDataLines[i].substring(j, j+1).charAt(0);
        }
        k++;
    }

    // DNA or Protein
    DNAorProtein(allFastaData);

    // Load data into digits
    digit = new Digit[numNucleotides];
    for (int i = 0; i < numNucleotides; i++) {
        digit[i] = new Digit(i, allFastaData[i]);
    }
    horizontalBar.updatePixels();

    // Digits are now loaded are ready for action

    // Add positions
    if (gffPanelOpen) {
        addMotifPosition();
    }
}

void constrainDigits() {
    // Constrain digits
    if (endDigit > numNucleotides - 1) {
        endDigit = numNucleotides - 1;
    }

    if (startDigit < 0) {
        startDigit = 0;
    }

    if (startDigit >= endDigit) {
        startDigit = endDigit - 2;
    }
}

void drawDigits() {
    constrainDigits();
    float dampening = 0.75;
    int displayDigitHowMany = endDigit - startDigit;    // How many digits to display
    int incrementMini = 1;    // This is required to skip a few digits
    int increment = 1;
    float digitWidth = ((canvasWidth - 160) / float(displayDigitHowMany));
    float digitHeight = map(displayDigitHowMany, 1, numNucleotides, 80, 12.5);
    if (!DNA) {
        digitHeight /= 2.16;
    }
    float digitWidthMini = (canvasWidth-( (sliderBarPaddingFromSide + 2) *2 ))/float(numNucleotides);
    float digitXMini = sliderBarPaddingFromSide + 2;

    float digitX = 80;
    float digitY = ((canvasHeight/2) + (digitHeight/dampening)) + map(digitHeight, 12, 120, 200, 100) - 150;

    for (int i = 0; i < numNucleotides; i++) {
        if (i >= startDigit && i <= endDigit) {

            // Draw the digit
            pushMatrix();
            textFont(font[currentFont]);
            digit[i].d_display(digitX, digitY, digitWidth, digitHeight);         
            digit[i].d_showNumLettersInColumn();

            popMatrix();
            digitX = digitX + digitWidth;

            // Search search text over the 
            int searchPanelSuperscript = 1;
            //count how many labels this digit has
            for (int k=0; k<6; k++) {
                if (checkBoxOn[k]) { 
                    searchPanelSuperscript++;
                }
            }

            for (int k=5; k>=0; k--) {  // reverse the print order so  taller ones get displayed first
                if (checkBoxOn[k]) { 
                    searchPanelSuperscript--;
                }
                if (searchMotifText[k][i] != "") {
                    //if (searchMotifStart[k][i] > 0) { 
                    //    println(searchMotifStart[k][i]);
                    //}
                    digit[i].d_searchLabel(searchMotifText[k][i], searchMotifStart[k][i], searchMotifEnd[k][i], k, searchPanelSuperscript);
                }
            }
        }
        digit[i].d_searchHighlight(digitXMini, float(sliderBarPaddingFromTop+4));
        digitXMini += digitWidthMini;
    }
    image(horizontalBar, sliderBarPaddingFromSide + 2, sliderBarPaddingFromTop - 15);
}

// This function determines have how many digit to scroll at a time
int dynamicButtonIncrement() {
    int increment = 1;
    if ( (endDigit - startDigit) < 50) {
        increment = 1;
    } else if ( (endDigit - startDigit) < 100) {
        increment = 2;
    } else if ( (endDigit - startDigit) < 300) {
        increment = 4;
    } else if ( (endDigit - startDigit) < 500) {
        increment = 8;
    } else if ( (endDigit - startDigit) < 700) {
        increment = 16;
    } else {
        increment = 30;
    }
    return increment;
}

void fontHeightAdjustor() {
    if (currentFont < 3) {
        fontHeight = fontSize * fontHeightMultiplier[currentFont];
        fontWidth = fontSize * fontHeightMultiplier[currentFont];
    }
}

void drawSliderBar() {
    // Variables
    int displayDigitHowMany = endDigit-startDigit;

    // rectangle representing length of entire gene
    strokeWeight(1);
    textFont (helvetica18, 12);
    stroke(220);
    fill(245, 0);
    rect(sliderBarPaddingFromSide, sliderBarPaddingFromTop-15, canvasWidth-(sliderBarPaddingFromSide*2), 20, 10);

    // small rounded rectangle slider   
    stroke(#BBBBBB);
    strokeWeight(2);
    rectMode(CORNERS); //adjust rectMode so 3rd and 4th parameters aren't relative to 1st and 2nd parameters
    // Start and end of the small rectangle
    sliderRectStart = map(startDigit, 0, numNucleotides, sliderBarPaddingFromSide, canvasWidth - sliderBarPaddingFromSide);
    sliderRectEnd = map(endDigit + 1, 0, numNucleotides, sliderBarPaddingFromSide, canvasWidth - sliderBarPaddingFromSide); //added +2 to make it more responsive

        // Rectangle for annotation
    if (gffPanelOpen) {
        fill(242, 120);
        noStroke();
        rect(sliderRectStart, sliderBarPaddingFromTop + 5, sliderRectEnd, sliderBarPaddingFromTop + 120);
    }
    stroke(#BBBBBB);
    strokeWeight(2);

    // Fill Color of small rectangle
    if ( (mouseX > sliderRectStart+3 && mouseX < sliderRectEnd-3) && (mouseY > sliderBarPaddingFromTop-15 && mouseY < sliderBarPaddingFromTop+10)) {
        fill(60);
    } else {
        fill(245, 255);
    }
    rect(sliderRectStart, sliderBarPaddingFromTop-18, sliderRectEnd, sliderBarPaddingFromTop+9, 10);

    rectMode(CORNER);

    // text: start & end points of data file (draw the numbers at the edges)
    textFont (helvetica18, 10);
    fill(128);
    if (sliderRectStart > sliderBarPaddingFromSide + 15) { // don't show if rectangle is covering
        textAlign(LEFT); 
        text(str(alnStart), sliderBarPaddingFromSide + 5, sliderBarPaddingFromTop);
    }
    if (sliderRectEnd < canvasWidth-sliderBarPaddingFromSide-15) { // don't show if rectangle is covering  
        textAlign(RIGHT);
        text(numNucleotides + alnStart - 1, canvasWidth - sliderBarPaddingFromSide - 5, sliderBarPaddingFromTop);
    }

    // draw the numbers that appear in the slider rectangle
    // starting number
    textAlign(LEFT);
    if ( textWidth(str(alnStart)) +10 + 70< sliderRectEnd-sliderRectStart) {
        fill(128);
        textFont(helvetica18, 12);
        text(startDigit + alnStart, sliderRectStart+5, sliderBarPaddingFromTop);
    }

    ///middle lines & number
    if (displayDigitHowMany >= 120) {
        fill(190);
        textFont(helvetica18, 10);
        textAlign(CENTER);
        text(displayDigitHowMany, (sliderRectStart+sliderRectEnd)/2, sliderBarPaddingFromTop);
    }
    //ending number if there's room
    if ( textWidth( str(endDigit + alnStart) ) + textWidth( str(startDigit + alnStart) ) +10 + 47 < sliderRectEnd-sliderRectStart) {
        textFont (helvetica18, 12);
        textAlign(RIGHT);  
        fill(128);
        text(endDigit + alnStart, sliderRectEnd-5, sliderBarPaddingFromTop);
        rectMode(CORNER); // return rectMode back to default setting
    }

    // end caps of rectangle
    noFill();
    ////// left side end cap
    if ( (mouseX > sliderRectStart-15 && mouseX < sliderRectStart+2) && (mouseY > sliderBarPaddingFromTop-15 && mouseY < sliderBarPaddingFromTop+5)) {
        fill(80);
        mouseOverButton = "scrollBarStart";
    } else {
        fill(#BBBBBB);
    }
    noStroke();
    rect(sliderRectStart-9, sliderBarPaddingFromTop-7, 10, 3);
    ellipse(sliderRectStart-10, sliderBarPaddingFromTop-5, 8, 8);

    ///// right side end cap
    if ((mouseX > sliderRectEnd-2 && mouseX < sliderRectEnd+15) && (mouseY > sliderBarPaddingFromTop-15 && mouseY < sliderBarPaddingFromTop+5)) {
        fill(80);
        mouseOverButton = "scrollBarEnd";
    } else {
        fill(#BBBBBB);
    }
    noStroke();
    rect(sliderRectEnd, sliderBarPaddingFromTop-7, 10, 3);
    ellipse(sliderRectEnd+12, sliderBarPaddingFromTop-5, 8, 8);
}

// This is the color legend at the bottom
void drawLegend() {
    String[] legendText = {
        "Adenine", "Guanine", "Cytosine", "Thymine"
    };
    String[] legendTextProtein = {
        "Other", "Polar", "Basic", "Acidic", "Hydrophobic"
    };
    int bottomRow = 480;

    if (gffPanelOpen) {
        bottomRow = 580;
    } else {
        bottomRow = 480;
    }

    // Color Legend
    strokeWeight(1);
    stroke(#AAAAAA);
    rectMode(CORNER);
    textFont (helvetica18, 10);
    textAlign(LEFT);
    if (DNA) {
        for (int i=0; i<legendText.length; i++) {
            fill(colorScheme[currentColorScheme][i]);
            rect(canvasWidth -320+(i*70), bottomRow-17, 15, 15, 15);
            fill(#888888);
            text(legendText[i], canvasWidth -320+(i*70)+20, bottomRow-5);
        }
    } else {
        for (int i=0; i<legendTextProtein.length; i++) {
            //select colors for display
            if (i == 0) {
                fill(colorScheme[currentColorScheme][2]);
            } else if (i == 1) {
                fill(colorScheme[currentColorScheme][1]);
            } else if (i == 2) {
                fill(colorScheme[currentColorScheme][13]);
            } else if (i == 3) {
                fill(colorScheme[currentColorScheme][9]);
            } else if (i == 4) {
                fill(colorScheme[currentColorScheme][0]);
            }
            rect(canvasWidth -390+(i*70), bottomRow-17, 15, 15, 15);
            fill(#888888);
            text(legendTextProtein[i], canvasWidth -390+(i*70)+20, bottomRow-5);
        }
    }
}

void drawAxis() {

    int displayDigitHowMany = endDigit - startDigit;    // How many digits to display
    float digitHeight = map(displayDigitHowMany, 1, numNucleotides, 80, 12.5);
    if (!DNA) {
        digitHeight /= 2.16;
    } 

    float dampening = 0.75;
    float digitX = 80;
    float digitY = ((canvasHeight/2) + (digitHeight/dampening)) + map(digitHeight, 12, 120, 200, 100) - 150;

    /// Bit Score legend -- left side
    fill(200);
    stroke(200);
    textAlign(RIGHT);

    //if dataType is DNA
    if (DNA) {
        for (float i=0; i<=2; i=i+.5) {
            // don't draw .5's if digit height less than 27
            if (digitHeight > 28) {
                textFont (helvetica18, 15);   
                text(str(i).substring(0, 3), 30, digitY-(i * digitHeight)+6 );
                line(40, digitY-(i * digitHeight)+1, 44, digitY-(i * digitHeight)+1);
            } else if (i % 1 == 0) {
                textFont (helvetica18, 15);   
                text(str(i).substring(0, 3), 30, digitY-(i * digitHeight)+6 );
                line(40, digitY-(i * digitHeight)+1, 44, digitY-(i * digitHeight)+1);
            }
        }
        //now draw axis & label
        line(45, digitY-(2 * digitHeight)+1, 45, digitY);
        fill(200);
        textFont (helvetica10, 10); 
        if (showWeightedBitScore) {
            text("Weighted\nBit Score", 48, digitY-(2 * digitHeight)-22);
        } else {
            text("Bit Score", 48, digitY-(2 * digitHeight)-18);
        }

        if (gffPanelOpen) {
            text("TAIR10", 48, digitY + 18);
        } else {
            text("Ref", 48, digitY + 18);
        }
    } else {

        for (float i=0; i<=4.32; i=i+.5) {
            // don't draw .5's if digit height less than 32.2
            if (digitHeight >= 32.2) {
                textFont (helvetica18, 15);   
                text(str(i).substring(0, 3), 30, digitY-(i * digitHeight)+6 );
                stroke(200);
                strokeWeight(1);
                line(40, digitY-(i * digitHeight)+1, 44, digitY-(i * digitHeight)+1);
            } else if (i % 1 == 0 && digitHeight > 16.75) {
                textFont (helvetica18, 15);   
                text(str(i).substring(0, 3), 30, digitY-(i * digitHeight)+6 );
                stroke(200);
                strokeWeight(1);
                line(40, digitY-(i * digitHeight)+1, 44, digitY-(i * digitHeight)+1);
            } else if (i % 2 == 0 ) {
                textFont (helvetica18, 15);   
                text(str(i).substring(0, 3), 30, digitY-(i * digitHeight)+6 );
                stroke(200);
                strokeWeight(1);
                line(40, digitY-(i * digitHeight)+1, 44, digitY-(i * digitHeight)+1);
            }   

            /////////////////////////////////////////////////
            //draw rectanglular white patch under legend text to fix weird display of text
            /////////////////////////////////////////////////
            noStroke();
            fill(255);
            rectMode(CORNER);
            rect(0, digitY+12, 55, 30);

            //now draw axis & label     
            stroke(200);
            strokeWeight(1);
            line(45, digitY-(4.32 * digitHeight)+1, 45, digitY);
            fill(200);
            textFont (helvetica10, 10);
            if (showWeightedBitScore) {
                text("Weighted\nBit Score", 48, digitY-(2 * digitHeight)-22);
            } else {
                text("Bit Score", 48, digitY-(2 * digitHeight)-18);
            }   
            //text("Protein", 48, digitY+36);
        }
    }  

    /////////////////////////////////////////////////
    // Number of Sequences Legend -- right side
    /////////////////////////////////////////////////
    /// num genes reporting legend
    fill(200);
    stroke(200);
    textAlign(LEFT);
    textFont (helvetica18, 10);  

    /// set multiplier value depending on if we're displaying DNA or Protein
    float adjustmentForDNAorProtein;
    if (DNA) {
        adjustmentForDNAorProtein = 2;
    } else {
        adjustmentForDNAorProtein = 4.32;
    }

    //draw the first and last digit
    //first digit....
    fill(200);
    textFont (helvetica18, 10);   
    text("0", canvasWidth-25, digitY-(0 * digitHeight/numSequences*adjustmentForDNAorProtein)+5 );
    line(canvasWidth-32, digitY-(0 * digitHeight/numSequences*adjustmentForDNAorProtein)+1, canvasWidth-34, digitY-(0 * digitHeight/numSequences*adjustmentForDNAorProtein)+1);    
    //last digit....
    text(numSequences, canvasWidth-25, digitY-(numSequences * digitHeight/numSequences*adjustmentForDNAorProtein)+5 );
    line(canvasWidth-32, digitY-(numSequences * digitHeight/numSequences*adjustmentForDNAorProtein)+1, canvasWidth-34, digitY-(numSequences * digitHeight/numSequences*adjustmentForDNAorProtein)+1);        

    // vertical Y axis bar
    line(canvasWidth-34, digitY-(adjustmentForDNAorProtein * digitHeight)+1, canvasWidth-34, digitY);
    fill(200);

    // and draw the word "Sequences"
    textFont (helvetica18, 10);
    text("Sequences", canvasWidth-60, digitY-(2 * digitHeight)-18);
    //// if we're in saturation view...
    noStroke();
    if (!alignmentCountIndicator) { 
        for (int i=0; i<numSequences; i++) {
            fill(60, 40+((i/numSequences)*200));
            rect(canvasWidth-45, digitY-(i * digitHeight/numSequences * adjustmentForDNAorProtein), 8, -digitHeight/numSequences * 1.5);
        }
    }

    // Show AGI if it exits
    if ((gffPanelOpen) && !(searchPanelOpen)) {
        if (agi != "") {
            textFont(helvetica18, 28);
            fill(60);
            stroke(60);
            text(agi.toUpperCase(), canvasWidth/2 - 55, 30);
            fill(200);
            stroke(200);
            textFont(helvetica18, 16);
            text("Conservation bit scores across 9 species", canvasWidth/2 - 110, 55);
        }
    }
}

// Rount the two decimal places
float rounder(float number) {
    return (float)(round((number*pow(10, 2))))/pow(10, 2);
} 

// Round number
float rounder(float number, float decimal) {
    return (float)(round((number*pow(10, decimal))))/pow(10, decimal);
} 

// Search Pannel
void drawSearchPanel() {
    // Variables
    float searchPanelTop = 5;
    float searchTextBoxHeight = 20;
    String searchPreloadValue1 = "  Use the sliders or keyboard to enter a search motif.";
    float searchBottom=105 + 35; 
    float searchWidth=40;
    String[] searchStartingColumn;
    String[] searchEndingColumn;

    searchStartingColumn = new String[6];
    searchEndingColumn = new String[6];

    if (DNA) {  
        searchHeight = 50;
    } else {
        searchHeight = 65;
    }

    if (!searchPanelOpen) {
        // main rectangle containing the search box
        fill(255);
        strokeWeight(2);
        roundButton_searchPanel.display("");
    } else {
        //transition frames
        fill(255, 220);
        stroke(120);

        //white patch to block out GUI buttons underneath
        noStroke();
        fill(255);
        rect(canvasWidth/2-225, searchPanelTop, 500, 40, 20);

        // left side panel bg for control buttons (these are placed in the gui function)
        fill(255);
        strokeWeight(2);
        stroke(220);
        rect(canvasWidth/2-270, searchPanelTop, 40, (searchHeight*2+10+searchTextBoxHeight), 20, 0, 0, 20);

        // main rectangle containing the search box
        fill(255, 220);
        stroke(120);
        strokeWeight(2);
        rect(canvasWidth/2-270, searchPanelTop, 540, (searchHeight*2+10+searchTextBoxHeight), 20);

        // text input box
        strokeWeight(3);
        if (searchPanelText[currentSearchPanel] == "" || searchPanelText[currentSearchPanel] == searchPreloadValue1 ) {
            stroke(lerpColor(digitBackground[currentSearchPanel+1], #FFFFFF, .6));
        } else {
            stroke(digitBackground[currentSearchPanel+1]);
        }
        fill(255);
        rect(canvasWidth/2-140, searchPanelTop+7, 300, 27, 10); //textbox

        //search panel number
        textFont (helvetica18, 16);
        textAlign(CENTER);
        fill(digitBackground[currentSearchPanel+1]);
        text("Query "+str(currentSearchPanel+1), canvasWidth/2-185, searchPanelTop+27);


        // draw all 8 sliders
        //numSearchColumns[currentSearchPanel] = 0;
        String whichColumns="";
        for (int i=0; i<8; i++) {
            // draw them
            searchDigit[currentSearchPanel][i].display(canvasWidth/2-212+(i*60), searchBottom-20, searchWidth, searchHeight ); ///x, y, width, canvasHeight
            ///track how many searchDigits are active at the moment? (concotinate a string that contains each)
            if (searchValue[currentSearchPanel][i] > 0) {
                whichColumns=whichColumns + str(i);
            }
        }

        // Display buttons
        roundButton_cancelSearch.display("");
        roundButton_backspace.display("");
        roundButton_textEnter.display("");
        roundButton_searchPanel.display("");

        if (whichColumns.length() > 0) { // now figure out which is first, which is last, and what the difference is between
            searchStartingColumn[currentSearchPanel] = whichColumns.substring(0, 1);
            searchEndingColumn[currentSearchPanel] = whichColumns.substring(whichColumns.length()-1);
            searchOffset[currentSearchPanel] = int(searchStartingColumn[currentSearchPanel]);
            if (whichColumns.length() > 1) { // and that's how many search columns are active
                numSearchColumns[currentSearchPanel] = int(searchEndingColumn[currentSearchPanel]) - int(searchStartingColumn[currentSearchPanel]) + 1;
            } else {
                numSearchColumns[currentSearchPanel] = 1;
            }
        } 

        //draw all 6 check boxes
        for (int i=0; i<6; i++) {
            checkBoxes[i].display(checkBoxOn[i]);
        }
    }
}

//////////////////////////// Text Input Box Function /////////////////////
void drawTextInputBox() {
    String searchPreloadValue1 = "  Use the sliders or keyboard to enter a search motif.";
    String cursorContents = "";
    float searchPanelTop = 5;
    float searchBottom=105 + 35; 
    float searchTextBoxHeight = 20;

    if (searchPanelOpen) {
        //if a second has incremented since the last cycle, adjust status of the cursor
        if (searchPanelText[currentSearchPanel] != searchPreloadValue1) {
            cursorContents = "|";
        }

        String searchPanelTextDisplay = "";
        if (searchPanelOpen) {
            /////// determine what the text should say
            /// add spaces between letters (if it's not a preload message) for aesthetics
            if (searchPanelText[currentSearchPanel] != searchPreloadValue1 ) {
                for (int i=0; i<searchPanelText[currentSearchPanel].length (); i++) {
                    searchPanelTextDisplay = searchPanelTextDisplay + searchPanelText[currentSearchPanel].substring(i, i+1)+" ";
                }
            } else {
                searchPanelTextDisplay = searchPanelText[currentSearchPanel];
            }
        }

        ///then print it
        textAlign(CENTER);
        fill(120);
        textFont (helvetica18, 12);
        text(searchPanelTextDisplay+cursorContents, (canvasWidth/2)+3, searchPanelTop+25);

        // if mouse clicks in box, clear the preloaded messages out of it.
        if (mousePressed == true && mouseX > canvasWidth/2-210 && mouseX < canvasWidth/2-210+440 && mouseY > searchBottom-searchHeight*2-searchTextBoxHeight-3 && mouseY < searchBottom-searchHeight*2-searchTextBoxHeight-3+27) {
            if (searchPanelText[currentSearchPanel] == searchPreloadValue1 ) {
                searchPanelText[currentSearchPanel] = "";
            }
        }
    }
}

void updateSearchResults() {
    // temp variables for storing start and end ponts of positive search queries
    int tempQstart = 0;
    int tempQend =0 ;

    /// start by clearing the text box
    int tempMaxActiveSlider = 0;
    for (int i=0; i<8; i++) {
        if (searchValue[currentSearchPanel][i] >0) {  
            tempMaxActiveSlider = i;
        }
        searchPanelText[currentSearchPanel] = "";
    }

    /// now rebuild it
    boolean tempFlag = false;
    for (int i=0; i<8; i++) {
        if (DNA) {
            // if slider is active and value is less than 2, make it lower case
            if (searchValue[currentSearchPanel][i] >0 && searchValue[currentSearchPanel][i] < 2 ) { 
                // Asher's crash fix
                if (!str(searchString[currentSearchPanel][i]).equals("")) {
                    searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel]+str(searchString[currentSearchPanel][i]).toLowerCase();
                    tempFlag = true;
                }
            }
            // if it's equal to 2, take letter as is
            else if (searchValue[currentSearchPanel][i] == 2 ) {
                // Asher's Crash fix  
                if (!str(searchString[currentSearchPanel][i]).equals("")) {
                    searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel]+str(searchString[currentSearchPanel][i]).toUpperCase();
                    tempFlag = true;
                }
            }
            // if slider is inactive but there is another active slider coming up, add a dash
            else if (tempFlag && i<tempMaxActiveSlider) {
                searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel]+"-";
            }
        } else {
            // if slider is active and value is less than 4.32, make it lower case
            if (searchValue[currentSearchPanel][i] >0 && searchValue[currentSearchPanel][i] < 4.32 ) {  
                // Asher's crash fix
                //println(searchString[currentSearchPanel][i].toLowerCase());
                if (!str(searchString[currentSearchPanel][i]).equals("")) {
                    searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel]+ str(searchString[currentSearchPanel][i]).toLowerCase();
                    //println(searchString[currentSearchPanel][i].toLowerCase());
                    tempFlag = true;
                }
            }
            // if it's equal to 4.32, take letter as is
            else if (searchValue[currentSearchPanel][i] == 4.32 ) {  
                // Asher's crash fix
                if (!str(searchString[currentSearchPanel][i]).equals("")) {
                    searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel]+ str(searchString[currentSearchPanel][i]).toUpperCase();
                    tempFlag = true;
                }
            }
            // if slider is inactive but there is another active slider coming up, add a dash
            else if (tempFlag && i<tempMaxActiveSlider) {
                searchPanelText[currentSearchPanel] = searchPanelText[currentSearchPanel]+"-";
            }
        }
    }

    /// pass this new search motif to all the digits
    updateSearchMotif();

    // Clear all colors
    for (int k = 0; k < numNucleotides; k++) {
        digit[k].digitBackgroundColor[currentSearchPanel] = 0;
        digit[k].backgroundColored = false;
    }

    //now scan through and if the current digit meets the search requirements, adjust background accordingly
    for (int k=0; k<numNucleotides-numSearchColumns[currentSearchPanel]; k++) {

        if (numSearchColumns[currentSearchPanel] == 1 && digit[k].matchChecker(0+searchOffset[currentSearchPanel]) ) {
            if (checkBoxOn[currentSearchPanel]) {
                digit[k].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
                digit[k].backgroundColored = true;
            }
        } else if (numSearchColumns[currentSearchPanel] == 2 && digit[k].matchChecker(0+searchOffset[currentSearchPanel]) && digit[k+1].matchChecker(1+searchOffset[currentSearchPanel]) ) {
            digit[k].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+1].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k].backgroundColored = true;
            digit[k+1].backgroundColored = true;
        } else if (numSearchColumns[currentSearchPanel] == 3 && digit[k].matchChecker(0+searchOffset[currentSearchPanel]) && digit[k+1].matchChecker(1+searchOffset[currentSearchPanel]) && digit[k+2].matchChecker(2+searchOffset[currentSearchPanel]) ) {
            digit[k].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+1].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+2].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k].backgroundColored = true;
            digit[k+1].backgroundColored = true;
            digit[k+2].backgroundColored = true;
        } else if (numSearchColumns[currentSearchPanel] == 4 && digit[k].matchChecker(0+searchOffset[currentSearchPanel]) && digit[k+1].matchChecker(1+searchOffset[currentSearchPanel]) && digit[k+2].matchChecker(2+searchOffset[currentSearchPanel]) && digit[k+3].matchChecker(3+searchOffset[currentSearchPanel]) ) {
            digit[k].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+1].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+2].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+3].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k].backgroundColored = true;
            digit[k+1].backgroundColored = true;
            digit[k+2].backgroundColored = true;
            digit[k+3].backgroundColored = true;
        } else if (numSearchColumns[currentSearchPanel] == 5 && digit[k].matchChecker(0+searchOffset[currentSearchPanel]) && digit[k+1].matchChecker(1+searchOffset[currentSearchPanel]) && digit[k+2].matchChecker(2+searchOffset[currentSearchPanel]) && digit[k+3].matchChecker(3+searchOffset[currentSearchPanel]) && digit[k+4].matchChecker(4+searchOffset[currentSearchPanel]) ) {
            digit[k].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+1].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+2].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+3].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+4].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k].backgroundColored = true;
            digit[k+1].backgroundColored = true;
            digit[k+2].backgroundColored = true;
            digit[k+3].backgroundColored = true;
            digit[k+4].backgroundColored = true;
        } else if (numSearchColumns[currentSearchPanel] == 6 && digit[k].matchChecker(0+searchOffset[currentSearchPanel]) && digit[k+1].matchChecker(1+searchOffset[currentSearchPanel]) && digit[k+2].matchChecker(2+searchOffset[currentSearchPanel]) && digit[k+3].matchChecker(3+searchOffset[currentSearchPanel]) && digit[k+4].matchChecker(4+searchOffset[currentSearchPanel]) && digit[k+5].matchChecker(5+searchOffset[currentSearchPanel]) ) {
            digit[k].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+1].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+2].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+3].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+4].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+5].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k].backgroundColored = true;
            digit[k+1].backgroundColored = true;
            digit[k+2].backgroundColored = true;
            digit[k+3].backgroundColored = true;
            digit[k+4].backgroundColored = true;
            digit[k+5].backgroundColored = true;
        } else if (numSearchColumns[currentSearchPanel] == 7 && digit[k].matchChecker(0+searchOffset[currentSearchPanel]) && digit[k+1].matchChecker(1+searchOffset[currentSearchPanel]) && digit[k+2].matchChecker(2+searchOffset[currentSearchPanel]) && digit[k+3].matchChecker(3+searchOffset[currentSearchPanel]) && digit[k+4].matchChecker(4+searchOffset[currentSearchPanel]) && digit[k+5].matchChecker(5+searchOffset[currentSearchPanel]) && digit[k+6].matchChecker(6+searchOffset[currentSearchPanel]) ) {
            digit[k].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+1].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+2].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+3].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+4].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+5].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+6].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k].backgroundColored = true;
            digit[k+1].backgroundColored = true;
            digit[k+2].backgroundColored = true;
            digit[k+3].backgroundColored = true;
            digit[k+4].backgroundColored = true;
            digit[k+5].backgroundColored = true;
            digit[k+6].backgroundColored = true;
        } else if (numSearchColumns[currentSearchPanel] == 8 && digit[k].matchChecker(0+searchOffset[currentSearchPanel]) && digit[k+1].matchChecker(1+searchOffset[currentSearchPanel]) && digit[k+2].matchChecker(2+searchOffset[currentSearchPanel]) && digit[k+3].matchChecker(3+searchOffset[currentSearchPanel]) && digit[k+4].matchChecker(4+searchOffset[currentSearchPanel]) && digit[k+5].matchChecker(5+searchOffset[currentSearchPanel]) && digit[k+6].matchChecker(6+searchOffset[currentSearchPanel]) && digit[k+7].matchChecker(7+searchOffset[currentSearchPanel]) ) {
            digit[k].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+1].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+2].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+3].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+4].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+5].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+6].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k+7].digitBackgroundColor[currentSearchPanel] = currentSearchPanel+1;
            digit[k].backgroundColored = true;
            digit[k+1].backgroundColored = true;
            digit[k+2].backgroundColored = true;
            digit[k+3].backgroundColored = true;
            digit[k+4].backgroundColored = true;
            digit[k+5].backgroundColored = true;
            digit[k+6].backgroundColored = true;
            digit[k+7].backgroundColored = true;
        } else {
        }

        //check to see if this is a start point for a positive search
        if ( (k == 0 && digit[k].digitBackgroundColor[currentSearchPanel] >= 1) ||  (k>0 && digit[k].digitBackgroundColor[currentSearchPanel] >= 1 && digit[k-1].digitBackgroundColor[currentSearchPanel] == 0)) {
            tempQstart = k;
        } else if ( digit[k].digitBackgroundColor[currentSearchPanel] == 0 ) {
            tempQstart = -1;
        }   
        searchMotifStart[currentSearchPanel][k] = tempQstart;
    }     

    // Asher's crash fix: Just added -1 after nunNucleotides 
    for (int k=numNucleotides-1; k>=0; k--) {
        //now start at the end and look for an end point for a search
        if (k<numNucleotides-1 && digit[k].digitBackgroundColor[currentSearchPanel] >= 1 && digit[k+1].digitBackgroundColor[currentSearchPanel] == 0) {
            tempQend = k;
        } else if ( digit[k].digitBackgroundColor[currentSearchPanel] == 0 ) {
            tempQend = -1;
        }
        searchMotifEnd[currentSearchPanel][k] = tempQend;
    }
    //check to see if any sliders in this panel are up. If so, turn on check box
    checkBoxOn[currentSearchPanel]  = false;
    for (int i=0; i<8; i++) {
        if (searchValue[currentSearchPanel][i] >0) {  
            checkBoxOn[currentSearchPanel] = true;  
            //println(checkBoxOn);
        }
    }
}

// reload the motif text based on the state of the sliders
void updateSearchMotif() {
    String searchPreloadValue1 = "  Use the sliders or keyboard to enter a search motif.";

    // if we aren't looking at preload values, store the text box
    for (int k=0; k<numNucleotides; k++) {
        if (searchPanelText[currentSearchPanel] != null) { // stupid check to prevent occasional out of bound errors that I can't explain. I've already constrained boundries of the two arrays but that didn't help. This seems to work.
            if ( searchPanelText[currentSearchPanel]!= searchPreloadValue1 ) {
                searchMotifText[currentSearchPanel][k] = searchPanelText[currentSearchPanel];
            }
        }
    }
}

//////////////////////  Outer Rectangle Function     /////////////////////
void outer_rect( float x, float y, float w, float h, color strokeCol, color fillCol ) {
    pushStyle();
    pushMatrix();
    noStroke();
    fill( fillCol );
    rectMode(CORNERS);
    //top
    rect(0, 0, width, y);
    //left
    rect(0, y, x, height);
    //right
    rect(x+w, y, width, height);
    //bottom
    rect(x, y+h, x+w, height);

    popMatrix();
    popStyle();
}

////////////////////// Display Column Data Window  ///////////////////////
// To do:
// add fast forward, rewind buttons (hold and click)
// add toolTip for when mouse over scrollbar
// bottom line not showing all the time. rethink text display to ensure reliability
void drawColumnData() {
    color strokeColor = #BBBBBB;
    color textColor = #333333;
    color guiStrokeColor = #AAAAAA;
    String symbols = "AGCTNXRY-BDEFGHIJKLMOPQSUVWZ*";
    String columnData = "";

    // if drawColumnData mode is active...
    if (displayColumnData) {

        // clear mouseOverButton to avoid accidental re-triggering of another digit upon exit
        mouseOverButton = "";

        /////////////////////////////////////
        //white out the screen (adjust this to white out everything but the active digit)
        float adjustmentForDNAorProtein;
        if (DNA) {
            adjustmentForDNAorProtein = 2;
        } else {
            adjustmentForDNAorProtein = 4.32;
        }

        //adjust fade value and fade status

        if (displayColumnFadeStatus == "fadeIn") {
            displayColumnFadeValue = 230;
            displayColumnData = true;
        } else if (displayColumnFadeStatus == "fadeOut") {
            displayColumnFadeValue = 0;
            displayColumnData = false;
        }

        //white-out screen, but leave a hole for the active digit
        displayColumn = constrain(displayColumn, 0, numNucleotides-1);
        outer_rect( digit[displayColumn].d_x-(digit[displayColumn].d_w/2), (digit[displayColumn].d_y-digit[displayColumn].d_h * adjustmentForDNAorProtein)-10, digit[displayColumn].d_w, digit[displayColumn].d_h * adjustmentForDNAorProtein+20, color(255, displayColumnFadeValue), color(255, displayColumnFadeValue) );

        //draw container box
        rectMode(CENTER);
        strokeWeight(3);
        stroke(strokeColor, displayColumnFadeValue);
        fill(255, displayColumnFadeValue);
        rect(width/2, height/2, 280, height-40, 30);

        //draw connecting lines to active base
        stroke(230, displayColumnFadeValue);
        strokeWeight(2);
        fill(230, displayColumnFadeValue);
        //if lines should be on left side of box
        if (digit[displayColumn].d_x < width/2-142) {
            // upper line
            line(digit[displayColumn].d_x, (digit[displayColumn].d_y-digit[displayColumn].d_h*adjustmentForDNAorProtein)-13, width/2-142, 43);
            ellipse(digit[displayColumn].d_x, (digit[displayColumn].d_y-digit[displayColumn].d_h*adjustmentForDNAorProtein)-13, 9, 9);
            // lower line
            line(digit[displayColumn].d_x, digit[displayColumn].d_y+13, width/2-142, height-43);
            ellipse(digit[displayColumn].d_x, digit[displayColumn].d_y+13, 9, 9);
        }
        //right side of box
        else if (digit[displayColumn].d_x > width/2+142) {
            // upper line
            line(digit[displayColumn].d_x, (digit[displayColumn].d_y-digit[displayColumn].d_h * adjustmentForDNAorProtein)-13, width/2+142, 43);
            ellipse(digit[displayColumn].d_x, (digit[displayColumn].d_y-digit[displayColumn].d_h*adjustmentForDNAorProtein)-13, 9, 9);
            // lower line
            line(digit[displayColumn].d_x, (digit[displayColumn].d_y)+13, width/2+142, height-43);
            ellipse(digit[displayColumn].d_x, (digit[displayColumn].d_y)+13, 9, 9);
        }

        //draw little circle with an X in it beside the panel to suggest that people may close the window by clicking there
        //(in truth they can close the window by clicking anywhere outside the panel)
        fill(250);
        ellipseMode(CENTER);
        textFont(helvetica18, 14);
        textAlign(CENTER);
        boolean tempMouseTest = false;
        // if mouse is over
        if (mouseX > width/2+145 && mouseX < width/2+165 && mouseY > 40 && mouseY < 60) {
            tempMouseTest = true;
        }
        if (tempMouseTest) {
            strokeWeight(2);
            stroke(120, displayColumnFadeValue);
        } else {        
            strokeWeight(1);
            stroke(strokeColor, displayColumnFadeValue);
        }
        ellipse(width/2+155, 50, 20, 20);
        // if mouse is over, darken fill
        if (tempMouseTest) {
            fill(120, displayColumnFadeValue);
        } else {
            fill(200, displayColumnFadeValue);
        }
        text("✕", width/2+155.5, 55);

        //// Draw the text with adjustable start and stop lines

        //update text 
        columnData = digit[displayColumn].d_updateColumnData();

        // create temporary variables
        String[] displayColumnDataString = splitTokens(columnData, "\n");
        float displayColumnDataY = 47;
        float lineHeight = 16;
        boolean outOfBounds = false;

        // count how many lines there are
        numLines = displayColumnDataString.length;
        linesDisplayed = 0;


        // Start writing the lines
        textAlign(LEFT);  
        fill(textColor, displayColumnFadeValue);

        // starting at the columnDataStart... 
        for (int i=columnDataStart; i<numLines; i++) {
            //if displayColumnDataY hits the bottom of the square, subtract one and break
            if (displayColumnDataY >= height-20) {
                outOfBounds = true;
                i--;                
                break;
            }

            // - if first line, increase font size
            else if (i == 0) {
                textAlign(LEFT);  
                textFont(helvetica18, 15);
                fill(textColor, displayColumnFadeValue);
                text(displayColumnDataString[i], width/2-120, displayColumnDataY);
                linesDisplayed++;
                displayColumnDataY += lineHeight*1.5;
            }

            // - hereafter use standard font size, add white space after 2nd line
            else if (i == 1) {
                textAlign(LEFT);  
                textFont(helvetica18, 12);
                fill(textColor, displayColumnFadeValue);
                text(displayColumnDataString[i], width/2-120, displayColumnDataY);
                linesDisplayed++;
                displayColumnDataY += lineHeight*1.5;
            }

            // - print 3rd line normally
            else if (i == 2) {
                textAlign(LEFT);  
                textFont(helvetica18, 12);
                fill(textColor, displayColumnFadeValue);
                text(displayColumnDataString[i], width/2-120, displayColumnDataY);
                linesDisplayed++;
                displayColumnDataY += lineHeight;
            }

            // - print the lines that begin with "•" 
            else if (i>0 && i<numLines && displayColumnDataString[i].substring(0, 1).equals("•")) { //ugh!! test i to prevent weird out of bounds exception i???
                textAlign(LEFT);  
                textFont(helvetica18, 12);
                fill(textColor, displayColumnFadeValue);

                //draw bullet
                text("•", width/2-120, displayColumnDataY);

                //remove bullet from the string
                displayColumnDataString[i] = displayColumnDataString[i].substring(1);

                // draw colored letter and the gene name side by side
                String[] splitLine = splitTokens(displayColumnDataString[i], "@");
                if (splitLine.length == 2 && colorScheme != null) {                
                    // colored symbol first
                    fill(colorScheme[currentColorScheme][ symbols.indexOf( splitLine[0] ) ], displayColumnFadeValue);           
                    text(splitLine[0], width/2-120, displayColumnDataY);

                    // add the name in grey, right beside it
                    fill(textColor, displayColumnFadeValue);
                    // if line is wider than box width, only display the first part
                    if (textWidth(splitLine[1]) > 200 && splitLine[1].length()>29 ) {
                        text(splitLine[1].substring(0, 28)+"...", width/2-120+20, displayColumnDataY);
                    } else {               
                        text(splitLine[1], width/2-120+20, displayColumnDataY);
                    }
                }                
                linesDisplayed++;
                displayColumnDataY += lineHeight;
            }

            // - if line begins with 'Total Bit Score' add extra before next line
            else if (i>0 && i<numLines && displayColumnDataString[i].length()>1 && displayColumnDataString[i].substring(0, 5).equals("Total")) {  //reconfirm i is within range to avoid crashes
                textAlign(LEFT);  
                textFont(helvetica18, 12);
                fill(textColor, displayColumnFadeValue);
                text(displayColumnDataString[i], width/2-120, displayColumnDataY);
                linesDisplayed++;
                displayColumnDataY += lineHeight*1.5;
            }                

            // - now the various sequence lines
            else if (i>0 && i<numLines) { //reconfirm i is within range to avoid crashes
                textAlign(LEFT);  
                textFont(helvetica18, 12);
                // draw colored letter and the gene name side by side
                String[] splitLine = splitTokens(displayColumnDataString[i], "@");
                if (splitLine.length == 2) {                
                    // colored symbol first
                    fill(colorScheme[currentColorScheme][ symbols.indexOf( splitLine[0] ) ], displayColumnFadeValue);           
                    text(splitLine[0], width/2-120, displayColumnDataY);

                    // add the name in grey, right beside it
                    fill(textColor, displayColumnFadeValue);
                    // if line is wider than box width, only display the first part
                    if (textWidth(splitLine[1]) > 200 && splitLine[1].length()>29 ) {
                        text(splitLine[1].substring(0, 28)+"...", width/2-120+20, displayColumnDataY);
                    } else {               
                        text(splitLine[1], width/2-120+20, displayColumnDataY);
                    }
                }
                linesDisplayed++;
                displayColumnDataY += lineHeight;
            }

            // Vertical Scrollbar
            // draw vertical rectangle
            rectMode(CORNER);
            strokeWeight(2);
            stroke(strokeColor, displayColumnFadeValue);
            fill(255, displayColumnFadeValue);
            rect(width/2+105, 40, 20, height-80, 30);

            // determine start and end points of control slider
            float sliderYStart = map(columnDataStart, 0, numLines, 40, height-80);
            float sliderYEnd = map(min(linesDisplayed, numLines), 0, numLines, 40, height-80);
            ///// constrain these values just in case. should be unnecessary but errors have slipped through.
            sliderYStart = constrain(sliderYStart, 40, height-80);
            sliderYEnd = constrain(sliderYEnd, 40, height-80);


            /////////// draw control slider
            //check if mouseOver first
            if (mouseX>width/2+105 && mouseX<width/2+125 && mouseY > sliderYStart && mouseY < sliderYEnd) {
                mouseOverButton = "verticalScrollbar";
                fill(180, displayColumnFadeValue);
            } else {        
                fill(230, displayColumnFadeValue);
            }
            rect(width/2+105, sliderYStart, 20, sliderYEnd, 30);

            /// Scroll right and left triangles
        }        
        //triangle buttons
        strokeWeight(1);
        stroke(guiStrokeColor, displayColumnFadeValue);
        triButton_displayColumnLeft.display();
        triButton_displayColumnRight.display();
        triButton_displayColumnFastLeft.display();
        triButton_displayColumnFastRight.display();

        //drawToolTips() ;
    }
}


// Popup for display GFF data
void displaygffMessage(String tipText_temp) {
    float tooltip_mouseOffsetX = 30;
    float tooltip_mouseOffsetY = 20;
    float tooltip_currentX = canvasWidth/2;
    float tooltip_currentY= canvasHeight/4;
    String tooltip_tipText;
    color tooltip_textColor = #222222;
    color tooltip_backgroundColor = #FFFFFF;
    color tooltip_strokeColor = #CCCCCC;
    color tooltip_shadowColor = #999999;
    int tooltip_textHeight = 20 * 2; //adjust multiplier for number of lines
    int tooltip_textPadding = 5;
    int tooltip_shadowOffset = 3;
    int tooltip_paddingLeft = 5;
    int tooltip_paddingRight = 10;
    int tooltip_distanceFromEdgeToReverseMouseXOffset = 210;
    PFont tooltip_helvetica18 = createFont("Helvetica", 18, true);
    int tooltip_countNewLines = 1;
    int tooltip_countLinesUntilBreak = 3; 
    int tooltip_slurpTemp;

    tooltip_tipText = tipText_temp;

    //////////////////////////////////////////    
    //// count how many lines. first reset counters... then count!
    //////////////////////////////////////////
    tooltip_countNewLines = 1;
    tooltip_slurpTemp=0;
    while (tooltip_tipText.indexOf ("\n", tooltip_slurpTemp) != -1) {
        tooltip_slurpTemp = tooltip_tipText.indexOf("\n", tooltip_slurpTemp)+1;
        tooltip_countNewLines ++;
        if (tooltip_slurpTemp+5 < tooltip_tipText.length() && tooltip_tipText.substring(tooltip_slurpTemp, tooltip_slurpTemp+5).equals("Total")) { 
            tooltip_countLinesUntilBreak = tooltip_countNewLines; 
            //println(tooltip_tipText.substring(tooltip_slurpTemp, tooltip_slurpTemp+5));
        }
    } 

    tooltip_textHeight = (tooltip_countNewLines*15) + 13;       

    textFont (tooltip_helvetica18, 12);


    //////////////////////////////////////////    
    // adjust offset from mouse for various reasons
    //////////////////////////////////////////    

    // if mouse is close to top of screen, nudge it downwards
    if (mouseY < 200) {
        tooltip_mouseOffsetY = tooltip_textHeight-10;
        tooltip_mouseOffsetX = 10;
    } else {
        tooltip_mouseOffsetY = -10;
        tooltip_mouseOffsetX = -15;
    }

    /// if mouse close to right edge of screen, put tool tips on left side of mouse
    if (mouseX > canvasWidth-tooltip_distanceFromEdgeToReverseMouseXOffset) {
        tooltip_mouseOffsetX = int(textWidth(tooltip_tipText) * -0.90);
    }


    // finally, adjust the placement variables according to the computed offset
    tooltip_currentX = mouseX+tooltip_mouseOffsetX;
    tooltip_currentY = mouseY+tooltip_mouseOffsetY;


    //////////////////////////////////////////
    //// surrounding box
    //////////////////////////////////////////
    fill(tooltip_backgroundColor, 255); // non-transparent
    stroke(tooltip_strokeColor);
    strokeWeight(1);
    rect(tooltip_currentX, tooltip_currentY-tooltip_textHeight, textWidth(tooltip_tipText)+tooltip_paddingRight, tooltip_textHeight, 3);

    // The Triangle
    if (mouseY < 200) {
        beginShape(TRIANGLES);
        vertex(mouseX+10, mouseY-10);
        vertex(mouseX+10, mouseY+10);
        vertex(mouseX, mouseY);
        endShape();
    } else {
        beginShape(TRIANGLES);
        vertex(mouseX-10, mouseY-10);
        vertex(mouseX+10, mouseY-10);
        vertex(mouseX, mouseY);
        endShape();
    }
    stroke(255);
    strokeWeight(2);
    if (mouseY < 200) {
        line(mouseX+10, mouseY-9, mouseX+10, mouseY+9);
    } else {
        line(mouseX-9, mouseY-10, mouseX+9, mouseY-10);
    }
    stroke(tooltip_strokeColor);
    strokeWeight(1);

    //////////////////////////////////////////
    //// now the text, adjust colors according to # and @ start/stop codes
    //////////////////////////////////////////
    textAlign(LEFT);    
    fill(tooltip_textColor);
    //first part of the text -- up until the word Total:
    if (tooltip_tipText.indexOf("#") == -1) {
        text(tooltip_tipText, tooltip_currentX+tooltip_paddingLeft, tooltip_currentY-tooltip_textHeight+15);
    } else {
        text(tooltip_tipText.substring(0, tooltip_tipText.indexOf("#")), tooltip_currentX+tooltip_paddingLeft+5, tooltip_currentY-tooltip_textHeight+15);
    }
    //After the word Total:, draw each line on its own row, adjust colors accordingly
    int startSlurp=0;
    int endSlurp=0;
    int lineBreak=0;
    float newLine=0;
    while (tooltip_tipText.indexOf ("#", startSlurp) != -1) {
        startSlurp = tooltip_tipText.indexOf("#", endSlurp);
        endSlurp = tooltip_tipText.indexOf("@", startSlurp+1);
        lineBreak = tooltip_tipText.indexOf("\n", endSlurp);
        //colored letter

        text (tooltip_tipText.substring(startSlurp+1, endSlurp), tooltip_currentX+tooltip_paddingLeft+5, tooltip_currentY-tooltip_textHeight+(newLine*15)+(tooltip_countLinesUntilBreak*20)+10);//JW
        //gene name

        text (tooltip_tipText.substring(endSlurp+1, lineBreak), tooltip_currentX+tooltip_paddingLeft+15, tooltip_currentY-tooltip_textHeight+(newLine*15)+(tooltip_countLinesUntilBreak*20)+10);

        startSlurp = endSlurp+1;
        newLine++;
    }
    newLine=0;
    fill(255, 220);
    strokeWeight(2);
    stroke(220);
}

// This function returns query for URL in javascript mode
String getQuery() {
    String query = "";
    boolean querySet = false;

    // Check to see if any checkboxes are on
    for (int i = 0; i < 6; i++) {
        if (checkBoxOn[i]) {
            querySet = true;
            break;
        }
    }

    // If all checkboxes are off, return empty string
    if (!querySet) {
        return query;
    }

    // Now make the query string
    query = "&search=[";
    for (int i = 0; i < 6; i++) {
        query += "[";
        for (int j = 0; j < 8; j++) {
            // Build the query
            query += "{\"" + str(searchDigit[i][j].sd_letter) + "\":" + str(searchValue[i][j]) + "}";

            // Add the commas
            if (j < 7) {
                query += ",";
            }
        }

        // Add the last }, or }]
        if (i < 5) {
            query += "],";
        } else {
            query += "]";
        }
    }
    query += "]";
    return query;
}

// Function to get the color of motif
String getColor(String motif) {
    // 140 set
    //color motifColors[] =  {
    //    #F0F8FF, #FAEBD7, #00FFFF, #7FFFD4, #F0FFFF, #F5F5DC, #FFE4C4, #FFEBCD, #0000FF, #8A2BE2, #A52A2A, #DEB887, #5F9EA0, #7FFF00, #D2691E, #FF7F50, #6495ED, #FFF8DC, #DC143C, #00FFFF, #00008B, #008B8B, #B8860B, #A9A9A9, #006400, #BDB76B, #8B008B, #556B2F, #FF8C00, #9932CC, #8B0000, #E9967A, #8FBC8F, #483D8B, #2F4F4F, #00CED1, #9400D3, #FF1493, #00BFFF, #696969, #1E90FF, #B22222, #FFFAF0, #228B22, #FF00FF, #DCDCDC, #F8F8FF, #FFD700, #DAA520, #808080, #008000, #ADFF2F, #F0FFF0, #FF69B4, #CD5C5C, #4B0082, #FFFFF0, #F0E68C, #E6E6FA, #FFF0F5, #7CFC00, #FFFACD, #ADD8E6, #F08080, #E0FFFF, #FAFAD2, #D3D3D3, #90EE90, #FFB6C1, #FFA07A, #20B2AA, #87CEFA, #778899, #B0C4DE, #FFFFE0, #00FF00, #32CD32, #FAF0E6, #FF00FF, #800000, #66CDAA, #0000CD, #BA55D3, #9370DB, #3CB371, #7B68EE, #00FA9A, #48D1CC, #C71585, #191970, #F5FFFA, #FFE4E1, #FFE4B5, #FFDEAD, #000080, #FDF5E6, #808000, #6B8E23, #FFA500, #FF4500, #DA70D6, #EEE8AA, #98FB98, #AFEEEE, #DB7093, #FFEFD5, #FFDAB9, #CD853F, #FFC0CB, #DDA0DD, #B0E0E6, #800080, #663399, #FF0000, #BC8F8F, #4169E1, #8B4513, #FA8072, #F4A460, #2E8B57, #FFF5EE, #A0522D, #C0C0C0, #87CEEB, #6A5ACD, #708090, #FFFAFA, #00FF7F, #4682B4, #D2B48C, #008080, #D8BFD8, #FF6347, #40E0D0, #EE82EE, #F5DEB3, #FFFFFF, #F5F5F5, #FFFF00, #9ACD32
    //};  

    // 46 color set
    String motifColors[] = {
        "#0000FF", "#FF0000", "#00FF00", "#00FFFF", "#FFFF00", "#FF00FF", "#009900", "#993333", "#009999", "#FFFF99", "#66CCCC", "#33CCFF", "#99CC66", "#FF99CC", "#CCCC99", "#3366FF", "#FFCC33", "#FF9933", "#CCFFCC", "#CCFFFF", "#CC99FF", "#999933", "#003399", "#FF6633", "#336699", "#990099", "#999999", "#A9A9A9", "#00008B", "#008B8B", "#8B008B", "#8B0000", "#90EE90", "#BEBEBE", "#FFFAF0", "#F5FFFA", "#00BFFF", "#7FFFD4", "#DAA520", "#FF7F50", "#FF69B4", "#8A2BE2", "#8B8989", "#D2D2D2", "#D2D2D2", "#D2D2D2"
    };
    // If it is the first entry, just add it
    if (motifs.isEmpty()) {
        motifs.put(motif, motifColors[motifCounter]);
        motifCounter = motifCounter + 1;
    } else {
        // If it is not the first entry but already has a color
        if (motifs.containsKey(motif)) {
            return motifs.get(motif);
        } else {
            // Add the motif and increment the counter
            motifs.put(motif, motifColors[motifCounter]);
            motifCounter = motifCounter + 1;

            // If the counter is past 139, reset it
            if (motifCounter >= motifColors.length - 1) {
                motifCounter = 0;
            }
        }
    }
    return motifs.get(motif);
}

// Check if JASPAR data overlap in zoom view
boolean checkOverlap(int startx, int endx, int starty, int endy) {
    if ((startx <= starty) && (endx >= starty)) {
        return true;
    } else if ((startx >= starty) && (startx <= endy)) {
        return true;
    } else {
        return false;
    }
}

// Return index of max array
int getIndex(int startx) {
    int JasIndex = (startx - jsonClone.start)/50;
    return (int) JasIndex;
}

// Add motif position for zoomed view
void addMotifPosition() {
    int JasSize = (int) ((jsonClone.end - jsonClone.start) / 50);
    int[] max = new int[JasSize]; 
    int i, j, k, a;
    int JasIndex;

    //init array
    for (i = 0; i < max.length; i++) {
        max[i] = 1;
    }

    // Add the positon of one to all JASPAR
    for (i = 0; i < jsonClone.transcripts; i++) {
        for (j = 0; j < jsonClone.gff[i].data.length; j++) {
            if (((jsonClone.gff[i].data[j][0].equals("JASPAR"))  || (jsonClone.gff[i].data[j][0].equals("Weirauch et al. 2014")))) {
                if (jsonClone.gff[i].data[j].length == 7) {
                    append(jsonClone.gff[i].data[j], 0);
                }
            }
        }
    }

    for (i = 0; i < jsonClone.transcripts; i++) {
        for (j = 0; j < jsonClone.gff[i].data.length; j++) {
            for (k = 0; k < jsonClone.gff[i].data.length; k++) {
                if ((jsonClone.gff[i].data[j][0].equals("JASPAR"))  || (jsonClone.gff[i].data[j][0].equals("Weirauch et al. 2014"))) {
                    if ((jsonClone.gff[i].data[k][0].equals("JASPAR"))  || (jsonClone.gff[i].data[j][0].equals("Weirauch et al. 2014"))) {

                        // It will always overlap with itself (!)
                        if ((jsonClone.gff[i].data[j][6] == jsonClone.gff[i].data[k][6]) && (jsonClone.gff[i].data[j][1] == jsonClone.gff[i].data[k][1]) && (jsonClone.gff[i].data[j][2] == jsonClone.gff[i].data[k][2])) {
                            continue;
                        }

                        // If overlaps
                        if (checkOverlap(jsonClone.gff[i].data[j][1], jsonClone.gff[i].data[j][2], jsonClone.gff[i].data[k][1], jsonClone.gff[i].data[k][2])) {
                            //println(jsonClone.gff[i].data[j][6] + " " + jsonClone.gff[i].data[k][6]);
                            if (jsonClone.gff[i].data[j][7] == 0) {
                                JasIndex = getIndex(jsonClone.gff[i].data[j][1]);
                                //println(JasIndex + " " + JasSize);
                                jsonClone.gff[i].data[j][7] = max[JasIndex];
                                max[JasIndex] = max[JasIndex]+1;
                            }
                        }
                    }
                }
            }
        }
    }

    // Add the positon of one to all JASPAR
    for (i = 0; i < jsonClone.transcripts; i++) {
        for (j = 0; j < jsonClone.gff[i].data.length; j++) {
            if ((jsonClone.gff[i].data[j][0].equals("JASPAR"))  || (jsonClone.gff[i].data[j][0].equals("Weirauch et al. 2014"))) {
                if (jsonClone.gff[i].data[j][7] == 0) {
                    jsonClone.gff[i].data[j][7] = 1;
                }
                if (jsonClone.gff[i].data[j].length == 9) {
                    //println(jsonClone.gff[i].data[j][8]);
                }
            }
        }
    }
}

// The popup legend
void drawMotifLegend() {
    int hashSize = motifs.size();    // Number of motifs
    int h = (11 * 15) + 8;    // Height of the window
    if (hashSize > 12) {
        h = h + 7;
    } 
    int w;    // Width of the window
    int x;    // X co-ordinate

    // Figure out the width of the window based on size
    if (hashSize == 0) {
        w = 150;
    } else if (hashSize <= 9) {
        w = 150 + 180;
    } else if (hashSize <= 18) {
        w = 150 + 180 * 2;
    } else if (hashSize <= 27) {
        w = 150 + 180 * 3;
    } else if (hashSize <= 36) {
        w = 150 + 180 * 4;
    } else {
        w = 150 + 180 * 5;
    }
    int x = (width/2) - (w/2);
    int y = (height/2) - (h/2);
    PFont tooltip_helvetica18 = createFont("Helvetica", 18, true);

    // The rectangle
    stroke(220);
    strokeWeight(5);
    fill(255);
    rect(x - 15, y - 15, w + 15, h + 15, 20);

    // Sequence Data
    textAlign(LEFT);    
    fill(#222222);
    textFont(tooltip_helvetica18, 14);
    text("Genomes:", x + 10, y + 15);
    textFont(tooltip_helvetica18, 12);
    text("AT: A. thaliana", x + 10, y + 15 * 2);
    text("AL: A. lyrata", x + 10, y + 15 * 3);
    text("CR: C. rubella", x + 10, y + 15 * 4);
    text("LA: L. alabamica", x + 10, y + 15 * 5);
    text("TH: T. halophila", x + 10, y + 15 * 6);
    text("SI: S. irio", x + 10, y + 15 * 7);
    text("BR: B. rapa", x + 10, y + 15 * 8);
    text("AA: A. arabicum", x + 10, y + 15 * 9);
    text("EP: E. salsugineum", x + 10, y + 15 * 10);

    // Draw Motif Legend
    if (hashSize > 0) {
        Iterator i = motifs.entrySet().iterator();
        int count = 2;
        textFont(tooltip_helvetica18, 14);
        text("Motifs: ", x + 160, y + 15);
        textFont(tooltip_helvetica18, 12);
        while (i.hasNext ()) {
            Map.Entry me = (Map.Entry)i.next();
            int r = 255 - unhex(me.getValue().substring(1, 3));
            int g = 255 - unhex(me.getValue().substring(3, 5));
            int b = 255 - unhex(me.getValue().substring(5, 7));
            stroke(r, g, b);
            fill(r, g, b);
            ellipse(x + 165, y + 15 * count - 3, 7, 7);
            fill(#222222);    
            text(me.getKey(), x + 175, y + 15 * count);
            count = count + 1;
            if (count == 11) {
                x = x + 180;
                y = (height/2) - (h/2);
                count = 2;
            } else {
                // Don't do anything here
            }
        }
    }    

    // Reset
    fill(255, 220);
    strokeWeight(2);
    stroke(220);
}

boolean screenGrabMode = false;
/////// DOWNLOAD HI RES SCREEN GRAB
void saveScreenGrab() {
    screenGrabMode = true;
    //println("Saving screen grab..."); 

    int scaleFactor = 5;
    size(1000 * scaleFactor, 590 * scaleFactor);
    PGraphics png = createGraphics(1000 * scaleFactor, 590 * scaleFactor); // set screengrab size

    png.beginDraw();
    scale(scaleFactor);
    //repeat everything from the draw() cycle 

    textAlign(CENTER);
    textFont(helvetica18, 50);

    // Draw stuff
    drawGUI();
    drawDigits();
    drawSliderBar();
    drawLegend();
    drawAxis();
    if (gffPanelOpen) {
        showgffPanel();
        showZoomedGff();
    }
    drawSearchPanel();
    drawTextInputBox();
    drawColumnData();
    //drawPointedRectangle(mouseX, mouseY, 500, "AT1G01010", "-", 128);
    if ((gffPanelOpen) && (popupOn)) {
        displaygffMessage(popupData);
        popupOn = false;
    }
    if (displayLegend) {
        drawMotifLegend();
    }


    // add watermark
    textFont (helvetica18, 10);
    textAlign(LEFT);
    fill(#888888);
    text("Please cite Waese et al., (manuscript in preparation). Gene Slider - http://bar.utoronto.ca/geneslider", 20, 575); 

    png.endDraw();
    screenGrabMode = false;
    save("Gene Slider screengrab.png");

    //resize back to normal
    scale(1/scaleFactor);
    size(1000, 590);
}

// Files: GSGUI.pde
///Rectangular button class
///Information to be passed in:
/// - xpos, ypos
/// - label
/// - string value for mouseOverButton when active
class RectButton {
    ///global variables
    int xPosRB, yPosRB;
    String labelRB;
    //String valueIfOnRB;

    /// toolTip variables
    String toolTipTextRB=""; // this is for calculating the contents of tool tip text
    String toolTipDisplayRB=""; // this is loaded if/when we want to display it
    //int timeSinceLastMouseMoveRB;

    ///calculated variables
    float buttonWidthRB;
    int buttonPressedRB = 0;
    boolean mouseOverRB = false;

    //Tooltip toolTipRB;

    // RectButton constructor
    RectButton (int _xPos, int _yPos, String _label, String _toolTipText) {
        xPosRB = _xPos;
        yPosRB = _yPos;
        labelRB = _label;
        toolTipTextRB = _toolTipText;
    }

    void display() {
        rectMode(CORNER);

        //draw rectangle    
        textFont (helvetica18, 12);
        buttonWidthRB = textWidth(labelRB)+(6*2);
        stroke(200);
        strokeWeight(1);
        if (mouseOverRB == false) {
            fill(#FAFAFA);
        } else {
            fill(#BBBBBB);
        }
        rect(xPosRB, yPosRB-20, buttonWidthRB, 20, 8); 
        //draw text
        fill(#888888);
        textAlign(LEFT);
        text(labelRB, xPosRB+6, yPosRB-5);    


        //call mouseOver function
        mouseOver();
        //call toolTips function
        toolTipsRB();
    }

    void mouseOver() {
        if (mouseX > xPosRB && mouseX < xPosRB + buttonWidthRB && mouseY > yPosRB-20 && mouseY < yPosRB) {
            mouseOverRB = true;
        } else {
            mouseOverRB = false;
        }
    }

    Boolean press() {
        if (mouseOverRB == true && mousePressed == true) {
            mouseOverRB = false;
            return true;
        } else {
            return false;
        }
    }

    String toolTipsRB() { 
        //advance timer
        //if (timeSinceLastMouseMove <= toolTipDelay) { timeSinceLastMouseMove++; }
        //if mouse moves, reset timer
        //if (mouseX != pmouseX || mouseY !=pmouseY) {
        //    timeSinceLastMouseMove = 0;
        //}
        //if mouse hasn't moved for certain amount of time and mouse is over button, trigger tooltip
        //if (timeSinceLastMouseMove > toolTipDelay && mouseOverRB == true ) {        
        //toolTipRB.display(toolTipTextRB);
        //        return toolTipTextRB; }
        //else {
        return "";
        //}
    }
}

////////////////////5. Class Triangle Button //////////////////////////////////////////////////////////////////////////
///Triangle button class
///Information to be passed in:
/// - xpos, ypos
/// - width, height
/// - tooltip text
class TriangleButton {
    ///global variables
    float xPosTB, yPosTB;    // These are the x, y position
    float wTB, hTB;    // These are the width and the height
    //String valueIfOnTB;

    /// toolTip variables
    String toolTipTextTB;
    //int timeSinceLastMouseMoveTB;
    //int toolTipDelayTB = 30;
    //int previousMouseXTB, previousMouseYTB;

    ///calculated variables
    //int buttonPressedTB = 0;
    boolean mouseOverTB = false;    // If mouse is over the button

    // TriangleButton constructor
    TriangleButton (float _xPos, float _yPos, float _w, float _h, String _toolTipText) {
        xPosTB = _xPos;
        yPosTB = _yPos;
        wTB = _w;
        hTB = _h;
        toolTipTextTB = _toolTipText;
    }

    void display() {
        //draw triangle    
        stroke(#B1B1B1);
        strokeWeight(1);
        if (mouseOverTB == false) {
            fill(#FAFAFA);
        } else {
            fill(#BBBBBB);
        }

        beginShape();
        curveVertex(xPosTB, yPosTB);
        curveVertex(xPosTB, yPosTB-hTB);
        curveVertex(xPosTB+wTB, yPosTB-int(hTB/2));
        curveVertex(xPosTB, yPosTB);
        curveVertex(xPosTB, yPosTB-hTB);
        curveVertex(xPosTB+wTB, yPosTB-int(hTB/2));
        endShape();

        mouseOver();
    }

    // This function determines if mouse is over the button, then sets moveOverTB button which can be used for different purposes
    void mouseOver() {
        if (xPosTB < xPosTB+wTB) { 
            if (mouseX > xPosTB && mouseX < xPosTB + wTB && mouseY > yPosTB-hTB && mouseY < yPosTB) {
                mouseOverTB = true;
            } else {
                mouseOverTB = false;
            }
        } else {
            if (mouseX > xPosTB+wTB && mouseX < xPosTB && mouseY > yPosTB-hTB && mouseY < yPosTB) {
                mouseOverTB = true;
            } else {
                mouseOverTB = false;
            }
        }
    }

    // If the button is pressed return true. 
    boolean press() {
        if (mouseOverTB == true && mousePressed == true) {
            return true;
        } else {
            return false;
        }
    }

    String toolTipsTB() { 
        //advance timer
        //if (timeSinceLastMouseMove <= toolTipDelay) { timeSinceLastMouseMove++; }
        //if mouse moves, reset timer
        //if (mouseX != pmouseX || mouseY !=pmouseY) {
        //    timeSinceLastMouseMove = 0;
        //}
        //if mouse hasn't moved for certain amount of time and mouse is over button, trigger tooltip
        //if (timeSinceLastMouseMove > toolTipDelay && mouseOverTB == true ) {        
        //toolTipRB.display(toolTipTextRB);
        //        return toolTipTextTB; }
        //else {
        return "";
        //}
    }
}

//////////////////7. Class Round Button    ////////////////////////////////////////////////////////////////////////////////// 
///Rectangular button class
///Information to be passed in:
/// - xpos, ypos
/// - label
/// - string value for mouseOverButton when active
class RoundButton {
    ///global variables
    int xPosRNB, yPosRNB;
    String labelRNB;
    String valueIfOnRNB;
    String directionRNB;

    /// toolTip variables
    String toolTipTextRNB;
    int timeSinceLastMouseMoveRNB;
    int toolTipDelayRNB = 30;
    int previousMouseXRNB, previousMouseYRNB;

    ///calculated variables
    int buttonPressedRNB = 0;
    boolean mouseOverRNB = false;

    // RoundButton constructor
    RoundButton (int _xPos, int _yPos, String _label, String _valueIfOn, String _toolTipText) {
        xPosRNB = _xPos;
        yPosRNB = _yPos;
        labelRNB = _label;
        valueIfOnRNB = _valueIfOn;
        toolTipTextRNB = _toolTipText;
    }

    void display(String _directionRNB) {
        directionRNB = _directionRNB;
        ellipseMode(CENTER);
        //Search Icon
        if (valueIfOnRNB == "searchPanel") {
            fill(255);
            if (mouseOverRNB == false) {
                stroke(220);
            } else {
                stroke(120);
            }
            strokeWeight(3);
            //ellipse(xPosRNB, yPosRNB-5, 35, 35);
            if (!searchPanelOpen) {
                rect(canvasWidth/2-270, 10, 40, 40, 20);
            }
            textFont (helvetica18, 15);
            if (mouseOverRNB == false) {
                fill(220);
            } else {
                fill(120);
            }
            textAlign(CENTER);
            textFont(helvetica18, 18);
            text("?", xPosRNB - 10, yPosRNB + 2);
            textFont(helvetica18, 22);
            text("?", xPosRNB, yPosRNB + 2);
            textFont(helvetica18, 18);
            text("?", xPosRNB + 10, yPosRNB + 2);
        }
        //Cancel Search Icon
        else if (valueIfOnRNB == "cancelSearch") {
            fill(255);
            if (mouseOverRNB == false) {
                stroke(220);
            } else {
                stroke(120);
            }
            strokeWeight(3);
            ellipse(xPosRNB, yPosRNB-5, 20, 20);
            textFont (helvetica18, 12);
            if (mouseOverRNB == false) {
                fill(220);
            } else {
                fill(120);
            }
            textAlign(CENTER);
            text("X", xPosRNB, yPosRNB);
        }
        //show More
        else if (valueIfOnRNB == "showMore") {

            if (mouseOverRNB == false) {
                stroke(#BBBBBB);
            } else {
                stroke(120);
            }
            strokeWeight(5);
            line(xPosRNB, yPosRNB-5, xPosRNB-15, yPosRNB+20);
            strokeWeight(3);
            fill(#FAFAFA);
            ellipse(xPosRNB, yPosRNB-5, 35, 30);
            textFont (helvetica18, 24);
            //draw text
            if (mouseOverRNB == false) {
                fill(#BBBBBB);
            } else {
                fill(120);
            }
            textAlign(CENTER);
            text(labelRNB, xPosRNB, yPosRNB+2);
        }
        //show Less
        else if (valueIfOnRNB == "showLess") {
            if (mouseOverRNB == false) {
                stroke(#BBBBBB);
            } else {
                stroke(120);
            }
            strokeWeight(5);
            line(xPosRNB, yPosRNB-5, xPosRNB+15, yPosRNB+20);
            strokeWeight(3);
            fill(#FAFAFA);
            ellipse(xPosRNB, yPosRNB-5, 35, 30);
            textFont (helvetica18, 24);     
            //draw text
            if (mouseOverRNB == false) {
                fill(#BBBBBB);
            } else {
                fill(120);
            }
            textAlign(CENTER);
            text(labelRNB, xPosRNB, yPosRNB+2);
        }        
        //all others
        else {
            if (mouseOverRNB == false) {
                stroke(#BBBBBB);
                strokeWeight(1);
            } else {
                stroke(120);
                strokeWeight(2);
            }
            fill(#FAFAFA);
            ellipse(xPosRNB, yPosRNB-5, 20, 20);
            textFont (helvetica18, 10);
            //draw text
            if (mouseOverRNB == false) {
                fill(#BBBBBB);
            } else {
                fill(120);
            }
            textAlign(CENTER);
            text(labelRNB, xPosRNB, yPosRNB);
        }    
        mouseOver();
    }

    void mouseOver() {
        if (mouseX > xPosRNB-(35/2) && mouseX < xPosRNB + (35/2) && mouseY > yPosRNB-(30/2) && mouseY < yPosRNB+(30/2)) {
            mouseOverRNB = true;
        } else {
            mouseOverRNB = false;
        }
    }

    boolean press() {
        if (mouseOverRNB == true && mousePressed == true) {
            mouseOverRNB = false;
            return true;
        } else {
            return false;
        }
    }

    String toolTipsRNB() { 
        //advance timer
        //if (timeSinceLastMouseMove <= toolTipDelay) { timeSinceLastMouseMove++; }
        //if mouse moves, reset timer
        //if (mouseX != pmouseX || mouseY !=pmouseY) {
        //    timeSinceLastMouseMove = 0;
        //}
        //if mouse hasn't moved for certain amount of time and mouse is over button, trigger tooltip
        //if (timeSinceLastMouseMove > toolTipDelay && mouseOverRNB == true ) {        
        //toolTipRB.display(toolTipTextRB);
        //        return toolTipTextRNB;
        //    }
        //else 
        //{
        return "";
        //}
    }
}

//----------------------------------------------------------------------//
//////////////////////////////////////////////////////////////////////////
//////////////////////// 9. Class Checkbox ///////////////////////////////
//////////////////////////////////////////////////////////////////////////
///Check Box class
///Information to be passed in:
/// - xpos, ypos
/// - width, height
/// - color
/// - status on/off
/// - string value for mouseOverButton when active
/// - tooltip text
//----------------------------------------------------------------------//

class CheckBox {
    ///global variables
    int xPosCB, yPosCB;
    int wCB, hCB;
    color boxColorCB;
    boolean boxOnCB = false;
    int valueIfMouseOverCB;

    /// toolTip variables 
    String toolTipTextCB;

    ///calculated variables
    int buttonPressedCB = 0;
    boolean mouseOverCB = false;

    ///style settings
    color strokeColorCB = #E1E1E1;
    int strokeWidthCB = 1;
    color backgroundColorCB = #FFFFFF;
    color backgroundColorMouseOverCB = #E1E1E1;

    //////////////////////////////////////////
    // CheckBox constructor
    //////////////////////////////////////////
    CheckBox (int _xPos, int _yPos, int _w, int _h, color _boxColor, boolean _boxOn, int  _valueIfMouseOver, String _toolTipText) {
        xPosCB = _xPos;
        yPosCB = _yPos;
        wCB = _w;
        hCB = _h;
        boxColorCB = _boxColor;
        boxOnCB = _boxOn;
        valueIfMouseOverCB = _valueIfMouseOver;
        toolTipTextCB = _toolTipText;
    }
    //////////////////////////////////////////
    /// Display
    //////////////////////////////////////////  
    void display(boolean _boxOnCB) {
        boxOnCB = _boxOnCB;
        //set line  
        stroke(strokeColorCB);
        strokeWeight(strokeWidthCB);

        // if box is on, fill with full color
        if (boxOnCB == true) {
            fill(boxColorCB);
            stroke(180);
        } else {  // otherwise
            // draw an dot over it
            fill(strokeColorCB);
            ellipse(xPosCB+6.5, yPosCB-5.5, 4, 4);
            /// and fade the color
            fill(boxColorCB, 40);
            stroke(strokeColorCB);
        }

        //call mouseOver function to decide how to draw the box
        mouseOver();

        if (mouseOverCB == false) {
            strokeWeight(strokeWidthCB);
        } else {
            stroke(180);
            strokeWeight(strokeWidthCB+2);
        }

        if (currentSearchPanel == valueIfMouseOverCB) {
            stroke(lerpColor(boxColorCB, 255, .5));
            strokeWeight(strokeWidthCB+2);
        }
        rect(xPosCB, yPosCB-hCB, wCB, hCB, 5);
    }

    //////////////////////////////////////////
    // mouseOver function -- test to see if mouse is over the check box
    //////////////////////////////////////////
    void mouseOver() {
        if (mouseX > xPosCB && mouseX < xPosCB + wCB && mouseY > yPosCB-hCB && mouseY < yPosCB) {
            mouseOverCB = true;
        } else {
            mouseOverCB = false;
        }
    }

    boolean press() {
        if (mouseOverCB == true && mousePressed == true) {
            return true;
        } else {
            return false;
        }
    }
}

// These are function for loading data from javascript
// Data: August 2014
// File: GSJavaScript.pde

// These function must be run after the resetData()
// Set the start of the alignment
void setAlnStart(int start) {
    alnStart = start;
}

// Set startDigit
void setStartDigit(int start) {
    startDigit = start;
}

// Set end digit
void setEndDigit(int end) {
    endDigit = end;
}

// Set gffPane
void setgffPanelOpen(boolean data) {
    gffPanelOpen = data;
}

// Set FASTA data from javascript. This function must run last
void setFastaData(String data) {
    gsStatus = 1;
    fastaData = data;
    loop();
    redraw();
}

// Set session data
void setSessionData(String _source, String _agi, int _before, int _after, String _bitscore, String _alnIndicator, String _cistome) {
    source = _source;
    agi = _agi;
    before = _before;
    after = _after;
    if (_bitscore.equals("true")) {
        showWeightedBitScore = true;
    } else {
        showWeightedBitScore = false;
    }
    if (_alnIndicator.equals("true")) {
        alignmentCountIndicator = true;
    } else {
        alignmentCountIndicator = false;
    }
    if (_cistome.equals("true")) {
        cistome = true;
    } else {
        cistome = false;
    }
}

// set welcome
void setWelcome() {
    showWelcome = false;
}

// This function draws a pointed rectangle to represent a gene on GFF pannel
void drawPointedRectangle(int x, int y, int w, String strand, int shade) {
    int h = 12;    // The height for these boxes
    fill(shade);
    strokeWeight(2);
    stroke(#AAAAAA);
    textFont (helvetica18, 12); 
    // For positive strand
    if (strand.equals("+")) {
        // The shape it self
        beginShape();
        vertex(x, y);
        vertex(x, y + h);
        vertex(x + w - 10, y + h);
        vertex(x + w, y + h - h/2);
        vertex(x + w - 10, y);
        endShape(CLOSE);
    } else {
        // For Negative strand
        beginShape();
        vertex(x, y + h - h/2);
        vertex(x + 10, y + h);
        vertex(x + w, y + h);
        vertex(x + w, y);
        vertex(x + 10, y);
        endShape(CLOSE);
    }
    fill(255, 220);
    strokeWeight(2);
    stroke(#AAAAAA);
}

// Set search data
void setSearch(int panel, int letterNum, String letter, float value) {
    searchString[panel][letterNum] = letter.charAt(0);
    searchValue[panel][letterNum] = value;
    searchDigit[panel][letterNum].sd_letter = letter;
    checkBoxOn[panel] = true;
}

// Update search results
// All these redraw are needed for proper functionality
void updateURLSearchResults() {
    for (int i = 0; i < 6; i++) {
        currentSearchPanel = i;
        redraw();
        updateSearchResults();
    }
    currentSearchPanel = 0;
}

// Get Y offset
int getOffset(String geneId) {
    int offset = 1;
    if (geneId.substring(geneId.length - 2, geneId.length - 1).equals(".")) {
        offset = int(geneId.substring(geneId.length - 1, geneId.length));
    } 
    return offset;
}

// Get Start Element
float getStartElement(int data, int start, float scale) {
    float startElement = 0;
    startElement = (data - start) * scale;
    // Correct start and end
    if (startElement < 0) {
        startElement = 0;
    }
    return startElement;
}

// Get End Element
float getEndElement(int data, int start, float scale, float size) {
    float endElement = 0;
    endElement = (data - start) * scale;
    if (endElement > (size * scale)) {
        endElement = size * scale;
    }
    return endElement;
}

// Get URL for 1000 BP upstream
String goUpstream() {
    if (JS) {
        String query = getQuery();
        before = before + 1000;
        String link = "http://bar.utoronto.ca/geneslider/?datasource=" + source + "&agi=" + agi + "&before=" + before + "&after=" + after + "&zoom_from=" + startDigit + "&zoom_to=" + endDigit
            + "&weightedBitscore=" + showWeightedBitScore + "&alnIndicator=" + alignmentCountIndicator + query;
        return link;
    } else {
        return "";
    }
}

// Get URL for 1000 BP downstream
String goDownstream() {
    if (JS) {
        String query = getQuery();
        after = after + 1000;
        String link = "http://bar.utoronto.ca/geneslider/?datasource=" + source + "&agi=" + agi + "&before=" + before + "&after=" + after + "&zoom_from=" + startDigit + "&zoom_to=" + endDigit
            + "&weightedBitscore=" + showWeightedBitScore + "&alnIndicator=" + alignmentCountIndicator + query;
        return link;
    } else {
        return "";
    }
}

// Zoomed in View
void showZoomedGff() {
    if (jsonClone == null) {
        return;
    }

    int i = 0;
    int j = 0;
    int x = 0;    // x co-oridinate
    int y = 0;    // y co-oridinate
    int a = 0;    // Width
    int b = 0;    // Height
    int h = 12;
    int offset = 1;
    float newY = 0;
    float size = (endDigit + alnStart) - (startDigit + alnStart);
    float startElement = 0;
    float endElement = 0;
    float scale = 0;
    float[] points;

    if (gffPanelOpen) {
        // The main rectange
        fill(255);
        strokeWeight(2);
        stroke(#AAAAAA);
        a = canvasWidth - (sliderBarPaddingFromSide * 2);
        b = 80;
        x = sliderBarPaddingFromSide;
        y = 70;
        scale = a/size;

        // Draw the gff upstreams upstream if they exists
        if (jsonClone.transcripts > 0) {
            points = new float(jsonClone.transcripts);

            for (i = 0; i < jsonClone.transcripts; i++) {
                // Draw bars
                for (j = 0; j < jsonClone.gff[i].data.length; j++) {
                    if (jsonClone.gff[i].data[j][0].equals("mRNA")) {
                        // Get offset
                        offset = getOffset(jsonClone.gff[i].geneId);

                        startElement = getStartElement(jsonClone.gff[i].data[j][1], startDigit + alnStart, scale);
                        endElement = getEndElement(jsonClone.gff[i].data[j][2], startDigit + alnStart, scale, size);

                        if (jsonClone.gff[i].data[j][3].equals("+")) {
                            points[i] = jsonClone.gff[i].data[j][2];
                        } else {
                            points[i] = jsonClone.gff[i].data[j][1];
                        }

                        // draw line
                        if (endElement > startElement) {
                            // Get the Y position. Note: This is better than map
                            newY = y + offset * (b/(float(jsonClone.maxTranscript) + 2));
                            fill(#AAAAAA);
                            rect(startElement + x, newY + h/2 -1, endElement - startElement, 1);
                        }
                    }
                } // Bars

                // Draw exon
                for (j = 0; j < jsonClone.gff[i].data.length; j++) {

                    if (jsonClone.gff[i].data[j][0].equals("exon")) {
                        // Get offset
                        offset = getOffset(jsonClone.gff[i].geneId);

                        // Get the start and the end
                        startElement = getStartElement(jsonClone.gff[i].data[j][1], startDigit + alnStart, scale);
                        endElement = getEndElement(jsonClone.gff[i].data[j][2], startDigit + alnStart, scale, size);

                        if (endElement > startElement) {
                            // Get the Y position. Note: This is better than map
                            fill(255);
                            newY = y + offset * (b/(float(jsonClone.maxTranscript) + 2));
                            if (jsonClone.gff[i].data[j][3].equals("+") && points[i] == jsonClone.gff[i].data[j][2] ) {
                                drawPointedRectangle(startElement + x, newY, endElement - startElement, "+", 255);
                            } else if (jsonClone.gff[i].data[j][3].equals("-") && points[i] == jsonClone.gff[i].data[j][1]) {
                                drawPointedRectangle(startElement + x, newY, endElement - startElement, "-", 255);
                            } else {
                                rect(startElement + x, newY, endElement -  startElement, h);
                            }
                            // GFF info box
                            if (!(displayColumnData) && (mouseX > startElement + x && mouseX < startElement + x + endElement -  startElement && mouseY >  newY && mouseY < newY + h)) {
                                popupOn = true;
                                if (jsonClone.gff[i].data[j][3].equals("+")) {
                                    popupData = "Gene ID: " + jsonClone.gff[i].geneId + "\nType: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][1] + "\nEnd: " + jsonClone.gff[i].data[j][2] + "\nStrand: " + jsonClone.gff[i].data[j][3];
                                } else {
                                    popupData = "Gene ID: " + jsonClone.gff[i].geneId + "\nType: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][2] + "\nEnd: " + jsonClone.gff[i].data[j][1] + "\nStrand: " + jsonClone.gff[i].data[j][3];
                                }
                            }
                        }
                    }
                } // exon

                // Draw CDS
                for (j = 0; j < jsonClone.gff[i].data.length; j++) {
                    // Skip the following elements

                    if (jsonClone.gff[i].data[j][0].equals("CDS")) {
                        // Get offset
                        offset = getOffset(jsonClone.gff[i].geneId);

                        // Get the start and the end
                        startElement = getStartElement(jsonClone.gff[i].data[j][1], startDigit + alnStart, scale);
                        endElement = getEndElement(jsonClone.gff[i].data[j][2], startDigit + alnStart, scale, size);

                        if (endElement > startElement) {
                            // Get the Y position. Note: This is better than map
                            newY = y + offset * (b/(float(jsonClone.maxTranscript) + 2));

                            fill(#AAAAAA);
                            if (jsonClone.gff[i].data[j][3].equals("+") && points[i] == jsonClone.gff[i].data[j][2] ) {
                                drawPointedRectangle(startElement + x, newY, endElement - startElement, "+", 220);
                            } else if (jsonClone.gff[i].data[j][3].equals("-") && points[i] == jsonClone.gff[i].data[j][1]) {
                                drawPointedRectangle(startElement + x, newY, endElement - startElement, "-", 220);
                            } else {
                                rect(startElement + x, newY, endElement -  startElement, h);
                            }

                            // GFF info box
                            if (!(displayColumnData) && (mouseX > startElement + x && mouseX < startElement + x + endElement -  startElement && mouseY >  newY && mouseY < newY + h)) {
                                popupOn = true;
                                if (jsonClone.gff[i].data[j][3].equals("+")) {
                                    popupData = "Gene ID: " + jsonClone.gff[i].geneId + "\nType: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][1] + "\nEnd: " + jsonClone.gff[i].data[j][2] + "\nStrand: " + jsonClone.gff[i].data[j][3];
                                } else {
                                    popupData = "Gene ID: " + jsonClone.gff[i].geneId + "\nType: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][2] + "\nEnd: " + jsonClone.gff[i].data[j][1] + "\nStrand: " + jsonClone.gff[i].data[j][3];
                                }
                            }
                        }
                    } else {
                        fill(255, 220);
                    }
                } // CDS

                motifOffset = 0;
                motifEnd = 0;
                motifStart = 0;
                // Draw JASPAR
                for (j = 0; j < jsonClone.gff[i].data.length; j++) {
                    // Skip the following elements

                    if ((jsonClone.gff[i].data[j][0].equals("JASPAR"))  || (jsonClone.gff[i].data[j][0].equals("Weirauch et al. 2014"))) {

                        // Get the start and the end
                        startElement = getStartElement(jsonClone.gff[i].data[j][1], startDigit + alnStart, scale);
                        endElement = getEndElement(jsonClone.gff[i].data[j][2], startDigit + alnStart, scale, size);

                        if (endElement > startElement) {

                            // Set motif offset
                            motifOffset = jsonClone.gff[i].data[j][7] * 6;

                            motifEnd = endElement;
                            motifStart = startElement;
                            newY = y + 10 + motifOffset;  

                            if (cistome) {
                                fill(#AAAAAA);
                                noStroke();
                            } else {
                                float value = parseFloat(jsonClone.gff[i].data[j][4]);
                                float jasparColorAlpha = (int)((value * 10 + 0.5))/10.0;
                                String jasparColor = getColor(jsonClone.gff[i].data[j][6]);
                                jasparColorAlpha = map(jasparColorAlpha, 0, 1, -1, -0.5);
                                jasparColorAlpha = abs(jasparColorAlpha);
                                int red = 255 - unhex(jasparColor.substring(1, 3));
                                int green = 255 - unhex(jasparColor.substring(3, 5));
                                int blue = 255 - unhex(jasparColor.substring(5, 7));
                                fill(red * jasparColorAlpha, green * jasparColorAlpha, blue * jasparColorAlpha);
                                noStroke(red * jasparColorAlpha, green * jasparColorAlpha, blue * jasparColorAlpha);
                            }
                            // Get the Y position. Note: This is better than map
                            rect(startElement + x, newY, endElement -  startElement, 5, 5);

                            // Text for JASPAR
                            /*
                            if (jsonClone.gff[i].data[j][0].equals("JASPAR")) {
                             fill(255);
                             stroke(255);
                             textFont (helvetica10, 10); 
                             text(jsonClone.gff[i].data[j][6].substring(jsonClone.gff[i].data[j][6].indexOf("_") + 1), startElement + x + 4, newY+8);
                             }
                             */
                            stroke(#AAAAAA);
                        }

                        // GFF info box
                        if (!(displayColumnData) && (mouseX > startElement + x && mouseX < startElement + x + endElement -  startElement && mouseY >  newY - 5 && mouseY < newY + 9)) {
                            popupOn = true;
                            if (jsonClone.gff[i].data[j][3].equals("+")) {
                                popupData = "Type: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][1] + "\nEnd: " + jsonClone.gff[i].data[j][2] + "\nStrand: " + jsonClone.gff[i].data[j][3] + "\np-value: " + jsonClone.gff[i].data[j][4] + "\nMatch: " + jsonClone.gff[i].data[j][5] + "\nMotif: " + jsonClone.gff[i].data[j][6] + "\n";
                            } else {
                                popupData = "Type: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][2] + "\nEnd: " + jsonClone.gff[i].data[j][1] + "\nStrand: " + jsonClone.gff[i].data[j][3] + "\np-value: " + jsonClone.gff[i].data[j][4] + "\nMatch: " + jsonClone.gff[i].data[j][5] + "\nMotif: " + jsonClone.gff[i].data[j][6] + "\n";
                            }
                        }
                    } else {
                        fill(255, 220);
                    }
                } // JASPAR
            }
        }
    }
}

// Asher's GFF Panel
void showgffPanel() {

    if (jsonClone == null) {
        return;
    }
    int i = 0;
    int j = 0;
    int x = 0;
    int y = 0;
    int a = 0;
    int b = 0;
    int h = 12;
    int offset = 1;
    float newY = 0;
    float size = jsonClone.end - jsonClone.start;
    float startElement = 0;
    float endElement = 0;
    float scale = 0;
    float[] points;

    // Display the gff panel
    // This needs to be updated!
    if (jsonClone.transcripts > 0) {
        gffPanelOpenUp = true;
    }

    // Text
    fill(#AAAAAA);
    stroke(#AAAAAA);
    textAlign(RIGHT);
    textFont (helvetica10, 10); 
    text("GFF", sliderBarPaddingFromSide - 10, sliderBarPaddingFromTop + 35);

    if (gffPanelOpen) {
        //rectButtonBottomRow = 580;    
        // The main rectange
        fill(255);
        strokeWeight(2);
        stroke(#AAAAAA);
        a = canvasWidth - (sliderBarPaddingFromSide * 2);
        b = 120;
        x = sliderBarPaddingFromSide;
        y = sliderBarPaddingFromTop + 10;
        scale = a/size;

        // Draw the gff upstreams upstream if they exists
        if (jsonClone.transcripts > 0) {
            points = new float(jsonClone.transcripts);

            for (i = 0; i < jsonClone.transcripts; i++) {
                // Draw bars
                for (j = 0; j < jsonClone.gff[i].data.length; j++) {
                    if (jsonClone.gff[i].data[j][0].equals("mRNA")) {
                        // Get offset
                        offset = getOffset(jsonClone.gff[i].geneId);

                        // Get the start and the end
                        startElement = getStartElement(jsonClone.gff[i].data[j][1], jsonClone.start, scale);
                        endElement = getEndElement(jsonClone.gff[i].data[j][2], jsonClone.start, scale, size);

                        // Get the Y position. Note: This is better than map
                        newY = y + offset * (b/(float(jsonClone.maxTranscript) + 2));

                        if (jsonClone.gff[i].data[j][3].equals("+")) {
                            points[i] = jsonClone.gff[i].data[j][2];
                        } else {
                            points[i] = jsonClone.gff[i].data[j][1];
                        }

                        // draw line
                        fill(255);
                        rect(startElement + x, newY + h/2 -1, endElement - startElement, 1);
                    }
                    if (jsonClone.gff[i].data[j][0].equals("gene")) {
                        startElement = getStartElement(jsonClone.gff[i].data[j][1], jsonClone.start, scale);
                        fill(#AAAAAA);
                        textAlign(LEFT);
                        textFont(helvetica18, 12);
                        newY = y + 1 * (b/(float(jsonClone.maxTranscript) + 2));
                        text(jsonClone.gff[i].geneId, startElement + 60, newY - 7);
                    }
                }

                // Draw exon
                for (j = 0; j < jsonClone.gff[i].data.length; j++) {

                    if (jsonClone.gff[i].data[j][0].equals("exon")) {
                        // Get offset
                        offset = getOffset(jsonClone.gff[i].geneId);

                        // Get the start and the end
                        startElement = getStartElement(jsonClone.gff[i].data[j][1], jsonClone.start, scale);
                        endElement = getEndElement(jsonClone.gff[i].data[j][2], jsonClone.start, scale, size);

                        // Get the Y position. Note: This is better than map
                        newY = y + offset * (b/(float(jsonClone.maxTranscript) + 2));

                        fill(255);
                        stroke(#AAAAAA);
                        if (jsonClone.gff[i].data[j][3].equals("+") && points[i] == jsonClone.gff[i].data[j][2] ) {
                            drawPointedRectangle(startElement + x, newY, endElement - startElement, "+", 255);
                        } else if (jsonClone.gff[i].data[j][3].equals("-") && points[i] == jsonClone.gff[i].data[j][1]) {
                            drawPointedRectangle(startElement + x, newY, endElement - startElement, "-", 255);
                        } else {
                            rect(startElement + x, newY, endElement -  startElement, h);
                        }
                        // GFF info box
                        if (!(displayColumnData) && (mouseX > startElement + x && mouseX < startElement + x + endElement -  startElement && mouseY >  newY && mouseY < newY + h)) {
                            popupOn = true;
                            if (jsonClone.gff[i].data[j][3].equals("+")) {
                                popupData = "Gene ID: " + jsonClone.gff[i].geneId + "\nType: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][1] + "\nEnd: " + jsonClone.gff[i].data[j][2] + "\nStrand: " + jsonClone.gff[i].data[j][3];
                            } else {
                                popupData = "Gene ID: " + jsonClone.gff[i].geneId + "\nType: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][2] + "\nEnd: " + jsonClone.gff[i].data[j][1] + "\nStrand: " + jsonClone.gff[i].data[j][3];
                            }
                        }
                    }
                }

                // Draw CDS
                for (j = 0; j < jsonClone.gff[i].data.length; j++) {
                    // Skip the following elements

                    if (jsonClone.gff[i].data[j][0].equals("CDS")) {
                        // Get offset
                        offset = getOffset(jsonClone.gff[i].geneId);

                        // Get the start and the end
                        startElement = getStartElement(jsonClone.gff[i].data[j][1], jsonClone.start, scale);
                        endElement = getEndElement(jsonClone.gff[i].data[j][2], jsonClone.start, scale, size);

                        // Get the Y position. Note: This is better than map
                        newY = y + offset * (b/(float(jsonClone.maxTranscript) + 2));

                        fill(#AAAAAA);
                        if (jsonClone.gff[i].data[j][3].equals("+") && points[i] == jsonClone.gff[i].data[j][2] ) {
                            drawPointedRectangle(startElement + x, newY, endElement - startElement, "+", 220);
                        } else if (jsonClone.gff[i].data[j][3].equals("-") && points[i] == jsonClone.gff[i].data[j][1]) {
                            drawPointedRectangle(startElement + x, newY, endElement - startElement, "-", 220);
                        } else {
                            rect(startElement + x, newY, endElement -  startElement, h);
                        }
                        // GFF info box
                        if (!(displayColumnData) && (mouseX > startElement + x && mouseX < startElement + x + endElement -  startElement && mouseY >  newY && mouseY < newY + h)) {
                            popupOn = true;
                            if (jsonClone.gff[i].data[j][3].equals("+")) {
                                popupData = "Gene ID: " + jsonClone.gff[i].geneId + "\nType: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][1] + "\nEnd: " + jsonClone.gff[i].data[j][2] + "\nStrand: " + jsonClone.gff[i].data[j][3];
                            } else {
                                popupData = "Gene ID: " + jsonClone.gff[i].geneId + "\nType: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][2] + "\nEnd: " + jsonClone.gff[i].data[j][1] + "\nStrand: " + jsonClone.gff[i].data[j][3];
                            }
                        }
                    } else {
                        fill(255);
                    }
                }

                // Draw JASPAR
                for (j = 0; j < jsonClone.gff[i].data.length; j++) {                
                    if ((jsonClone.gff[i].data[j][0].equals("JASPAR")) || (jsonClone.gff[i].data[j][0].equals("Weirauch et al. 2014"))) {

                        if (jsonClone.gff[i].data[j][7] == 100) {
                            continue;
                        }

                        // Get the start and the end
                        startElement = getStartElement(jsonClone.gff[i].data[j][1], jsonClone.start, scale);
                        endElement = getEndElement(jsonClone.gff[i].data[j][2], jsonClone.start, scale, size);

                        // Get the Y position. Note: This is better than map
                        newY = y + 20;
                        if (cistome) {
                            fill(#AAAAAA);
                            stroke(#AAAAAA);
                        } else {
                            float value = parseFloat(jsonClone.gff[i].data[j][4]);
                            float jasparColorAlpha = (int)((value * 10 + 0.5))/10.0;
                            String jasparColor = getColor(jsonClone.gff[i].data[j][6]);
                            jasparColorAlpha = map(jasparColorAlpha, 0, 1, -1, -0.5);
                            jasparColorAlpha = abs(jasparColorAlpha);
                            int red = 255 - unhex(jasparColor.substring(1, 3));
                            int green = 255 - unhex(jasparColor.substring(3, 5));
                            int blue = 255 - unhex(jasparColor.substring(5, 7));
                            stroke(red * jasparColorAlpha, green * jasparColorAlpha, blue * jasparColorAlpha);
                            fill(red * jasparColorAlpha, green * jasparColorAlpha, blue * jasparColorAlpha);
                        }
                        ellipse(startElement + x, newY, 5, 5);
                        stroke(#AAAAAA);

                        // GFF info box
                        if (!(displayColumnData) && (mouseX > startElement + x && mouseX < startElement + x + endElement -  startElement && mouseY >  newY - 5 && mouseY < newY + 5)) {
                            popupOn = true;
                            if (jsonClone.gff[i].data[j][3].equals("+")) {
                                popupData = "Type: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][1] + "\nEnd: " + jsonClone.gff[i].data[j][2] + "\nStrand: " + jsonClone.gff[i].data[j][3] + "\np-value: " + jsonClone.gff[i].data[j][4] + "\nMatch: " + jsonClone.gff[i].data[j][5] + "\nMotif: " + jsonClone.gff[i].data[j][6] + "\n";
                            } else {
                                popupData = "Type: " + jsonClone.gff[i].data[j][0] + "\nStart: " + jsonClone.gff[i].data[j][2] + "\nEnd: " + jsonClone.gff[i].data[j][1] + "\nStrand: " + jsonClone.gff[i].data[j][3] + "\np-value: " + jsonClone.gff[i].data[j][4] + "\nMatch: " + jsonClone.gff[i].data[j][5] + "\nMotif: " + jsonClone.gff[i].data[j][6] + "\n";
                            }
                        }
                    } else {
                        fill(255, 220);
                    }
                }
            }
        }
    }
}


