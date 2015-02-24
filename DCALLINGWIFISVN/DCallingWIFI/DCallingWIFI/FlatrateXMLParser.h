//
//  FlatrateXMLParser.h
//  DCalling WiFi
//
//  Created by Prashant Kumar on 19/01/12.
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

#import <Foundation/Foundation.h>
@interface FlatrateXMLParser : NSObject <NSXMLParserDelegate>
{
    //NSMutableURLRequest *myUrl;
	NSString		*current;
	NSMutableString	*outstring;
	NSURL			*url;
	id			delegate;
    id			callbacks;
    id			userCredit;
	NSThread		*thread;
    NSThread        *myThread;
    
    NSMutableData *outstringdata;
    NSMutableArray *parseData;
    NSMutableString *currentElementValue;
  //  NSString *token;
    NSData *xmlData;
    NSInteger depth;
    
    
}

- (FlatrateXMLParser *) initWithVerificationSMSDelegate: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithUserProviderDelegate: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithUserPasswordDelegate: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithDCallingDelegate: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithDCallingPostDelegate: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithAuthSessionDelegate: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithUserCreditDelegate: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithCallBackDCallingPostDelegate: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithVerficationCodeProvider: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithPriceValueforCountry: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithServiceProvideName: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithPushRegistration: (id) d xmlData: (NSData *) u;

- (FlatrateXMLParser *) initWithUserSIPAccount: (id) d xmlData: (NSData *) u;

- (void) runAuthSession: (id) param ;

//@property(nonatomic, retain) NSString *token;

@end
