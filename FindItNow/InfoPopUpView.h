//
//  InfoPopUpView.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/7/30.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoPopUpView : UIView {
    BOOL isInfoHidden;
    UITableView *infoTable;
    NSMutableArray *exitAreas;
    NSString *buildingName;
    NSString *category;
    double distance;
    int   walkingTime;
    NSArray *floorName;
    NSMutableDictionary *floorDetail;
    
}
-(void) addExitTapGesture;
-(IBAction) addRemInfoTable;
-(void) removeExitTapArea;
-(void) constructIndoorView;
-(void) constructOutdoorView;

- (id) initWithFrame:(CGRect)frame WithBName:(NSString*)building category:(NSString*)cat distance:(double)dist walkTime: (int)walk
                data:(NSMutableDictionary*) data IsOutdoor:(BOOL) isOutdoor;

@end
