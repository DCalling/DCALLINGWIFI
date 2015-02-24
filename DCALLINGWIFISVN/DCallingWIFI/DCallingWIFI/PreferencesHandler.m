//
//  PreferencesHandler.m
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

#import "PreferencesHandler.h"

@implementation PreferencesHandler

-(NSString *) getCallerID
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *callerID = [settings stringForKey : @"callerID"];
    return callerID;
}

-(void) setCallerID: (NSString *)callerID
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : callerID forKey : @"callerID"];
    [settings synchronize];
}

-(NSString *) getToken
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *token = [settings stringForKey : @"token"];
    return token;
}

-(void) setToken: (NSString *)token
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : token forKey : @"token"];
    [settings synchronize];
}

-(NSString *) getDropBox
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *dropBox = [settings stringForKey : @"dropBox"];
    return dropBox;
}

-(void) setDropBox: (NSString *)dropBox
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : dropBox forKey : @"dropBox"];
    [settings synchronize];
}

-(NSString *) getCallerBox
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *callerBox = [settings stringForKey : @"callerBox"];
    return callerBox;
}

-(void) setCallerBox: (NSString *)callerBox
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : callerBox forKey : @"callerBox"];
    [settings synchronize];
}

-(NSString *) getCredit
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *credit = [settings stringForKey : @"credit"];
    return credit;
}

-(void) setCredit: (NSString *)credit
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : credit forKey : @"credit"];
    [settings synchronize];
}

-(NSString *) getMNC{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *mnc = [settings stringForKey : @"mnc"];
    return mnc;
}
-(void) setMNC : (NSString *)mnc{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : mnc forKey : @"mnc"];
    [settings synchronize];
}

-(NSString *) getMCC{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *mcc = [settings stringForKey : @"mcc"];
    return mcc;
}
-(void) setMCC : (NSString *)mcc{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : mcc forKey : @"mcc"];
    [settings synchronize];
}

-(NSString *) getCarrier{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *carrier = [settings stringForKey : @"carrier"];
    return carrier;
}
-(void) setCarrier : (NSString *)carrier{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : carrier forKey : @"carrier"];
    [settings synchronize];
}

-(BOOL) getCallingStatus{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"boolealnDidCall"];
    return boolealnDidCall;
}
-(void) setCallingStatus:(BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"boolealnDidCall"];
    [settings synchronize];
}

-(BOOL) getViewSt{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"boolealnDidView"];
    return boolealnDidCall;
}
-(void) setViewSt: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"boolealnDidView"];
    [settings synchronize];
}

-(BOOL) getDoNot{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"booleanDoNot"];
    return boolealnDidCall;
}
-(void) setDoNot: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"booleanDoNot"];
    [settings synchronize];
}

-(BOOL) getAllGermanProvider{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"booleanAllGerman"];
    return boolealnDidCall;
}
-(void) setAllGermanProvider: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"booleanAllGerman"];
    [settings synchronize];
}

-(BOOL) getTmobile{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"booleantmobile"];
    return boolealnDidCall;
}
-(void) setTmobile: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"booleantmobile"];
    [settings synchronize];
}

-(BOOL) getVodafone{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"booleanvodafone"];
    return boolealnDidCall;
}
-(void) setVodafone: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"booleanvodafone"];
    [settings synchronize];
}

-(BOOL) getEPlus{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"booleaneplus"];
    return boolealnDidCall;
}
-(void) setEPlus: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"booleaneplus"];
    [settings synchronize];
}

-(BOOL) getOTwo{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"booleanotwo"];
    return boolealnDidCall;
}
-(void) setOTwo: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"booleanotwo"];
    [settings synchronize];
}

-(BOOL) getTelogic{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"booleantelogic"];
    return boolealnDidCall;
}
-(void) setTelogic: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"booleantelogic"];
    [settings synchronize];
}

-(NSString *) getServiceProvider{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *provider = [settings stringForKey : @"provider"];
    return provider;
}
-(void) setServiceProvider : (NSString *)provider{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : provider forKey : @"provider"];
    [settings synchronize];
}

-(NSString *) getProviderInfo{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
   // NSMutableArray *provider = [settings ar];
    NSString *provider = [settings stringForKey : @"providerNames"];    
    return provider;
}
-(void) setProviderInfo : (NSString *)provider{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : provider forKey : @"providerNames"];
    [settings synchronize];
}

-(NSString *) getBestSearchProvider{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *boolealnDidCall = [settings stringForKey:@"bestsearchprovider"];
    return boolealnDidCall;
}
-(void) setBestSearchProvider: (NSString *)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : boolealnDidCall forKey : @"bestsearchprovider"];
    [settings synchronize];
}

-(BOOL) getInternetConnection{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"connection"];
    return boolealnDidCall;
}
-(void) setInternetConnection: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"connection"];
    [settings synchronize];
}

-(NSString *) getInternetVal{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *boolealnDidCall = [settings stringForKey:@"strVal"];
    return boolealnDidCall;
}
-(void) setInternetVal: (NSString *)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : boolealnDidCall forKey : @"strVal"];
    [settings synchronize];
}

-(BOOL) getRoaming{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"boolroaming"];
    return boolealnDidCall;

}
-(void) setRoaming: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"boolroaming"];
    [settings synchronize];
}

-(NSString *) getDeviceToken{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *boolealnDidCall = [settings stringForKey:@"deviceToken"];
    return boolealnDidCall;
}
-(void) setDeviceToken: (NSString *)deviceToken{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : deviceToken forKey : @"deviceToken"];
    [settings synchronize];
}

-(NSString *) getPushRegistrationStatus{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *boolealnDidCall = [settings stringForKey:@"pushRegistrationStatus"];
    return boolealnDidCall;
}
-(void) setPushRegistrationStatus: (NSString *)deviceToken{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : deviceToken forKey : @"pushRegistrationStatus"];
    [settings synchronize];
}

-(BOOL) getInternetStatus{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"intstatus"];
    return boolealnDidCall;
}
-(void) setInternetStatus: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"intstatus"];
    [settings synchronize];
}

-(BOOL) getInstalledDB{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL boolealnDidCall = [settings boolForKey:@"installedDB"];
    return boolealnDidCall;
}
-(void) setInstalledDB: (BOOL)boolealnDidCall{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:boolealnDidCall forKey : @"installedDB"];
    [settings synchronize];
}

-(NSString *) getRegisterSIP{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *registered = [settings stringForKey : @"checkRegistered"];
    return registered;
}
-(void) setRegisterSIP: (NSString *)registered{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : registered forKey : @"checkRegistered"];
    [settings synchronize];
}

-(NSString *) getUserSIPLogin{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *UserSIPLogin = [settings stringForKey : @"UserSIPLogin"];
    return UserSIPLogin;
}
-(void) setUserSIPLogin:(NSString *)UserSIPLogin{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : UserSIPLogin forKey : @"UserSIPLogin"];
    [settings synchronize];
}

-(NSString *) getUserSIPPass{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *UserSIPPass = [settings stringForKey : @"UserSIPPass"];
    return UserSIPPass;
}
-(void) setUserSIPPass:(NSString *)UserSIPPass{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : UserSIPPass forKey : @"UserSIPPass"];
    [settings synchronize];
}

-(NSString *) getUserSIPProxy{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *UserSIPProxy = [settings stringForKey : @"UserSIPProxy"];
    return UserSIPProxy;
}
-(void) setUserSIPProxy:(NSString *)UserSIPProxy{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject : UserSIPProxy forKey : @"UserSIPProxy"];
    [settings synchronize];
}

@end
