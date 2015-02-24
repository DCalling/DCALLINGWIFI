//
//  TUDebugLoggingAssistant.h
//  NinePatch
//
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
//

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>


@interface TUDebugLoggingAssistant : NSObject {
	NSString *_sessionIdentifier;
	NSMutableSet *_activatedLoggingTags;
}

// Synthesized Properties
@property(nonatomic, retain, readonly) NSString *sessionIdentifier;
@property(nonatomic, retain, readonly) NSMutableSet *activatedLoggingTags;

// Init + Dealloc
-(id)init;
-(void)dealloc;

// Managing Logging
-(void)startLoggingTag:(NSString *)loggingTag;
-(void)stopLoggingTag:(NSString *)loggingTag;
-(void)startLoggingTags:(NSString *)loggingTag,...;
-(void)stopLoggingTags:(NSString *)loggingTag,...;
-(void)startLoggingTagsFromArray:(NSArray *)loggingTags;
-(void)stopLoggingTagsFromArray:(NSArray *)loggingTags;

// Formatting
-(NSString *)formattedImageLogFilenameForTimestamp:(NSTimeInterval)timestamp specifiedFileName:(NSString *)specifiedFileName;

// Log-Checking
-(BOOL)shouldLogLineWithTag:(NSString *)tag;

// Singleton Access
+(id)shared;

// Managing Logging
+(void)startLoggingTag:(NSString *)loggingTag;
+(void)stopLoggingTag:(NSString *)loggingTag;
+(void)startLoggingTags:(NSString *)loggingTag,...;
+(void)stopLoggingTags:(NSString *)loggingTag,...;
+(void)startLoggingTagsFromArray:(NSArray *)loggingTags;
+(void)stopLoggingTagsFromArray:(NSArray *)loggingTags;

// Formatting
+(NSString *)formattedImageLogFilenameForTimestamp:(NSTimeInterval)timestamp specifiedFileName:(NSString *)specifiedFileName;

// Log-Checking
+(BOOL)shouldLogLineWithTag:(NSString *)tag;

@end
