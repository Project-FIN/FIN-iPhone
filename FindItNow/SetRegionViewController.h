//
//  SetRegionViewController.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/21.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "FINDatabase.h"
#import "JSONKit.h"
#import "Reachability.h"

@class Reachability;
@protocol RegionViewControllerDelegate <NSObject>
- (void)didDismissRegionSelectView;
@end

@interface SetRegionViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>
{
    IBOutlet UIPickerView *pickerView;   
    NSArray *data;
    UIWindow *window;
    FINDatabase *db;
    SQLiteManager *dbManager;
    IBOutlet UIButton *confirmBtn;
    IBOutlet UIButton *cancelBtn;
    id<RegionViewControllerDelegate> *delegate;
        
    Reachability *internetReachable;
    Reachability *hostReachable;
}
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) id<RegionViewControllerDelegate> *delegate;

- (void) setWindow:(UIWindow*) win;
- (void) getRegionsList;
- (NSNumber*) getRIDFromRegion:(NSString*)region;
-(IBAction) confirmSelection:(id) sender;
-(IBAction) cancelSelection:(id) sender;
-(void) updateDB:(id) sender;
-(void) removeIndicatorForUpdate:(id) sender;
-(void) removeIndicatorForRegion:(id) sender;
-(void) checkNetworkStatus:(NSNotification *)notice;
-(void) performGetRegion:(id) sender;
-(void) setPickerViewDefault;
@end
