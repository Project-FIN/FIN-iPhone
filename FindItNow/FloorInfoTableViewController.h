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
    NSDictionary *dataDict;
    NSArray *floors;
    BOOL isDoubleExpendable;
    NSDictionary *cateNameToIcon;
}
-(BOOL) selectionIncludesSection:(NSInteger)section;
- (id)initWithDict:(NSDictionary*) data Floors:(NSArray*) flr andIsDoubleExpendable:(BOOL) isDouble;
//-(void) removeSubviewsForCell:(UITableViewCell*) cell;
-(void) setCellForDetailView:(UITableViewCell *) cell WithTableView:(UITableView *) tableView data:(NSDictionary*) data;
-(NSArray*) subCategory:(NSDictionary*) data;
-(CGFloat) heightBaseOnContent:(NSString*) data;
- (NSDictionary*) getCategoryIconDictionary;
@end
