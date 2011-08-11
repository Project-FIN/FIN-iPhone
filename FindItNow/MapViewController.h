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

@interface MapViewController : UIViewController {
    
    SQLiteManager *dbManager;
    MKMapView *mapView;
    NSString *mapCategory;
    NSString *building;
}
-(void) setCurrentCategory:(NSString*)category;
-(IBAction)openPopup:(id)sender;
-(IBAction) removeMap;
-(void) saveItems;
-(MKMapPoint*) getItemsOfCategory:(const char*)category;
-(void) setCurrentBuilding:(NSString*)build;

@end
