//
//  IASKSettingsStore.m
//  Created by Prashant on 23/02/12.
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


#import "IASKSettingsStore.h"

@implementation IASKAbstractSettingsStore

- (void)setObject:(id)value forKey:(NSString*)key {
    [NSException raise:@"Unimplemented"
                format:@"setObject:forKey: must be implemented in subclasses of IASKAbstractSettingsStore"];
}

- (id)objectForKey:(NSString*)key {
    [NSException raise:@"Unimplemented"
                format:@"objectForKey: must be implemented in subclasses of IASKAbstractSettingsStore"];
    return nil;
}

- (void)setBool:(BOOL)value forKey:(NSString*)key {
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString*)key {
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setInteger:(int)value forKey:(NSString*)key {
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString*)key {
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

- (BOOL)boolForKey:(NSString*)key {
    return [[self objectForKey:key] boolValue];
}

- (float)floatForKey:(NSString*)key {
    return [[self objectForKey:key] floatValue];
}
- (int)integerForKey:(NSString*)key {
    return [[self objectForKey:key] intValue];
}

- (double)doubleForKey:(NSString*)key {
    return [[self objectForKey:key] doubleValue];
}

- (BOOL)synchronize {
    return NO;
}

@end
