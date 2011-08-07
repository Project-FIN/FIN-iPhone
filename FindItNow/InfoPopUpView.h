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
}
-(void) addExitTapGesture;
-(IBAction) addRemInfoTable;
-(void) removeExitTapArea;
@end
