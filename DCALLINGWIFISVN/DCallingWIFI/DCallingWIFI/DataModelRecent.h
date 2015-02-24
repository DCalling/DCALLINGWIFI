//
//  DataModelRecent.h
//  DCalling WiFi
//
//  Created by Prashant Kumar on 20/06/12.
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
#import "RestAPICaller.h"


@interface DataModelRecent : NSObject<UIAlertViewDelegate, NSXMLParserDelegate>{
    NSTimer *updateTimer;
    NSRunLoop* runLoopData;
    NSAutoreleasePool* pool;
    NSString *fName;
    NSString *lName;
    NSString *mLabel;
    NSString *oNumber;
    NSString *tNumber;
    UIViewController *pController;
    RestAPICaller *restApiCaller;
    NSData *restData;
    NSMutableString	*outstring;
    NSString		*current;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSArray *selectedDetails;
@property (nonatomic, retain) id param;
@property (nonatomic, retain) NSString *fName;
@property (nonatomic, retain) NSString *lName;
@property (nonatomic, retain) NSString *mLabel;
@property (nonatomic, retain) NSString *mProvider;
@property (nonatomic, retain) NSString *mvaluesProvider;
@property (nonatomic, retain) NSString *oNumber;
@property (nonatomic, retain) NSString *tNumber;
@property (nonatomic, retain) UIViewController *pController;
@property (nonatomic, retain) NSArray *mainValues;
@property (nonatomic, retain) NSArray *noInternet;
@property (nonatomic, retain) NSArray *callingCallBack;
@property (nonatomic) int alertValues;


-(void) callingMethod: (NSString *)firstName : (NSString *)lastname : (NSString *)mobileLabel : (NSString *)originalNumber : (NSString *)trimNumber :(UIViewController *) param1;

-(void) callBackMethod:(NSString *)firstName : (NSString *)lastname : (NSString *)trimNumber;

-(void)stopTimer;

-(void)otherCountriesDialing : (NSString *)getPrefix : (NSString *)trimNumber : (NSString *)originalNumber : (NSString *)calleridNo : (NSString *)token :(BOOL)st;

@end
