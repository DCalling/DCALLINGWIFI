//
//  DTActionSheet.h
//  DTFoundation
//
//  Created by Prashant kumar on 08.06.12.
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

typedef void (^DTActionSheetBlock)(void);

/**
 Extends UIActionSheet with support for blocks
 */

@interface DTActionSheet : UIActionSheet

/**
 Initializes the action sheet using the specified title. 
 */
- (id)initWithTitle:(NSString *)title;

/**
 Adds a custom button to the action sheet.
 @param title The title of the new button.
 @param block The block to execute when the button is tapped.
 @returns The index of the new button. Button indices start at 0 and increase in the order they are added.
*/ 
- (NSInteger)addButtonWithTitle:(NSString *)title block:(DTActionSheetBlock)block;

/**
 Adds a custom destructive button to the action sheet.
 
 Since there can only be one destructive button a previously marked destructive button becomes a normal button.
 @param title The title of the new button.
 @param block The block to execute when the button is tapped.
 @returns The index of the new button. Button indices start at 0 and increase in the order they are added.
 */ 
- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title block:(DTActionSheetBlock)block;

/**
 Adds a custom cancel button to the action sheet.
 
 Since there can only be one cancel button a previously marked cancel button becomes a normal button.
 @param title The title of the new button.
 @param block The block to execute when the button is tapped.
 @returns The index of the new button. Button indices start at 0 and increase in the order they are added.
 */ 
- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(DTActionSheetBlock)block;

@end
