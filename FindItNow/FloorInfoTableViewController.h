//
//  FloorInfoTableViewController.h
//  FIN
//
//  Created by Chanel Huang on 2011/8/1.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FloorInfoTableViewController : UITableViewController/*<UISearchDisplayDelegate, UISearchBarDelegate>*/ {
    NSInteger numSection;
    NSMutableArray *selectedRowIndeices;
    NSMutableArray *selectedChildRow;   //for double expendable only
    NSDictionary *dataDict;
    NSArray *floors;
    BOOL isDoubleExpendable;
    NSDictionary *cateNameToIcon;
    
   /* NSArray         *listContent;           // The master content.
    NSMutableArray  *filteredListContent;   // The content filtered as a result of a search.
    
    // The saved state of the search UI if a memory warning removed the view.
    NSString        *savedSearchTerm;
    NSInteger       savedScopeButtonIndex;
    BOOL            searchWasActive;*/
}
-(BOOL) selectionIncludesSection:(NSInteger)section;
- (id)initWithDict:(NSDictionary*) data Floors:(NSArray*) flr andIsDoubleExpendable:(BOOL) isDouble;
//-(void) removeSubviewsForCell:(UITableViewCell*) cell;
-(void) setCellForDetailView:(UITableViewCell *) cell WithTableView:(UITableView *) tableView data:(NSDictionary*) data indexPath:(NSIndexPath*)indexPath;
-(NSArray*) subCategory:(NSDictionary*) data;
-(CGFloat) heightBaseOnContent:(NSString*) data;
- (NSDictionary*) getCategoryIconDictionary;
-(UITableViewCell*) createDetailCellwithTableView:(UITableView *)tableView;
@end
