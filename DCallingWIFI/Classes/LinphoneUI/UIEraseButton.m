/* UIEraseButton.m
 *
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
 */              

#import "UIEraseButton.h"


@implementation UIEraseButton

@synthesize addressField;


#pragma mark - Lifecycle Functions

- (void)initUIEraseButton {
	[self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
}

- (id)init {
    self = [super init];
    if (self) {
		[self initUIEraseButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self initUIEraseButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
		[self initUIEraseButton];
	}
    return self;
}	

- (void)dealloc {
    [super dealloc];
	[addressField release];
}


#pragma mark - Action Functions

-(void) touchDown:(id) sender {
  	if ([addressField.text length] > 0) {
		[addressField setText:[addressField.text substringToIndex:[addressField.text length]-1]];
	}  
}


#pragma mark - UILongTouchButtonDelegate Functions

- (void)onRepeatTouch {
}

- (void)onLongTouch {
    [addressField setText:@""];
}

@end
