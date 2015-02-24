//
//  getCreditHandler.m
//  DCalling WiFi
//
//  Created by Prashant Kumar on 07/05/12.
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

#import "getCreditHandler.h"
#import "RestAPICaller.h"
#import "PreferencesHandler.h"
#import "FlatrateXMLParser.h"

@implementation getCreditHandler

-(void) getCredit {
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
    NSString *token = [mPrefs getToken];
    RestAPICaller *mRst = [[RestAPICaller alloc]init];
    NSData *restForCredit = [mRst getUserCredit:token];
    FlatrateXMLParser *mFlat;
    mFlat = [[FlatrateXMLParser alloc] initWithUserCreditDelegate: self xmlData:restForCredit];
   
}

-(void)getCreditParserDidComplete:(NSMutableString *) result{
    NSRange textRange;
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
    //BOOL status;
    textRange = [result rangeOfString:@"success"];
    //NSLog(@"xml %@", result);
    // NSLog(@"123");
    NSRange textRangeError;
    textRangeError =[result rangeOfString:@"error"];
    
    if(textRange.location != NSNotFound){
        // status = true;
        NSString *myString = [NSString stringWithString:result];
        
        NSString *number = [[myString componentsSeparatedByString:@"\n"] objectAtIndex:3];
        NSRange rangeStr = NSMakeRange (0, [number length]-3);
        NSString *trimPhoneNumber = [number substringWithRange:rangeStr];
        //NSString *trimPhoneNumber = @"8.56";
        NSString *sign = @" €";
        NSString *creditValue = [trimPhoneNumber stringByAppendingFormat:@"%@",sign];
        //NSLog(@"cr %@", creditValue);
        PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
        [mPrefs setCredit:creditValue];
        //[mPrefs setCredit:@"20.0 €"];
        //NSLog(@"credited");      
    }
    else if (textRangeError.location != NSNotFound){
        [self checkAuthToken:[mPrefs getCallerID]];
    }
    else{
        //status = false;
        NSLog(@"Not credit");
    }
    
}

-(void)checkAuthToken:(NSString *)AuthToken{
    RestAPICaller *restApiCaller = [[RestAPICaller alloc]init];
    NSData *restData = [restApiCaller getAuthUser:AuthToken];
    FlatrateXMLParser *flatrateXMLParser;
    //NSLog(@"%lu", (unsigned long)[restData length]);
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithAuthSessionDelegate:self xmlData:restData];
    //[restData release];
}

-(void)authSessionParserDidComplete:(NSMutableString *) result {
    
    // NSLog(@"######## in AuthSessionParseDidComplete");
    
    // NSLog(@"Hello AuthSession - %@",result);
    NSString *myString = [NSString stringWithString:result];
    NSRange range = NSMakeRange (25, 32);
    
    NSString *authSessionToken = [myString substringWithRange:range];
    PreferencesHandler *preferences = [[[PreferencesHandler alloc]init]autorelease];
    //NSLog(@"TOken %@", [preferences getToken]);
    if(![[preferences getToken] isEqualToString:authSessionToken]){
        [preferences setToken:authSessionToken];
        [self getCredit];
    }
}

@end
