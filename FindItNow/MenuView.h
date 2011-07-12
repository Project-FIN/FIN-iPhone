//
//  MenuView.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/7.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapView;

@interface MenuView : UIView {
    IBOutlet MapView *mapView;
    UILabel *text;
}
@property (nonatomic, retain) IBOutlet UILabel *text;
@property (nonatomic, retain) IBOutlet MapView *mapView;

- (IBAction) getCategory ;
- (IBAction)map ;

@end
