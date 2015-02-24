//
//  DTActionSheet.m
//  DTFoundation
//
//  Created by Prashant kumar on 08.06.12.
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

#import "DTActionSheet.h"

@interface DTActionSheet () <UIActionSheetDelegate>

@end

@implementation DTActionSheet
{
	id <UIActionSheetDelegate> _externalDelegate;
	
	NSMutableDictionary *_actionsPerIndex;
	
	// lookup bitmask what delegate methods are implemented
	struct 
	{
		unsigned int delegateSupportsActionSheetCancel:1;
		unsigned int delegateSupportsWillPresentActionSheet:1;
		unsigned int delegateSupportsDidPresentActionSheet:1;
		unsigned int delegateSupportsWillDismissWithButtonIndex:1;
		unsigned int delegateSupportsDidDismissWithButtonIndex:1;
	} _delegateFlags;
}

- (id)init 
{
	self = [super init];
	if (self)
	{
		_actionsPerIndex = [[NSMutableDictionary alloc] init];
		self.delegate = self;
	}
	
	return self;
}

// designated initializer
- (id)initWithTitle:(NSString *)title
{
	self = [self init];
	if (self) 
	{
		self.title = title;
	}
	
	return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title block:(DTActionSheetBlock)block
{
	NSInteger retIndex = [self addButtonWithTitle:title];
	
	if (block)
	{
		NSNumber *key = [NSNumber numberWithInt:retIndex];
		[_actionsPerIndex setObject:[[block copy] autorelease] forKey:key];
	}
	
	return retIndex;
}

- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title block:(DTActionSheetBlock)block
{
	NSInteger retIndex = [self addButtonWithTitle:title block:block];
	[self setDestructiveButtonIndex:retIndex];
	
	return retIndex;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(DTActionSheetBlock)block
{
	NSInteger retIndex = [self addButtonWithTitle:title block:block];
	[self setCancelButtonIndex:retIndex];
	
	return retIndex;
}

#pragma UIActionSheetDelegate (forwarded)

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	if (_delegateFlags.delegateSupportsActionSheetCancel)
	{
		[_externalDelegate actionSheetCancel:actionSheet];
	}
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
	if (_delegateFlags.delegateSupportsWillPresentActionSheet)
	{
		[_externalDelegate willPresentActionSheet:actionSheet];	
	}
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	if (_delegateFlags.delegateSupportsDidPresentActionSheet)
	{
		[_externalDelegate didPresentActionSheet:actionSheet];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (_delegateFlags.delegateSupportsWillDismissWithButtonIndex)
	{
		[_externalDelegate actionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
	}
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSNumber *key = [NSNumber numberWithInt:buttonIndex];
	
	DTActionSheetBlock block = [_actionsPerIndex objectForKey:key];
	
	if (block)
	{
		block();
	}

	if (_delegateFlags.delegateSupportsDidDismissWithButtonIndex)
	{
		[_externalDelegate actionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
	}
}


#pragma mark Properties

- (id <UIActionSheetDelegate>)delegate
{
	return _externalDelegate;
}

- (void)setDelegate:(id <UIActionSheetDelegate>)delegate
{
	if (delegate == self)
	{
		[super setDelegate:self];
	}
	else if (delegate == nil)
	{
		[super setDelegate:nil];
		_externalDelegate = nil;
	}
	else 
	{
		_externalDelegate = delegate;
	}
	
	// wipe
	memset(&_delegateFlags, 0, sizeof(_delegateFlags));
	
	// set flags according to available methods in delegate
	if ([_externalDelegate respondsToSelector:@selector(actionSheetCancel:)])
	{
		_delegateFlags.delegateSupportsActionSheetCancel = YES;
	}

	if ([_externalDelegate respondsToSelector:@selector(willPresentActionSheet:)])
	{
		_delegateFlags.delegateSupportsWillPresentActionSheet = YES;
	}

	if ([_externalDelegate respondsToSelector:@selector(didPresentActionSheet:)])
	{
		_delegateFlags.delegateSupportsDidPresentActionSheet = YES;
	}

	if ([_externalDelegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)])
	{
		_delegateFlags.delegateSupportsWillDismissWithButtonIndex = YES;
	}

	if ([_externalDelegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)])
	{
		_delegateFlags.delegateSupportsDidDismissWithButtonIndex = YES;
	}
}

@end
