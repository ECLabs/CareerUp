var app = require('express')();
var exec = require('child_process').exec
var fs = require("fs");
var http = require('http');
var bodyParser = require('body-parser');
var path = require('path');

var api_key = 'key-c0abe311133a3d919a39de38bf8c1c7c';
var domain = 'sandbox6f2648d56a9d4238a0be4ee94827288c.mailgun.org';
var mailgun = require('mailgun-js')({apiKey: api_key, domain: domain});

// Constants
var PORT = 8080;
var RECRUITER_EMAIL = "recruiter-a26uhzkuy7b4@applicantstack.com";
var CC_EMAIL = "admin@evanschambers.com";
var FROM_EMAIL = "Mailgun@CloudCode.com";

// App
// test with: curl -d '{"resumeImageUrl":"http://www.google.com/images/srpr/logo11w.png"}' -H 'Content-Type: application/json' -i http://localhost:8080

// or test with: curl -d '{"resumeImageUrl":"http://files.parsetfss.com/61609546-e01c-4bda-b6da-7cc8976abf5e/tfss-69c7f76d-64d4-499e-9f4d-74af38c10010-resume.pdf"}' -H 'Content-Type: application/json' -i -v http://localhost:8080

app.use(bodyParser.json()); // for parsing application/json
app.post('/', function (req, res) {
  var fileprefix = 'source-' + new Date().getTime();
  var filename = fileprefix + ".pdf";
  var filepath = path.join(__dirname, filename);
  var resumePdfUrl = req.body.resumeImageUrl;
  console.log('Fetching input PDF from: ' + resumePdfUrl);
  console.log('Saving to: ' + filepath);

  var file = fs.createWriteStream(filename);

  var request = http.get(resumePdfUrl, function(response) {
    response.pipe(file);
    file.on('close', function () {
        res.sendFile(filepath, function (err) {
            if (err) {
                console.log(err);
                res.status(err.status).end();
            }
            else {
                console.log('HttpResponse sent with contents of ' + filepath);
                console.log('Beginning OCR...');
                console.log("\n");
                
                exec('. process.sh ' + fileprefix,
                    function(error, stdout, stderr) {
                      if(error !== null) {
                          console.log('exec error: ' + error);
                          return;
                      } else {
                        console.log('OCR complete.');
                      }
                      console.log('Emailing to recruiter ' + RECRUITER_EMAIL);
                      var emailData = {
                            to: RECRUITER_EMAIL,
                            cc: CC_EMAIL,
                            from: FROM_EMAIL,
                            subject: "Resume from CareerUp",
                            text: "Enjoy!",
                            attachment: fileprefix + ".final.pdf"
                        };  
                      mailgun.messages().send(emailData, function (error, body) {
                        console.log(body);
                        console.log("\n");
                    });
                });
            }
        });
    });
  });
});


app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
