//
//  AppDelegate.h
//  c2
//
//  Created by Siqi Li on 10/11/12.
//  Copyright (c) 2012 Siqi Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *token;
    NSMutableArray *imageArray;
    NSMutableArray *imageNameArray;
}

@property (nonatomic) NSMutableArray *imageArray;
@property (nonatomic) NSMutableArray *imageNameArray;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic) NSString *token;

@property(nonatomic, retain) UINavigationController *navController;
@end
