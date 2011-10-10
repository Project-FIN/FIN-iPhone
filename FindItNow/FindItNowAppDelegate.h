//
//  FindItNowAppDelegate.h
//  FindItNow
//
//  Created by Eric Hare on 5/7/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetRegionViewController.h"
#import "FINDatabase.h"

@class FindItNowViewController;

@interface FindItNowAppDelegate : NSObject <UIApplicationDelegate, RegionViewControllerDelegate> {
    FINDatabase *db;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FindItNowViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController   *navigationController;
@end
