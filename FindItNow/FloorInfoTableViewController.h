//
//  FloorInfoTableViewController.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/1.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FloorInfoTableViewController : UITableViewController {
    NSInteger numSection;
    NSMutableArray *selectedRowIndeices;
}
-(BOOL) selectionIncludesSection:(NSInteger)section;
@end
