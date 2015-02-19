//
//  IASKSpecifier.m
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


#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

@interface IASKSpecifier ()
@property (nonatomic, retain) NSDictionary  *multipleValuesDict;
- (void)_reinterpretValues:(NSDictionary*)specifierDict;
@end

@implementation IASKSpecifier

@synthesize specifierDict=_specifierDict;
@synthesize multipleValuesDict=_multipleValuesDict;
@synthesize settingsReader = _settingsReader;

- (id)initWithSpecifier:(NSDictionary*)specifier {
    if ((self = [super init])) {
        [self setSpecifierDict:specifier];
        
        if ([[self type] isEqualToString:kIASKPSMultiValueSpecifier] ||
			[[self type] isEqualToString:kIASKPSTitleValueSpecifier]) {
            [self _reinterpretValues:[self specifierDict]];
        }
    }
    return self;
}

- (void)dealloc {
    [_specifierDict release], _specifierDict = nil;
    [_multipleValuesDict release], _multipleValuesDict = nil;
	
	_settingsReader = nil;

    [super dealloc];
}

- (void)_reinterpretValues:(NSDictionary*)specifierDict {
    NSArray *values = [_specifierDict objectForKey:kIASKValues];
    NSArray *titles = [_specifierDict objectForKey:kIASKTitles];
    
    NSMutableDictionary *multipleValuesDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    if (values) {
		[multipleValuesDict setObject:values forKey:kIASKValues];
	}
	
    if (titles) {
		[multipleValuesDict setObject:titles forKey:kIASKTitles];
	}
    
    [self setMultipleValuesDict:multipleValuesDict];
}
- (NSString*)localizedObjectForKey:(NSString*)key {
	return [self.settingsReader titleForStringId:[_specifierDict objectForKey:key]];
}

- (NSString*)title {
    return [self localizedObjectForKey:kIASKTitle];
}

- (NSString*)footerText {
    return [self localizedObjectForKey:kIASKFooterText];
}

-(Class) viewControllerClass {
    return NSClassFromString([_specifierDict objectForKey:kIASKViewControllerClass]);
}

-(SEL) viewControllerSelector {
    return NSSelectorFromString([_specifierDict objectForKey:kIASKViewControllerSelector]);
}

-(Class)buttonClass {
    return NSClassFromString([_specifierDict objectForKey:kIASKButtonClass]);
}

-(SEL)buttonAction {
    return NSSelectorFromString([_specifierDict objectForKey:kIASKButtonAction]);
}

- (NSString*)key {
    return [_specifierDict objectForKey:kIASKKey];
}

- (NSString*)type {
    return [_specifierDict objectForKey:kIASKType];
}

- (NSString*)titleForCurrentValue:(id)currentValue {
	NSArray *values = [self multipleValues];
	NSArray *titles = [self multipleTitles];
	if (values.count != titles.count) {
		return nil;
	}
    NSInteger keyIndex = [values indexOfObject:currentValue];
	if (keyIndex == NSNotFound) {
		return nil;
	}
	@try {
		return [self.settingsReader titleForStringId:[titles objectAtIndex:keyIndex]];
	}
	@catch (NSException * e) {}
	return nil;
}

- (NSInteger)multipleValuesCount {
    return [[_multipleValuesDict objectForKey:kIASKValues] count];
}

- (NSArray*)multipleValues {
    return [_multipleValuesDict objectForKey:kIASKValues];
}

- (NSArray*)multipleTitles {
    return [_multipleValuesDict objectForKey:kIASKTitles];
}

- (NSString*)file {
    return [_specifierDict objectForKey:kIASKFile];
}

- (id)defaultValue {
    return [_specifierDict objectForKey:kIASKDefaultValue];
}

- (id)defaultStringValue {
    return [[_specifierDict objectForKey:kIASKDefaultValue] description];
}

- (BOOL)defaultBoolValue {
	id defaultValue = [self defaultValue];
	if ([defaultValue isEqual:[self trueValue]]) {
		return YES;
	}
	if ([defaultValue isEqual:[self falseValue]]) {
		return NO;
	}
	return [defaultValue boolValue];
}

- (id)trueValue {
    return [_specifierDict objectForKey:kIASKTrueValue];
}

- (id)falseValue {
    return [_specifierDict objectForKey:kIASKFalseValue];
}

- (float)minimumValue {
    return [[_specifierDict objectForKey:kIASKMinimumValue] floatValue];
}

- (float)maximumValue {
    return [[_specifierDict objectForKey:kIASKMaximumValue] floatValue];
}

- (NSString*)minimumValueImage {
    return [_specifierDict objectForKey:kIASKMinimumValueImage];
}

- (NSString*)maximumValueImage {
    return [_specifierDict objectForKey:kIASKMaximumValueImage];
}

- (BOOL)isSecure {
    return [[_specifierDict objectForKey:kIASKIsSecure] boolValue];
}

- (UIKeyboardType)keyboardType {
    if ([[_specifierDict objectForKey:KIASKKeyboardType] isEqualToString:kIASKKeyboardAlphabet]) {
        return UIKeyboardTypeDefault;
    }
    else if ([[_specifierDict objectForKey:KIASKKeyboardType] isEqualToString:kIASKKeyboardNumbersAndPunctuation]) {
        return UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([[_specifierDict objectForKey:KIASKKeyboardType] isEqualToString:kIASKKeyboardNumberPad]) {
        return UIKeyboardTypeNumberPad;
    }
    else if ([[_specifierDict objectForKey:KIASKKeyboardType] isEqualToString:kIASKKeyboardDecimalPad]) {
		if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_4_1) {
			return UIKeyboardTypeDecimalPad;
		}
		else {
			return UIKeyboardTypeNumbersAndPunctuation;
		}
    }
    else if ([[_specifierDict objectForKey:KIASKKeyboardType] isEqualToString:KIASKKeyboardURL]) {
        return UIKeyboardTypeURL;
    }
    else if ([[_specifierDict objectForKey:KIASKKeyboardType] isEqualToString:kIASKKeyboardEmailAddress]) {
        return UIKeyboardTypeEmailAddress;
    }
    return UIKeyboardTypeDefault;
}

- (UITextAutocapitalizationType)autocapitalizationType {
    if ([[_specifierDict objectForKey:kIASKAutocapitalizationType] isEqualToString:kIASKAutoCapNone]) {
        return UITextAutocapitalizationTypeNone;
    }
    else if ([[_specifierDict objectForKey:kIASKAutocapitalizationType] isEqualToString:kIASKAutoCapSentences]) {
        return UITextAutocapitalizationTypeSentences;
    }
    else if ([[_specifierDict objectForKey:kIASKAutocapitalizationType] isEqualToString:kIASKAutoCapWords]) {
        return UITextAutocapitalizationTypeWords;
    }
    else if ([[_specifierDict objectForKey:kIASKAutocapitalizationType] isEqualToString:kIASKAutoCapAllCharacters]) {
        return UITextAutocapitalizationTypeAllCharacters;
    }
    return UITextAutocapitalizationTypeNone;
}

- (UITextAutocorrectionType)autoCorrectionType {
    if ([[_specifierDict objectForKey:kIASKAutoCorrectionType] isEqualToString:kIASKAutoCorrDefault]) {
        return UITextAutocorrectionTypeDefault;
    }
    else if ([[_specifierDict objectForKey:kIASKAutoCorrectionType] isEqualToString:kIASKAutoCorrNo]) {
        return UITextAutocorrectionTypeNo;
    }
    else if ([[_specifierDict objectForKey:kIASKAutoCorrectionType] isEqualToString:kIASKAutoCorrYes]) {
        return UITextAutocorrectionTypeYes;
    }
    return UITextAutocorrectionTypeDefault;
}

- (UIImage *)cellImage
{
    return [UIImage imageNamed:[_specifierDict objectForKey:kIASKCellImage]];
}

- (UIImage *)highlightedCellImage
{
    return [UIImage imageNamed:[[_specifierDict objectForKey:kIASKCellImage ] stringByAppendingString:@"Highlighted"]];
}

- (BOOL)adjustsFontSizeToFitWidth {
	NSNumber *boxedResult = [_specifierDict objectForKey:kIASKAdjustsFontSizeToFitWidth];
	return !boxedResult || [boxedResult boolValue];
}

- (UITextAlignment)textAlignment
{
    if ([[_specifierDict objectForKey:kIASKTextLabelAlignment] isEqualToString:kIASKTextLabelAlignmentLeft]) {
        return UITextAlignmentLeft;
    } else if ([[_specifierDict objectForKey:kIASKTextLabelAlignment] isEqualToString:kIASKTextLabelAlignmentCenter]) {
        return UITextAlignmentCenter;
    } else if ([[_specifierDict objectForKey:kIASKTextLabelAlignment] isEqualToString:kIASKTextLabelAlignmentRight]) {
        return UITextAlignmentRight;
    }
    if ([self.type isEqualToString:kIASKButtonSpecifier] && !self.cellImage) {
		return UITextAlignmentCenter;
	} else if ([self.type isEqualToString:kIASKPSMultiValueSpecifier] || [self.type isEqualToString:kIASKPSTitleValueSpecifier]) {
		return UITextAlignmentRight;
	}
	return UITextAlignmentLeft;
}
@end
