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
}

#pragma mark - View lifecycle
-(void) setCurrentCategory:(NSString*)category
{
    mapCategory = category;
}
-(void) setCurrentBuilding:(NSString*)build
{
    building = build;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"];
    
    NSError *error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS items (item_id INTEGER PRIMARY KEY, rid INTEGER, latitude INTEGER, longitude INTEGER, special_info TEXT, fid INTEGER, not_found_count INTEGER, username TEXT, cat_id INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    [self saveItems];
    
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
    CLLocationCoordinate2D coord;
    coord.latitude = 47.654288;
    coord.longitude = -122.308044;
    
    NSMutableArray *points = [self getItemsOfCategory:"Coffee"];
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
    MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    
    annView.pinColor = MKPinAnnotationColorPurple;
    annView.animatesDrop = TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    
    return annView;
}
     
- (void)saveItems
{
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getItems.php?rid=1"];
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
        printf("Latitude is %f", [[dict objectForKey:@"latitude"] doubleValue] / 1000000);
        CLLocationDegrees longitude = [[dict objectForKey:@"longitude"] doubleValue] / 1000000;
        
        CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        [pointArr addObject:location];
    }
    
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
    //LOOK@
    // www.applausible.com/blog/?p=489
    
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
    InfoPopUpView *popup = [ [InfoPopUpView alloc] initWithFrame:CGRectMake(20, yCoord, CGRectGetWidth(self.view.frame)-40, 160)WithBName:@"Test Building" category:@"Test Cate." distance:0.1334 walkTime:130 data:dataDict IsOutdoor:NO];
    //Perform animation
    //[popup appear];
    //need a UIViewAppear class
    
    [overlay addSubview:popup];
    [popup addExitTapGesture];
    //  [popup release];
}

@end
