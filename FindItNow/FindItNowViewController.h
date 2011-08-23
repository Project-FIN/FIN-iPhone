//
//  FindItNowViewController.h
//  FindItNow
//
//  Created by Eric Hare on 5/7/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuView;

@interface FindItNowViewController : UIViewController <UIActionSheetDelegate> {
    
}
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

-(IBAction) showActionSheet:(id)sender;

@end
