//
//  SetRegionViewController.h
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/21.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetRegionViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UIPickerView *pickerView;   
    NSArray *data;
    UIWindow *window;
}
- (void) setWindow:(UIWindow*) win;
@end
