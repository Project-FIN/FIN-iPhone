//
//  SubcategoryListController.h
//  FIN
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
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil initSubcategory:(NSArray*) subcate MapView:(MapViewController*) map Category:(NSString*) cate;

@end
