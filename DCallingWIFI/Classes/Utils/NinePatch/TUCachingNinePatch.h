//
//  TUCachingNinePatch.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TUNinePatchProtocols.h"

@interface TUCachingNinePatch : NSObject < NSCoding, NSCopying > {
	id < TUNinePatch > _ninePatch;
	NSMutableDictionary *_ninePatchImageCache;
}

// Synthesized Properties
@property(nonatomic, retain, readonly) id < TUNinePatch > ninePatch;
@property(nonatomic, retain, readonly) NSMutableDictionary *ninePatchImageCache;

// Init + Dealloc
-(id)initWithNinePatchNamed:(NSString *)ninePatchName;
-(id)initWithNinePatch:(id < TUNinePatch >)ninePatch;
+(id)ninePatchCacheWithNinePatchNamed:(NSString *)ninePatchName;
+(id)ninePatchCacheWithNinePatch:(id < TUNinePatch >)ninePatch;
-(void)dealloc;

// NSCoding
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)anEncoder;

// NSCopying
-(id)copyWithZone:(NSZone *)zone;

// Nib
-(void)awakeFromNib;

// Cache Management
-(void)flushCachedImages;

// Image Access - Utility Accessors
-(UIImage *)imageOfSize:(CGSize)size;

// Cache Access
-(void)cacheImage:(UIImage *)image ofSize:(CGSize)size;
-(UIImage *)cachedImageOfSize:(CGSize)size;

// Image Construction
-(UIImage *)constructImageOfSize:(CGSize)size;

@end
