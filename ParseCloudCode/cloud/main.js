// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
 
 
Parse.Cloud.afterSave("Candidate", function(request) {
    
    var Mailgun = require('mailgun');
    Mailgun.initialize('sandbox6f2648d56a9d4238a0be4ee94827288c.mailgun.org','key-c0abe311133a3d919a39de38bf8c1c7c');
 
    var email = request.object.get("email")
    var userEmailed = request.object.get("emailSent")
    if (!userEmailed) {
        
        Mailgun.sendEmail({
            to: email,
            from: "Mailgun@CloudCode.com",
            subject: "Hello from Evans & Chambers!",
            text: "Thanks for applying!"
        }, {
            success: function(httpResponse) {
                console.log(httpResponse);
                //response.success("Email sent!");
            },
            error: function(httpResponse) {
                console.error(httpResponse);
                //response.error("Uh oh, something went wrong");
            }
        });
 
      request.object.set("emailSent", true);
      request.object.save();
    }
    
    var resumeImageUrl = request.object.get("resumeImage").url();
    console.log("resumeImageUrl: " + resumeImageUrl);
    
    var bodyJson = ({ 
        candidateName: request.object.get("firstName") + ' ' + request.object.get("lastName"),
        candidateEmail: request.object.get("email"),
        jobTitle: request.object.get("desiredJobTitle"),
        comments: request.object.get("comments"),
        linkedInUrl: request.object.get("linkedInUrl"),
        resumeImageUrl: resumeImageUrl
      });
    console.log("About to POST: " + JSON.stringify(bodyJson));
    Parse.Cloud.httpRequest({
      /* for testing
      method: 'GET',
      url: 'http://www.google.com/images/srpr/logo11w.png',
      */
      method: 'POST',
      headers: {
          'Content-Type': 'application/json;charset=utf-8'
      },
      url: 'http://54.85.4.149:80/', // this points to EC2 instance called CareerUp OCR
      body: bodyJson,
      success: function(httpResponse) {
        var imageBuffer = httpResponse.buffer;
        // Commenting this out because it's not saving:
        //console.log("imageBuffer: " + imageBuffer);
        //request.object.set("searchableResume", imageBuffer);
        //console.log("Image buffer base64: " + imageBuffer.toString('base64'));
      },
      error: function(httpResponse) {
        console.error('Request failed with response code ' + httpResponse.status);
      }
    });
    
});
