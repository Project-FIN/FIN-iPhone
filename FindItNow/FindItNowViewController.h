//
//  FindItNowViewController.h
//  FIN
//
//  Created by Eric Hare on 5/7/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetRegionViewController.h"
@class MenuView;

@interface FindItNowViewController : UIViewController <UIActionSheetDelegate, RegionViewControllerDelegate> {
    
}
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

-(IBAction) showActionSheet:(id)sender;

@end
