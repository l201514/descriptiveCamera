//
//  second.m
//  DescriptiveCamera
//
//  Created by Siqi Li on 3/10/13.
//  Copyright (c) 2013 Siqi Li. All rights reserved.
//

#import "second.h"
#import "AppDelegate.h"

@interface second ()

@end

@implementation second
@synthesize image,descriptions;

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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *ID = appDelegate.token;
    //NSString *ID = @"2 1";
    ID = [ID stringByReplacingOccurrencesOfString:@" "
                                       withString:@""];
    ID = [ID stringByReplacingOccurrencesOfString:@"<"
                                       withString:@""];
    ID = [ID stringByReplacingOccurrencesOfString:@">"
                                       withString:@""];
    
    NSString *imageURLString = [NSString stringWithFormat:@"http://musicserver.ece.cornell.edu/~chenlab/descriptive_camera/user_folders/%@/images/c.jpg",ID];
    NSString *descriptionsURLString = [NSString stringWithFormat:@"http://musicserver.ece.cornell.edu/~chenlab/descriptive_camera/user_folders/%@/images/results",ID];
    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
    [image loadRequest:imageRequest];
    
    NSURL *descriptionURL = [NSURL URLWithString:descriptionsURLString];
    NSURLRequest *descriptionRequest = [NSURLRequest requestWithURL:descriptionURL];
    [descriptions loadRequest:descriptionRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
