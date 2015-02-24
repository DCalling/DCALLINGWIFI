//
//  AddressBookHandler.h
//  DCalling WiFi
//
//  Created by Prashant on 07/02/12.
//  Copyright (C) 2015 DALASON GmbH.
//  This file is part of a DALASON Project. (http://www.dalason.de)
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
@interface AddressBookHandler : NSObject<UIAlertViewDelegate, MFMessageComposeViewControllerDelegate >{
    NSString *dataStr;
    UIImage *image;
}

@property(nonatomic, retain) NSMutableArray *_allPhoneNumbers;

@property(nonatomic, retain) NSMutableArray *phoneNumbers;

@property(nonatomic, retain) NSString *trimPhoneNumber;

@property(nonatomic, copy) NSString *dataStr;

@property(nonatomic, retain) NSString *matchPhoneNumber;

@property(nonatomic, retain) NSString *getMatchedPhone;

@property(nonatomic, retain) NSMutableArray *trimMutableArray;

@property(nonatomic, retain) NSMutableArray *trimMutableArrayOfArray;

@property(nonatomic, retain) NSMutableString *PhoneBook;

@property(nonatomic, retain) NSArray *getABNames;

@property(nonatomic, retain) NSArray *getABMobiles;

@property (nonatomic, retain) NSMutableArray *addMyPhoneBook;

@property (nonatomic, retain) NSMutableString *mobileMutable;

@property (nonatomic, retain) id param;

@property(nonatomic, copy) NSString *telNumner;

-(void) setPhoneValues:(NSMutableArray *) allPhoneNumbers;

-(NSMutableArray *)getPhoneValues;

-(void) getAllPhoneFromAB;

-(BOOL) getContactCompare:(NSString *) phoneStr;

-(BOOL) getCompareWithZero:(NSString *) phoneStr;

-(void) SetReturnPhoneStr:(NSString *) phoneStr;

-(NSMutableArray *) trimWhiteSpaceMutable :(NSMutableArray *) myMutableArray;

-(NSString *) returnPhoneStr;

-(NSString *) trimWhiteSpace :(NSString *) myString;

-(void) getAddrBookName;

-(void) getAddrMobile;

-(NSString *) prefixStr:(NSString *) phone;

-(UIImage *) imageFetchFromAB: (NSString *)phoneStr;

-(NSString *) namesFromAB: (NSString *)phoneStr;

-(NSMutableArray *) trimWhiteSpaceMutableOfMutable :(NSMutableArray *) myMutableArray;

-(BOOL) updateCallLogdata;

-(BOOL) updateFavLogdata;

-(BOOL) updateCall: (NSArray *) personDetails;

-(NSString *) getDialin:(NSString *)getPrefix;

-(NSString *) getCountryID:(NSString *)getPrefix;

-(void) getAlterView: (id)param1 :(NSString *)phonenumber;

-(void) smsController: (id)param1 :(NSString *)number;

-(NSString *) trimWhiteSpaceNotZero :(NSString *) myString;

@end