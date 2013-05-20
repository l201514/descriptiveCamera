//
//  Cell.h
//  DescriptiveCamera
//
//  Created by Siqi Li on 4/3/13.
//  Copyright (c) 2013 Siqi Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@property (strong, nonatomic) IBOutlet UIImageView *cross;
@end
