//
//  ContactsViewController.h
//  DCalling WiFi
//
//  Created by David C. Son on 11.01.12.
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

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "DTActionSheet.h"

@interface ContactsViewController : UIViewController<UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate, ABPersonViewControllerDelegate> {
    //<ABPeoplePickerNavigationControllerDelegate> warnings
    NSMutableArray *contactNames;
    NSMutableArray *contactIDs;
    NSString *callerid;
    IBOutlet UITabBarItem *contactTab;
    CTTelephonyNetworkInfo *networkInfo ;
    NSTimer *timerSim;
    //UIWebView *mCallWebview;
    NSMutableData *responseData;
    NSTimer *updateTimer;
    ABPeoplePickerNavigationController *picker;
   DTActionSheet *securitySheet;
}

@property (nonatomic, retain) NSMutableArray *contactNames;
@property (nonatomic, retain) NSMutableArray *contactIDs;
@property(nonatomic, retain) NSString *callerid;
@property(nonatomic, retain) NSMutableArray *PhoneBook;
@property(nonatomic, retain) NSArray *selectedDetails;
@property(nonatomic) int mVal;
@property(nonatomic) int rect;
@property(nonatomic) int tokenInt;
@property(nonatomic) BOOL stDr;
@property(nonatomic) int checkConnectivity;

@property (nonatomic, retain) IBOutlet UIImageView* registrationStateImage;
@property (nonatomic, retain) IBOutlet UILabel*     registrationStateLabel;
@property (nonatomic, retain) IBOutlet UIImageView* callQualityImage;
@property (nonatomic, retain) IBOutlet UIImageView* callSecurityImage;
@property (nonatomic, retain) IBOutlet UIButton* callSecurityButton;

-(void) getAddressBook;


-(BOOL)CheckNetwork;


@end
