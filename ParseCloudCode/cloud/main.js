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
    Parse.Cloud.httpRequest({
      method: 'GET',
      url: 'http://www.google.com/images/srpr/logo11w.png',
     /* method: 'POST',
      url: 'http://100.36.32.104:49160/', 
      body: {
        candidateName: request.object.get("firstName") + ' ' + request.object.get("lastName"),
        candidateEmail: request.object.get("email"),
        jobTitle: request.object.get("desiredJobTitle"),
        comments: request.object.get("comments"),
        linkedInUrl: request.object.get("linkedInUrl"),
        resume: resumeImageUrl
      }, */
      success: function(httpResponse) {
        var imageBuffer = httpResponse.buffer;
        console.log("imageBuffer: " + imageBuffer);
        request.object.set("searchableResume", imageBuffer);
        request.object.save();
        console.log("Image buffer base64: " + imageBuffer.toString('base64'));
          
        Mailgun.sendEmail({
            to: "recruiter-a26uhzkuy7b4@applicantstack.com ",
            cc: "admin@evanschambers.com",
            from: "Mailgun@CloudCode.com",
            subject: "Resume",
            text: "Put the json http request body here.",
            attachment: imageBuffer.toString('base64')
        }, {
            success: function(httpResponse) {
                console.log("email sent!: " + httpResponse);
                //response.success("Email sent!");
            },
            error: function(httpResponse) {
                console.error("email send failed!: " + httpResponse);
                //response.error("Uh oh, something went wrong");
            }
        });
      },
      error: function(httpResponse) {
        console.error('Request failed with response code ' + httpResponse.status);
      }
    });
    
});
