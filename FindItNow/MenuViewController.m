//
//  MenuViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/26.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "MenuViewController.h"
#import "MapView.h"
#import "JSONKit.h"
#import "sqlite3.h"

@implementation MenuViewController
@synthesize mapView;
@synthesize btnGrid;
@synthesize text;

- (void) initBtnGrid
{
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getCategories.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSDictionary *categoriesJson = [results objectFromJSONString];
    NSLog(@"%@", [categoriesJson description]);
        
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (NSDictionary *category in categoriesJson) {
        [categories addObject:[category objectForKey:@"full_name"]];
    }
    NSLog(@"%@", categories);
    
   // NSArray *categories = [results componentsSeparatedByString:@","];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[categories count]];
    int btnSize = ( CGRectGetHeight(btnGrid.frame) - 60 )/([categories count]/2);
    //int btnWidth = CGRectGetWidth(btnGrid.frame) / ([categories count
    for (int i=0; i < [categories count]; i = i+1) {
        UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        butt.frame = CGRectMake(btnSize/2+((i%2)*(btnSize+60)), (10+(i/2)*(15+btnSize)), btnSize, btnSize);
        
        [butt setTitle:[categories objectAtIndex:i] forState:UIControlStateNormal];
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
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    
    sqlite3 *FIN_LOCAL;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"FIN_LOCAL.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
        sqlite3_open(dbpath, &FIN_LOCAL);
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS categories (cat_id INTEGER PRIMARY KEY, name TEXT, full_name TEXT, parent INTEGER)";
        
        sqlite3_exec(FIN_LOCAL, sql_stmt, NULL, NULL, &errMsg);
        sqlite3_close(FIN_LOCAL);
    }
    
    [filemgr release];
    [super viewDidLoad];
    
    [self initBtnGrid];
    [self saveCategory];
    [self getCategoryList];
}

- (void)saveCategory
{
    sqlite3_stmt *statement;
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    
    sqlite3 *FIN_LOCAL;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"FIN_LOCAL.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &FIN_LOCAL) == SQLITE_OK)
    {
        const char *insert_stmt = "INSERT OR REPLACE INTO categories (cat_id, name, full_name, parent) VALUES (1, 'coffee', 'Coffee', 0)";
                
        if ((sqlite3_prepare_v2(FIN_LOCAL, insert_stmt, -1, &statement, NULL) == SQLITE_OK)) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            sqlite3_close(FIN_LOCAL);
        }
    }
}

- (void)getCategoryList
{
    sqlite3_stmt *statement;
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    
    sqlite3 *FIN_LOCAL;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"FIN_LOCAL.db"]];
    const char *dbpath = [databasePath UTF8String];

    
    if (sqlite3_open(dbpath, &FIN_LOCAL) == SQLITE_OK)
    {
        const char *query_stmt = "SELECT * FROM categories";
        
        if (sqlite3_prepare_v2(FIN_LOCAL, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *fullName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSLog(@"%@", [fullName description]);
            } else {
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(FIN_LOCAL);
    }
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
    //MapView *temp = [ [MapView alloc] init];
    [self.tabBarController.view addSubview:mapView];
}

- (IBAction) getCategory {
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getCategories.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    [text setText:results ];
    [text setCenter:CGPointMake(100, 150)];
}



@end
