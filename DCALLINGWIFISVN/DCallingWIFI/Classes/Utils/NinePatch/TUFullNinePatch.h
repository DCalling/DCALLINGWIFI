//
//  TUFullNinePatch.h
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
 Concrete TUNinePatch instance. Handles NinePatches that stretch horizontally and vertically. Only instantiate directly if you know what you're doing.
 */
@interface TUFullNinePatch : TUNinePatch < TUNinePatch > {
	UIImage *_upperEdge;
	UIImage *_lowerEdge;
	UIImage *_leftEdge;
	UIImage *_rightEdge;
	UIImage *_upperLeftCorner;
	UIImage *_lowerLeftCorner;
	UIImage *_upperRightCorner;
	UIImage *_lowerRightCorner;
}

// Synthesized Properties
@property(nonatomic, retain, readonly) UIImage *upperEdge;
@property(nonatomic, retain, readonly) UIImage *lowerEdge;
@property(nonatomic, retain, readonly) UIImage *leftEdge;
@property(nonatomic, retain, readonly) UIImage *rightEdge;

@property(nonatomic, retain, readonly) UIImage *upperLeftCorner;
@property(nonatomic, retain, readonly) UIImage *lowerLeftCorner;
@property(nonatomic, retain, readonly) UIImage *upperRightCorner;
@property(nonatomic, retain, readonly) UIImage *lowerRightCorner;

// Init + Dealloc
-(id)initWithCenter:(UIImage *)center contentRegion:(CGRect)contentRegion tileCenterVertically:(BOOL)tileCenterVertically tileCenterHorizontally:(BOOL)tileCenterHorizontally upperLeftCorner:(UIImage *)upperLeftCorner upperRightCorner:(UIImage *)upperRightCorner lowerLeftCorner:(UIImage *)lowerLeftCorner lowerRightCorner:(UIImage *)lowerRightCorner leftEdge:(UIImage *)leftEdge rightEdge:(UIImage *)rightEdge upperEdge:(UIImage *)upperEdge lowerEdge:(UIImage *)lowerEdge;
-(void)dealloc;

// Sanity-Checking Tools
-(BOOL)checkSizeSanityAgainstOriginalImage:(UIImage *)originalImage;

// TUNinePatch Overrides
-(void)drawInRect:(CGRect)rect;
-(CGFloat)leftEdgeWidth;
-(CGFloat)rightEdgeWidth;
-(CGFloat)upperEdgeHeight;
-(CGFloat)lowerEdgeHeight;

// Image Logging
-(void)logExplodedImage;

@end