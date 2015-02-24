//
//  UISwitch+tagged.m
//  DCalling WiFi
//
//  Created by Dileep Nagesh on 23/11/12.
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
//
//

#import "UISwitch+tagged.h"
#define TAG_OFFSET	900

@implementation UISwitch (tagged)
- (void) spelunkAndTag: (UIView *) aView withCount:(int *) count
{
	for (UIView *subview in [aView subviews])
	{
        NSLog(@"Subview %@", subview);
		if ([subview isKindOfClass:[UILabel class]])
		{
			*count += 1;
			[subview setTag:(TAG_OFFSET + *count)];
		}
		else
			[self spelunkAndTag:subview withCount:count];
	}
}

- (UILabel *) label1
{
	return (UILabel *) [self viewWithTag:TAG_OFFSET + 1];
}

- (UILabel *) label2
{
	return (UILabel *) [self viewWithTag:TAG_OFFSET + 2];
}

+ (UISwitch *) switchWithLeftText: (NSString *) tag1 andRight: (NSString *) tag2
{
	UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    
	int labelCount = 0;
	[switchView spelunkAndTag:switchView withCount:&labelCount];
    
	if (labelCount == 2)
	{
		[switchView.label1 setText:tag1];
		[switchView.label2 setText:tag2];
	}
    
	return [switchView autorelease];
}

@end
