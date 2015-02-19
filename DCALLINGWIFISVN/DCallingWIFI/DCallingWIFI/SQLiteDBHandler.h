//
//  SQLiteDBHandler.h
//  DCalling WiFi
//
//  Created by David C. Son on 19.01.12.
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

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteDBHandler : NSObject {
    NSString        *databasePath;
    sqlite3 *DCallingDB;
    
}

-(BOOL) initDB;

//-(void) checkAndCreateDB ;



- (BOOL) saveCallLog: (NSArray *)callLog;

- (NSMutableArray *) getCallLog;

- (NSMutableArray *) getCallLogRec;

- (NSMutableArray *) getCallLogRecName: (NSMutableArray *)numbers;

- (BOOL) saveFavorites: (NSArray *)favorites;

- (NSMutableArray *) getFavorites;

-(NSMutableArray *) getFavNumbers;

-(NSString *) getFavNumberSingle:(NSString *) pnStr;

- (NSString *) getFavoritesPhone:(NSString *) phoneNumber;

- (NSString *) getCallLogPhone:(NSString *) phoneNumber;

- (BOOL) deleteFavorites:(NSString *) phoneNumber;

- (BOOL) deleteCallLog:(NSString *) phoneNumber;

- (BOOL) deleteFavLog:(NSString *) phoneNumber;

-(BOOL) sameNumber:(NSString *)number;

-(NSString *) getCallLogNumber :(NSArray *) arrName;

-(BOOL) updateCallLog :(NSArray *) arrName;

-(BOOL) updateFavLog :(NSArray *) arrName;

-(NSMutableArray *) getCountryName;

-(NSString *) getCountryPre: (NSString *)countryName ;

- (NSString *)readLineAsNSString:(FILE *)file;

-(BOOL) checkAndInsertCountryTable:(NSString *) countryQuery;

-(NSString *) checkCountryTableCount;

-(BOOL) runScript;

-(NSString *) getCountFromCallLog:(NSString *) phonestr;

-(NSString *) getCountFromCallLogName:(NSArray *) names;

-(NSMutableArray *) getCountryPrefixCode;

-(NSMutableArray *) getCountryPrefixCodeEN;

-(NSMutableArray *) getCountryNameEn;

-(NSString *) getCountryPreEN:(NSString *)countryName;

-(NSMutableArray *) getMCC;

-(NSString *) getPrefixMCCCode:(NSInteger) mcc;

-(NSString *) getDefaultDialin:(NSString *)getPrefix;

-(NSString *) getCountrCodeID:(NSString *)getPrefix;

- (NSMutableArray *) getFavPhoneLabel;

- (NSMutableArray *) getCallLogPhoneLabels:(NSMutableArray *) numbers;

- (NSMutableArray *) getCallLogPhoneLabel:(NSString *) number;

- (NSMutableArray *) getCallLogRecNameString:(NSString *) numbers;

-(NSMutableArray *) getDefaultDialinCoutryCode;

-(NSMutableArray *) getCoutryCodeThroughDialin:(NSMutableArray *) code;

- (NSMutableArray *) getCallLogRecNameDemo:(NSMutableArray *) numbers;

- (NSMutableArray *) getCountryNameTr;

-(NSString *) getCountryPreTr:(NSString *)countryName;

-(NSMutableArray *) getCountryPrefixCodeTr;

-(NSString *) getCountryNamePre:(NSString *)countryName;

-(NSString *) getCountryNamePreTr:(NSString *)countryName;

-(NSString *) getCountryNamePreEN:(NSString *)countryName;

-(NSString *) getProviderPhone:(NSString *)phoneNumber;

-(NSString *) getProviderTime:(NSString *)phoneNumber;

-(void) updateProvider: (NSString *)phoneNumber :(NSString *)provider;

- (NSString *) getLastCallLogRec;

- (NSString *)getDateTime : (NSString *)number;

- (NSString *)getCallNetValues : (NSString *)number;

- (NSString *)getCallNetValuesOnly : (NSString *)number : (NSString *)datetime;

- (NSString *)getCountryPrefix : (NSString *)countryCode;

@end
