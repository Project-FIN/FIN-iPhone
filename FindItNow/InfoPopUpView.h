//
//  InfoPopUpView.h
//  FIN
//
//  Created by Chanel Huang on 2011/7/30.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FloorInfoTableViewController;

@interface InfoPopUpView : UIView {
    BOOL isInfoHidden;
    FloorInfoTableViewController *infoTable;
    NSMutableArray *exitAreas;
    NSString *buildingName;
    NSString *category;
    double distance;
    int   walkingTime;
    NSDictionary *floorDetail;
    
}
-(void) addExitTapGesture;
-(IBAction) addRemInfoTable;
-(void) removeExitTapArea;
-(void) constructIndoorView;
-(void) constructOutdoorView;
- (IBAction) exitAnimation:(UITapGestureRecognizer *)recognizer;
- (id) initWithFrame:(CGRect)frame WithBName:(NSString*)building category:(NSString*)cat distance:(double)dist walkTime: (int)walk
                data:(NSDictionary*) data IsOutdoor:(BOOL) isOutdoor;
-(NSArray*) getDesendFloor;
@end
