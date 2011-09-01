//
//  SetRegionViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/21.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "SetRegionViewController.h"


@implementation SetRegionViewController

- (void)saveRegions
{
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getRegions.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSDictionary *regionsJson = [results objectFromJSONString];
    
    for (NSDictionary *region in regionsJson) {
        int rid = [[region objectForKey:@"rid"] intValue];
        const char *name = (const char *) [[region objectForKey:@"name"] UTF8String];
        const char *full_name = (const char *) [[region objectForKey:@"full_name"] UTF8String];
        int lat = [[region objectForKey:@"lat"] intValue];
        int lon = [[region objectForKey:@"lon"] intValue];
        const char *color1 = (const char *) [[region objectForKey:@"color1"] UTF8String];
        const char *color2 = (const char *) [[region objectForKey:@"color2"] UTF8String];
        int deleted = [[region objectForKey:@"deleted"] intValue];
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO regions (rid, name, full_name, latitude, longitude, deleted) VALUES (%d, '%s', '%s', %d, %d, %d)", rid, name, full_name, lat, lon, deleted];
        NSError *error = [dbManager doQuery:sqlStr];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO colors (rid, color1, color2) VALUES (%d, '%s', '%s')", rid, color1, color2];
        error = [dbManager doQuery:sqlStr];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"];

    NSError *error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS regions (rid INTEGER PRIMARY KEY, name TEXT, full_name TEXT, latitude INTEGER, longitude INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS colors (rid INTEGER PRIMARY KEY, color1 TEXT, color2 TEXT)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    [self saveRegions];
    
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
    // Do any additional setup after loading the view from its nib.
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
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT rid FROM regions WHERE full_name = '%s'", (const char*)[selectedRegion UTF8String]];
        NSArray *ridArr = [dbManager getRowsForQuery:sqlStr];
        NSDictionary *dict = [ridArr objectAtIndex:0];
        int rid = [[dict objectForKey:@"rid"] intValue];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = @"rid";
        NSNumber *value = [NSNumber numberWithInt:rid];
        
        [defaults setObject:value forKey:key];
        [defaults synchronize];
        [window makeKeyAndVisible];
        [self dismissModalViewControllerAnimated:YES];
    }
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
