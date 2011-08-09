//
//  FloorInfoTableViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/1.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "FloorInfoTableViewController.h"


@implementation FloorInfoTableViewController

const int detailcellMargin = 10;
const int fontSizeSpace = 15;
const int reportBtnHeight = 30;
const int reportBtnWidth = 60;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        numSection = 5;
        selectedRowIndeices = [[NSMutableArray alloc] initWithCapacity:numSection];
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
    return numSection;
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
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self selectionIncludesSection:indexPath.section] && indexPath.row == 1)
    {
        NSString *str = @"Snack, Soda\nOpen 25 hr 7 days a week\nAnd 366 Days a Year\nFor TESTING ONLY";
        NSArray *textline = [str componentsSeparatedByString:@"\n"];
        return [textline count]*fontSizeSpace + reportBtnHeight + detailcellMargin;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if ( [self selectionIncludesSection:indexPath.section] && 1 == indexPath.row){
        cell.textLabel.text = @"";
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.frame)-10, 45)];
        detail.font = [UIFont boldSystemFontOfSize:10.0f];
        [detail setBackgroundColor:[UIColor clearColor]];
        detail.textAlignment = UITextAlignmentLeft;
        detail.numberOfLines = 0;
        NSString *str = @"Snack, Soda\nOpen 25 hr 7 days a week\nAnd 366 Days a Year\nFor TESTING ONLY";
        [detail setText:str];
        NSArray *textline = [str componentsSeparatedByString:@"\n"];
        detail.frame = CGRectMake(CGRectGetMinX(detail.frame), CGRectGetMinY(detail.frame), CGRectGetWidth(detail.frame),[textline count]*fontSizeSpace );
        [cell.contentView addSubview:detail];
        
        
        UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        butt.frame = CGRectMake(CGRectGetMaxX(tableView.frame)-(reportBtnWidth+detailcellMargin), CGRectGetMaxY(detail.frame), reportBtnWidth, reportBtnHeight);
        [butt setTitle:@"Report!" forState:UIControlStateNormal];
        [cell.contentView addSubview:butt];
        
    }else{
        cell.textLabel.text = [NSMutableString stringWithFormat:@"Floor %d", [indexPath section] ];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ( [selectedRowIndeices containsObject:indexPath] )
    {
        //NSArray *delete = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]] ];
        
        NSIndexPath *childCell = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];

        for(UIView *subView in [tableView cellForRowAtIndexPath:childCell].contentView.subviews)
        {
            [subView removeFromSuperview];
        }
            
        [selectedRowIndeices removeObject:indexPath];
        //[tableView beginUpdates];
        //[tableView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationBottom];
        [tableView reloadData];
        //[tableView endUpdates];
    }else if(indexPath.row == 0)
    {
        [selectedRowIndeices addObject:indexPath];
        
        //NSArray *insert = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[indexPath row] inSection:indexPath.section+1]];
                       
        //[tableView beginUpdates];
        [tableView reloadData];
        //[tableView reloadRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
        //[tableView endUpdates];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
