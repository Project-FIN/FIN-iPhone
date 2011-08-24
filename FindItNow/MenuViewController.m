//
//  MenuViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/26.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "MenuViewController.h"
#import "MapViewController.h"
#import "SubcategoryListController.h"
#import "FindItNowViewController.h"

@implementation MenuViewController
@synthesize mapView;
@synthesize btnGrid;
@synthesize text;

- (void) initBtnGrid
{
    NSArray *categories = [self getCategoryList];
    NSDictionary *icons = [self getCategoryIconDictionary];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[categories count]];
    int btnSize = ( CGRectGetWidth(btnGrid.frame) - 180 )/2;
    //int btnWidth = CGRectGetWidth(btnGrid.frame) / ([categories count
    for (int i=0; i < [categories count]; i = i+1) {
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(((i%2)*(btnSize+80))+20, (10+(i/2)*(50+btnSize)), btnSize+60, btnSize+40)];
        [btnView setBackgroundColor:[UIColor colorWithRed:185/255.0 green:245/255.0 blue:108/255.0 alpha:1]];
        [btnGrid addSubview:btnView];
        
        UILabel *cat = [[UILabel alloc] initWithFrame:CGRectMake(0,5,btnSize+60,20)];
        [cat setText:[categories objectAtIndex:i]];
        [cat setBackgroundColor:[UIColor clearColor]];
        [cat setTextAlignment:UITextAlignmentCenter];
        [btnView addSubview:cat];
        
        UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        butt.frame = CGRectMake(30, 30, btnSize, btnSize);
        [butt setTag:i];
        [butt.titleLabel setAlpha:0];
        NSString *iconName = [NSString stringWithFormat:@"%@",  [icons objectForKey:[categories objectAtIndex:i]] ];
        UIImage *image = [UIImage imageNamed:iconName];
        
        [butt setImage:image forState:UIControlStateNormal];
        [butt.imageView setBackgroundColor:[UIColor clearColor]];
        [butt setContentMode:UIViewContentModeRight];
        
        [butt addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchDown];
        [btnView addSubview:butt];
        [buttons addObject:butt];
    }
    btnGrid.contentSize = CGSizeMake( 2*(btnSize+60), [buttons count]*(btnSize+40));
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[self initBtnGrid];
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
    
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"];
            
    NSError *error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS categories (cat_id INTEGER PRIMARY KEY, name TEXT, full_name TEXT, parent INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS buildings (bid INTEGER PRIMARY KEY, name TEXT, latitude INTEGER, longitude INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS floors (fid INTEGER PRIMARY KEY, bid INTEGER, fnum INTEGER, name TEXT, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS items (item_id INTEGER PRIMARY KEY, rid INTEGER, latitude INTEGER, longitude INTEGER, special_info TEXT, fid INTEGER, not_found_count INTEGER, username TEXT, cat_id INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
        
    [self saveCategory];
    [self saveBuilding];
    [self saveItems];
    
    [self initBtnGrid];
}

-(void) viewDidAppear:(BOOL)animated
{
    self.tabBarController.title = @"FindItNow";
}

- (void)saveCategory
{
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getCategories.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSDictionary *categoriesJson = [results objectFromJSONString];
    
    for (NSDictionary *category in categoriesJson) {
        int cat_id = [[category objectForKey:@"cat_id"] intValue];
        const char *name = (const char *) [[category objectForKey:@"name"] UTF8String];
        const char *full_name = (const char *) [[category objectForKey:@"full_name"] UTF8String];
        int parent = [[category objectForKey:@"parent"] intValue];
        int deleted = [[category objectForKey:@"deleted"] intValue];
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO categories (cat_id, name, full_name, parent, deleted) VALUES (%d, '%s', '%s', %d, %d)", cat_id, name, full_name, parent, deleted];
        NSError *error = [dbManager doQuery:sqlStr];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
}

- (void)saveBuilding
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    NSURL *URL=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.fincdn.org/getBuildings.php?rid=%d", [rid intValue]]];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSDictionary *buildingsJson = [results objectFromJSONString];
    
    for (NSDictionary *building in buildingsJson) {
        int bid = [[building objectForKey:@"bid"] intValue];
        const char *name = (const char *) [[building objectForKey:@"name"] UTF8String];
        int latitude = [[building objectForKey:@"latitude"] intValue];
        int longitude = [[building objectForKey:@"longitude"] intValue];
        int deleted = [[building objectForKey:@"deleted"] intValue];
        
        NSArray *fids = [building objectForKey:@"fid"];
        NSArray *fnums = [building objectForKey:@"fnum"];
        NSArray *fnames = [building objectForKey:@"floor_names"];
        NSArray *deletedFloors = [building objectForKey:@"deletedFloors"];
        
        int i;
        for (i = 0; i < [fids count]; i++) {
            const char *fname = (const char *)[[fnames objectAtIndex:i] UTF8String];
            NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO floors (fid, bid, fnum, name, deleted) VALUES (%d, %d, %d, '%s', %d)", [[fids objectAtIndex:i] intValue], bid, [[fnums objectAtIndex:i] intValue], fname, [[deletedFloors objectAtIndex:i] intValue]];
            NSError *error = [dbManager doQuery:sqlStr];
            if (error != nil) {
                NSLog(@"Error: %@",[error localizedDescription]);
            }
        }
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO buildings (bid, name, latitude, longitude, deleted) VALUES (%d, '%s', %d, %d, %d)", bid, name, latitude, longitude, deleted];
        NSError *error = [dbManager doQuery:sqlStr];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
}

- (void)saveItems
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    NSURL *URL=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.fincdn.org/getItems.php?rid=%d", [rid intValue]]];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSDictionary *itemsJson = [results objectFromJSONString];
    
    for (NSDictionary *item in itemsJson) {
        int item_id = [[item objectForKey:@"item_id"] intValue];
        int rid = [[item objectForKey:@"rid"] intValue];
        int latitude = [[item objectForKey:@"latitude"] intValue];
        int longitude = [[item objectForKey:@"longitude"] intValue];
        const char *special_info = (const char *) [[item objectForKey:@"special_info"] UTF8String]; // May need to replace \n
        int fid = [[item objectForKey:@"fid"] intValue];
        int not_found_count = [[item objectForKey:@"not_found_count"] intValue];
        const char *username = (const char *) [[item objectForKey:@"username"] UTF8String];
        int cat_id = [[item objectForKey:@"cat_id"] intValue];
        int deleted = [[item objectForKey:@"deleted"] intValue];
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO items (item_id, rid, latitude, longitude, special_info, fid, not_found_count, username, cat_id, deleted) VALUES (%d, %d, %d, %d, '%s', %d, %d, '%s', %d, %d)", item_id, rid, latitude, longitude, special_info, fid, not_found_count, username, cat_id, deleted];
        NSError *error = [dbManager doQuery:sqlStr];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
}

- (NSArray*)getCategoryList
{   
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM categories WHERE parent = 0 AND deleted = 0"];
    NSArray *categoriesList = [dbManager getRowsForQuery:sqlStr];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in categoriesList) {
        [categories addObject:[dict objectForKey:@"full_name"]];
    }
        
    return categories;
}

- (NSDictionary*) getCategoryIconDictionary
{    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT name, full_name FROM categories WHERE parent = 0 AND deleted = 0"];
    NSArray *categoriesList = [dbManager getRowsForQuery:sqlStr];
    
    NSMutableDictionary *icons = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in categoriesList) {
        [icons setObject:[dict objectForKey:@"name"] forKey:[dict objectForKey:@"full_name"]];
    }
    return icons;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSArray*) hasChildrenCategory:(NSString*) cate
{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT cat_id FROM categories WHERE full_name = '%@'", cate];
    NSArray *result = [dbManager getRowsForQuery:sqlStr];
    
    NSInteger cat_id = [[[result objectAtIndex:0] objectForKey:@"cat_id"] intValue];
    
    sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM categories WHERE parent = %d AND deleted = 0", cat_id];
    result = [dbManager getRowsForQuery:sqlStr];
    
    NSArray *categoriesList = [dbManager getRowsForQuery:sqlStr];
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in categoriesList) {
        [categories addObject:[dict objectForKey:@"full_name"]];
    }
    
    return categories;
}
- (IBAction)map:(id) sender {
    UIButton *butt = sender;
    NSArray *categories = [self getCategoryList];
    NSArray* subCategories = [self hasChildrenCategory:[categories objectAtIndex:butt.tag ]];
    
    if (subCategories.count == 0)
    {
        mapView = [ [MapViewController alloc] initWithNibName:@"MapViewController" bundle:[mapView nibBundle]];
        [mapView setCurrentCategory:[categories objectAtIndex:butt.tag ]];
        [mapView setCurrentBuilding:@""];
        [self.navigationController pushViewController:mapView animated:YES];
    } else{
        SubcategoryListController *subCate = [[SubcategoryListController alloc] initWithNibName:@"SubcategoryListController" bundle:[self nibBundle] initSubcategory:subCategories MapView:mapView Category:butt.titleLabel.text];        
        [self.navigationController pushViewController:subCate animated:YES];
    }
}

- (IBAction) getCategory {
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getCategories.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    [text setText:results ];
    [text setCenter:CGPointMake(100, 150)];
}

@end
