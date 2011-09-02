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
    
    [self initBtnGrid];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.title = @"FindItNow";
    for (UIView* subView in btnGrid.subviews){
        [subView removeFromSuperview];
    }
    [self initBtnGrid];
    NSLog(@"Temp");
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
