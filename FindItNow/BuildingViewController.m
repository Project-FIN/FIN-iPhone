//
//  BuildingViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/27.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "BuildingViewController.h"
#import "MapViewController.h"

@implementation BuildingViewController
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"];
    
    buildings = [self getBuildingsList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.title = @"Buildings";
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


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [buildings count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [buildings objectAtIndex: [indexPath row]];
    
    // Configure the cell.
    return cell;
}

- (NSArray*)getBuildingsList
{   
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT name FROM buildings WHERE deleted = 0"];
    NSArray *buildingsList = [dbManager getRowsForQuery:sqlStr];
        
    NSMutableArray *building = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in buildingsList) {
        [building addObject:[dict objectForKey:@"name"]];
    }
    
    return building;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mapView = [ [MapViewController alloc] initWithNibName:@"MapViewController" bundle:[mapView nibBundle]];
    [mapView setCurrentCategory:@"Coffee"];
    [mapView setCurrentBuilding:[buildings objectAtIndex: [indexPath row]]];
    [self.navigationController pushViewController:mapView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)dealloc
{
    [buildingTable release];
    [super dealloc];
}

@end
