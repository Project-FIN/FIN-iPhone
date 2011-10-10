//
//  SetRegionViewController.m
//  FindItNow
//
//  Created by Chanel Huang on 2011/8/21.
//  Copyright 2011年 University of Washington. All rights reserved.
//

#import "SetRegionViewController.h"


@implementation SetRegionViewController
@synthesize indicator;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{   
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setModalPresentationStyle:UIModalPresentationFormSheet];
    }
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"];
    db = [[FINDatabase alloc] init];
    
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
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    if (internetStatus != NotReachable && hostStatus != NotReachable) {
        if (rid == nil) {
            [db createDB];
            [db saveRegions:0];
        }
        [self getRegionsList];
        [pickerView reloadAllComponents];
    }
}

- (void) checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    if (internetStatus != NotReachable && hostStatus != NotReachable) {
        if (rid == nil) {
            [db createDB];
            [db saveRegions:0];
        }
        [self getRegionsList];
        [pickerView reloadAllComponents];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    if (rid == nil) {
        cancelBtn.hidden = YES;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
    [hostReachable startNotifier];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
/*    if (row != 0){
        UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"You selected %@",[data objectAtIndex:row-1] ] delegate:self cancelButtonTitle:@"Select Again" otherButtonTitles:@"Yes", nil];
        [confirm show];
    }*/
}
-(void) updateDB:(id) sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
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
    [self performSelectorOnMainThread:@selector(removeIndicatorForUpdate:) withObject:nil waitUntilDone:NO];

    [pool release];
}

-(void) removeIndicatorForUpdate:(id) sender
{
    [indicator stopAnimating];
    [[indicator superview] removeFromSuperview];
    [window makeKeyAndVisible];
    [delegate didDismissRegionSelectView];
}

-(void) removeIndicatorForRegion:(id)sender
{
    [indicator stopAnimating];
    [[indicator superview] removeFromSuperview];
    [pickerView reloadAllComponents];
    [self setPickerViewDefault];
}

-(void) setPickerViewDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    if (rid != NULL) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM regions WHERE rid = %d",[rid intValue]];
        NSArray *regionsArr = [dbManager getRowsForQuery:sqlStr];
        
        [pickerView selectRow:[data indexOfObject:[[regionsArr objectAtIndex:0] objectForKey:@"full_name"]]+1 inComponent:0 animated:YES];
    }
}

-(IBAction) confirmSelection:(id) sender
{
    if ([pickerView selectedRowInComponent:0]-1 != -1) {
        NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
        NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
        
        if (internetStatus != NotReachable && hostStatus != NotReachable) {

            UIView *overlay = [[ [UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))] autorelease];
            [overlay setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
            [self.view addSubview:overlay];
    
            indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
            [indicator setCenter:self.view.center];
            [overlay addSubview:indicator];
            [indicator startAnimating];
            [self performSelectorInBackground:@selector(updateDB:) withObject:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error: No Internet Connection" message:@"Please ensure your data connection is active and working" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error: Region Not Selected" message:@"Please select a region from the list" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

-(IBAction) cancelSelection:(id) sender
{
    [delegate didDismissRegionSelectView];
}


- (void) getRegionsList {
    UIView *overlay = [[ [UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))] autorelease];
    [overlay setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
    [self.view addSubview:overlay];
    
    indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [indicator setCenter:self.view.center];
    [overlay addSubview:indicator];
    [indicator startAnimating];
    [self performSelectorInBackground:@selector(performGetRegion:) withObject:nil];
}

-(void) performGetRegion:(id)sender
{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT full_name FROM regions WHERE deleted = 0"];
    NSArray *regionsArr = [dbManager getRowsForQuery:sqlStr];
    
    NSMutableArray* regionsList = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in regionsArr) {
        [regionsList addObject:[dict objectForKey:@"full_name"]];
    }
    
    data = regionsList;
    [self performSelectorOnMainThread:@selector(removeIndicatorForRegion:) withObject:nil waitUntilDone:NO];
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
