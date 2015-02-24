//
//  TUHorizontalNinePatch.h
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

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "TUNinePatch.h"
#import "TUNinePatchProtocols.h"

/**
 Concrete TUNinePatch instance. Handles NinePatches that stretch horizontally but not vertically. Only instantiate directly if you know what you're doing.
 */
@interface TUHorizontalNinePatch : TUNinePatch  < TUNinePatch > {
	UIImage *_leftEdge;
	UIImage *_rightEdge;
}

// Synthesized Properties
@property(nonatomic, retain, readonly) UIImage *leftEdge;
@property(nonatomic, retain, readonly) UIImage *rightEdge;

// Init + Dealloc
-(id)initWithCenter:(UIImage *)center contentRegion:(CGRect)contentRegion tileCenterVertically:(BOOL)tileCenterVertically tileCenterHorizontally:(BOOL)tileCenterHorizontally leftEdge:(UIImage *)leftEdge rightEdge:(UIImage *)rightEdge;
-(void)dealloc;

// TUNinePatch Overrides
-(void)drawInRect:(CGRect)rect;
-(BOOL)stretchesVertically;
-(CGSize)sizeForContentOfSize:(CGSize)contentSize;
-(CGFloat)leftEdgeWidth;
-(CGFloat)rightEdgeWidth;

@end
