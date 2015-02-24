//
//  TUCachingNinePatch.m
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

#import "TUCachingNinePatch.h"
#import "TUNinePatch.h"
#import "TUNinePatchCachingCategories.h"

@interface TUCachingNinePatch ()

// Synthesized Properties
@property(nonatomic, retain, readwrite) id < TUNinePatch > ninePatch;
@property(nonatomic, retain, readwrite) NSMutableDictionary *ninePatchImageCache;

@end


@implementation TUCachingNinePatch

#pragma mark Synthesized Properties
@synthesize ninePatch = _ninePatch;
@synthesize ninePatchImageCache = _ninePatchImageCache;

#pragma mark Init + Dealloc
-(id)initWithNinePatchNamed:(NSString *)ninePatchName {
	return [self initWithNinePatch:[TUNinePatch ninePatchNamed:ninePatchName]];
}

-(id)initWithNinePatch:(id < TUNinePatch >)ninePatch {
	if (self = [super init]) {
		self.ninePatch = ninePatch;
		self.ninePatchImageCache = [NSMutableDictionary dictionaryWithCapacity:5];
	}
	return self;
}

#pragma mark -
+(id)ninePatchCacheWithNinePatchNamed:(NSString *)ninePatchName {
	return [[[self alloc] initWithNinePatchNamed:ninePatchName] autorelease];
}

+(id)ninePatchCacheWithNinePatch:(id < TUNinePatch >)ninePatch {
	return [[[self alloc] initWithNinePatch:ninePatch] autorelease];
}

#pragma mark -
-(void)dealloc {
	self.ninePatch = nil;
	self.ninePatchImageCache = nil;
	[super dealloc];
}

#pragma mark NSCoding
-(id)initWithCoder:(NSCoder *)aDecoder {
	NSParameterAssert(aDecoder != nil);
	if (self = [super init]) {
		self.ninePatch = [aDecoder decodeObjectForKey:@"ninePatch"];
		self.ninePatchImageCache = [aDecoder decodeObjectForKey:@"ninePatchImageCache"];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)anEncoder {
	NSParameterAssert(anEncoder != nil);
	[anEncoder encodeObject:self.ninePatch 
					 forKey:@"ninePatch"];
	[anEncoder encodeObject:self.ninePatchImageCache 
					 forKey:@"ninePatchImageCache"];
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone {
	return [[[self class] alloc] initWithNinePatch:self.ninePatch];
}

#pragma mark Nib
-(void)awakeFromNib {
	[super awakeFromNib];
	if (!self.ninePatchImageCache) { 
		self.ninePatchImageCache = [NSMutableDictionary dictionaryWithCapacity:5];
	};
}

#pragma mark Cache Management
-(void)flushCachedImages {
	NPAssertPropertyNonNil(ninePatchImageCache);
	[self.ninePatchImageCache removeAllObjects];
}

#pragma mark Image Access - Utility Accessors
-(UIImage *)imageOfSize:(CGSize)size {
	UIImage *imageOfSize = [self cachedImageOfSize:size];
	if (!imageOfSize) {
		imageOfSize = [self constructImageOfSize:size];
		if (imageOfSize) {
			[self cacheImage:imageOfSize 
					  ofSize:size];
		}
	}
	return imageOfSize;
}

#pragma mark Cache Access
-(void)cacheImage:(UIImage *)image ofSize:(CGSize)size {
	NPParameterAssertNotNilIsKindOfClass(image,UIImage);
	NPAssertPropertyNonNil(self.ninePatchImageCache);
	return [self.ninePatchImageCache setObject:image 
									   forSize:size];
}

-(UIImage *)cachedImageOfSize:(CGSize)size {
	NPAssertPropertyNonNil(ninePatchImageCache);
	return [self.ninePatchImageCache objectForSize:size];
}

#pragma mark Image Construction
-(UIImage *)constructImageOfSize:(CGSize)size {
	NPAssertPropertyNonNil(ninePatch);
	return (!self.ninePatch)?(nil):([self.ninePatch imageOfSize:size]);
}

@end
