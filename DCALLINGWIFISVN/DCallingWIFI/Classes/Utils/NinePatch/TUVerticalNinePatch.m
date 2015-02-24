//
//  TUVerticalNinePatch.m
//  NinePatch
//
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
//

#import "TUVerticalNinePatch.h"

@interface TUVerticalNinePatch ()

// Synthesized Properties
@property(nonatomic, retain, readwrite) UIImage *upperEdge;
@property(nonatomic, retain, readwrite) UIImage *lowerEdge;

@end


@implementation TUVerticalNinePatch

#pragma mark Synthesized Properties
@synthesize upperEdge = _upperEdge;
@synthesize lowerEdge = _lowerEdge;

#pragma mark NSCoding
-(id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		self.upperEdge = (UIImage *)[coder decodeObjectForKey:@"upperEdge"];
		self.lowerEdge = (UIImage *)[coder decodeObjectForKey:@"lowerEdge"];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	
	[coder encodeObject:self.upperEdge 
				 forKey:@"upperEdge"];

	[coder encodeObject:self.lowerEdge 
				 forKey:@"lowerEdge"];
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone {
	return [[[self class] allocWithZone:zone] initWithCenter:self.center 
											   contentRegion:self.contentRegion 
										tileCenterVertically:self.tileCenterVertically 
									  tileCenterHorizontally:self.tileCenterHorizontally 
												   upperEdge:self.upperEdge 
												   lowerEdge:self.lowerEdge];
}

#pragma mark Init + Dealloc
-(id)initWithCenter:(UIImage *)center contentRegion:(CGRect)contentRegion tileCenterVertically:(BOOL)tileCenterVertically tileCenterHorizontally:(BOOL)tileCenterHorizontally upperEdge:(UIImage *)upperEdge lowerEdge:(UIImage *)lowerEdge {
	NPParameterAssertNotNilIsKindOfClass(upperEdge,UIImage);
	NPParameterAssertNotNilIsKindOfClass(lowerEdge,UIImage);
	if (self = [super initWithCenter:center 
					   contentRegion:contentRegion 
				tileCenterVertically:tileCenterVertically 
			  tileCenterHorizontally:tileCenterHorizontally]) {
		self.upperEdge = upperEdge;
		self.lowerEdge = lowerEdge;
	}
	return self;
}

#pragma mark -
-(void)dealloc {
	self.upperEdge = nil;
	self.lowerEdge = nil;
	[super dealloc];
}

#pragma mark TUNinePatch Overrides
-(void)drawInRect:(CGRect)rect {
	NPSelfProperty(center);
	NPSelfProperty(upperEdge);
	NPSelfProperty(lowerEdge);
	CGFloat width = [self minimumWidth];
	[self.center drawInRect:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + [self upperEdgeHeight], width, CGRectGetHeight(rect) - ([self upperEdgeHeight] + [self lowerEdgeHeight]))];
	if (self.upperEdge) {
		[self.upperEdge drawAtPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
	}
	if (self.lowerEdge) {
		[self.lowerEdge drawAtPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) - [self lowerEdgeHeight])];
	}	
}

#pragma mark -
-(BOOL)stretchesHorizontally {
	return NO;
}

-(CGSize)sizeForContentOfSize:(CGSize)contentSize {
	NPAInputLog(@"sizeForContentOfSize:'%@'",NSStringFromCGSize(contentSize));
	CGSize outSize = [super sizeForContentOfSize:contentSize];
	outSize.width = [self minimumWidth];
	NPCGSOutputLog(outSize);
	return outSize;
}

#pragma mark -
-(CGFloat)upperEdgeHeight {
	NPSelfProperty(upperEdge);
	CGFloat upperEdgeHeight = 0.0f;
	if (self.upperEdge) {
		upperEdgeHeight = [self.upperEdge size].height;
	}
	NPFOutputLog(upperEdgeHeight);
	return upperEdgeHeight;
}

-(CGFloat)lowerEdgeHeight {
	NPSelfProperty(lowerEdge);
	CGFloat lowerEdgeHeight = 0.0f;
	if (self.lowerEdge) {
		lowerEdgeHeight = [self.lowerEdge size].height;
	}
	NPFOutputLog(lowerEdgeHeight);
	return lowerEdgeHeight;
}

#pragma mark Customized Description Overrides
-(NSString *)descriptionPostfix {
	return [NSString stringWithFormat:@"%@, self.upperEdge:<'%@'>, self.lowerEdge:<'%@'>", 
			[super descriptionPostfix],
			self.upperEdge, 
			self.lowerEdge];
}

@end