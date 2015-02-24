//
//  PreferencesHandler.h
//  DCalling WiFi
//
//  Created by David C. Son on 19.01.12.
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

@interface PreferencesHandler : NSObject

-(NSString *) getCallerID;
-(void) setCallerID: (NSString *)callerID;

-(NSString *) getToken;
-(void) setToken: (NSString *)token;

-(NSString *) getCallerBox;
-(void) setCallerBox: (NSString *)callerBox;

-(NSString *) getDropBox;
-(void) setDropBox: (NSString *)dropBox;

-(NSString *) getCredit;
-(void) setCredit : (NSString *)mnc;

-(NSString *) getMNC;
-(void) setMNC : (NSString *)mnc;

-(NSString *) getMCC;
-(void) setMCC : (NSString *)mnc;

-(NSString *) getCarrier;
-(void) setCarrier : (NSString *)mnc;

-(NSString *) getServiceProvider;
-(void) setServiceProvider : (NSString *)provider;

-(BOOL) getCallingStatus;
-(void) setCallingStatus: (BOOL)boolealnDidCall;

-(BOOL) getViewSt;
-(void) setViewSt: (BOOL)boolealnDidCall;

-(BOOL) getDoNot;
-(void) setDoNot: (BOOL)boolealnDidCall;

-(BOOL) getAllGermanProvider;
-(void) setAllGermanProvider: (BOOL)boolealnDidCall;

-(BOOL) getTmobile;
-(void) setTmobile: (BOOL)boolealnDidCall;

-(BOOL) getVodafone;
-(void) setVodafone: (BOOL)boolealnDidCall;

-(BOOL) getEPlus;
-(void) setEPlus: (BOOL)boolealnDidCall;

-(BOOL) getOTwo;
-(void) setOTwo: (BOOL)boolealnDidCall;

-(BOOL) getTelogic;
-(void) setTelogic: (BOOL)boolealnDidCall;

-(NSString *) getProviderInfo;
-(void) setProviderInfo : (NSString *)provider;

-(NSString *) getBestSearchProvider;
-(void) setBestSearchProvider: (NSString *)boolealnDidCall;

-(BOOL) getInternetConnection;
-(void) setInternetConnection: (BOOL)boolealnDidCall;

-(NSString *) getInternetVal;
-(void) setInternetVal: (NSString *)boolealnDidCall;

-(BOOL) getRoaming;
-(void) setRoaming: (BOOL)boolealnDidCall;

-(NSString *) getDeviceToken;
-(void) setDeviceToken: (NSString *)deviceToken;

-(NSString *) getPushRegistrationStatus;
-(void) setPushRegistrationStatus: (NSString *)deviceToken;

-(BOOL) getInternetStatus;
-(void) setInternetStatus: (BOOL)boolealnDidCall;

-(BOOL) getInstalledDB;
-(void) setInstalledDB: (BOOL)boolealnDidCall;

-(NSString *) getRegisterSIP;
-(void) setRegisterSIP: (NSString *)registered;

-(NSString *) getUserSIPLogin;
-(void) setUserSIPLogin: (NSString *)UserSIPLogin;

-(NSString *) getUserSIPPass;
-(void) setUserSIPPass: (NSString *)UserSIPPass;

-(NSString *) getUserSIPProxy;
-(void) setUserSIPProxy: (NSString *)UserSIPProxy;

@end
