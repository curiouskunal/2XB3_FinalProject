'use-strict'

const electron = require('electron');
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;

var mainWindow = null;


app.on('ready', function () {
    mainWindow = new BrowserWindow({
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
var path ;

function initialize(x) {
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

function loadStuff() {
    console.log("hi");
//clear
    d3.selectAll("svg > *").remove();
    drawMap();
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
    load();


}

function check(x){
    if (!x) {
        return 0;
    }
    return x;

}
function load() {
    // console.log("sup");
    d3.json("../Backend/load.json", function (error, json) {
        if (!json.Graphs) {
            setTimeout(load, 50);
        } else if (!json.Cutting) {

            document.getElementById("msg").innerHTML = "Building Graphs";
            setTimeout(load, 50);
        } else if (!json.Testing) {
            document.getElementById("msg").innerHTML = "Cutting Stations";
            setTimeout(load, 50);
        } else if (!json.loading) {

            document.getElementById("msg").innerHTML = "testing";
            console.log("fail");
            setTimeout(load, 50);
        } else {
            document.getElementById("msg").innerHTML = null;
            test();
        }
    });
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
            .style("fill", function(d){if (d.properties.NAME=="California"){return "#666666"}else{return "#d3d3d3"}})
            .attr("d", path);
// put boarder around states
/*for (var i=0; i<json.)
        svgContainer.append("path")
            .datum(function(a, b) { return a !== b; }))
            .attr("class", "mesh")
            .attr("d", path);*/

        // add circles to svg
        /*svgContainer
         .append("circle")
         .attr("cx",  projection(aa)[0])
         .attr("cy", projection(aa)[1])
         .attr("r", "8px")
         .attr("fill", "red");*/

    });
}


   /* tmp = ["20MRes_ARI.json", "20MRes_IDA.json", "20MRes_ORE.json", "20MRes_NEV.json", "20MRes_UTA.json", "20MRes_COL.json", "20MRes_NEW.json", "20MRes_WYO.json"];
    for (var i in tmp) {
        console.log(tmp[i]);
        d3.json("./geoJSON/"+tmp[i], function (error, json) {
            svgContainer.append("g")
                .selectAll("path")
                .data(json.features)
                .enter()
                .append("path")
                .attr("d", d3.geo.path())
                .attr("fill", "#d3d3d3")
                .attr("transform", "translate (80,-360) scale (2.8)")
            ;

        });
    }
    d3.json("./geoJSON/20MRes_test.json", function (error, json) {
        svgContainer.append("g")
            .selectAll("path")
            .data(json.features)
            .enter()
            .append("path")
            .attr("d", d3.geo.path())
            .attr("fill", "#666666")
           // .attr("transform", "translate (80,-360) scale (2.8)")
        ;

    });

    var bottomDisp = -360;//585;
    var leftDisp = 80;//230;
    var scaleY = 1;//545 / 10;
    var scaleX = 1;//340 / 11;
    var radius = 20;
    svgContainer.append("circle")
        .attr("cx", 80)
        .attr("cy", 100)
        .attr("r", radius)
        .attr("fill", "#000000")
        .attr("transform", "translate (100,100");
*/

function CheckAndload(){
    var in_start_yr = document.getElementById("start_year").value;
    var in_period = document.getElementById("period").value;
    var el = document.getElementById("msg");

    if (2014 - in_start_yr >= in_period){
        console.log("input parameters valid.");
        el.style.color = "green";
        document.getElementById("msg").innerHTML = " ";
        document.getElementById("submitButton").disabled = true; 
        loadStuff();
    }else{
        console.log("Error: input parameters not valid.");
        el.style.color = "red";
        document.getElementById("msg").innerHTML = "*Error: Input parameters not valid   Please Check Start Year and Period Conditions*";
    }    
}

function test(){
    console.log("sup");
    d3.json("goodbad.json", function (error, json) {
        for (var
                 i = 0; i < json.STATIONS.length; i++) {
            var colour = "#FFFFFF";
            if (json.STATIONS[i].goodBad) {
                colour = "#00FF00";
            } else {
                colour = "#FF2222";
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
                .attr("cx",  projection(aa)[0])
                .attr("cy", projection(aa)[1])
                .attr("r", "2px")
                .attr("fill", colour);
        }
    });
//svgContainer.sort(function(a,b){console.log(a);console.log(b);return d3.ascending(a.value, b.value);});
document.getElementById("submitButton").disabled = false;
}


function updatePeriod(){
    var in_start_yr = document.getElementById("start_year").value;
    var period = 2014 - in_start_yr+1;
    var out ="";
        for (var i=1;i<period;i++){

            out+="<option value="+i;
            out+=">"+i;
            out+=" Year<"+"/option>";
        }
    document.getElementById("period").innerHTML=out;
}
