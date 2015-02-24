//
//  UIImage-TUNinePatch.h
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
#import "TUNinePatchProtocols.h"

void TUImageLog(UIImage *image, NSString *imageName);
/**
 This category implements all the image-slicing, pixel-tasting, and similar image-manipulation and image-analysis functions. These are only used in methods that'll probably become private real soon now, so maybe a "not much to see here" sign is called for.
 */
@interface UIImage (TUNinePatch)

// Black Pixel Searching - Corners
-(BOOL)upperLeftCornerIsBlackPixel;
-(BOOL)upperRightCornerIsBlackPixel;
-(BOOL)lowerLeftCornerIsBlackPixel;
-(BOOL)lowerRightCornerIsBlackPixel;

// Pixel Tasting - Single Pixel
-(BOOL)isBlackPixel;

// Black Pixel Searching - Strips
-(NSRange)blackPixelRangeInUpperStrip;
-(NSRange)blackPixelRangeInLowerStrip;
-(NSRange)blackPixelRangeInLeftStrip;
-(NSRange)blackPixelRangeInRightStrip;

// Pixel Tasting - Strips
-(NSRange)blackPixelRangeAsVerticalStrip;
-(NSRange)blackPixelRangeAsHorizontalStrip;

// Corners - Rects
-(CGRect)upperLeftCornerRect;
-(CGRect)lowerLeftCornerRect;
-(CGRect)upperRightCornerRect;
-(CGRect)lowerRightCornerRect;

// Corners - Slicing
-(UIImage *)upperLeftCorner;
-(UIImage *)lowerLeftCorner;
-(UIImage *)upperRightCorner;
-(UIImage *)lowerRightCorner;

// Strips - Sizing
-(CGRect)upperStripRect;
-(CGRect)lowerStripRect;
-(CGRect)leftStripRect;
-(CGRect)rightStripRect;

// Strips - Slicing
-(UIImage *)upperStrip;
-(UIImage *)lowerStrip;
-(UIImage *)leftStrip;
-(UIImage *)rightStrip;

// Subimage Slicing
-(UIImage *)subImageInRect:(CGRect)rect;

// Nine-Patch Content Extraction
-(UIImage *)imageAsNinePatchImage;

-(UIImage *)extractUpperLeftCornerForStretchableRegion:(CGRect)stretchableRegion;
-(UIImage *)extractUpperRightCornerForStretchableRegion:(CGRect)stretchableRegion;
-(UIImage *)extractLowerLeftCornerForStretchableRegion:(CGRect)stretchableRegion;
-(UIImage *)extractLowerRightCornerForStretchableRegion:(CGRect)stretchableRegion;
-(UIImage *)extractLeftEdgeForStretchableRegion:(CGRect)stretchableRegion;
-(UIImage *)extractRightEdgeForStretchableRegion:(CGRect)stretchableRegion;
-(UIImage *)extractUpperEdgeForStretchableRegion:(CGRect)stretchableRegion;
-(UIImage *)extractLowerEdgeForStretchableRegion:(CGRect)stretchableRegion;
-(UIImage *)extractCenterForStretchableRegion:(CGRect)stretchableRegion;

@end
