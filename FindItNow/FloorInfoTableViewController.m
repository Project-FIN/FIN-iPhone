//
// FloorInfoTableViewController.m
// FindItNow
//
// Created by Chanel Huang on 2011/8/1.
// Copyright 2011ๅนด University of Washington. All rights reserved.
//

#import "FloorInfoTableViewController.h"


@implementation FloorInfoTableViewController

const int detailcellMargin = 10;
const int fontSizeSpace = 18;
const int reportBtnHeight = 0;//30;
const int reportBtnWidth = 0;//60;


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
    }
    return self;
}

- (void)dealloc
{
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if ( [self selectionIncludesSection:indexPath.section] && 1 == indexPath.row && !isDoubleExpendable){
        [self removeSubviewsForIndexPath:indexPath];
        [self setCellForDetailView:cell WithTableView:tableView data:[dataDict objectForKey:[floors objectAtIndex:indexPath.section]]];
    }else if ([self selectionIncludesSection:indexPath.section] && isDoubleExpendable && 1 <= indexPath.row)
    {
        if ([selectedChildRow containsObject:indexPath]){
            [self removeSubviewsForIndexPath:indexPath];
            NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
            NSString *str = [cateItem objectForKey:[[self subCategory:cateItem] objectAtIndex:(indexPath.row-1)/2]];
            str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            [self setCellForDetailView:cell WithTableView:tableView data:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:str,nil] forKeys:[[NSArray alloc] initWithObjects:@"",nil]]];
        }else{
            NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
            cell.textLabel.text = [[self subCategory:cateItem] objectAtIndex:(indexPath.row-1)/2];
        }
    }
    else{
        cell.textLabel.text =[floors objectAtIndex:indexPath.section];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row >= 1 ) {
        return 1;
    }
    return 0;
    
}

-(void) setCellForDetailView:(UITableViewCell *) cell WithTableView:(UITableView *) tableView data:(NSDictionary*) data
{
    cell.textLabel.text = @"";
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.frame)-10, 45)];
    detail.font = [UIFont systemFontOfSize:12.0f];
    [detail setBackgroundColor:[UIColor clearColor]];
    detail.textAlignment = UITextAlignmentLeft;
    detail.numberOfLines = 0;
    
    NSString *str = [data objectForKey:[[data keyEnumerator] nextObject]] ;
    NSArray *textline = [str componentsSeparatedByString:@"\\n"];
    str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [detail setText:str];
    detail.frame = CGRectMake(CGRectGetMinX(detail.frame), CGRectGetMinY(detail.frame), CGRectGetWidth(detail.frame),[textline count]*fontSizeSpace );
    [cell.contentView addSubview:detail];
    
    /*UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    butt.frame = CGRectMake(CGRectGetMaxX(tableView.frame)-(reportBtnWidth+detailcellMargin), CGRectGetMaxY(detail.frame), reportBtnWidth, reportBtnHeight);
    [butt setTitle:@"Report!" forState:UIControlStateNormal];
    [cell.contentView addSubview:butt];*/
    
}

-(NSArray*) subCategory:(NSDictionary*) data
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:5];
    for(NSString* str in [data keyEnumerator])
    {
        [result addObject:str];
    }
    return result;
}

-(void) removeSubviewsForIndexPath:(NSIndexPath*)indexPath
{
    for(UIView *subView in [self.tableView cellForRowAtIndexPath:indexPath].contentView.subviews)
    {
        [subView removeFromSuperview];
    }
}
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
            [self removeSubviewsForIndexPath:[insert objectAtIndex:0]];
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
        NSIndexPath *childCell = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        
        if ( !([indexPath section]+1 >= [dataDict count])){
            [reload addObject:[NSIndexPath indexPathForRow:[indexPath row] inSection:indexPath.section+1]];
        }
        
        if (isDoubleExpendable){
            delete = [[NSMutableArray alloc] initWithCapacity:3];
            for (int i = 0; i < [[dataDict objectForKey:[floors objectAtIndex:indexPath.section]] count]*2; i++){
                [delete addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
                [self removeSubviewsForIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
            }
            baseHeight -= [delete count]*45;
        }else{
            NSDictionary *cateItem = [dataDict objectForKey:[floors objectAtIndex:indexPath.section]];
            NSString *str = [cateItem objectForKey:[[cateItem keyEnumerator] nextObject]] ;
            baseHeight -= [self heightBaseOnContent:str];
        }
        
        selectedChildRow = [[NSMutableArray alloc] initWithCapacity:5];
        [self removeSubviewsForIndexPath:childCell];
        
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
        //[tableView reloadData];
        [tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
        [tableView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (baseHeight <= 0)
        baseHeight = 45;
    else if (baseHeight > 180)
        baseHeight = 180;
    
    [self.tableView.superview setFrame:CGRectMake(CGRectGetMinX(self.tableView.superview.frame), CGRectGetMinY(self.tableView.superview.frame), CGRectGetWidth(self.tableView.superview.frame), CGRectGetHeight(self.tableView.superview.frame)-self.tableView.frame.size.height+baseHeight)];
    
    [self.tableView setFrame:CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), CGRectGetWidth(self.tableView.frame), baseHeight)];
                              
    NSLog(@"%f", self.tableView.contentSize.height);
}

@end

