/* UIConferenceHeader.m
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

#import "UIConferenceHeader.h"

#import "LinphoneManager.h"

@implementation UIConferenceHeader

@synthesize stateImage;
@synthesize pauseButton;


#pragma mark - Lifecycle Functions

- (id)init {
    return [super initWithNibName:@"UIConferenceHeader" bundle:[NSBundle mainBundle]];
}

- (void)dealloc {
    [stateImage release];
    [pauseButton release];
    [super dealloc];
}


#pragma mark - ViewController Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set selected+over background: IB lack !
    [pauseButton setImage:[UIImage imageNamed:@"call_state_pause_over.png"] 
                      forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [pauseButton setType:UIPauseButtonType_Conference call:nil];
}


#pragma mark - Static size Functions

+ (int)getHeight {
    return 50;
}


#pragma mark - 

- (void)update {
    [self view]; // Force view load
    [stateImage setHidden:true];
    [pauseButton update];
}

@end
