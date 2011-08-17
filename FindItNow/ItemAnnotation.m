//
//  ItemAnnotation.m
//  FindItNow
//
//  Created by Eric Hare on 8/16/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import "ItemAnnotation.h"

@implementation ItemAnnotation

@synthesize coordinate;

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return @"Golden Gate Bridge";
}

// optional
- (NSString *)subtitle
{
    return @"Opened: May 27, 1937";
}

- (id)initWithCoordinate:(CLLocationCoordinate2D) c {
    coordinate = c;
    return self;
}

@end
