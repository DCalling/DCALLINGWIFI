//
//  SQLiteDBHandler.m
//  DCalling WiFi
//
//  Created by David C. Son on 19.01.12.
//  Copyright (C) 2015 DALASON GmbH.
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

#import "SQLiteDBHandler.h"
#import "FavViewHandler.h"
#import "PreferencesHandler.h"
#include <stdio.h>

@implementation SQLiteDBHandler



-(BOOL) initDB{
    BOOL status = true;      
    
    NSString *docsDir;
    NSArray *dirPaths;
    PreferencesHandler *pref = [[[PreferencesHandler alloc]init]autorelease];
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] 
                    initWithString: [docsDir stringByAppendingPathComponent:@"DCallingDB.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS callLog (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT,LABEL TEXT, DATETIME TIMESTAMP, PROVIDER TEXT)";
            
            const char *sql_stmt1 ="CREATE TABLE IF NOT EXISTS favorites (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, LASTNAME TEXT, PHONE TEXT, LABEL TEXT)";
            
            const char *sql_stmt2 = "CREATE TABLE IF NOT EXISTS tdtaDid ('_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'fiId' INTEGER, 'txDid' TEXT, 'fiCountry' INTEGER, 'fiDnidFunction' INTEGER);"; 
            
            const char *sql_stmt3 = "CREATE TABLE IF NOT EXISTS tfixCountryPrefixCode ('_id' INTEGER PRIMARY KEY NOT NULL, 'country_en' TEXT NOT NULL, 'country_de' TEXT NOT NULL, 'country_tr' TEXT NOT NULL, 'prefix_code' TEXT NOT NULL, 'show' TEXT NOT NULL, 'country' TEXT NOT NULL, 'code' TEXT NOT NULL, 'continent' TEXT NOT NULL, 'rate' TEXT NOT NULL, 'rate_date' TEXT NOT NULL, 'mcc' TEXT NOT NULL);";
            
            
            
            if (sqlite3_exec(DCallingDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status = false;
            }
            
            if (sqlite3_exec(DCallingDB, sql_stmt1, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status = false;
            }
            if (sqlite3_exec(DCallingDB, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status = false;
            }
            if (sqlite3_exec(DCallingDB, sql_stmt3, NULL, NULL, &errMsg) == SQLITE_OK)
            {
                status = [self runScript];
                [pref setInstalledDB:YES];
            }
            
            
            sqlite3_close(DCallingDB);
            
            
        } else {
            status = false;
        }
        
    }
    else if ([filemgr fileExistsAtPath: databasePath ] == YES){
        if([pref getInstalledDB]){
            const char *dbpath = [databasePath UTF8String];
            BOOL ssd = TRUE;
            if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
            {
                const char *sql_alter_stmt1 = "ALTER TABLE callLog ADD COLUMN NET TEXT NULL";
                char *errMsg;
                if (sqlite3_exec(DCallingDB, sql_alter_stmt1, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    ssd = false;
                    [pref setInstalledDB:NO];
                }
            }
            
        }
        
    }
    [filemgr release];
       
    return status;
}

-(NSString *) readLineAsNSString:(FILE *)file{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}

- (BOOL) saveCallLog: (NSArray *)callLog{
    BOOL insertStatus = true;
    if([self initDB] == true)
    {
        PreferencesHandler *mPref = [[[PreferencesHandler alloc]init]autorelease];
        
        sqlite3_stmt    *statement = nil;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            NSString *name = @"";
            NSString *addrs = @"";
            NSString *phone = @"";
            NSString *phoneLabel = @"";
            NSString *provider = @"0";
            NSString *test = @"";
            if([mPref getInternetStatus] == YES)
                test=@"TRUE";
            else
                test=@"FALSE";
            if([[callLog objectAtIndex:0] length] !=0)
                name = [callLog objectAtIndex:0];
            if([[callLog objectAtIndex:1] length] !=0)
                addrs = [callLog objectAtIndex:1];
            if([[callLog objectAtIndex:2] length] !=0)
                phone = [callLog objectAtIndex:2];
            if([[callLog objectAtIndex:3] length] !=0)
                phoneLabel = [callLog objectAtIndex:3];
            if([[callLog objectAtIndex:4] length] !=0)
                provider = [callLog objectAtIndex:4];
            
            if([provider isEqualToString:@""]){
                provider=@"0";
            }
            /*FavViewHandler *mFav = [[FavViewHandler alloc] autorelease];
            insertStatus = [mFav scanNumber:phone];
            if(insertStatus == NO)
                return insertStatus;*/
            
            NSString *insertSQL = [NSString stringWithFormat: 
                                   @"INSERT INTO callLog (name, address, phone, label, DATETIME, PROVIDER, NET) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", datetime('now', 'localtime'), \"%@\", \"%@\")", name, addrs, phone, phoneLabel, provider, test];
           // NSLog(@"select %@", insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(DCallingDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                insertStatus = true;
                name = @"";
                addrs= @"";
                phone = @"";
                phoneLabel = @"";
            } else {
            insertStatus = false;
            }
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
       }
       //
    }
    return insertStatus;
}

- (NSMutableArray *) getCallLog{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT phone FROM callLog ORDER BY id DESC LIMIT 0,10"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    NSString *phoneField = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 0)];
                                       
                    selectStatus = true;
                    [callLog addObject:phoneField];
                    
                    [phoneField release];
                   
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
    
    }
   
    return callLog;
}


- (NSMutableArray *) getCallLogRec{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT DISTINCT phone FROM callLog ORDER BY id DESC LIMIT 0,10"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    NSString *phoneField = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 0)];
                                        
                    selectStatus = true;
                    [callLog addObject:phoneField];
                    
                    [phoneField release];
                    
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}


- (NSMutableArray *) getCallLogRecName:(NSMutableArray *) numbers{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        for(NSString *number in numbers){
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt    *statement = nil;
        
            if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
            {
                //NSString *nameText = @"ABC";
                NSString *querySQL = [NSString stringWithFormat: @"SELECT NAME, ADDRESS FROM callLog WHERE PHONE='%@' ORDER BY id DESC LIMIT 0,10", number];
            
                const char *query_stmt = [querySQL UTF8String];
            
                if (sqlite3_prepare_v2(DCallingDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                        NSString *addrs = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        phoneField = [phoneField stringByAppendingFormat:@" %@", addrs];
                        if([phoneField length] < 2)
                            phoneField = number;
                                            
                        selectStatus = true;
                        [callLog addObject:phoneField];
                       
                        [phoneField release];
                        [addrs release];
                        
                    }
                    if(sqlite3_finalize(statement) != SQLITE_OK)
                    { NSLog(@"Failed to finalize data statement."); }
                }
                sqlite3_close(DCallingDB);
            }
        
        }
    }
    
    return callLog;
}

- (NSMutableArray *) getCallLogRecNameString:(NSString *) numbers{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {       
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt    *statement = nil;
            
            if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
            {
                //NSString *nameText = @"ABC";
                NSString *querySQL = [NSString stringWithFormat: @"SELECT NAME, ADDRESS FROM callLog WHERE PHONE='%@' ORDER BY id DESC LIMIT 0,10", numbers];
                
                const char *query_stmt = [querySQL UTF8String];
                
                if (sqlite3_prepare_v2(DCallingDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        
                        NSString *addrs = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        phoneField = [phoneField stringByAppendingFormat:@" %@", addrs];
                        if([phoneField length] < 2)
                            phoneField = numbers;
                        
                        selectStatus = true;
                        [callLog addObject:phoneField];
                        
                        [phoneField release];
                        [addrs release];
                        
                    }
                    if(sqlite3_finalize(statement) != SQLITE_OK)
                    { NSLog(@"Failed to finalize data statement."); }
                }
                sqlite3_close(DCallingDB);
            }
            
       
    }
    
    return callLog;
}

- (NSMutableArray *) getCallLogPhoneLabels:(NSMutableArray *) numbers{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        for(NSString *number in numbers){
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt    *statement = nil;
            
            if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
            {
                //NSString *nameText = @"ABC";
                NSString *querySQL = [NSString stringWithFormat: @"SELECT LABEL FROM callLog WHERE PHONE='%@' ORDER BY id DESC LIMIT 0,15", number];
                
                const char *query_stmt = [querySQL UTF8String];
                
                if (sqlite3_prepare_v2(DCallingDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        
                                               
                        selectStatus = true;
                        [callLog addObject:phoneField];
                        
                        [phoneField release];
                      
                        // [nameField release];
                    }
                    if(sqlite3_finalize(statement) != SQLITE_OK)
                    { NSLog(@"Failed to finalize data statement."); }
                }
                sqlite3_close(DCallingDB);
            }
            
        }
    }
    
    return callLog;
}

- (NSMutableArray *) getCallLogPhoneLabel:(NSString *) number{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt    *statement = nil;
            
            if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
            {
                //NSString *nameText = @"ABC";
                NSString *querySQL = [NSString stringWithFormat: @"SELECT LABEL FROM callLog WHERE PHONE='%@' ORDER BY id DESC LIMIT 0,15", number];
                
                const char *query_stmt = [querySQL UTF8String];
                
                if (sqlite3_prepare_v2(DCallingDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        
                        
                        selectStatus = true;
                        [callLog addObject:phoneField];
                        
                        [phoneField release];
                        
                        // [nameField release];
                    }
                    if(sqlite3_finalize(statement) != SQLITE_OK)
                    { NSLog(@"Failed to finalize data statement."); }
                }
                sqlite3_close(DCallingDB);
            }
            
        
    }
    
    return callLog;
}




- (BOOL) saveFavorites: (NSArray *)favorites{
    BOOL insertStatus = true;
    if([self initDB] == true)
    {
        
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSLog(@"Arr %@", favorites);
            NSString *name = @"";
            NSString *last = @"";
            NSString *phone = @"";
            NSString *phonelabel = @"";
            if([[favorites objectAtIndex:0] length] !=0){
                name = (NSString *)[favorites objectAtIndex:0];
            }
            if([[favorites objectAtIndex:1] length] !=0){
                last = (NSString *)[favorites objectAtIndex:1];
            }
            
            if([[favorites objectAtIndex:2] length] !=0){
                phone = (NSString *)[favorites objectAtIndex:2];
            }
            if([[favorites objectAtIndex:3] length] !=0){
                phonelabel = (NSString *)[favorites objectAtIndex:3];
            }
                        
           
            
            sqlite3_stmt    *statement = nil;
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO favorites (NAME, LASTNAME, PHONE, LABEL) VALUES (\"%@\", \"%@\", \"%@\", \"%@\");", name, last, phone, phonelabel];
            const char *insert_stmt = [insertSQL UTF8String];
            if (sqlite3_prepare_v2(DCallingDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    insertStatus = true;
                    name = @"";
                    last= @"";
                    phone = @"";
                    phonelabel=@"";
                } else {
                    insertStatus = false;
                }
                sqlite3_finalize(statement);
                sqlite3_close(DCallingDB);
            }
            else if (sqlite3_prepare_v2(DCallingDB, insert_stmt, -1, &statement, NULL) != SQLITE_OK) 
            {
                NSLog(@"%@",[NSString stringWithUTF8String:sqlite3_errmsg(DCallingDB)] );
            }
        }
    }
    return insertStatus;
}

-(BOOL) sameNumber:(NSString *)number{
    BOOL status = true;
    NSString *getSQLITEPhone = [self getFavoritesPhone:number];
    
    if([number isEqualToString:getSQLITEPhone]){
        status = false;
        
    }
    return status;
}

- (NSMutableArray *) getFavorites{
    
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT NAME, LASTNAME, PHONE FROM favorites"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *nameField = [[NSString alloc]
                                           initWithUTF8String:(const char *)
                                           sqlite3_column_text(statement, 0)];
                    
                     NSString *lastField = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                    
                    NSString *appendStr = [NSString stringWithFormat:@"%@ %@", nameField, lastField];
                    selectStatus = true;
                    [callLog addObject:appendStr];
                    
                    
                    [lastField release];
                    [appendStr release];
                    [nameField release];
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}

- (NSString *) getFavNumberSingle:(NSString *)pnStr{
    
    BOOL selectStatus = true;
    NSString *callLog =@"";
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT NAME, LASTNAME, PHONE, LABEL FROM favorites WHERE PHONE='%@'", pnStr];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *nameField = [[NSString alloc]
                                           initWithUTF8String:(const char *)
                                           sqlite3_column_text(statement, 0)];
                    // address.text = addressField;
                    
                    // [callLog appendString:nameField];
                    NSString *lastField = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                    NSString *phoneLabel = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                    
                    callLog = [NSString stringWithFormat:@"%@}%@}%@", nameField, lastField, phoneLabel];
                    selectStatus = true;
                    
                    [phoneLabel release];
                    [lastField release];
                    
                    [nameField release];
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}


- (NSMutableArray *) getFavNumbers{
    
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT PHONE FROM favorites"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *phoneField = [[NSString alloc]
                                           initWithUTF8String:(const char *)
                                           sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    [callLog addObject:phoneField];
                    
                    [phoneField release];
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}

- (NSMutableArray *) getFavPhoneLabel{
    
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT LABEL FROM favorites"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *phoneField = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    [callLog addObject:phoneField];
                    
                    [phoneField release];
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}



-(NSString *) getCallLogPhone:(NSString *)phoneNumber{
    BOOL selectStatus = true;
    NSString *phoneField = nil;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT PHONE FROM callLog WHERE PHONE='%@'", phoneNumber];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    
                } 
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
    
}


- (NSString *) getFavoritesPhone:(NSString *) phoneNumber{
    BOOL selectStatus = true;
    NSString *phoneField = nil;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT PHONE FROM favorites WHERE PHONE='%@'", phoneNumber];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                   phoneField = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    
                } 
               
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
}

- (NSString *) getCallLogNumber:(NSArray *) arrName {
    BOOL selectStatus = true;
    NSString *phoneField = nil;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *name = @"";
            NSString *last =@"";
            if([arrName count] > 1){
                if([[arrName objectAtIndex:0] length] !=0)
                    name = [arrName objectAtIndex:0];
                if([[arrName objectAtIndex:1] length] !=0)
                    last = [arrName objectAtIndex:1];
            }
            
            
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT PHONE FROM callLog WHERE NAME='%@' AND ADDRESS='%@'", name, last ];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    
                } 
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
}

- (NSMutableArray *) getCountryName{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT country_de FROM tfixCountryPrefixCode"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *countryEng = [[NSString alloc]
                                           initWithUTF8String:(const char *)
                                           sqlite3_column_text(statement, 0)];
                    
                    NSString *contryDe = [NSString stringWithString:countryEng]; 
                    [callLog addObject:contryDe];
                    
                    
                    selectStatus = true;
                  
                    [countryEng release];
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    NSArray *myarr = [NSArray arrayWithArray:callLog];
    NSArray *sortedArray = [myarr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *myMutableArray = [sortedArray mutableCopy];
    
    return myMutableArray;
}

- (NSMutableArray *) getCountryNameTr{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT country_tr FROM tfixCountryPrefixCode ORDER BY country_tr ASC"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *countryEng = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 0)];
                    
                    NSString *contryDe = [NSString stringWithString:countryEng];
                    [callLog addObject:contryDe];
                    
                    
                    selectStatus = true;
                    
                    [countryEng release];
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    NSArray *myarr = [NSArray arrayWithArray:callLog];
    NSArray *sortedArray = [myarr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *myMutableArray = [sortedArray mutableCopy];
    
    return myMutableArray;
}


-(NSString *) getCountryPre:(NSString *)countryName{
    BOOL selectStatus = true;
    NSString *callLog = nil ;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT prefix_code FROM tfixCountryPrefixCode where country_de='%@'", countryName];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 0)];
                    
                    
                    selectStatus = true;
                    
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;

}

-(NSString *) getCountryPreTr:(NSString *)countryName{
    BOOL selectStatus = true;
    NSString *callLog =nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT prefix_code FROM tfixCountryPrefixCode where country_tr='%@'", countryName];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    
                    
                    selectStatus = true;
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

-(NSString *) getCountryPreEN:(NSString *)countryName{
    BOOL selectStatus = true;
    NSString *callLog = nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT prefix_code FROM tfixCountryPrefixCode where country_en='%@'", countryName];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    
                    
                    selectStatus = true;
                    
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

-(NSMutableArray *) getCountryPrefixCode{
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray alloc] init];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT prefix_code FROM tfixCountryPrefixCode ORDER BY country_de ASC" ];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *str = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];

                    [callLog addObject:str];
                    [str release];
                                        
                    selectStatus = true;
                    
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

-(NSMutableArray *) getCountryPrefixCodeTr{
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray alloc] init];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT prefix_code FROM tfixCountryPrefixCode ORDER BY country_tr ASC" ];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *str = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                    [callLog addObject:str];
                    [str release];
                    
                    selectStatus = true;
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

-(NSMutableArray *) getCountryPrefixCodeEN{
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray alloc] init];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT prefix_code FROM tfixCountryPrefixCode ORDER BY country_en ASC" ];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *str = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                    [callLog addObject:str];
                    [str release];
                    
                    selectStatus = true;
                    
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

- (NSMutableArray *) getCountryNameEn{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT country_en FROM tfixCountryPrefixCode ORDER BY country_en ASC"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *countryEng = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 0)];
                    
                    NSString *contryDe = [NSString stringWithString:countryEng]; 
                    [callLog addObject:contryDe];
                    
                    
                    selectStatus = true;
                    
                    [countryEng release];
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    NSArray *myarr = [NSArray arrayWithArray:callLog];
    NSArray *sortedArray = [myarr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *myMutableArray = [sortedArray mutableCopy];
    
    return myMutableArray;
}



-(NSMutableArray *) getMCC{
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray alloc]init];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT mcc FROM tfixCountryPrefixCode"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    NSString *str = [[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 0)]; 
                    NSArray *countArray = [str componentsSeparatedByString: @","];
                    //for(int i=0; i<[countArray count]; i++){
                        
                   // }
                    [callLog addObject:countArray];
                    
                    
                    selectStatus = true;
                   
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    //NSLog(@"%@", callLog);
    return callLog;
    
}

-(NSString *) getPrefixMCCCode:(NSInteger) mcc{
    BOOL selectStatus = true;
    NSString *callLog = nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"SELECT prefix_code FROM tfixCountryPrefixCode where _id=%d", (int)mcc];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                                        
                    selectStatus = true;
                    
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}



- (BOOL) deleteFavorites:(NSString *) phoneNumber{
    BOOL deleteStatus = true;
    if([self initDB] == true)
    {
        
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
                
           
            NSString *deleteSQL = [NSString stringWithFormat: 
                                   @"delete from favorites where NAME ='%@'", phoneNumber];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(DCallingDB, delete_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                deleteStatus = true;
                
            } else {
                deleteStatus = false;
            }
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    return deleteStatus;
    
}

- (BOOL) deleteCallLog:(NSString *) phoneNumber{
    BOOL deleteStatus = true;
    if([self initDB] == true)
    {
        
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            
            
            NSString *deleteSQL = [NSString stringWithFormat: 
                                   @"delete from callLog where PHONE ='%@'", phoneNumber];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(DCallingDB, delete_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                deleteStatus = true;
                
            } else {
                deleteStatus = false;
            }
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    return deleteStatus;
    
}

- (BOOL) deleteFavLog:(NSString *) phoneNumber{
    BOOL deleteStatus = true;
    if([self initDB] == true)
    {
        
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {                  
            NSString *deleteSQL = [NSString stringWithFormat: 
                                   @"DELETE FROM favorites WHERE PHONE='%@'",phoneNumber ];
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(DCallingDB, delete_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                deleteStatus = true;
                
            } else {
                deleteStatus = false;
            }
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    return deleteStatus;
}



-(BOOL) updateCallLog :(NSArray *) arrName{
    
    BOOL selectStatus = true;
    NSString *phoneField = nil;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *name = [arrName objectAtIndex:0];
            NSString *last = [arrName objectAtIndex:1];
            NSString *phone = [arrName objectAtIndex:2];
            NSString *phoneLabel = [arrName objectAtIndex:3];
           // NSString *provider = [arrName objectAtIndex:4];
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"UPDATE callLog set NAME=\'%@\', ADDRESS = \'%@\', LABEL = \'%@\' where PHONE = '%@'", name, last,phoneLabel, phone];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    
                } 
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return selectStatus;
    
}

-(BOOL) updateFavLog :(NSArray *) arrName{
    
    BOOL selectStatus = true;
    NSString *phoneField = nil;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *name = [arrName objectAtIndex:0];
            NSString *last = [arrName objectAtIndex:1];
            NSString *phone = [arrName objectAtIndex:2];
            NSString *phoneLabel = [arrName objectAtIndex:3];
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"UPDATE favorites set NAME=\'%@\', LASTNAME = \'%@\', LABEL = \'%@\' where PHONE = '%@'", name, last,phoneLabel, phone ];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    
                } 
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return selectStatus;
    
}




/*-(void) checkAndCreateDB {
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    BOOL check = [filemgr fileExistsAtPath:databasePath];
    if(check) return;
    
    NSString *databasePathFromApps = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databasePath];
    [filemgr copyItemAtPath:databasePathFromApps toPath:databasePath error:nil];
    [filemgr release];
}*/

-(NSString *) checkCountryTableCount{
   
    NSString *callLog =nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"select count(_id) from tfixCountryPrefixCode"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }

    return callLog;
}

-(BOOL) checkAndInsertCountryTable:(NSString *)countryQuery{
    BOOL insertStatus = true;
    if([self initDB] == true)
    {        
        sqlite3_stmt    *statement = nil;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
                  
            const char *insert_stmt = [countryQuery UTF8String];
            sqlite3_prepare_v2(DCallingDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                insertStatus = true;
               
            } else {
                insertStatus = false;
            }
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    return insertStatus;
}

-(BOOL) runScript{
    NSString *sqlFile = [[NSBundle mainBundle] pathForResource:@"country_codes_prefix" ofType:@"txt"];  
    BOOL status = true;
    // check for NULL
    if(sqlFile)
    {
        // NSString *line = [self readLineAsNSString:sqlFile1];
        NSString *line = [NSString stringWithContentsOfFile:sqlFile encoding:NSUTF8StringEncoding error:nil ];
        NSArray* singleStrs = 
        [line componentsSeparatedByCharactersInSet:
         [NSCharacterSet characterSetWithCharactersInString:@";"]];
        // NSLog(@"sql file : %@", singleStrs);
        NSString *rowCount = [self checkCountryTableCount];
        int vals = [rowCount intValue];
        if(vals == 0){
            for (int i=0; i< [singleStrs count]; i++) {
                NSString *linByLine = [singleStrs objectAtIndex:i];
                status = [self checkAndInsertCountryTable:linByLine];
            }
        }
        // do stuff with line; line is autoreleased, so you should NOT release it (unless you also retain it beforehand)
    }
    // fclose(sqlFile1);
    return status;
}

-(NSString *) getCountFromCallLog:(NSString *)phonestr{
   // NSInteger tableCount;
    NSString *callLog =nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"select count(ID) from callLog WHERE PHONE='%@'", phonestr];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                {if(sqlite3_step(statement) == SQLITE_ROW)
                
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                   // tableCount = (NSInteger)callLog;
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}

-(NSString *) getCountFromCallLogName:(NSArray *)names{
    //NSInteger tableCount;
    NSString *callLog =nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        NSString *fName;
        NSString *lName;
        fName = [names objectAtIndex:0];
        lName = [names objectAtIndex:1];
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"select count(ID) from callLog WHERE NAME='%@' AND ADDRESS='%@'", fName, lName];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                   // tableCount = (NSInteger)callLog;
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}

-(NSString *) getDefaultDialin:(NSString *)getPrefix{
    //NSInteger tableCount;
    NSString *callLog =@"";
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"select txDid from tdtaDid WHERE tdtaDid.fiCountry='%@'", getPrefix];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    // tableCount = (NSInteger)callLog;
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;

}

-(NSString *) getCountrCodeID:(NSString *)getPrefix{
    //NSInteger tableCount;
    NSString *callLog =@"";
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"select _id from tfixCountryPrefixCode WHERE  prefix_code='%@'", getPrefix];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    // tableCount = (NSInteger)callLog;
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}

-(NSMutableArray *) getDefaultDialinCoutryCode{
    //NSInteger tableCount;
    NSMutableArray *callLog = [[NSMutableArray alloc]init];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat: 
                                  @"select fiCountry from tdtaDid"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB, 
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *code = [[NSString alloc] initWithUTF8String:(const char *)                               sqlite3_column_text(statement, 0)];
                    // tableCount = (NSInteger)callLog;
                    [callLog addObject:code];
                    [code release];
                } 
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

-(NSMutableArray *) getCoutryCodeThroughDialin:(NSMutableArray *) code{
    //NSInteger tableCount;
    NSMutableArray *callLog = [[NSMutableArray alloc]init];
    for(NSString* str in code)
    {
        if([self initDB] == true)
        {
        
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt    *statement = nil;
            if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
            {
                //NSString *nameText = @"ABC";
                NSString *querySQL = [NSString stringWithFormat:@"select prefix_code from tfixCountryPrefixCode WHERE  _id='%@'", str];            
                const char *query_stmt = [querySQL UTF8String];
            
                if (sqlite3_prepare_v2(DCallingDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if(sqlite3_step(statement) == SQLITE_ROW)
                    {
                        NSString *code = [[NSString alloc] initWithUTF8String:(const char *)                                    sqlite3_column_text(statement, 0)];
                    // tableCount = (NSInteger)callLog;
                    [callLog addObject:code];
                    } 
                    if(sqlite3_finalize(statement) != SQLITE_OK)
                    { NSLog(@"Failed to finalize data statement."); }
                }
                sqlite3_close(DCallingDB);
            }
        }
        
    }
    
    return callLog;
    
}


- (NSMutableArray *) getCallLogRecNameDemo:(NSMutableArray *) numbers{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        for(NSString *number in numbers){
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt    *statement = nil;
            
            if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
            {
                //NSString *nameText = @"ABC";
                NSString *querySQL = [NSString stringWithFormat: @"SELECT NAME, ADDRESS, PHONE, LABEL FROM callLog WHERE PHONE='%@' ORDER BY id DESC LIMIT 0,10", number];
                
                const char *query_stmt = [querySQL UTF8String];
                
                if (sqlite3_prepare_v2(DCallingDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        
                        NSString *addrs = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        NSString *phone = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                         NSString *mobLabel = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                        NSString *names = [phoneField stringByAppendingFormat:@" %@", addrs];
                        if([names length] < 2)
                            names = number;
                       
                        selectStatus = true;
                        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:names, @"fnames",mobLabel, @"label", phone, @"phone", nil];
                        //NSLog(@"%@",names);
                        [callLog addObject:dict];
                        
                        [phoneField release];
                        [addrs release];
                        [dict release];
                        [mobLabel release];
                        [phone release];
                        [names release];
                    }
                    if(sqlite3_finalize(statement) != SQLITE_OK)
                    { NSLog(@"Failed to finalize data statement."); }
                }
                sqlite3_close(DCallingDB);
            }
            
        }
    }
    
    return callLog;
}


-(NSString *) getCountryNamePre:(NSString *)countryName{
    BOOL selectStatus = true;
    NSString *callLog =nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT country_de FROM tfixCountryPrefixCode where prefix_code='%@'", countryName];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    
                    
                    selectStatus = true;
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

-(NSString *) getCountryNamePreTr:(NSString *)countryName{
    BOOL selectStatus = true;
    NSString *callLog =nil ;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT country_tr FROM tfixCountryPrefixCode where prefix_code='%@'", countryName];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    
                    
                    selectStatus = true;
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

-(NSString *) getCountryNamePreEN:(NSString *)countryName{
    BOOL selectStatus = true;
    NSString *callLog = nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT country_en FROM tfixCountryPrefixCode where prefix_code='%@'", countryName];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    
                    
                    selectStatus = true;
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
    
}

-(NSString *) getProviderPhone:(NSString *)phoneNumber{
    BOOL selectStatus = true;
    NSString *phoneField = nil;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT PROVIDER FROM callLog WHERE PHONE='%@' AND PROVIDER!='' ORDER BY id DESC LIMIT 0,1", phoneNumber];
            
            const char *query_stmt = [querySQL UTF8String];
            //NSLog(@"ddd %@", querySQL);
            if (sqlite3_prepare_v2(DCallingDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 0)];
                    if(phoneField.length>0 && ![phoneField isEqualToString:@""]){
                        break;
                    }
                    
                    selectStatus = true;
                    
                }
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
    
}

-(NSString *) getProviderTime:(NSString *)phoneNumber{
    BOOL selectStatus = true;
    NSString *phoneField = nil;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT DATETIME FROM callLog WHERE PHONE='%@' AND PROVIDER!='' ORDER BY ID DESC LIMIT 0,1", phoneNumber];
            
            const char *query_stmt = [querySQL UTF8String];
            //NSLog(@"ddd %@", querySQL);
            if (sqlite3_prepare_v2(DCallingDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 0)];
                    
                    
                    selectStatus = true;
                    
                }
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
    
}

-(void) updateProvider:(NSString *)phoneNumber :(NSString *)provider{
    
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
           
            NSString *querySQL = [NSString stringWithFormat:
                                  @"UPDATE callLog set DATETIME=datetime('now', 'localtime'), PROVIDER=\'%@\' where PHONE = '%@'", provider, phoneNumber];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)               {
                    
                    
                    
                }
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        
    }
    
   
}

- (NSString *) getLastCallLogRec{ // need to improve sqlite handling, i am stuck on statement things
    BOOL selectStatus = true;
    NSString *phoneField=@"";
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT DISTINCT phone FROM callLog ORDER BY id DESC LIMIT 0,1"];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    //[callLog addObject:phoneField];
                    
                    //[phoneField release];
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
}

- (NSString *)getDateTime : (NSString *)number{
    BOOL selectStatus = true;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    NSString *phoneField = @"";
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT DATETIME FROM callLog WHERE PHONE=\"%@\" ORDER BY id DESC LIMIT 0,1", number];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    //[callLog addObject:phoneField];
                    
                    //[phoneField release];
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
}

- (NSString *)getCallNetValues : (NSString *)number{
    BOOL selectStatus = true;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    NSString *phoneField = @"";
    NSString *netVal = @"TRUE";
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT DATETIME FROM callLog WHERE PHONE=\"%@\" AND NET =\"%@\" ORDER BY id DESC LIMIT 0,1", number, netVal];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    //[callLog addObject:phoneField];
                    
                    //[phoneField release];
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
}

- (NSString *)getCallNetValuesOnly : (NSString *)number : (NSString *)datetime{
    BOOL selectStatus = true;
    //NSMutableArray *callLog = [[NSMutableArray new] autorelease];
    NSString *phoneField = @"";
    NSString *netVal = @"TRUE";
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT NET FROM callLog WHERE PHONE=\"%@\" AND NET=\"%@\" AND DATETIME > datetime('%@') ORDER BY id DESC LIMIT 0,1", number, netVal, datetime];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    phoneField = [[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 0)];
                    
                    selectStatus = true;
                    //[callLog addObject:phoneField];
                    
                    //[phoneField release];
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return phoneField;
}

- (BOOL) saveCallLogInternetValues{
    BOOL insertStatus = true;
    if([self initDB] == true)
    {
        
        sqlite3_stmt    *statement = nil;
        const char *dbpath = [databasePath UTF8String];
        NSString *provider =@"FALSE";
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
           
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"UPDATE callLog set NET=\"%@\"", provider];
            // NSLog(@"select %@", insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(DCallingDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                insertStatus = true;
               
            } else {
                insertStatus = false;
            }
            sqlite3_finalize(statement);
            sqlite3_close(DCallingDB);
        }
        //
    }
    return insertStatus;
}

- (NSString *)getCountryPrefix : (NSString *)countryCode{
    BOOL selectStatus = true;
    NSString *callLog = nil;
    if([self initDB] == true)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement = nil;
        
        if (sqlite3_open(dbpath, &DCallingDB) == SQLITE_OK)
        {
            //NSString *nameText = @"ABC";
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT prefix_code FROM tfixCountryPrefixCode where code='%@'", countryCode];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(DCallingDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    callLog = [[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 0)];
                    
                    callLog = [@"+" stringByAppendingString:callLog];
                    selectStatus = true;
                    
                }
                if(sqlite3_finalize(statement) != SQLITE_OK)
                { NSLog(@"Failed to finalize data statement."); }
            }
            sqlite3_close(DCallingDB);
        }
        
    }
    
    return callLog;
}


-(void)dealloc{
    //[databasePath release];
    [super dealloc];
}

@end
