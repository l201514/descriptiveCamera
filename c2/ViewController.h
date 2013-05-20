//
//  ViewController.h
//  c2
//
//  Created by Siqi Li on 10/11/12.
//  Copyright (c) 2012 Siqi Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,OpenEarsEventsObserverDelegate> {
    FliteController *fliteController;
    Slt *slt;
    PocketsphinxController *pocketsphinxController;
    OpenEarsEventsObserver *openEarsEventsObserver;
    UITextView  *Text;
    }
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;

@property (nonatomic) NSInteger count;
@property (strong, nonatomic) NSMutableArray *tempImageArray;
@property (strong, nonatomic) NSMutableArray *tempImageNameArray;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITextView  *Text;
@property (strong, nonatomic) IBOutlet UIImageView *Image;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (strong, nonatomic) IBOutlet UIButton *question;

- (IBAction)camera:(id)sender;
- (IBAction)gallary:(id)sender;
- (IBAction)option:(id)sender;
- (IBAction)getResult:(id)sender;
- (IBAction)RecordQuestion:(id)sender;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
