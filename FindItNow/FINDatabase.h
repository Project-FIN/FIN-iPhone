//
//  FINDatabase.h
//  FIN
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
-(void) saveRegions:(int)timestamp;
-(void) saveCategory:(int)timestamp;
-(void) saveBuildings:(int)timestamp;
-(void) saveItems:(int)timestamp;

@end
