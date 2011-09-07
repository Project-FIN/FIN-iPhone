//
// FloorInfoTableViewController.m
// FindItNow
//
// Created by Chanel Huang on 2011/8/1.
// Copyright 2011ๅนด University of Washington. All rights reserved.
//

#import "FloorInfoTableViewController.h"
#import "InfoPopUpView.h"
#import "SQLiteManager.h"

@implementation FloorInfoTableViewController

const int detailcellMargin = 10;
const int fontSizeSpace = 18;
const int reportBtnHeight = 0;//30;
const int reportBtnWidth = 0;//60;


#define DETAIL_TAG 1
#define DETAIL_BUTTON 2
#define CATEIMG_START 2
#define FLR_TITLE 1

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        selectedRowIndeices = [[NSMutableArray alloc] initWithCapacity:numSection];
        floors = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}
- (id)initWithDict:(NSMutableDictionary*) data Floors:(NSArray*) flr andIsDoubleExpendable:(BOOL) isDouble
{
    self = [super init];
    if (self){
        selectedRowIndeices = [[NSMutableArray alloc] initWithCapacity:numSection];
        selectedChildRow = [[NSMutableArray alloc] initWithCapacity:numSection];
        floors = flr;
        isDoubleExpendable = isDouble;
        dataDict = data;
        cateNameToIcon = [self getCategoryIconDictionary];
    }
    return self;
}

- (void)dealloc
{
    [cateNameToIcon release];
    [selectedChildRow release];
    [selectedRowIndeices release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) isSubcategory:(NSString *) cat {
    SQLiteManager *dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"] autorelease];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT parent FROM categories WHERE full_name = '%s'", (const char*)[cat UTF8String]];
    NSArray *arr = [dbManager getRowsForQuery:sqlStr];
    NSDictionary *parents = [arr objectAtIndex:0];
    
    return ([[parents objectForKey:@"parent"] intValue] != 0);
}

- (NSDictionary*) getCategoryIconDictionary
{
    SQLiteManager *dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"] autorelease];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT name, full_name FROM categories WHERE deleted = 0"];
    NSArray *categoriesList = [dbManager getRowsForQuery:sqlStr];
    
    //don't auto release icon as well;
    NSMutableDictionary *icons = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in categoriesList) {
        NSString *mapName = [dict objectForKey:@"name"];
        if ([self isSubcategory:[dict objectForKey:@"full_name"]]) {
            sqlStr = [NSString stringWithFormat:@"SELECT parent FROM categories WHERE full_name = '%s'", (const char*)[[dict objectForKey:@"full_name"] UTF8String]];
            NSArray *arr = [dbManager getRowsForQuery:sqlStr];
            NSDictionary *parents = [arr objectAtIndex:0];
            
            int parent_id = [[parents objectForKey:@"parent"] intValue];
            
            sqlStr = [NSString stringWithFormat:@"SELECT name FROM categories WHERE cat_id = %d", parent_id];
            arr = [dbManager getRowsForQuery:sqlStr];
            parents = [arr objectAtIndex:0];
            
            mapName = [parents objectForKey:@"name"];
            NSLog(@"%@", mapName);
        }
        [icons setObject:mapName forKey:[dict objectForKey:@"full_name"]];
    }
    return icons;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [floors count];
}

-(BOOL) selectionIncludesSection:(NSInteger) section
{
    for (NSIndexPath *index in selectedRowIndeices)
    {
        if (index.section == section)
            return YES;
    }
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self selectionIncludesSection:section])
    {
        return (isDoubleExpendable)? [[dataDict objectForKey:[floors objectAtIndex:section]] count]*2+1: 2;
    }
    return 1;
}

-(CGFloat) heightBaseOnContent:(NSString*) str
{
    NSArray *textline = [str componentsSeparatedByString:@"\\n"];
    //str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return [textline count]*fontSizeSpace + reportBtnHeight + detailcellMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0){
        return 45;
    } else if ([self selectionIncludesSection:indexPath.section] && indexPath.row == 1 && !isDoubleExpendable)
    {
        NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
        NSString *str = [cateItem objectForKey:[[cateItem keyEnumerator] nextObject]] ;
        return [self heightBaseOnContent:str];
    } else if ( isDoubleExpendable && [self selectionIncludesSection:indexPath.section] && indexPath.row % 2 == 1){
        return 45;
    } else if ([selectedChildRow containsObject:indexPath] && isDoubleExpendable){
        NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
        NSString *str = [cateItem objectForKey:[[self subCategory:cateItem] objectAtIndex:(indexPath.row-1)/2]];
        return [self heightBaseOnContent:str];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ( [self selectionIncludesSection:indexPath.section] && 1 == indexPath.row && !isDoubleExpendable){
        NSString *CellIdentifier = @"DetailCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            UILabel *detail = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.frame)-10, 45)] autorelease];
            detail.tag = DETAIL_TAG;
            [detail setTextColor:[UIColor whiteColor]];
            [cell.contentView addSubview:detail];
        }
        [self setCellForDetailView:cell WithTableView:tableView data:[dataDict objectForKey:[floors objectAtIndex:indexPath.section]]];
    }else if ([self selectionIncludesSection:indexPath.section] && isDoubleExpendable && 1 <= indexPath.row)
    {
        if ([selectedChildRow containsObject:indexPath]){
            NSString *CellIdentifier = @"DetailCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                UILabel *detail = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.frame)-10, 45)] autorelease];
                detail.tag = DETAIL_TAG;
                [detail setTextColor:[UIColor whiteColor]];
                [cell.contentView addSubview:detail];
            }
            NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
            NSArray *subCate = [self subCategory:cateItem];            
            NSString *str = [cateItem objectForKey:[subCate objectAtIndex:(indexPath.row-1)/2]];
            NSArray *obj = [NSArray arrayWithObjects:str,nil];
            NSArray *key = [NSArray arrayWithObjects:@"",nil];
            NSDictionary *data = [NSDictionary dictionaryWithObjects:obj forKeys:key];
            [self setCellForDetailView:cell WithTableView:tableView data:data];
        }else{
            NSString *CellIdentifier = @"CateCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
            }
            NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
            NSArray *subCate = [self subCategory:cateItem];
            cell.textLabel.text = [subCate objectAtIndex:(indexPath.row-1)/2];
        }
    }
    else{
        NSString *CellIdentifier = @"FlrCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            [cell setContentMode:UIViewContentModeCenter];
            for (int i = 0; i < 5; i++){
                UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(tableView.frame)-((i+1)*40), 5, 36, 36)] autorelease];
                [imageView setContentMode:UIViewContentModeCenter];
                [imageView setBackgroundColor:[UIColor clearColor]];
                imageView.tag = i+CATEIMG_START;
                [cell.contentView addSubview:imageView];
            }
            UILabel *title = [[[UILabel alloc] initWithFrame:CGRectMake(10,0,CGRectGetWidth(tableView.frame), 45)] autorelease];
            [title setFont:[UIFont boldSystemFontOfSize:20.0f]];
            [title setBackgroundColor:[UIColor clearColor]];
            [title setTextColor:[UIColor whiteColor]];
            title.tag = FLR_TITLE;
            [cell.contentView addSubview:title];
        }
        NSString *str =[floors objectAtIndex:indexPath.section];
        cell.textLabel.text = @"";
        
        NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
        for (int i = 0; i < 5; i++){
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i+CATEIMG_START];
            imageView.image = nil;
        }
        int i = 0;
        
        for (NSString* cate in [cateItem keyEnumerator]){
            NSString *iconName = [NSString stringWithFormat:@"%@_small", [cateNameToIcon objectForKey:cate]];
            UIImage *image = [UIImage imageNamed:iconName];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i+CATEIMG_START];
            [imageView setImage:image];
            i++;
        }
        UILabel *title = (UILabel*)[cell.contentView viewWithTag:FLR_TITLE];
        title.text=str;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == 1 ) {
        return 1;
    } else if (indexPath.row >= 2){
        return 3;
    }
    return 0;
    
}

-(void) setCellForDetailView:(UITableViewCell *) cell WithTableView:(UITableView *) tableView data:(NSDictionary*) data
{
    cell.textLabel.text = @"";
    UILabel *detail = (UILabel*)[cell.contentView viewWithTag:DETAIL_TAG];
    detail.font = [UIFont systemFontOfSize:12.0f];
    [detail setBackgroundColor:[UIColor clearColor]];
    detail.textAlignment = UITextAlignmentLeft;
    detail.numberOfLines = 0;
    
    NSString *str = [data objectForKey:[[data keyEnumerator] nextObject]] ;
    NSArray *textline = [str componentsSeparatedByString:@"\\n"];
    str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [detail setText:str];
    detail.frame = CGRectMake(CGRectGetMinX(detail.frame), CGRectGetMinY(detail.frame), CGRectGetWidth(detail.frame),[textline count]*fontSizeSpace );
    
    /*UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     butt.frame = CGRectMake(CGRectGetMaxX(tableView.frame)-(reportBtnWidth+detailcellMargin), CGRectGetMaxY(detail.frame), reportBtnWidth, reportBtnHeight);
     [butt setTitle:@"Report!" forState:UIControlStateNormal];
     [cell.contentView addSubview:butt];*/
    
}

-(NSArray*) subCategory:(NSDictionary*) data
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:3];
    for(NSString* str in [data keyEnumerator])
    {
        [result addObject:str];
    }
    return result;
}

/*-(void) removeSubviewsForCell:(UITableViewCell *)cell
 {
 for(UIView *subView in cell.contentView.subviews)
 {
 [subView removeFromSuperview];
 }
 }*/
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    float baseHeight = self.tableView.frame.size.height;
    
    if (isDoubleExpendable && indexPath.row >= 1 && indexPath.row%2 == 1){
        NSMutableArray *insert = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:[indexPath row]+1 inSection:indexPath.section]];
        // NSArray *reload = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[indexPath row] inSection:indexPath.section],
        //[NSIndexPath indexPathForRow:[indexPath row]+2 inSection:indexPath.section], nil];
        
        if ([selectedChildRow containsObject:[insert objectAtIndex:0]]){
            baseHeight -= [self.tableView cellForRowAtIndexPath:[insert objectAtIndex:0]].frame.size.height;
            baseHeight = MAX(baseHeight, [floors count]*45);
            //[self removeSubviewsForCell:[tableView cellForRowAtIndexPath:[insert objectAtIndex:0]]];
            [selectedChildRow removeObject:[insert objectAtIndex:0]];
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationBottom];
            [tableView endUpdates];
        } else{
            [selectedChildRow addObject:[insert objectAtIndex:0]];
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
            NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
            NSString *str = [cateItem objectForKey:[[self subCategory:cateItem] objectAtIndex:(indexPath.row)/2]];
            baseHeight += [self heightBaseOnContent:str];
        }
        
    }else if ( [selectedRowIndeices containsObject:indexPath] )
    {
        NSMutableArray *delete = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]] ];
        NSMutableArray *reload = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:[indexPath row] inSection:indexPath.section]];
        //NSIndexPath *childCell = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        
        if ( !([indexPath section]+1 >= [dataDict count])){
            [reload addObject:[NSIndexPath indexPathForRow:[indexPath row] inSection:indexPath.section+1]];
        }
        
        if (isDoubleExpendable){
            delete = [NSMutableArray arrayWithCapacity:3];
            for (int i = 0; i < [[dataDict objectForKey:[floors objectAtIndex:indexPath.section]] count]*2; i++){
                [delete addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
                //[self removeSubviewsForCell:[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]]];
            }
            baseHeight -= [delete count]*45;
            baseHeight = MAX(baseHeight, [floors count]*45);
        }else{
            NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
            NSString *str = [cateItem objectForKey:[[cateItem keyEnumerator] nextObject]] ;
            baseHeight -= [self heightBaseOnContent:str];
            baseHeight = MAX(baseHeight, [floors count]*45);
        }
        
        selectedChildRow = [[NSMutableArray alloc] initWithCapacity:5];
        //[self removeSubviewsForCell:[tableView cellForRowAtIndexPath:childCell]];
        
        [selectedRowIndeices removeObject:indexPath];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationBottom];
        [tableView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }else if(indexPath.row == 0)
    {
        [selectedRowIndeices addObject:indexPath];
        
        NSMutableArray *insert = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:[indexPath row]+1 inSection:indexPath.section]];
        NSMutableArray *reload = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:[indexPath row] inSection:indexPath.section]];
        
        if ( !([indexPath section]+1 >= [dataDict count])){
            [reload addObject:[NSIndexPath indexPathForRow:[indexPath row] inSection:indexPath.section+1]];
        }
        if (isDoubleExpendable){
            insert = [NSMutableArray arrayWithCapacity:[dataDict count]*2];
            for (int i = 0; i < [[dataDict objectForKey:[floors objectAtIndex:indexPath.section]] count]*2; i++)
                [insert addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
            baseHeight += [insert count]*45;
        }else{
            NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
            NSString *str = [cateItem objectForKey:[[cateItem keyEnumerator] nextObject]] ;
            baseHeight += [self heightBaseOnContent:str];
        }
        
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
        //[tableView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (baseHeight <= 0)
        baseHeight = 45;
    else if (baseHeight > 180)
        baseHeight = 180;
    
    [self.tableView.superview setFrame:CGRectMake(CGRectGetMinX(self.tableView.superview.frame), CGRectGetMinY(self.tableView.superview.frame)+(self.tableView.frame.size.height/2)-(baseHeight/2), CGRectGetWidth(self.tableView.superview.frame), CGRectGetHeight(self.tableView.superview.frame)-self.tableView.frame.size.height+baseHeight)];
    
    [self.tableView setFrame:CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), CGRectGetWidth(self.tableView.frame), baseHeight)];
    
    InfoPopUpView *superView = self.tableView.superview;
    [superView removeExitTapArea];
    [superView addExitTapGesture];
    
}

@end