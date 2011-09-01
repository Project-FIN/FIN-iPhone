//
//  FINDatabase.m
//  FindItNow
//
//  Created by Eric Hare on 9/1/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import "FINDatabase.h"

@implementation FINDatabase

- (id)init
{
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"FIN_LOCAL.db"];

    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)createDB
{
    NSError *error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS regions (rid INTEGER PRIMARY KEY, name TEXT, full_name TEXT, latitude INTEGER, longitude INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS colors (rid INTEGER PRIMARY KEY, color1 TEXT, color2 TEXT)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }

    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS categories (cat_id INTEGER PRIMARY KEY, name TEXT, full_name TEXT, parent INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS buildings (bid INTEGER PRIMARY KEY, name TEXT, latitude INTEGER, longitude INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS floors (fid INTEGER PRIMARY KEY, bid INTEGER, fnum INTEGER, name TEXT, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    error = [dbManager doQuery:@"CREATE TABLE IF NOT EXISTS items (item_id INTEGER PRIMARY KEY, rid INTEGER, latitude INTEGER, longitude INTEGER, special_info TEXT, fid INTEGER, not_found_count INTEGER, username TEXT, cat_id INTEGER, deleted INTEGER)"];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}

- (void)deleteDB
{
    NSError *error = [dbManager doQuery:@"DELETE FROM categories"];
    error = [dbManager doQuery:@"DELETE FROM buildings"];
    error = [dbManager doQuery:@"DELETE FROM floors"];
    error = [dbManager doQuery:@"DELETE FROM items"];
}

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

- (void)saveCategory
{
    NSURL *URL=[[NSURL alloc] initWithString:@"http://www.fincdn.org/getCategories.php"];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSDictionary *categoriesJson = [results objectFromJSONString];
    
    for (NSDictionary *category in categoriesJson) {
        int cat_id = [[category objectForKey:@"cat_id"] intValue];
        const char *name = (const char *) [[category objectForKey:@"name"] UTF8String];
        const char *full_name = (const char *) [[category objectForKey:@"full_name"] UTF8String];
        int parent = [[category objectForKey:@"parent"] intValue];
        int deleted = [[category objectForKey:@"deleted"] intValue];
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO categories (cat_id, name, full_name, parent, deleted) VALUES (%d, '%s', '%s', %d, %d)", cat_id, name, full_name, parent, deleted];
        NSError *error = [dbManager doQuery:sqlStr];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
}

- (void)saveBuildings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    NSURL *URL=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.fincdn.org/getBuildings.php?rid=%d", [rid intValue]]];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSDictionary *buildingsJson = [results objectFromJSONString];
    
    for (NSDictionary *building in buildingsJson) {
        int bid = [[building objectForKey:@"bid"] intValue];
        const char *name = (const char *) [[building objectForKey:@"name"] UTF8String];
        int latitude = [[building objectForKey:@"latitude"] intValue];
        int longitude = [[building objectForKey:@"longitude"] intValue];
        int deleted = [[building objectForKey:@"deleted"] intValue];
        
        NSArray *fids = [building objectForKey:@"fid"];
        NSArray *fnums = [building objectForKey:@"fnum"];
        NSArray *fnames = [building objectForKey:@"floor_names"];
        NSArray *deletedFloors = [building objectForKey:@"deletedFloors"];
        
        int i;
        for (i = 0; i < [fids count]; i++) {
            const char *fname = (const char *)[[fnames objectAtIndex:i] UTF8String];
            NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO floors (fid, bid, fnum, name, deleted) VALUES (%d, %d, %d, '%s', %d)", [[fids objectAtIndex:i] intValue], bid, [[fnums objectAtIndex:i] intValue], fname, [[deletedFloors objectAtIndex:i] intValue]];
            NSError *error = [dbManager doQuery:sqlStr];
            if (error != nil) {
                NSLog(@"Error: %@",[error localizedDescription]);
            }
        }
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO buildings (bid, name, latitude, longitude, deleted) VALUES (%d, '%s', %d, %d, %d)", bid, name, latitude, longitude, deleted];
        NSError *error = [dbManager doQuery:sqlStr];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
}

- (void)saveItems
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rid = [defaults objectForKey:@"rid"];
    
    NSURL *URL=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.fincdn.org/getItems.php?rid=%d", [rid intValue]]];
    NSString *results = [[NSString alloc] initWithContentsOfURL :URL];
    
    NSDictionary *itemsJson = [results objectFromJSONString];
    
    for (NSDictionary *item in itemsJson) {
        int item_id = [[item objectForKey:@"item_id"] intValue];
        int rid = [[item objectForKey:@"rid"] intValue];
        int latitude = [[item objectForKey:@"latitude"] intValue];
        int longitude = [[item objectForKey:@"longitude"] intValue];
        const char *special_info = (const char *) [[item objectForKey:@"special_info"] UTF8String]; // May need to replace \n
        int fid = [[item objectForKey:@"fid"] intValue];
        int not_found_count = [[item objectForKey:@"not_found_count"] intValue];
        const char *username = (const char *) [[item objectForKey:@"username"] UTF8String];
        int cat_id = [[item objectForKey:@"cat_id"] intValue];
        int deleted = [[item objectForKey:@"deleted"] intValue];
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO items (item_id, rid, latitude, longitude, special_info, fid, not_found_count, username, cat_id, deleted) VALUES (%d, %d, %d, %d, '%s', %d, %d, '%s', %d, %d)", item_id, rid, latitude, longitude, special_info, fid, not_found_count, username, cat_id, deleted];
        NSError *error = [dbManager doQuery:sqlStr];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
}


@end
