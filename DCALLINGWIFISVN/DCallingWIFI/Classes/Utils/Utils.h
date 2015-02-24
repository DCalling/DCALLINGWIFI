/* Utils.h
 *
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
 */   

#ifndef LINPHONE_UTILS_H
#define LINPHONE_UTILS_H

#define DYNAMIC_CAST(x, cls)                        \
 ({                                                 \
    cls *inst_ = (cls *)(x);                        \
    [inst_ isKindOfClass:[cls class]]? inst_ : nil; \
 })

typedef enum _LinphoneLoggerSeverity {
    LinphoneLoggerLog = 0,
    LinphoneLoggerDebug,
    LinphoneLoggerWarning,
    LinphoneLoggerError,
    LinphoneLoggerFatal
} LinphoneLoggerSeverity;


@interface LinphoneLogger : NSObject {

}
+ (void)log:(LinphoneLoggerSeverity) severity format:(NSString *)format,...;
+ (void)logc:(LinphoneLoggerSeverity) severity format:(const char *)format,...;

@end

@interface LinphoneUtils : NSObject {

}

+ (BOOL)findAndResignFirstResponder:(UIView*)view;
+ (void)adjustFontSize:(UIView*)view mult:(float)mult;
+ (void)buttonFixStates:(UIButton*)button;
+ (void)buttonFixStatesForTabs:(UIButton*)button;
+ (void)buttonMultiViewAddAttributes:(NSMutableDictionary*)attributes button:(UIButton*)button;
+ (void)buttonMultiViewApplyAttributes:(NSDictionary*)attributes button:(UIButton*)button;

@end

@interface NSNumber (HumanReadableSize)

- (NSString*)toHumanReadableSize;

@end

#endif
