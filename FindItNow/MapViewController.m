//
//  MapViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/2.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "MapViewController.h"
#import "InfoPopUpView.h"	
#import "ItemAnnotation.h"
#import "SetRegionTableController.h"

@implementation MapViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"Map";
}

#pragma mark - View lifecycle
-(void) setCurrentCategory:(NSString*)category
{
    mapCategory = category;
}
-(void) setCurrentBuilding:(NSString*)build
{
    mapBuilding = build;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"];
    
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    // create out annotations array (in this example only 2)
    mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];

    MKCoordinateRegion region;
    region.center.latitude = 47.654288;
    region.center.longitude = -122.308044;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.004;
    
    // annotation for the City of Seattle
    CLLocationCoordinate2D coord2;
    coord2.latitude = 47.654288;
    coord2.longitude = -122.308044;
    NSMutableArray *points;
    if ([mapCategory length] == 0) {
        points = [self getLocationOfBuilding:(const char *)[mapBuilding UTF8String]];
    } else {
        points = [self getItemsOfCategory:(const char*)[mapCategory UTF8String]];
    }
    for (CLLocation *loc in points) {
        CLLocationCoordinate2D coord = [loc coordinate];
        ItemAnnotation *itemAnnotation = [[ItemAnnotation alloc] initWithCoordinate:coord];
        [mapView addAnnotation:itemAnnotation];
    }
    
    [mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];
            
    // Chanel: Here's how to get an array of 'geopoints'
    // sMKMapPoint* points = [self getItemsOfCategory:"Coffee"];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    MKAnnotationView *annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT name FROM categories WHERE full_name = '%s'", (const char*)[mapCategory UTF8String]];
    NSArray *arr = [dbManager getRowsForQuery:sqlStr];
    if ([arr count] == 0) {
        annView.image = [UIImage imageNamed:[NSString stringWithFormat:@"buildings.png"]];
    } else {
        NSDictionary *names = [arr objectAtIndex:0];
    
        const char *name = (const char*)[[names objectForKey:@"name"] UTF8String];
    
        annView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s.png", name]];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPopup:)];
    [annView addGestureRecognizer:tap];
    
    return annView;
}

- (NSMutableArray*) getItemsOfCategory:(const char*)category {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT cat_id FROM categories WHERE full_name = '%s'", category];
    NSArray *arr = [dbManager getRowsForQuery:sqlStr];
    NSDictionary *cat_ids = [arr objectAtIndex:0];
    
    int cat_id = [[cat_ids objectForKey:@"cat_id"] intValue];

    sqlStr = [NSString stringWithFormat:@"SELECT latitude, longitude FROM items WHERE cat_id = %d AND deleted = 0", cat_id];
    NSArray *itemsList = [dbManager getRowsForQuery:sqlStr];
    
    NSMutableArray* pointArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < itemsList.count; i++) {
        NSDictionary *dict = [itemsList objectAtIndex:i];
        
        CLLocationDegrees latitude = [[dict objectForKey:@"latitude"] doubleValue] / 1000000;
        CLLocationDegrees longitude = [[dict objectForKey:@"longitude"] doubleValue] / 1000000;
        
        CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        [pointArr addObject:location];
    }
    
    return pointArr;
}
                  
- (NSMutableArray*) getLocationOfBuilding:(const char*)building {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT latitude, longitude FROM buildings WHERE name = '%s' AND deleted = 0", building];
    NSArray *itemsList = [dbManager getRowsForQuery:sqlStr];
    
    NSMutableArray* pointArr = [[NSMutableArray alloc] init];
    NSDictionary *dict = [itemsList objectAtIndex:0];
        
    CLLocationDegrees latitude = [[dict objectForKey:@"latitude"] doubleValue] / 1000000;
    CLLocationDegrees longitude = [[dict objectForKey:@"longitude"] doubleValue] / 1000000;
        
    CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
    [pointArr addObject:location];
    
    return pointArr;
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

- (IBAction) removeMap
{
    [self.view removeFromSuperview];
}

-(IBAction) openPopup:(id)sender
{
    //create a dark overlay over the map
    UIView *overlay = [ [UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [overlay setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
    [self.view addSubview:overlay];

    //temporary data
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:6 ];
    [dataDict setObject:@"This is a test" forKey:@"Floor A"];
    [dataDict setObject:@"This is a test\nSecond Line" forKey:@"Floor B"];
    [dataDict setObject:@"This is a test\nwith lot of text and so this is fun" forKey:@"Floor C"];
    [dataDict setObject:@"This is a test\n\n\nt fourth line?" forKey:@"Floor D"];
    [dataDict setObject:@"" forKey:@"Floor E"];
    [dataDict setObject:@"hour:??" forKey:@"Floor F"];
    
    //Create a popup
    int yCoord = CGRectGetMidY(self.view.frame) - (160/2);
    InfoPopUpView *popup = [ [InfoPopUpView alloc] initWithFrame:CGRectMake(20,0, CGRectGetWidth(self.view.frame)-40, 160)WithBName:@"Test Building" category:@"Test Cate." distance:0.1334 walkTime:130 data:dataDict IsOutdoor:NO];    
    [overlay addSubview:popup];
    
    //perform animation
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.8];
    [popup setFrame:CGRectMake(20, yCoord, CGRectGetWidth(self.view.frame)-40, 160)];
    [popup addExitTapGesture];
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
}

-(IBAction) scrollToUserLocation
{
    [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
}


-(IBAction) scrollToDefaultLocation
{
    MKCoordinateRegion region;
    region.center.latitude = 47.654288;
    region.center.longitude = -122.308044;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.004;
    
    [mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];
}
@end
