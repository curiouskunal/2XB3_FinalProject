'use-strict'

const electron = require('electron');
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;

var mainWindow = null;



app.on('ready', function () {
    mainWindow = new BrowserWindow({
        resizable: false,
        width: 1280,
        height: 720
    });

    mainWindow.loadURL('file://' + __dirname + '/index.html');

    mainWindow.on('closed', function () {
        mainWindow = null;
    });
});

app.on('window-all-closed', function () {
    app.quit();
});


var svgContainer;
var d3;
var width = 950,
    height = 550;

// set projection
var projection;

// create path variable
var path;

function initialize(x) {
    document.getElementById("msg").innerHTML = "Waiting for Query";
    d3 = x;
    //Make an SVG Container
    svgContainer = d3.select("#map")
        .attr("width", 950)
        .attr("height", 800);
    // testing();
    svgContainer = d3.select("#map")
        .attr("width", 950)
        .attr("height", 800);

    projection = d3.geo.mercator();


    // set projection parameters
    projection
        .scale(2500)
        .center([-121, 38.5]);
    path = d3.geo.path()
        .projection(projection);

}

function increaseProgressBar(num) {
  var elem = document.getElementById("myBar");   
    if (width >= 100) {
    } else {
      width = num;
        elem.style.width =  width + '%';
      document.getElementById("label").innerHTML = Math.floor(width) * 1  + '%';
  }
}


function loadStuff() {
    console.log("hi");
//clear
    d3.selectAll("svg > *").remove();
    // drawMap();
    var query = '{'
        + '"start_year":' + document.getElementById("start_year").value
        + ',"period":' + document.getElementById("period").value
        + ',"temp":' + check(document.getElementById("temp").value)
        + ',"percip":' + check(document.getElementById("percip").value)
        + ',"accuracy":' + check(document.getElementById("accuracy").value)
        + '}';
    //console.log (query);
    //console.log(JSON.parse(query));
    var xhReq = new XMLHttpRequest();
    xhReq.open("GET", 'http://localhost:8080/query/' + query);
    xhReq.send(null);
    console.log("hii");
    document.getElementById("msg").innerHTML = " ";
    load();


}

function check(x) {
    if (!x) {
        return 0;
    }
    return x;

}
function load() {
    d3.json("../Backend/load.json", function (error, json) {
        if (!json.Graphs) {

            setTimeout(load, 50);
            increaseProgressBar(1);
        } else if (!json.Cutting) {

            document.getElementById("msg").innerHTML = "Parsing Data";
            setTimeout(load, 50);
            increaseProgressBar(width +.115);
        } else if (!json.Testing) {

            document.getElementById("msg").innerHTML = "Formulating Grid Network";
            setTimeout(load, 50);

                increaseProgressBar(width + .115);

        } else if (!json.loading) {
  
            document.getElementById("msg").innerHTML = "Prediction Verification";

            setTimeout(load, 50);
           if(width>=97){
                increaseProgressBar(97);
            }else{
                increaseProgressBar(width + .115);
            }
        } else {
            
            increaseProgressBar(100);

            setTimeout(finalTing, 900);

            // test();
        }
    });
}

function finalTing(){
    document.getElementById("msg").innerHTML = null;
    document.getElementById("label").innerHTML = null
    document.getElementById("myBar").innerHTML = null
    document.getElementById("wrapper").remove();//.innerHTML = null

    drawMap();

    setTimeout(test, 1000);

}


function drawMap() {

    d3.json("20MRes_USA.json", function (error, json) {
        console.log(json);

        states = json.features;

        // points
        aa = [-122.490402, 37.786453];
        bb = [-122.389809, 37.72728];

        console.log(projection(aa), projection(bb));

        // add states from topojson
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


var ran=false;
function CheckAndload() {
    if (ran){
        setTimeout(window.location.reload(), 100)
    }else{
    ran=true;
    var width = 0; 
    var in_start_yr = document.getElementById("start_year").value;
    var in_period = document.getElementById("period").value;
    var el = document.getElementById("msg");

    if (2014 - in_start_yr >= in_period) {
        console.log("input parameters valid.");
        el.style.color = "black";
        document.getElementById("msg").innerHTML = " ";
        document.getElementById("submitButton").disabled = true;
        document.getElementById("start_year").disabled = true;
        document.getElementById("period").disabled = true;
        document.getElementById("temp").disabled = true;
        document.getElementById("percip").disabled = true;
        document.getElementById("accuracy").disabled = true;
        loadStuff();
    } else {
        console.log("Error: input parameters not valid.");
        el.style.color = "red";
        document.getElementById("msg").innerHTML = "*Error: Input parameters not valid   Please Check Start Year and Period Conditions*";
    }}
}

function test() {
    console.log("sup");
    d3.json("goodbad.json", function (error, json) {
        var size="2px";
        for (var
                 i = 0; i < json.STATIONS.length; i++) {
            var colour = "#FFFFFF";
            if (json.STATIONS[i].goodBad==3) {
                size="2px";
                colour = "#FF2222";
            } else if (json.STATIONS[i].goodBad==2) {
                size="2px";
                colour = "#0000FF";
            }else if (json.STATIONS[i].goodBad==0){
                size="1px";
                     colour = "#00FF00";
            }else{
                size="1px";
                colour = "#000000";
            }
            /* svgContainer.append("circle")
             .attr("cx", (json.STATIONS[i].Longitude) * scaleX + leftDisp)
             .attr("cy", bottomDisp+((json.STATIONS[i].Latitude) * scaleY))
             .attr("r", radius).attr("fill", colour);*/
            // add circles to svg
            /*svgContainer
             .append("circle")
             .attr("cx", projection([json.STATIONS[i].Longitude,json.STATIONS[i].Latitude])[0])
             .attr("cy", projection([json.STATIONS[i].Longitude,json.STATIONS[i].Latitude])[1])
             .attr("r", "8px")
             .attr("fill", "red");*/
            aa = [json.STATIONS[i].Longitude, json.STATIONS[i].Latitude];
            svgContainer
                .append("circle")
                .attr("cx", projection(aa)[0])
                .attr("cy", projection(aa)[1])
                .attr("r", size)
                .attr("fill", colour);
        }
    });
//svgContainer.sort(function(a,b){console.log(a);console.log(b);return d3.ascending(a.value, b.value);});
    document.getElementById("submitButton").innerHTML = "Reset";
    document.getElementById("submitButton").disabled = false;

}


function updatePeriod() {
    var in_start_yr = document.getElementById("start_year").value;
    var curPeriod = document.getElementById("period").value;
    var period = 2014 - in_start_yr + 1;
    var out = "";
    for (var i = 1; i < period; i++) {

        out += "<option value=" + i;
        out += ">" + i;
        out += " Year<" + "/option>";
    }
    document.getElementById("period").innerHTML = out;
    if (curPeriod <= period) {
        document.getElementById("period").value = curPeriod;
    }else{
        document.getElementById("period").value = 1;
    }
}
