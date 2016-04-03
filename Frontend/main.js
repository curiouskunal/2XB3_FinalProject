'use-strict'

const electron = require('electron');
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;

var mainWindow = null;
console.log(electron);
console.log(app);
try {
    app.on('ready', function () {
        mainWindow = new BrowserWindow({
            width: 1280,
            height: 720
        });

        mainWindow.loadURL('file://' + __dirname + '/index.html');

        mainWindow.webContents.openDevTools();

        mainWindow.on('closed', function () {
            mainWindow = null;
        });
    });

    app.on('window-all-closed', function () {
        app.quit();
    });
}catch(err){}

var svgContainer;
var d3;
function initialize(x) {
    d3 = x;
    //Make an SVG Container
    svgContainer = d3.select("#map")
        .attr("width", 700)
        .attr("height", 700);
}

function loadStuff() {
//clear
    d3.selectAll("svg > *").remove();
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
    drawMap();
    load();
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
    svgContainer = d3.select("#map")
        .attr("width", 700)
        .attr("height", 700);
    d3.json("20MRes_CALI.json", function (error, json) {
        svgContainer.append("g")
            .selectAll("path")
            .data(json.features)
            .enter()
            .append("path")
            .attr("d", d3.geo.path())
            .attr("fill", "#666666")
            .attr("transform", "translate (-20,-360) scale (2.8)")
        ;

    });
}

function drawDots() {
    var topDisp = 10;
    var bottomDisp = 585;
    var leftDisp = 230;
    var scaleY = 545 / 10;
    var scaleX = 340 / 11;
    var radius = 2;
    d3.json("goodbad.json", function (error, json) {
        for (var
                 i = 0; i < json.STATIONS.length; i++) {
            var colour = "#FFFFFF";
            if (json.STATIONS[i].goodBad) {
                colour = "#00FF00";
            } else {
                colour = "#0000FF";
            }
            svgContainer.append("circle").attr("cx", (json.STATIONS[i].Longitude + 125) * scaleX + leftDisp).attr("cy", bottomDisp - ((json.STATIONS[i].Latitude - 32) * scaleY)).attr("r", radius).attr("fill", colour)
        }
    });
}

function test() {


    //for now
    drawDots();
}

function check(x) {
    if (!x) {
        return 0;
    } else {
        return x;
    }
}
