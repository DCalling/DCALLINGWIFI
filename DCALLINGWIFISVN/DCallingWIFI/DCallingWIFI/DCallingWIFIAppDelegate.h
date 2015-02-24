//
//  DCallingWIFIAppDelegate.h
//  DCalling WiFi
//
//  Created by David C. Son on 03.01.12.
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

#import <UIKit/UIKit.h>
#import "SQLiteDBHandler.h"
#import <FacebookSDK/FacebookSDK.h>

#import "LinphoneCoreSettingsStore.h"

@interface DCallingWIFIAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>{
    SQLiteDBHandler *sqliteDB;
    FBSessionState *activeSession;
    NSTimer *creditTimer;
@private
	UIBackgroundTaskIdentifier bgStartId;
    BOOL started;
	int savedMaxCall;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (assign) BOOL started;
@property (nonatomic) BOOL checkVal;
@property(nonatomic, retain) NSString *numbers;
@property (nonatomic, retain) NSString *dName;
@property (nonatomic) BOOL addCallValue;
@property (nonatomic, retain) NSString *configURL;
-(NSString *) currentDatetime;

@end
