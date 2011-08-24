//
//  MapViewController.h
//  FindItNow
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

@interface MapViewController : UIViewController {
    
    SQLiteManager *dbManager;
    NSMutableArray *mapAnnotations;
    NSString *mapCategory;
    NSString *mapBuilding;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

-(void) setCurrentCategory:(NSString*)category;
-(IBAction) openPopup:(UITapGestureRecognizer *)recognizer;
-(IBAction) removeMap;
-(NSMutableArray*) getItemsOfCategory:(const char*)category;
-(NSMutableArray*) getLocationOfBuilding:(const char*)building;
-(NSArray*) getItemsAtLocation:(int)latitude:(int)longitude;
-(void) setCurrentBuilding:(NSString*)build;
-(IBAction) scrollToUserLocation;
-(IBAction) scrollToDefaultLocation;
@end
