//
//  ItemAnnotation.h
//  FindItNow
//
//  Created by Eric Hare on 8/16/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ItemAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

@end
