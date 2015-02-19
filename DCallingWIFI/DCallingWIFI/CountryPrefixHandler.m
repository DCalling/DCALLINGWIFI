//
//  CountryPrefixHandler.m
//  DCalling WiFi
//
//  Created by Prashant Kumar on 29/02/12.
//  Copyright (C) 2014 DALASON GmbH.
//  This file is part of a DALASON Project. (http://www.dalason.de)
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//

#import "CountryPrefixHandler.h"
#import "SQLiteDBHandler.h"
@implementation CountryPrefixHandler

@synthesize countryPrefix;
@synthesize countryName;
-(void) getCountryName{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    countryPrefix = [[NSMutableArray alloc] retain];
    countryPrefix = [sqliteDB getCountryName];
   
    
    [sqliteDB release];
}

-(void) getCountryNameTr{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    countryPrefix = [[NSMutableArray alloc] retain];
    countryPrefix = [sqliteDB getCountryNameTr];
    
    
    [sqliteDB release];
}

-(void) getCountryNameEN{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    countryPrefix = [[NSMutableArray alloc] retain];
    countryPrefix = [sqliteDB getCountryNameEn];
    
    
    [sqliteDB release];
}

-(NSString *) getCountryPrefix:(NSString *)cName{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    countryName = [sqliteDB getCountryPre:cName];
    [sqliteDB release];
    return countryName;
}

-(NSString *) getCountryPrefixEN:(NSString *)cName{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    countryName = [sqliteDB getCountryPreEN:cName];
    [sqliteDB release];
    return countryName;
}

-(NSString *) getCountryPrefixTr:(NSString *)cName{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    countryName = [sqliteDB getCountryPreTr:cName];
    [sqliteDB release];
    return countryName;
}

-(NSMutableArray *) getCountryPrefixCode{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    NSMutableArray *countryPrefixCode = [[NSMutableArray alloc] init];
    countryPrefixCode = [sqliteDB getCountryPrefixCode];
    [sqliteDB release];
    return countryPrefixCode;
}

-(NSMutableArray *) getCountryPrefixCodeEN{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    NSMutableArray *countryPrefixCode = [[NSMutableArray alloc] init];
    countryPrefixCode = [sqliteDB getCountryPrefixCodeEN];
    [sqliteDB release];
    return countryPrefixCode;
}

-(NSMutableArray *) getCountryPrefixCodeTr{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    NSMutableArray *countryPrefixCode = [[NSMutableArray alloc] init];
    countryPrefixCode = [sqliteDB getCountryPrefixCodeTr];
    [sqliteDB release];
    return countryPrefixCode;
}

-(NSMutableArray *) getMCCCode{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    NSMutableArray *mccCode = [[NSMutableArray alloc] init];
    mccCode = [sqliteDB getMCC];
    [sqliteDB release];
    return mccCode;
    
}

-(NSString *) getPreMCCCode:(NSInteger ) mcc{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    NSString *mccCode = [sqliteDB getPrefixMCCCode:mcc];
    [sqliteDB release];
    return mccCode;
    
}

-(BOOL) staticDialinNumbers:(NSString *) prefixed{
    BOOL status = FALSE;
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    NSMutableArray *dialin = [[NSMutableArray alloc] init];
    NSMutableArray *prefix = [[NSMutableArray alloc] init];
    dialin = [sqliteDB getDefaultDialinCoutryCode];
    prefix = [sqliteDB getCoutryCodeThroughDialin:dialin];
    for(NSString *str in prefix){
        if([prefixed isEqualToString:str]){
            status = TRUE;
        }
    }
    return status;
}


-(NSString *) getCountryNamePrefix:(NSString *)cName{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    countryName = [sqliteDB getCountryNamePre:cName];
    [sqliteDB release];
    return countryName;
}

-(NSString *) getCountryNamePrefixEN:(NSString *)cName{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    countryName = [sqliteDB getCountryNamePreEN:cName];
    [sqliteDB release];
    return countryName;
}

-(NSString *) getCountryNamePrefixTr:(NSString *)cName{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc] init];
    //countryName = [[NSString alloc] retain];
    countryName = [sqliteDB getCountryNamePreTr:cName];
    [sqliteDB release];
    return countryName;
}


-(void) dealloc{
    countryPrefix = nil;
    [countryPrefix release];
    countryName = nil;
    [countryName release];
    [super dealloc];
}

@end
