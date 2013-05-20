//
//  CellView.h
//  DescriptiveCamera
//
//  Created by Siqi Li on 4/10/13.
//  Copyright (c) 2013 Siqi Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>



@interface CellView : UIViewController{
    FliteController *fliteController;
    Slt *slt;
}
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;

@property (nonatomic) NSMutableArray *desArray;
@property (nonatomic) NSInteger *index;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (IBAction)speaker:(id)sender;

@end
