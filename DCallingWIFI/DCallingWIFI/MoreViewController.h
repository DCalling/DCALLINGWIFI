//
//  MoreViewController.h
//  DCalling WiFi
//
//  Created by David C. Son on 17.01.12.
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

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PreferencesHandler.h"
#import "FavViewHandler.h"

@interface MoreViewController : UITableViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate> {
    IBOutlet UITableView *tableViewCus;
    IBOutlet UILabel *recharge;
    IBOutlet UILabel *priceValue;
    IBOutlet UILabel *priceList;
    IBOutlet UILabel *priceDetails;
    IBOutlet UILabel *callReport;
    IBOutlet UILabel *callreportDetails;
    IBOutlet UILabel *facebook;
    IBOutlet UILabel *fbBonus;
    IBOutlet UILabel *smsLbl;
    IBOutlet UILabel *smsDetails;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *emailDetails;
    IBOutlet UILabel *lblHelp;
    IBOutlet UILabel *lblAbout;
    IBOutlet UILabel *helpDetails;
    IBOutlet UILabel *abotDetails;
    IBOutlet UILabel *lblGTC;
    IBOutlet UILabel *gtcDetails;
    IBOutlet UITabBarItem *moreTab;
    IBOutlet UILabel *hotLine;
    IBOutlet UILabel *lblCall;
    PreferencesHandler *mPref;
    FavViewHandler *mFav;
    UILabel *label;
    UILabel *label2;  
    NSTimer *updateTimer;
    IBOutlet UINavigationItem *mNav;
    IBOutlet UITableViewCell *providercallS;
    UISwitch *switchRoaming;
    IBOutlet UITableViewCell *roamingcell;
}

@property (nonatomic, retain) UITableView *tableViewCus;
@property(nonatomic) int tokenInt;
@property(nonatomic) int mVal;

-(IBAction)makeCallToSupport:(id)sender;

- (void) navHeader;
- (void) backgroundHeader;
- (IBAction)switchSwitched:(UISwitch*)sender;

@end
