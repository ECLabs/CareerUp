var app = require('express')();
// var exec = require('child_process').exec
var spawn = require('child_process').spawn
var fs = require('fs');
var http = require('http');
var bodyParser = require('body-parser');
var path = require('path');

var api_key = 'key-c0abe311133a3d919a39de38bf8c1c7c';
var domain = 'sandbox6f2648d56a9d4238a0be4ee94827288c.mailgun.org';
var mailgun = require('mailgun-js')({apiKey: api_key, domain: domain});

// Constants
var PORT = 8000;
var RECRUITER_EMAIL = "recruiter-a26uhzkuy7b4@applicantstack.com";
var CC_EMAIL = "admin@evanschambers.com";
var FROM_EMAIL = "Mailgun@CloudCode.com";

// App
// test with: curl -d '{"resumeImageUrl":"http://www.google.com/images/srpr/logo11w.png"}' -H 'Content-Type: application/json' -i http://localhost:8080

// or test with: curl -d '{"resumeImageUrl":"http://files.parsetfss.com/61609546-e01c-4bda-b6da-7cc8976abf5e/tfss-69c7f76d-64d4-499e-9f4d-74af38c10010-resume.pdf"}' -H 'Content-Type: application/json' -i -v http://localhost:8080

app.use(bodyParser.json()); // for parsing application/json
app.post('/', function (req, res) {
    
  var resumePdfUrl = req.body.resumeImageUrl;
  var candidateSummary = req.body.candidateName + "\r\n" + 
      req.body.candidateEmail + "\r\n";
  if(req.body.jobTitle) {
      candidateSummary += req.body.jobTitle + "\r\n";
  }
  if(req.body.comments) {
     candidateSummary += req.body.comments + "\r\n"; 
  }
  if(req.body.linkedInUrl) {
     candidateSummary += req.body.linkedInUrl + "\r\n"; 
  }   
  console.log("POST received for candidate: " + candidateSummary);   
    
  // write to file
  var dateTime = new Date().getTime();
  var resumeFileprefix = 'resume_' + req.body.candidateEmail + "_" + dateTime;
  var resumeFilename = resumeFileprefix + ".pdf";
  var resumeFilepath = path.join(__dirname, resumeFilename);
    /*
  var summaryFileprefix = 'summary_' + + req.body.candidateEmail + "_" + dateTime;
  var summaryFilename = summaryFileprefix + ".txt";
  var summaryFilepath = path.join(__dirname, summaryFilename);
  */
  console.log('Fetching input PDF from: ' + resumePdfUrl);
  console.log('And saving to: ' + resumeFilepath);
  var file = fs.createWriteStream(resumeFilepath);
  console.log('Save complete to: ' + resumeFilepath);

  var request = http.get(resumePdfUrl, function(response) {
    response.pipe(file);
    file.on('close', function () {
        res.sendFile(resumeFilepath, function (err) {
            if (err) {
                console.log(err);
                res.status(err.status).end();
            }
            else {
                console.log('HttpResponse sent with contents of ' + resumeFilepath);
                console.log('Beginning OCR...');
                console.log("\n");
                
                var commandpath = path.join(__dirname, 'process.sh');
                var cwd = __dirname;
                console.log("cwd is " + cwd);
                var bashcmd = spawn('bash', [commandpath, resumeFileprefix, cwd, candidateSummary]);
                
                bashcmd.stdout.on('data', function (data) {
                    console.log('stdout: ' + data);
                });
                bashcmd.stderr.on('data', function (data) {
                    console.log('stderr: ' + data);
                });
                bashcmd.on('close', function(code) {
                    console.log('bash process.sh has exited with code ' + code);
                    if(code == 0) {
                        console.log('Emailing to recruiter ' + RECRUITER_EMAIL);
                        var emailData = {
                            to: RECRUITER_EMAIL,
                            cc: CC_EMAIL,
                            from: FROM_EMAIL,
                            subject: "Resume from CareerUp",
                            text: "Enjoy!",
                            attachment: cwd + '/' + resumeFileprefix + ".final.pdf"
                        };  
                        mailgun.messages().send(emailData, function (error, body) {
                            console.log(body);
                            console.log("\n");
                        });
                    } else {
                        console.log("error with OCR, stopping work.");   
                    }
                });
            }
        });
    });
  });
});


app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
