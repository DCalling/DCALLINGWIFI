/* LinphoneCoreSettingsStore.h
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

#import <Foundation/Foundation.h>
#import "IASKSettingsStore.h"

#import "LinphoneManager.h"

@interface LinphoneCoreSettingsStore : IASKAbstractSettingsStore {
	@private
	NSDictionary *dict;
	NSDictionary *changedDict;
}

- (void)synchronizeAccount;
- (void)transformLinphoneCoreToKeys;

@end
