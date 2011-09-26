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

- (UIColor*) getColorForRegion:(NSString*)full_name {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT rid FROM regions WHERE full_name = '%@'", full_name];
    NSArray *regionsArr = [dbManager getRowsForQuery:sqlStr];
    int rid = [[[regionsArr objectAtIndex:0] objectForKey:@"rid"] intValue];
    
    sqlStr = [NSString stringWithFormat:@"SELECT color1 FROM colors WHERE rid = %d", rid];
    NSArray *colorsArr = [dbManager getRowsForQuery:sqlStr];
    NSString *color = [[colorsArr objectAtIndex:0] objectForKey:@"color1"];
    
    if ([color isEqualToString:@"purple"]) {
        return [UIColor colorWithRed:.4 green:0 blue:.8 alpha:.2];
    } else if ([color isEqualToString:@"blue"]) {
        return [UIColor colorWithRed:0 green:.1 blue:.8 alpha:.25];
    } else if ([color isEqualToString:@"red"]) {
        return [UIColor colorWithRed:.8 green:0 blue:0 alpha:.2];
    } else {
        return [UIColor colorWithRed:0 green:.05 blue:.3 alpha:.1];
    }
}

- (void) initBtnGrid
{
    NSArray *categories = [self getCategoryList];
    NSDictionary *icons = [self getCategoryIconDictionary];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM regions WHERE rid = %d",[rid intValue]];
    NSArray *regionsArr = [dbManager getRowsForQuery:sqlStr];
    NSString *region_name = [[regionsArr objectAtIndex:0] objectForKey:@"full_name"];
    
    //NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[categories count]];
    int btnSize = ( CGRectGetWidth(btnGrid.frame) - 180 )/3;
    int labelOffset = 8;

    for (int i=0; i < [categories count]; i = i+1) {
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnView setFrame:CGRectMake(((i%3)*(btnSize + 51))+29, ((i/3)*(51+btnSize))+20, btnSize+22, btnSize+22)];
        [btnView setShowsTouchWhenHighlighted:YES];
        [btnView setTag:i];
        [btnGrid addSubview:btnView];   
        
        UILabel *cat = [[UILabel alloc] initWithFrame:CGRectMake(((i%3)*(btnSize + 51))+20, ((i/3)*(51+btnSize))+(btnSize + 29 + labelOffset) + labelOffset,btnSize+40,15)];
        [cat setText:[categories objectAtIndex:i]];
        [cat setBackgroundColor:[UIColor clearColor]];
        [cat setTextAlignment:UITextAlignmentCenter];
        [cat setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        [cat setTextColor:[UIColor darkTextColor]];
        [btnGrid addSubview:cat];
        
        NSString *iconName = [NSString stringWithFormat:@"%@",  [icons objectForKey:[categories objectAtIndex:i]] ];
        UIImage *image = [UIImage imageNamed:iconName];
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        [img setCenter:CGPointMake(btnSize/2+11, btnSize/2+11)];
        
        [btnView addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:img];
        //[buttons addObject:img];
        
        [cat release];
        [img release];
    }
    UILabel *regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(29, CGRectGetWidth(btnGrid.frame), 262, 20)];
    [regionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [regionLabel setTextAlignment:UITextAlignmentCenter];
    [regionLabel setText:[NSString stringWithFormat:@"%@", region_name]];
    [btnGrid addSubview:regionLabel];

    btnGrid.backgroundColor = [self getColorForRegion:region_name];
    btnGrid.contentSize = CGSizeMake( 2*(btnSize+60), [categories count]*(btnSize+40));
    
    [regionLabel release];
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
    self.tabBarController.navigationItem.title = @"FindItNow";
    for (UIView* subView in btnGrid.subviews){
        [subView removeFromSuperview];
    }
    [self initBtnGrid];
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
    [dbManager release];
    [mapView release];
    [btnGrid release];
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
        [mapView setCurrentCategory:[categories objectAtIndex:butt.tag]];
        [mapView setCurrentBuilding:@""];
        [self.navigationController pushViewController:mapView animated:YES];
    } else{
        SubcategoryListController *subCate = [[SubcategoryListController alloc] initWithNibName:@"SubcategoryListController" bundle:[self nibBundle] initSubcategory:subCategories MapView:mapView Category:[categories objectAtIndex:butt.tag]];        
        [self.navigationController pushViewController:subCate animated:YES];
        
        [subCate release];
    }
}

@end
