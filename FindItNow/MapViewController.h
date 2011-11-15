//
//  MapViewController.h
//  FIN
//
//  Created by Chanel Huang on 2011/8/2.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "JSONKit.h"
#import "CoreLocation/CLLocation.h"
#import "MapKit/MapKit.h"
#import "MapKit/MKGeometry.h"
#import "MapKit/MKOverlayView.h"
#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    
    SQLiteManager *dbManager;
    NSMutableArray *mapAnnotations;
    NSString *mapCategory;
    NSString *mapBuilding;
    BOOL hasCenteredOnLoc;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

-(void) setCurrentCategory:(NSString*)category;
-(IBAction) openPopup:(UITapGestureRecognizer *)recognizer;
-(IBAction) removeMap;
-(NSMutableArray*) getItemsOfCategory:(const char*)category;
-(NSMutableArray*) getLocationOfBuilding:(const char*)building;
-(NSDictionary*) getItemsAtLocation:(int)latitude:(int)longitude;
-(void) setCurrentBuilding:(NSString*)build;
-(CLLocationCoordinate2D) getRegionCenter;
-(IBAction) scrollToUserLocation;
-(IBAction) scrollToDefaultLocation;
-(int) walkingTime:(double)distance:(int)mile_time;
-(double) distanceBetween:(CLLocationCoordinate2D)point1: (CLLocationCoordinate2D)point2;
@end
