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
    NSMutableArray *selectedChildRow;   //for double expendable only
    NSArray *dataArray;
    NSMutableArray *floors;
    BOOL isDoubleExpendable;
}
-(BOOL) selectionIncludesSection:(NSInteger)section;
-(void) setData:(NSArray*) data;
- (id)initWithDict:(NSArray*) data andIsDoubleExpendable:(BOOL) isDouble;
-(void) removeSubviewsForIndexPath:(NSIndexPath*) indexPath;
-(void) setCellForDetailView:(UITableViewCell *) cell WithTableView:(UITableView *) tableView index:(int) index;
@end
