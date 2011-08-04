//
//  MenuViewController.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/26.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapViewController;

@interface MenuViewController : UIViewController {
    
}
@property (nonatomic, retain) IBOutlet MapViewController *mapView;
@property (nonatomic, retain) IBOutlet UILabel *text;
@property (nonatomic, retain) IBOutlet UIScrollView *btnGrid;

- (IBAction) getCategory ;
- (IBAction)map;
- (void) initBtnGrid;
- (void) saveCategory;
- (void) getCategoryList;

@end
