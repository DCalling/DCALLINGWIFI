//
//  IASKSettingsStoreUserDefaults.m
//  Created by Prashant on 23/02/12.
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


#import "IASKSettingsStoreUserDefaults.h"


@implementation IASKSettingsStoreUserDefaults

- (void)setBool:(BOOL)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
}

- (void)setInteger:(int)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

- (void)setObject:(id)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (BOOL)boolForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (float)floatForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

- (double)doubleForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

- (int)integerForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (id)objectForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (BOOL)synchronize {
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
