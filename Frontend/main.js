'use-strict'

/*******************************************************************
 *-----------------------------------------------------------------*
 *--                  Application window setup                   --*
 *-----------------------------------------------------------------*
 *******************************************************************/

const electron = require('electron');
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;
var mainWindow = null;

/*-- intialize run window and start app --*/
app.on('ready', function () {
    //make window
    mainWindow = new BrowserWindow({
        resizable: false,
        width: 1280,
        height: 720
    });

    //load html page
    mainWindow.loadURL('file://' + __dirname + '/index.html');


    //set on close action
    mainWindow.on('closed', function () {
        mainWindow = null;
    });
});

//set on close action
app.on('window-all-closed', function () {
    app.quit();
});

/*******************************************************************
 *-----------------------------------------------------------------*
 *--                       User Interface                        --*
 *-----------------------------------------------------------------*
 *******************************************************************/

/*--   Global Variables   --*/

//map info
var width = 950,  height = 550;
var svgContainer;

//D3 Library, for graphics
var d3;
// set projection, to project points onto map
var projection;
// create path variable, to draw the map
var path;

/*
 * Intializes the graphics library, and prepares the canvas for drawing
 * param x - is the d3 library
 */
function initialize(x) {
    //display message to user on start-up
    document.getElementById("msg").innerHTML = "Waiting for Query";

    //assigne and load d3 library
    d3 = x;
    //Making the svg container to draw on
    svgContainer = d3.select("#map")
        .attr("width", 950)
        .attr("height", 800);
    //telling d3 that the projection we want to do is that of a map
    projection = d3.geo.mercator();

    // set projection parameters
    projection
        .scale(2500)
        .center([-121, 38.5]);
    //create a path modeled on the projection wanted
    path = d3.geo.path()
        .projection(projection);

}

/*
 * Sets load bar to specified width
 * param num 0- the width to set the load bar too
 */
function increaseProgressBar(num) {
    //the laod bar is just a simple div tag, with CSS used to give the aperance of a laod bar
  var elem = document.getElementById("myBar");
    //if the width is >100% loading then do nothing leave the bar as is
    if (width >= 100) {
    } else {
        //set width to the laod amount specified
        width = num;
        //sets the width of the object
        elem.style.width =  width + '%';
        //In the laod bar give a percentage to let user's know progress
      document.getElementById("label").innerHTML = Math.floor(width) * 1  + '%';
  }
}

/*
 * This method is called after all parameters have been checked for elagibilty and essentially passes them as a json to the server
 */
function loadStuff() {
    //clear, the contents of the map, so it may be redrawn
    d3.selectAll("svg > *").remove();
    //create a query for the server
    var query = '{'
        + '"start_year":' + document.getElementById("start_year").value
        + ',"period":' + document.getElementById("period").value
        + ',"temp":' + check(document.getElementById("temp").value)
        + ',"percip":' + check(document.getElementById("percip").value)
        + ',"accuracy":' + check(document.getElementById("accuracy").value)
        + '}';
    //formulate a request to the server
    var xhReq = new XMLHttpRequest();
    //make the request
    xhReq.open("GET", 'http://localhost:8080/query/' + query);
    xhReq.send(null);
    //erae the message "waitng for query"
    document.getElementById("msg").innerHTML = " ";
    //show the load bar, and wait for the data to be prepared
    load();
}

/*
 * This is a helper function which is used to determine if a user has filled in the field or not
 * used to avoid crashes from not, having values
 * param x - is a boolean value which was pulled from a jason
 */
function check(x) {
    //if the user has not filled in the fieled return 0, to suplement
    if (!x) {
        return 0;
    }
    //if their is a value return that
    return x;
}
/*
 * this is the screen that is shown, as we wait for the server to process out request.
 */
function load() {
    //the load system works by reading a json file which the server writes too at each stage in the processing, and then depending on the laue fo that state the next load state will be shown
    //read json, file to get load status
    d3.json("../Backend/load.json", function (error, json) {

        // the json file ahs four attributes and as each one is set to true the script moves onto the next message
        if (!json.Graphs) {
            //message
            document.getElementById("msg").innerHTML = "Recieved Query";
            //recursive call, to check state of json load file
            setTimeout(load, 50);
            // set load bar state
            increaseProgressBar(1);
             // next state in json file
        } else if (!json.Cutting) {

            document.getElementById("msg").innerHTML = "Parsing Data";
            setTimeout(load, 50);
            //minimum load bar state at this point
            if(width<20)
                increaseProgressBar(20);
            increaseProgressBar(width +.115);
            // next state in json file
        } else if (!json.Testing) {
            document.getElementById("msg").innerHTML = "Formulating Grid Network";
            setTimeout(load, 50);
            if(width<40)
                increaseProgressBar(40);
            increaseProgressBar(width + .115);
        //next state in json file
        } else if (!json.loading) {

            document.getElementById("msg").innerHTML = "Prediction Verification";

            setTimeout(load, 50);
            //final stage, maximum laod is 97%
           if(width>=97){
                increaseProgressBar(97);
            }else{
                increaseProgressBar(width + .115);
            }
        // if all otheer joba re done we can show the final info
        } else {
            //disply final message
            document.getElementById("msg").innerHTML = "DONE";

            increaseProgressBar(99);
            //remove unneccesary info
            document.getElementById("msg").innerHTML = null;
            document.getElementById("label").innerHTML = null
            document.getElementById("myBar").innerHTML = null
            document.getElementById("wrapper").remove();//.innerHTML = null

            //draw map
            drawMap();
            //draw points, use 1 second delay, to ensure points are drawn on top of map
            setTimeout(drawPoints, 1000);
        }
    });
}
/*
 * this method draws the U.S map in the svg container
 */
function drawMap() {
    // load data for map, from geojson file, filled with polygons
    d3.json("20MRes_USA.json", function (error, json) {
        //get state outlines
        states = json.features;

        // add states from geojson, and draw them in the path, and if the state is not california fill it with a lighter colour
        svgContainer.selectAll("path")
            .data(states).enter()
            .append("path")
            .attr("class", "feature")
            .style("fill", function (d) {
                if (d.properties.NAME == "California") {
                    return "#666666"
                } else {
                    return "#d3d3d3"
                }
            })
            .attr("d", path);

    });
}

/*
* this method checks that the user input is valid, as well as this the method will reset the window to allow the user to submit another query
*/
var ran=false;
function CheckAndload() {
    //if query has already been submitted then force reload the page, to allow the user to submit another query
    if (ran){
        setTimeout(window.location.reload(), 100)
    }else{
    //get values from ui, to check for validity
    var in_start_yr = document.getElementById("start_year").value;
    var in_period = document.getElementById("period").value;
    var el = document.getElementById("msg");
    //if requested time period is valid, then program is valid, the other values will default
    if (2014 - in_start_yr >= in_period) {
        //dipsplay message
        console.log("input parameters valid.");
        el.style.color = "black";
        //don't allow users to perfom any actions
        document.getElementById("msg").innerHTML = " ";
        document.getElementById("submitButton").disabled = true;
        document.getElementById("start_year").disabled = true;
        document.getElementById("period").disabled = true;
        document.getElementById("temp").disabled = true;
        document.getElementById("temp").style="background-color: #9fb9d9";
        document.getElementById("percip").disabled = true;
        document.getElementById("percip").style="background-color: #9fb9d9";
        document.getElementById("accuracy").disabled = true;
        document.getElementById("accuracy").style="background-color: #9fb9d9";
        //query submittd is true next time the program will reset
        ran=true;
        //run the loadbar and loading ui
        loadStuff();
    //if the time period is invalid
    } else {
        //display invalid message in red
        console.log("Error: input parameters not valid.");
        el.style.color = "red";
        document.getElementById("msg").innerHTML = "*Error: Input parameters not valid   Please Check Start Year and Period Conditions*";
    }}
}
/*
 * this method reads from a json file and colours and draws station on california
 */
function drawPoints() {
    //open the goodbad.json file to get a list of points and importance
    d3.json("goodbad.json", function (error, json) {
        //size of the station points
        var size="2px";
        //loop through all stations
        for (var i = 0; i < json.STATIONS.length; i++) {
            //default colour is white
            var colour = "#FFFFFF";
            //if the station may be removed colour it red
            if (json.STATIONS[i].goodBad==3) {
                size="2px";
                colour = "#FF2222";
                //if the station is used to predict colour it blude
            } else if (json.STATIONS[i].goodBad==2) {
                size="2px";
                colour = "#0000FF";
                //if the statiion is to be kept colour it green
            }else if (json.STATIONS[i].goodBad==0){
                size="1px";
                     colour = "#00FF00";
                //if the station has insuffiecent data then colour it black
            }else{
                size="1px";
                colour = "#000000";
            }

            //draw point on map
            point = [json.STATIONS[i].Longitude, json.STATIONS[i].Latitude];
            svgContainer
                .append("circle")
                .attr("cx", projection(point)[0])
                .attr("cy", projection(point)[1])
                .attr("r", size)
                .attr("fill", colour);
        }
    });
    //at this point everything has been drawn the user may reset
    document.getElementById("submitButton").innerHTML = "Reset";
    document.getElementById("submitButton").disabled = false;

}
/*
 * this method is called whenever the user modifies the start year in the UI. It updates the choices for time span to match
 */
function updatePeriod() {
    //gets the selected start year and current selected time span
    var in_start_yr = document.getElementById("start_year").value;
    var curPeriod = document.getElementById("period").value;
    //the new maximumtime span
    var period = 2014 - in_start_yr + 1;
    //the html write to be done
    var out = "";
    //for all eyars in time span
    for (var i = 1; i < period; i++) {
        //create and option for this year
        out += "<option value=" + i;
        out += ">" + i;
        out += " Year<" + "/option>";
    }
    //change the innerhtml to match
    document.getElementById("period").innerHTML = out;
    //if the previoudly selected period is less then the current period then leave that choice selected
    if (curPeriod <= period) {
        document.getElementById("period").value = curPeriod;
        // if not then set default to 1 year
    }else{
        document.getElementById("period").value = 1;
    }
}
