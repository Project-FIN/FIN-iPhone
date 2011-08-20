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
    NSString* parentCategory;
}
@property (nonatomic,retain) IBOutlet UIView* allView;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil initSubcategory:(NSArray*) subcate MapView:(MapViewController*) map Category:(NSString*) cate;
-(IBAction) removeSelf;
@end
