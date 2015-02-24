//
//  DCRoundSwitchKnobLayer.m
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

#import "DCRoundSwitchKnobLayer.h"

CGGradientRef CreateGradientRefWithColors(CGColorSpaceRef colorSpace, CGColorRef startColor, CGColorRef endColor);

@implementation DCRoundSwitchKnobLayer
@synthesize gripped;

- (void)drawInContext:(CGContextRef)context
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGRect knobRect = CGRectInset(self.bounds, 2, 2);
	CGFloat knobRadius = self.bounds.size.height - 2;

	// knob outline (shadow is drawn in the toggle layer)
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.62 alpha:1.0].CGColor);
	CGContextSetLineWidth(context, 1.5);
	CGContextStrokeEllipseInRect(context, knobRect);
	CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0, NULL);

	// knob inner gradient
	CGContextAddEllipseInRect(context, knobRect);
	CGContextClip(context);
	CGColorRef knobStartColor = [UIColor colorWithWhite:0.82 alpha:1.0].CGColor;
	CGColorRef knobEndColor = (self.gripped) ? [UIColor colorWithWhite:0.894 alpha:1.0].CGColor : [UIColor colorWithWhite:0.996 alpha:1.0].CGColor;
	CGPoint topPoint = CGPointMake(0, 0);
	CGPoint bottomPoint = CGPointMake(0, knobRadius + 2);
	CGGradientRef knobGradient = CreateGradientRefWithColors(colorSpace, knobStartColor, knobEndColor);
	CGContextDrawLinearGradient(context, knobGradient, topPoint, bottomPoint, 0);
	CGGradientRelease(knobGradient);

	// knob inner highlight
	CGContextAddEllipseInRect(context, CGRectInset(knobRect, 0.5, 0.5));
	CGContextAddEllipseInRect(context, CGRectInset(knobRect, 1.5, 1.5));
	CGContextEOClip(context);
	CGGradientRef knobHighlightGradient = CreateGradientRefWithColors(colorSpace, [UIColor whiteColor].CGColor, [UIColor colorWithWhite:1.0 alpha:0.5].CGColor);
	CGContextDrawLinearGradient(context, knobHighlightGradient, topPoint, bottomPoint, 0);
	CGGradientRelease(knobHighlightGradient);

	CGColorSpaceRelease(colorSpace);
}

CGGradientRef CreateGradientRefWithColors(CGColorSpaceRef colorSpace, CGColorRef startColor, CGColorRef endColor)
{
	CGFloat colorStops[2] = {0.0, 1.0};
	CGColorRef colors[] = {startColor, endColor};
	CFArrayRef colorsArray = CFArrayCreate(NULL, (const void**)colors, sizeof(colors) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorsArray, colorStops);
	CFRelease(colorsArray);
	return gradient;
}

- (void)setGripped:(BOOL)newGripped
{
	gripped = newGripped;
	[self setNeedsDisplay];
}

@end
