//
//  FINDatabase.h
//  FindItNow
//
//  Created by Eric Hare on 9/1/11.
//  Copyright 2011 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteManager.h"
#import "JSONKit.h"

@interface FINDatabase : NSObject {
    SQLiteManager *dbManager;
}

-(void) createDB;
-(void) deleteDB;
-(void) saveRegions;
-(void) saveCategory;
-(void) saveBuildings;
-(void) saveItems;

@end
