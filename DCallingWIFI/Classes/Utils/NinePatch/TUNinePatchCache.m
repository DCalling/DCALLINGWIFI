//
//  TUNinePatchCache.m
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

#import "TUNinePatchCache.h"
#import "TUCachingNinePatch.h"
#import "TUNinePatch.h"

@interface TUNinePatchCache ()

@property(nonatomic, retain, readwrite) NSMutableDictionary *ninePatchCache;

@end


@implementation TUNinePatchCache

#pragma mark Synthesized Properties
@synthesize ninePatchCache = _ninePatchCache;

#pragma mark Init + Dealloc
-(id)init {
	if (self = [super init]) {
		self.ninePatchCache = [NSMutableDictionary dictionary];
	}
	return self;
}

#pragma mark -
+(id)shared {
	static TUNinePatchCache *shared;
	if (!shared) {
		shared = [[self alloc] init];
	}
	return shared;
}

#pragma mark -
-(void)dealloc {
	self.ninePatchCache = nil;
	[super dealloc];
}

#pragma mark Getting Ninepatches Directly
// Getting Ninepatches Directly
-(id < TUNinePatch >)ninePatchNamed:(NSString *)ninePatchName {
	TUCachingNinePatch *cachingNinePatch = [self cachingNinePatchNamed:ninePatchName];
	NPAssertNilOrIsKindOfClass(cachingNinePatch,TUCachingNinePatch);
	return (!cachingNinePatch)?(nil):([cachingNinePatch ninePatch]);
}


-(TUCachingNinePatch *)cachingNinePatchNamed:(NSString *)ninePatchName {
	TUCachingNinePatch *cachingNinePatch = [self cachedCachingNinePatchNamed:ninePatchName];
	NPAssertNilOrIsKindOfClass(cachingNinePatch,TUCachingNinePatch);
	if (!cachingNinePatch) {
		cachingNinePatch = [self constructCachingNinePatchNamed:ninePatchName];
		NPAssertNilOrIsKindOfClass(cachingNinePatch,TUCachingNinePatch);
		if (cachingNinePatch) {
			[self cacheCachingNinePatch:cachingNinePatch 
								  named:ninePatchName];
		}
	}
	return cachingNinePatch;
}

-(void)cacheCachingNinePatch:(TUCachingNinePatch *)cachingNinePatch named:(NSString *)ninePatchName {
	NPAssertPropertyNonNil(ninePatchCache);
	if (cachingNinePatch && ninePatchName) {
		[self.ninePatchCache setObject:cachingNinePatch 
								forKey:ninePatchName];
	}
}

-(TUCachingNinePatch *)cachedCachingNinePatchNamed:(NSString *)ninePatchName {
	return (!ninePatchName)?(nil):([self.ninePatchCache objectForKey:ninePatchName]);
}

-(TUCachingNinePatch *)constructCachingNinePatchNamed:(NSString *)ninePatchName {
	return (!ninePatchName)?(nil):([TUCachingNinePatch ninePatchCacheWithNinePatchNamed:ninePatchName]);
}

#pragma mark Getting Images Directly
-(UIImage *)imageOfSize:(CGSize)size forNinePatchNamed:(NSString *)ninePatchName {
	NPParameterAssertNotNilIsKindOfClass(ninePatchName,NSString);
	UIImage *image = nil;
	TUCachingNinePatch *cachingNinePatch = [self cachingNinePatchNamed:ninePatchName];
	if (cachingNinePatch) {
		image = [cachingNinePatch imageOfSize:size];
	}
	return image;
}

#pragma mark Getting Ninepatches - Convenience
+(TUCachingNinePatch *)cachingNinePatchNamed:(NSString *)ninePatchName {
	return [[self shared] ninePatchNamed:ninePatchName];
}

+(id < TUNinePatch >)ninePatchNamed:(NSString *)ninePatchName {
	TUCachingNinePatch *cachingNinePatch = [[self shared] cachingNinePatchNamed:ninePatchName];
	NPAssertNilOrIsKindOfClass(cachingNinePatch,TUCachingNinePatch);
	return (!cachingNinePatch)?(nil):([cachingNinePatch ninePatch]);
}

#pragma mark Getting Images - Convenience
+(UIImage *)imageOfSize:(CGSize)size forNinePatchNamed:(NSString *)ninePatchName {
	return [[self shared] imageOfSize:size 
					forNinePatchNamed:ninePatchName];
}

#pragma mark Cache Management - Direct
-(void)flushCache {
	[self.ninePatchCache removeAllObjects];
}
-(void)flushCacheForNinePatchNamed:(NSString *)name {
	if (name) {
		[self.ninePatchCache removeObjectForKey:name];
	}
}

#pragma mark Cache Management - Convenience
+(void)flushCache {
	[[self shared] flushCache];
}

+(void)flushCacheForNinePatchNamed:(NSString *)name {
	[[self shared] flushCacheForNinePatchNamed:name];
}

@end