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
    self.title = ([mapCategory length] == 0)? mapBuilding: mapCategory;
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
    
    hasCenteredOnLoc = FALSE;
    
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    // create out annotations array (in this example only 2)
    mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];

    MKCoordinateRegion region;
    CLLocationCoordinate2D center = [self getRegionCenter];
    region.center.latitude = center.latitude;
    region.center.longitude = center.longitude;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.004;
    
    [mapView setRegion:region];
    
    NSMutableArray *points;
    if ([mapCategory length] == 0) {
        points = [self getLocationOfBuilding:(const char *)[mapBuilding UTF8String]];
        [mapView setCenterCoordinate:[[points objectAtIndex:0] coordinate]];
    } else {
        points = [self getItemsOfCategory:(const char*)[mapCategory UTF8String]];
    }
    for (CLLocation *loc in points) {
        CLLocationCoordinate2D coord = [loc coordinate];
        ItemAnnotation *itemAnnotation = [[ItemAnnotation alloc] initWithCoordinate:coord];
        [mapView addAnnotation:itemAnnotation];
        [itemAnnotation release];
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if ([mapCategory length] != 0 && !hasCenteredOnLoc) {
        [aMapView setCenterCoordinate:userLocation.coordinate];
        hasCenteredOnLoc = TRUE;
    }
}

- (int) walkingTime:(double)distance :(int)mile_time {
    return (int)round(mile_time * distance);
}

- (double) distanceBetween:(CLLocationCoordinate2D)point1:(CLLocationCoordinate2D)point2 {
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:point1.latitude longitude:point1.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:point2.latitude longitude:point2.longitude];
    
    double distance = [loc1 distanceFromLocation:loc2] * .000621371192;
    
    [loc1 release];
    [loc2 release];
    
    return distance;
}

- (BOOL) isSubcategory:(NSString *) cat {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT parent FROM categories WHERE full_name = '%s'", (const char*)[cat UTF8String]];
    NSArray *arr = [dbManager getRowsForQuery:sqlStr];
    NSDictionary *parents = [arr objectAtIndex:0];
    
    return ([[parents objectForKey:@"parent"] intValue] != 0);
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSString *str = mapCategory;
    if ([mapCategory length] > 0 && [self isSubcategory:str]) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT parent FROM categories WHERE full_name = '%s'", (const char*)[str UTF8String]];
        NSArray *arr = [dbManager getRowsForQuery:sqlStr];
        NSDictionary *parents = [arr objectAtIndex:0];

        int parent_id = [[parents objectForKey:@"parent"] intValue];
        
        sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM categories WHERE cat_id = %d", parent_id];
        arr = [dbManager getRowsForQuery:sqlStr];
        parents = [arr objectAtIndex:0];
        
        str = [parents objectForKey:@"full_name"];
    }
        
    MKAnnotationView *annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT name FROM categories WHERE full_name = '%s'", (const char*)[str UTF8String]];
    NSArray *arr = [dbManager getRowsForQuery:sqlStr];
    if ([arr count] == 0) {
        annView.image = [UIImage imageNamed:[NSString stringWithFormat:@"buildings_small.png"]];
    } else {
        NSDictionary *names = [arr objectAtIndex:0];
    
        const char *name = (const char*)[[names objectForKey:@"name"] UTF8String];
    
        annView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%s_small.png", name]];
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
        
        [location release];
    }
    
    return pointArr;
}

- (CLLocationCoordinate2D) getRegionCenter {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT latitude, longitude FROM regions WHERE rid = %d", [rid intValue]];
    NSArray *arr = [dbManager getRowsForQuery:sqlStr];
    NSDictionary *lats = [arr objectAtIndex:0];
    
    CLLocationCoordinate2D coord;
    coord.latitude = [[lats objectForKey:@"latitude"] doubleValue] / 1000000;
    coord.longitude = [[lats objectForKey:@"longitude"] doubleValue] / 1000000;
    
    return coord;
}

- (NSDictionary*) getItemsAtLocation:(int)latitude: (int)longitude {
    const char* str;
    if ([mapCategory length] != 0) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT cat_id FROM categories WHERE full_name = '%s'", (const char*)[mapCategory UTF8String]];
        NSArray *itemsList = [dbManager getRowsForQuery:sqlStr];
        NSDictionary *dict = [itemsList objectAtIndex:0];
    
        int cat_id = [[dict objectForKey:@"cat_id"] intValue];
        printf("Cat id is %d", cat_id);
    
        str = (const char*)[[NSString stringWithFormat:@"AND cat_id = %d", cat_id] UTF8String];
    } else {
        str = "";
    }
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT fid FROM items WHERE latitude = %d AND longitude = %d %s AND deleted = 0", latitude, longitude, str];
    NSArray *fList = [dbManager getRowsForQuery:sqlStr];
    NSMutableDictionary *itemsMap = [[NSMutableDictionary alloc] init];

    for (NSDictionary *dict in fList) {
        sqlStr = [NSString stringWithFormat:@"SELECT name FROM floors WHERE fid = %d", [[dict objectForKey:@"fid"] intValue]];
        NSArray *fnames = [dbManager getRowsForQuery:sqlStr];
        NSString *fname;
        const char *str2;
        if ([fnames count] == 0) {
            fname = [NSString stringWithFormat:@"Outdoor Location"];
            str2 = (const char*) [[NSString stringWithFormat:@"AND latitude = %d AND longitude = %d", latitude, longitude] UTF8String];
        } else {
            fname = [[fnames objectAtIndex:0] objectForKey:@"name"];
            str2 = "";
        }
        
        sqlStr = [NSString stringWithFormat:@"SELECT * FROM items WHERE fid = %d %s %s AND deleted = 0", [[dict objectForKey:@"fid"] intValue], str, str2];
        NSArray *itemsOnFloor = [dbManager getRowsForQuery:sqlStr];
        
        NSMutableDictionary *itemsOnFloorMap = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dict in itemsOnFloor) {
            int cat_id = [[dict objectForKey:@"cat_id"] intValue];
            sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM categories WHERE cat_id = %d", cat_id];
            NSArray *cnames = [dbManager getRowsForQuery:sqlStr];
            
            NSString *cname = [[cnames objectAtIndex:0] objectForKey:@"full_name"];
            NSString *sp_info = [NSString stringWithFormat:@"%s", (const char*)[[dict objectForKey:@"special_info"] UTF8String]];
            
            NSMutableDictionary *value = [[NSMutableDictionary alloc] init];
            [value objectForKey:@"cname"];
            [value setObject:sp_info forKey:cname];
            
            [itemsOnFloorMap setObject:sp_info  forKey:cname];
            
            [value release];
        }
        [itemsMap setObject:itemsOnFloorMap forKey:fname];
        [itemsOnFloorMap release];
    }
    
    return itemsMap;
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
    
    [location release];
    
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

-(IBAction) openPopup:(UITapGestureRecognizer *)recognizer
{
    MKAnnotationView *view = [recognizer view];
    id <MKAnnotation> annot = [view annotation];
    int latitude = [annot coordinate].latitude*1000000 ;
    int longitude = [annot coordinate].longitude*1000000;
    NSDictionary *data = [self getItemsAtLocation:latitude:longitude];
    
    //create a dark overlay over the map
    UIView *overlay = [ [UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [overlay setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
    [self.view addSubview:overlay];
    
    //temporary, johnson hall's restroom crashes and some other
    NSString *building = mapBuilding; 
    if ([mapBuilding isEqualToString:@""]){
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT name FROM buildings WHERE latitude = %d AND longitude = %d", latitude, longitude];
        NSArray *itemsList = [dbManager getRowsForQuery:sqlStr];
        if ([itemsList count] == 0) {
            building = [NSString stringWithFormat:@"Outdoor Location"];
        } else {
            NSDictionary *dict = [itemsList objectAtIndex:0];
            building = [dict objectForKey:@"name"];
        }
    }
    
    //Create a popup
    int yCoord = CGRectGetMidY(self.view.frame) - (160/2);
    double dist = [self distanceBetween:[annot coordinate]:mapView.userLocation.coordinate];
    int walkTime = [self walkingTime:dist:35];

    InfoPopUpView *popup = [ [InfoPopUpView alloc] initWithFrame:CGRectMake(20,0, CGRectGetWidth(self.view.frame)-40, 160)WithBName:building category:mapCategory distance:dist walkTime:walkTime data:data IsOutdoor:[building isEqualToString:@"Outdoor Location"]];    
    [overlay addSubview:popup];
    
    [overlay release];
    
    //perform animation
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [popup setFrame:CGRectMake(20, yCoord, CGRectGetWidth(self.view.frame)-40, 160)];
                         [popup addExitTapGesture];
                     }completion:^(BOOL finished) {
                     }];
}

-(IBAction) scrollToUserLocation
{
    MKUserLocation *myLoc = mapView.userLocation;
    if (myLoc != nil) {
        [mapView setCenterCoordinate:myLoc.coordinate animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error: Location Not Detected" message:@"Could not detect your location" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}


-(IBAction) scrollToDefaultLocation
{
    [mapView setCenterCoordinate:[self getRegionCenter]];
}
@end
