//
//  BuildingViewController.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/27.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BuildingViewController : UITableViewController {
    UITableView *buildingTable;
}
@property (nonatomic, retain) IBOutlet UITableView *buildingTable;
@end