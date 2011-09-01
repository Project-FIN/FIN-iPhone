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

@interface SetRegionViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>
{
    IBOutlet UIPickerView *pickerView;   
    NSArray *data;
    UIWindow *window;
    FINDatabase *db;
    SQLiteManager *dbManager;
}
- (void) setWindow:(UIWindow*) win;
- (NSMutableArray*) getRegionsList;
- (NSNumber*) getRIDFromRegion:(NSString*)region;

@end