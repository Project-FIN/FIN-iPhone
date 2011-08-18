//
//  BuildingViewController.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/27.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "JSONKit.h"

@class MapViewController;

@interface BuildingViewController : UITableViewController {
    SQLiteManager *dbManager;
    
    UITableView *buildingTable;
    NSArray *buildings;
}
@property (nonatomic, retain) IBOutlet MapViewController *mapView;

- (NSArray*) getBuildingsList;

@end
