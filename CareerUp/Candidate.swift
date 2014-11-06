class Candidate: NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    var eventId = ""
    var editing = false
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var jobTitle = ""
    var comments = ""
    var linkedIn = ""
    var resumeImages:[UIImage] = []
    var pdfData:NSData?
    var notes = ""
    
    func getResumePDF()->NSData {
        // get your images
        let image = UIImage(named: "thing.png")

        //create an image view to size the image
        let pdfRect = CGRectMake(0, 0, 612, 792)
        let imageView = UIImageView(frame: pdfRect)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit

        // create data variable to store the pdf
        var data = NSMutableData()

        //begin writing pdf
        UIGraphicsBeginPDFContextToData(data, pdfRect, nil);

        //draw pages
        for image in resumeImages {
            imageView.image = image
            
            UIGraphicsBeginPDFPage()
            var pdfContext = UIGraphicsGetCurrentContext()
            
            imageView.layer.renderInContext(pdfContext)
        }
        UIGraphicsEndPDFContext()

        return data
    }
}
