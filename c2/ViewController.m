//
//  ViewController.m
//  c2
//
//  Created by Siqi Li on 10/11/12.
//  Copyright (c) 2012 Siqi Li. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "second.h"
#import "third.h"
#import <OpenEars/LanguageModelGenerator.h>

@interface ViewController ()
{
    SLComposeViewController *slComposeViewController;
    Boolean initiated;
    NSMutableArray *descriptionArray;
    NSMutableArray *checkMarkArray;
    
    NSString *lmPath;
    NSString *dicPath;
    NSString *uploadQuestion;
    NSString *imageDir;
}

@end

@implementation ViewController

@synthesize Text, Image, picker, spinner,tempImageArray,tempImageNameArray,count,question;

@synthesize fliteController;
@synthesize slt;
@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;

- (void)viewDidLoad
{
    self.title=@"Descriptive Camera";
    
    [super viewDidLoad];
	
    [self.fliteController say:@"Welcome to descriptive camera!" withVoice:self.slt];
/*    UIImage *imageLeft= [UIImage imageNamed:@"ApertureExpert-20120612001651-Library_icon.png"];
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftbutton setBackgroundImage:imageLeft forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    leftbutton.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *photoLibrary = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];

    
    UIImage *imageRight= [UIImage imageNamed:@"fx-photo-studio-for-ios-icon.png"];
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];

    [rightbutton setBackgroundImage:imageRight forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    self.navigationItem.leftBarButtonItem = photoLibrary;
    self.navigationItem.rightBarButtonItem = camera;
*/
    Text.hidden = true;
    question.hidden = true;
    uploadQuestion = nil;
    slComposeViewController = [[SLComposeViewController alloc]init];
    
    initiated = false;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.imageArray = [[NSMutableArray alloc] init];
    appDelegate.imageNameArray = [[NSMutableArray alloc] init];
    
    tempImageArray = [[NSMutableArray alloc] init];
    tempImageNameArray = [[NSMutableArray alloc] init];

    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    //Get the list of files from the file manager
    NSArray *docFiles = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:docsDir error:NULL];
    //use fast enumeration to iterate the list of files searching for .png extensions and load those
    for (NSString *fileName in docFiles) {
        //check to see if the file is a .png file
        if ([fileName hasSuffix:@".png"]) {
            NSString *fullPath = [docsDir stringByAppendingPathComponent:fileName];
            UIImage *loadedImage = [UIImage imageWithContentsOfFile:fullPath];
            //you'll have to sort out how to put these images in their proper place
            [tempImageArray addObject:loadedImage];
            [tempImageNameArray addObject:fileName];
           
        }
    }
    
    NSLog(@"%@",tempImageNameArray);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    count = [prefs integerForKey:@"count"];
    
    [self.openEarsEventsObserver setDelegate:self];
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    
    NSArray *words = [NSArray arrayWithObjects:@"PLEASE DESCRIBE THIS IMAGE FOR ME", @"PLEASE PROVIDE YOUR DESCRIPTIONS", @"PROVIDE", @"PLEASE DESCRIBE THIS IMAGE", @"DESCRIPTION" ,@"YOUR", @"GIVE", @"ME", @"FOR", @"IMAGE", @"PLEASE", @"DESCRIBE", @"THIS", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name];
    
    
    NSDictionary *languageGeneratorResults = nil;
	
    if([err code] == noErr) {
        
        languageGeneratorResults = [err userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [spinner stopAnimating];
}

- (IBAction)gallary:(id)sender {
    
    picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:picker animated:YES];

}

- (IBAction)option:(id)sender {
    
    [spinner startAnimating];
    [self performSelector: @selector(postingOnAMT)
               withObject: nil
               afterDelay: 0];
    return;
    
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Save to camera roll", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Post on Facebook", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Post on Twitter", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Post on Amazon Mturk", nil)];
    //[actionSheet addButtonWithTitle:NSLocalizedString(@"Uploaded Images", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:[self.view window]];
    */
}


#pragma mark
#pragma mark UIActionSheetDelegate


/*- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Save to camera roll", nil)]) {
        UIImage *UIImage = Image.image;
        UIImageWriteToSavedPhotosAlbum(UIImage, self, @selector(imageSavedToPhotoAlbum:didFinishSavingWithError:contextInfo:)
                                                                , nil);
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Post on Facebook", nil)]) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [slComposeViewController setInitialText:@"This image is posted by descriptive camera, please give your description"];
            [slComposeViewController addImage:Image.image];
            [self presentViewController:slComposeViewController animated:YES completion:nil];
        }
        
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Post on Twitter", nil)]) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [slComposeViewController setInitialText:@"This image is posted by descriptive camera, please give your description"];
            [slComposeViewController addImage:Image.image];
            [self presentViewController:slComposeViewController animated:YES completion:nil];
        }
        
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Post on Amazon Mturk", nil)]) {
        
        [spinner startAnimating];
        [self performSelector: @selector(postingOnAMT)
                   withObject: nil
                   afterDelay: 0];
        return;
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Uploaded Images", nil)]) {
        [self performSelector: @selector(uploadingImages)
                   withObject: nil
                   afterDelay: 0];

    }
}*/
- (void) uploadingImages{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.imageArray = tempImageArray;
        appDelegate.imageNameArray = tempImageNameArray;
        NSLog(@"%@", appDelegate.imageArray);
        NSLog(@"%@", appDelegate.imageNameArray);
    
        third* thirdView = [[third alloc] initWithNibName:@"third" bundle:nil];
        thirdView.desArray = descriptionArray;
        thirdView.checkArray = checkMarkArray;
        [self.navigationController pushViewController:thirdView animated:YES];
}

- (void) postingOnAMT{

    count++;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:count forKey:@"count"];
    [prefs synchronize];
    
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        
            //appDelegate.imageArray =[NSMutableArray arrayWithObjects:Image.image,nil];
            //appDelegate.imageArray = [[NSMutableArray alloc] init];
            //NSLog(@"%@", appDelegate.imageArray);
    
            CGSize shrinkedSize=CGSizeMake(320,320);
            UIImage *addedImage = [ViewController imageWithImage:Image.image scaledToSize:shrinkedSize];
            
            //NSLog(@"%@", appDelegate.imageArray);
    
    
            NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
            NSString *imageName = [NSString stringWithFormat:@"Image%i.png",count];
            //concatenate the docsDirectory and the filename
            NSString *imagePath = [docsDir stringByAppendingPathComponent:imageName];
            [UIImagePNGRepresentation(addedImage) writeToFile:imagePath atomically:YES];
    
            [tempImageArray addObject:addedImage];
            [tempImageNameArray addObject:imageName];
    
    //[appDelegate.imageArray addObject:[UIImage imageNamed:@"photo.png"]];
            NSString *ID = appDelegate.token;
    
    //NSLog(@"%@", appDelegate.imageArray);
        
            //NSString *ID = @"2 1";
            ID = [ID stringByReplacingOccurrencesOfString:@" "
                                       withString:@""];
            ID = [ID stringByReplacingOccurrencesOfString:@"<"
                                           withString:@""];
            ID = [ID stringByReplacingOccurrencesOfString:@">"
                                           withString:@""];
            NSLog(@"My token is: %@", ID);
        
            NSData *imageData = UIImageJPEGRepresentation(Image.image, 90);
        
            NSString *server = @"musicserver.ece.cornell.edu/~chenlab/descriptive_camera";

            //setting up the URL to post to
            //NSString *urlString = [NSString stringWithFormat:@"http://%@/~dbatra/image_upload_id.php?id=%@", server,ID];
    
    NSString *urlString = nil;
    if (uploadQuestion != nil) {
            NSString *combined = [NSString stringWithFormat:@"%@,%@",ID,uploadQuestion];
            urlString = [NSString stringWithFormat:@"http://%@/image_upload_id_with_question.php?id=%@", server,combined];
    }else{
            urlString = [NSString stringWithFormat:@"http://%@/image_upload_id.php?id=%@", server,ID];
    }
            // setting up the request object now
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            
            //add some header info now
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            //now lets create the body of the post
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //NSString *fileName = [NSString stringWithFormat:@"image%d", imageNumber];
        
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"Image%i.jpg\"\r\n",count] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            // now lets make the connection to the web
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            //NSLog(@"%s", returnString);
            NSLog(returnString);
            
            //[returnString release];
    [spinner stopAnimating];
    
}

- (void)imageSavedToPhotoAlbum:(UIImage *)UIImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *message;
    NSString *title;
    
    if (!error) {
        title = NSLocalizedString(@"", nil);
        message = NSLocalizedString(@"Succeed", nil);
    }
    else
    {
        title = NSLocalizedString(@"", nil);
        message = [error description];
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    
    [alert show];
}


- (IBAction)camera:(id)sender {
    
    picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:picker animated:YES];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [Image setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    question.hidden = false;

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    question.hidden = true;
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getResult:(id)sender {
    

    [spinner startAnimating];

    [self performSelector: @selector(gettingResults)
               withObject: nil
               afterDelay: 0];
    return;
    
}

- (IBAction)RecordQuestion:(id)sender {
    question.hidden = true;

    
    [self.fliteController say:@"Please record your question" withVoice:self.slt];


    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath languageModelIsJSGF:NO];
}

- (void) gettingResults{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    //NSData *imageData = UIImageJPEGRepresentation(Image.image, 90);
    
    NSString *server = @"musicserver.ece.cornell.edu/~chenlab/descriptive_camera";
    NSString *ID = appDelegate.token;
    //NSString *ID = @"2 1";
    ID = [ID stringByReplacingOccurrencesOfString:@" "
                                       withString:@""];
    ID = [ID stringByReplacingOccurrencesOfString:@"<"
                                       withString:@""];
    ID = [ID stringByReplacingOccurrencesOfString:@">"
                                       withString:@""];
    
    for (NSString *imageName in tempImageNameArray) {
        
    //setting up the URL to post to
    //NSString *urlString = [NSString stringWithFormat:@"http://%@/~dbatra/image_upload_id.php?id=%@", server,ID];
        NSLog(@"%@",imageName);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/getResults.php?id=%@,%@", server,ID,imageName];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    
    //add some header info now
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //now lets create the body of the post
    
    //NSMutableData *body = [NSMutableData data];
    //[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSString *fileName = [NSString stringWithFormat:@"image%d", imageNumber];
    
    //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"c.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[NSData dataWithData:imageData]];
    //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    //[request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%s", returnString);
    NSLog(returnString);
    }
    //[returnString release];
    descriptionArray = [[NSMutableArray alloc] init];
    checkMarkArray = [[NSMutableArray alloc] init];
    
    NSString *emptyDescription = [NSString stringWithFormat:@"http://musicserver.ece.cornell.edu/~chenlab/descriptive_camera/user_folders/%@/images/results",ID];
    NSURL *emptyDescriptionURL = [NSURL URLWithString:emptyDescription];
    
    NSData *data = [NSData dataWithContentsOfURL:emptyDescriptionURL];    
    NSString *empty = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   
    for (NSString *imageName in tempImageNameArray){
        
        imageDir = [imageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
        NSString *URL = [NSString stringWithFormat:@"http://musicserver.ece.cornell.edu/~chenlab/descriptive_camera/user_folders/%@/images/%@/results",ID,imageDir];
        NSURL *DescriptionURL = [NSURL URLWithString:URL];
        NSData *data = [NSData dataWithContentsOfURL:DescriptionURL];
        NSString *description = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [descriptionArray addObject:description];
        if (![description isEqualToString:empty]) {
            [checkMarkArray addObject:[UIImage imageNamed:@"gou.png"]];
        }else{
            [checkMarkArray addObject:[UIImage imageNamed:@"cross.png"]];
        }
    }
    
    [self performSelector: @selector(uploadingImages)
               withObject: nil
               afterDelay: 0];

    //third* thirdView = [[third alloc] initWithNibName:@"third" bundle:nil];
    //thirdView.desArray = descriptionArray;
    //thirdView.checkArray = checkMarkArray;
    //[self.navigationController pushViewController:thirdView animated:YES];

    //second* secondView = [[second alloc] initWithNibName:@"second" bundle:nil];
    //[self.navigationController pushViewController:secondView animated:YES];
    [spinner stopAnimating];
}
- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
    [self.pocketsphinxController stopListening];
    
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    [self.fliteController say:[NSString stringWithFormat:@"Your question is %@",hypothesis] withVoice:self.slt];
    
    uploadQuestion = [hypothesis lowercaseString];
    Text.text =  [NSString stringWithFormat:@"%@",uploadQuestion];
    uploadQuestion = [Text.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    Text.hidden = false;
    [self performSelector: @selector(showSiri)
               withObject: nil
               afterDelay: 0];
}

- (void) showSiri{
    question.hidden = false;
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([Text isFirstResponder] && [touch view] != Text) {
        [Text resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}
@end


