//
//  IASKSpecifier.h
//  Created by Prashant on 23/02/12.
//  Copyright (C) 2014 DALASON GmbH.
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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IASKSettingsReader;

@interface IASKSpecifier : NSObject {
    NSDictionary    *_specifierDict;
    NSDictionary    *_multipleValuesDict;
	IASKSettingsReader *_settingsReader;
}
@property (nonatomic, retain) NSDictionary  *specifierDict;
@property (nonatomic, assign) IASKSettingsReader *settingsReader;

- (id)initWithSpecifier:(NSDictionary*)specifier;
- (NSString*)localizedObjectForKey:(NSString*)key;
- (NSString*)title;
- (NSString*)key;
- (NSString*)type;
- (NSString*)titleForCurrentValue:(id)currentValue;
- (NSInteger)multipleValuesCount;
- (NSArray*)multipleValues;
- (NSArray*)multipleTitles;
- (NSString*)file;
- (id)defaultValue;
- (id)defaultStringValue;
- (BOOL)defaultBoolValue;
- (id)trueValue;
- (id)falseValue;
- (float)minimumValue;
- (float)maximumValue;
- (NSString*)minimumValueImage;
- (NSString*)maximumValueImage;
- (BOOL)isSecure;
- (UIKeyboardType)keyboardType;
- (UITextAutocapitalizationType)autocapitalizationType;
- (UITextAutocorrectionType)autoCorrectionType;
- (NSString*)footerText;
- (Class)viewControllerClass;
- (SEL)viewControllerSelector;
-(Class)buttonClass;
-(SEL)buttonAction;
- (UIImage *)cellImage;
- (UIImage *)highlightedCellImage;
- (BOOL)adjustsFontSizeToFitWidth;
- (UITextAlignment)textAlignment;
@end
