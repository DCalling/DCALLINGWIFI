//
//  IASKSpecifierValuesViewController.m
//  Created by Prashant on 23/02/12.
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


#import "IASKSpecifierValuesViewController.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"
#import "IASKSettingsStoreUserDefaults.h"

#define kCellValue      @"kCellValue"

@interface IASKSpecifierValuesViewController()
- (void)userDefaultsDidChange;
@end

@implementation IASKSpecifierValuesViewController

@synthesize tableView=_tableView;
@synthesize currentSpecifier=_currentSpecifier;
@synthesize checkedItem=_checkedItem;
@synthesize settingsReader = _settingsReader;
@synthesize settingsStore = _settingsStore;

- (void) updateCheckedItem {
    NSInteger index;
	
	// Find the currently checked item
    if([self.settingsStore objectForKey:[_currentSpecifier key]]) {
      index = [[_currentSpecifier multipleValues] indexOfObject:[self.settingsStore objectForKey:[_currentSpecifier key]]];
    } else {
      index = [[_currentSpecifier multipleValues] indexOfObject:[_currentSpecifier defaultValue]];
    }
	[self setCheckedItem:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (id<IASKSettingsStore>)settingsStore {
    if(_settingsStore == nil) {
        _settingsStore = [[IASKSettingsStoreUserDefaults alloc] init];
    }
    return _settingsStore;
}

- (void)loadView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.view = _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    if (_currentSpecifier) {
        [self setTitle:[_currentSpecifier title]];
        [self updateCheckedItem];
    }
    
    if (_tableView) {
        [_tableView reloadData];

		// Make sure the currently checked item is visible
        [_tableView scrollToRowAtIndexPath:[self checkedItem] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[_tableView flashScrollIndicators];
	[super viewDidAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(userDefaultsDidChange)
												 name:NSUserDefaultsDidChangeNotification
											   object:[NSUserDefaults standardUserDefaults]];
}

- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tableView = nil;
}


- (void)dealloc {
    [_currentSpecifier release], _currentSpecifier = nil;
	[_checkedItem release], _checkedItem = nil;
	[_settingsReader release], _settingsReader = nil;
    [_settingsStore release], _settingsStore = nil;
	[_tableView release], _tableView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentSpecifier multipleValuesCount];
}

- (void)selectCell:(UITableViewCell *)cell {
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	[[cell textLabel] setTextColor:kIASKgrayBlueColor];
}

- (void)deselectCell:(UITableViewCell *)cell {
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[[cell textLabel] setTextColor:[UIColor darkTextColor]];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [_currentSpecifier footerText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:kCellValue];
    NSArray *titles         = [_currentSpecifier multipleTitles];
	
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellValue] autorelease];
    }
	
	if ([indexPath isEqual:[self checkedItem]]) {
		[self selectCell:cell];
    } else {
        [self deselectCell:cell];
    }
	
	@try {
		[[cell textLabel] setText:[self.settingsReader titleForStringId:[titles objectAtIndex:indexPath.row]]];
	}
	@catch (NSException * e) {}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath == [self checkedItem]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    NSArray *values         = [_currentSpecifier multipleValues];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self deselectCell:[tableView cellForRowAtIndexPath:[self checkedItem]]];
    [self selectCell:[tableView cellForRowAtIndexPath:indexPath]];
    [self setCheckedItem:indexPath];
	
    [self.settingsStore setObject:[values objectAtIndex:indexPath.row] forKey:[_currentSpecifier key]];
	[self.settingsStore synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged
                                                        object:[_currentSpecifier key]
                                                      userInfo:[NSDictionary dictionaryWithObject:[values objectAtIndex:indexPath.row]
                                                                                           forKey:[_currentSpecifier key]]];
}

- (CGSize)contentSizeForViewInPopover {
    return [[self view] sizeThatFits:CGSizeMake(320, 2000)];
}


#pragma mark Notifications

- (void)userDefaultsDidChange {
	NSIndexPath *oldCheckedItem = [[self.checkedItem retain] autorelease];
	if(_currentSpecifier) {
		[self updateCheckedItem];
	}
	
	// only reload the table if it had changed; prevents animation cancellation
	if (![self.checkedItem isEqual:oldCheckedItem]) {
		[_tableView reloadData];
	}
}

@end
