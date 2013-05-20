//
//  CellView.m
//  DescriptiveCamera
//
//  Created by Siqi Li on 4/10/13.
//  Copyright (c) 2013 Siqi Li. All rights reserved.
//

#import "CellView.h"
#import "AppDelegate.h"

@interface CellView ()

@end

@implementation CellView
@synthesize imageView,myTextView,desArray,index,spinner;
@synthesize fliteController;
@synthesize slt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate.imageArray objectAtIndex:index];
    [imageView setImage:[appDelegate.imageArray objectAtIndex:index]];
    [myTextView setText:[desArray objectAtIndex:index]];
    
    //[self.fliteController say:[desArray objectAtIndex:index] withVoice:self.slt];
    //[self performSelector: @selector(speak) withObject: nil afterDelay: 0];
}

- (void)speak
{
    [self.fliteController say:[desArray objectAtIndex:index] withVoice:self.slt];
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)speaker:(id)sender {
    [spinner startAnimating];
    [self performSelector: @selector(speak) withObject: nil afterDelay: 0];
}
@end
