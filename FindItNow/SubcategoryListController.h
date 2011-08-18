//
//  SubcategoryListController.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/10.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;

@interface SubcategoryListController : UITableViewController {
    NSArray* subcategories;
    MapViewController *mapView;
}
@property (nonatomic,retain) IBOutlet UINavigationBar* naviBar;
-(id) initSubcategory:(NSArray*) subcate MapView:(MapViewController*) map;
-(IBAction) removeSelf;
@end
