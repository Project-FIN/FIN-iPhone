//
//  MenuViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/26.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "MenuViewController.h"
#import "MapViewController.h"

@implementation MenuViewController
@synthesize mapView;
@synthesize btnGrid;
@synthesize text;

- (void) initBtnGrid
{
    NSArray *categories = [self getCategoryList];
    NSDictionary *icons = [self getCategoryIconDictionary];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[categories count]];
    int btnSize = ( CGRectGetHeight(btnGrid.frame) - 60 )/([categories count]/2);
    //int btnWidth = CGRectGetWidth(btnGrid.frame) / ([categories count
    for (int i=0; i < [categories count]; i = i+1) {
        UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        butt.frame = CGRectMake(btnSize/2+((i%2)*(btnSize+60)), (10+(i/2)*(15+btnSize)), btnSize, btnSize);
        
        [butt setTitle:[categories objectAtIndex:i] forState:UIControlStateNormal];
        [butt setImage:[UIImage imageNamed: [icons objectForKey:[categories objectAtIndex:i] ]] forState:UIControlStateNormal];
        [butt addTarget:self action:@selector(map) forControlEvents:UIControlEventTouchDown];
        [btnGrid addSubview:butt];
        [buttons addObject:butt];
    }
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
        
    [self saveCategory];
    [self initBtnGrid];
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


- (IBAction)map {
    
    [self.tabBarController.view addSubview:mapView.view];
}

- (IBAction) getCategory {
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getCategories.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    [text setText:results ];
    [text setCenter:CGPointMake(100, 150)];
}



@end
