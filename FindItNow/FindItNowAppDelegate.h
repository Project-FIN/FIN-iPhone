//
//  FindItNowAppDelegate.h
//  FindItNow
//
//  Created by Eric Hare on 5/7/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindItNowViewController;

@interface FindItNowAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FindItNowViewController *viewController;

@end