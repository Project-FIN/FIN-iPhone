//
//  MenuViewController.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/26.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "JSONKit.h"

@class MapViewController;
@class SubcategoryListController;

@interface MenuViewController : UIViewController {
    
    SQLiteManager *dbManager;
}
@property (nonatomic, retain) IBOutlet MapViewController *mapView;
@property (nonatomic, retain) IBOutlet UILabel *text;
@property (nonatomic, retain) IBOutlet UIScrollView *btnGrid;

- (IBAction)map:(id) sender;
- (void) initBtnGrid;

- (NSArray*) getCategoryList;
- (NSDictionary*) getCategoryIconDictionary;
- (NSArray*) hasChildrenCategory:(NSString*) cate;

@end
