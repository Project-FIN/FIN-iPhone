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
@property (nonatomic, retain) IBOutlet UIScrollView *btnGrid;

- (IBAction) getCategory ;
- (IBAction)map ;
- (void) initOnStart;
- (void) initBtnGrid;
@end