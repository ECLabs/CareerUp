var express = require('express');
var exec = require('child_process').exec
var fs = require("fs");

// Constants
var PORT = 8080;

// App
var app = express();
app.post('/', function (req, res) {
  res.send('Hello world from post\n');
});

app.get('/', function (req, res) {

var filename = 'source-' + new Date().getTime() + ".pdf";

fs.writeFile(filename, 'Hello Node', function (err) {
  if (err) throw err;
  console.log('It\'s saved!');
});

  exec('. process.sh ' + filename,
    function(error, stdout, stderr) {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      if(error !== null) {
        console.log('exec error: ' + error);
      }
    });
  res.send('Hello world from get request\n');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
