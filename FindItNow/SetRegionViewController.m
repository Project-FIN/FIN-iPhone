//
//  SetRegionViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/21.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "SetRegionViewController.h"


@implementation SetRegionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    db = [[FINDatabase alloc] init];
    [db createDB];
    [db saveRegions:0];
    
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        data = [self getRegionsList];
        [self setModalPresentationStyle:UIModalPresentationFormSheet];
    }
    return self;
}

- (void) setWindow:(UIWindow*) win
{
    window = win;
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    if (rid != NULL) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM regions WHERE rid = %d",[rid intValue]];
        NSArray *regionsArr = [dbManager getRowsForQuery:sqlStr];
        
        [pickerView selectRow:[data indexOfObject:[[regionsArr objectAtIndex:0] objectForKey:@"full_name"]]+1 inComponent:0 animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//pickerView delegate code
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pv didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row != 0){
        UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"You selected %@",[data objectAtIndex:row-1] ] delegate:self cancelButtonTitle:@"Select Again" otherButtonTitles:@"Yes", nil];
        [confirm show];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex){
        NSString *selectedRegion = [data objectAtIndex:[pickerView selectedRowInComponent:0]-1];
        
        int rid = [[self getRIDFromRegion:selectedRegion] intValue];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = @"rid";
        NSNumber *value = [NSNumber numberWithInt:rid];
        
        [defaults setObject:value forKey:key];
        [defaults synchronize];
        
        [db deleteDB];
        
        [db saveCategory:0];
        [db saveBuildings:0];
        [db saveItems:0];
        
        [window makeKeyAndVisible];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (NSMutableArray*) getRegionsList {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM regions WHERE deleted = 0"];
    NSArray *regionsArr = [dbManager getRowsForQuery:sqlStr];
    
    NSMutableArray* regionsList = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in regionsArr) {
        [regionsList addObject:[dict objectForKey:@"full_name"]];
    }
    
    return regionsList;
}

- (NSNumber*) getRIDFromRegion:(NSString*) regionName {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT rid FROM regions WHERE full_name = '%s'", (const char*)[regionName UTF8String]];
    NSArray *ridArr = [dbManager getRowsForQuery:sqlStr];
    NSDictionary *dict = [ridArr objectAtIndex:0];
    
    return [dict objectForKey:@"rid"];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [data count]+1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (row == 0)
        return @" ";
    return [data objectAtIndex:row-1];
}

@end
