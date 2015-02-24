/* UIMicroButton.m
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

#import "UIMicroButton.h"

#import "LinphoneManager.h"

@implementation UIMicroButton

- (void)onOn {
    if(![LinphoneManager isLcReady]) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle mic button: Linphone core not ready"];
        return;
    }
	linphone_core_mute_mic([LinphoneManager getLc], false);
}

- (void)onOff {
    if(![LinphoneManager isLcReady]) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle mic button: Linphone core not ready"];
        return;
    }
	linphone_core_mute_mic([LinphoneManager getLc], true);
}

- (bool)onUpdate {
	if([LinphoneManager isLcReady]) {
		return linphone_core_is_mic_muted([LinphoneManager getLc]) == false;
	} else {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot update mic button: Linphone core not ready"];
		return true;
	}
}

- (void)dealloc {
    [super dealloc];
}

@end
