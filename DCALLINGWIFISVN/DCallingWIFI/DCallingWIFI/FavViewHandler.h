//
//  FavViewHandler.h
//  DCalling WiFi
//
//  Created by Prashant on 17/02/12.
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
#import "AddressBookHandler.h"
#import "RestAPICaller.h"
@interface FavViewHandler : NSObject<NSXMLParserDelegate, UIAlertViewDelegate>{
    NSMutableArray *favCall;
    RestAPICaller *restApi;
    NSData *apiData;
    NSString		*current;
    NSMutableString	*outstring;
}

@property (nonatomic, retain) AddressBookHandler *mAddr;

@property (nonatomic, retain) NSMutableArray *favCall;

@property (nonatomic) BOOL finalStatus;

@property(nonatomic, retain) NSMutableArray *favPhones;

@property(nonatomic, retain) NSMutableArray *userNames;

@property(nonatomic, retain) NSMutableArray *userLabels;

@property(nonatomic, retain) NSString *myChache;


-(void) getFavCallLog;

- (BOOL) delete:(NSString *) phoneNumber;


- (BOOL) deleteInFavView:(NSString *) phoneNumber;

-(BOOL) scanNumber:(NSString *) str;

-(NSString *) getNumber :(NSArray *) strString;

-(NSString *) getUserName:(NSString *)phoneNumber;

-(NSString *) getCallLogCount:(NSArray *)nameString;

-(NSString *) getCallLogCountPhone:(NSString *)phoneString;

-(BOOL) validateEmail: (NSString *) email ;

-(BOOL) validateMobile: (NSString *) mobile ;

-(BOOL) countryPrefixCheck: (NSString *) mobile;

-(BOOL) checkLocalNumber: (NSString *) mobile;

-(NSString *) removedPlus:(NSString *) prefixNo;

-(BOOL) checkPrefixStr:(NSString *)phone;

-(BOOL) checkPrefixStrLandLine:(NSString *)phone;

-(NSString *)getAllPhoneFromAB : (NSString *)mobilNumber;

-(BOOL) checkNumberNational:(NSString *) mobileNumber : (NSString *)originalNumber;

-(BOOL) checkNumberLandline:(NSString *) mobileNumber  : (NSString *) calleridNo : (NSString *) token : (NSString *) getPrefix : (NSString *) original;
-(BOOL)checkNumberInternational:(NSString *)mobileNumber : (NSString *) calleridNo : (NSString *) token : (NSString *) getPrefix : (NSString *) original;

-(NSString *) changeInLocalFormat:(NSString *)mobileNumer;

-(BOOL) checkGermanNumber:(NSString *)mobileNumer;

-(NSMutableArray *) fetchName : (NSMutableArray *)numbers;

-(NSMutableArray *) fetchLabel: (NSMutableArray *)numbers;

-(BOOL)checkServiceProvider:(NSString *)number;

-(BOOL)checkSettings:(NSString *)number;

-(NSString *)checkProvider:(NSString *)number;

-(void)updateTheProvider:(NSString *)mobileNumber;

-(BOOL) checkPrefixOne:(NSString *)phone;

-(BOOL) checkSingleZero:(NSString *)phone;
-(BOOL) checkRemovedPlus:(NSString *) prefixNo;

- (NSString *)convertNumber : (NSString *)mobile;
//- (BOOL)checkRoaming;

@end
