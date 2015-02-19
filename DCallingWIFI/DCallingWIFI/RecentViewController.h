//
//  RecentViewController.h
//  DCalling WiFi
//
//  Created by Prashant on 06/02/12.
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
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressBookHandler.h"
#import "DTActionSheet.h"

@interface RecentViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIWebViewDelegate, ABUnknownPersonViewControllerDelegate, UIAlertViewDelegate> 
{
    IBOutlet UITableView *tv;
    NSMutableArray *phoneNumbers;
    NSMutableArray *allPhoneFromAB;
    IBOutlet UIImageView *arrowImage;
    IBOutlet UIImageView *imagePerson;
    IBOutlet UILabel *cellName;
    IBOutlet UILabel *cellMobile;
    IBOutlet UILabel *cellMobileSec;
    IBOutlet UILabel *cellMobileThird;
    IBOutlet UILabel *cellNumber;
    IBOutlet UILabel *cellTime;
    IBOutlet UILabel *cellTimeSec;
    IBOutlet UILabel *cellTimeThird;
    IBOutlet UILabel *cellCallDuration;
    IBOutlet UILabel *cellCallDurationSec;
    IBOutlet UILabel *cellCallDurationThird;
    IBOutlet UIImageView *redImage;
    IBOutlet UIImageView *greenImage;
    IBOutlet UIImageView *whiteImage;
    IBOutlet UILabel *countNumberLbl;
    UIImage *userImage;
    IBOutlet UILabel *topHeader;
    IBOutlet UILabel *toprightHeader;
    IBOutlet UILabel *topRightBottomHeader;
    IBOutlet UITabBarItem *recentTab;
    AddressBookHandler *mAddr;
    IBOutlet UIButton *addButton;
    UINavigationController *npNav;
    NSTimer *updateTimer;
    IBOutlet UIImageView *headerImage;
    //UIWebView *mCallWebview;
    DTActionSheet *securitySheet;

}   
@property (nonatomic, retain) NSMutableArray *phoneNumbers;

@property (nonatomic, retain) NSMutableArray *phoneLabels;

@property (nonatomic, retain) NSMutableArray *allPhoneFromAB;

@property (nonatomic, retain) NSMutableArray *compareNumbers;

@property (nonatomic, retain) NSArray *namesFromAB;

@property(nonatomic, retain) NSMutableArray *getMatchedPhone;

@property(nonatomic, retain) NSMutableArray *getMatchedWithRecent;

@property (nonatomic, retain) IBOutlet UITableView *tv;

@property(nonatomic, retain) NSMutableArray *myRecent;

@property(nonatomic, retain) NSMutableArray *myRecentCall;

@property(nonatomic, retain) NSMutableArray *arrayNumbers;

@property(nonatomic, retain) NSMutableArray *dialNumberCount;

@property(nonatomic, retain) NSArray *userData;

@property(nonatomic) int mVal;
@property(nonatomic) int tokenInt;
@property(nonatomic, retain) NSMutableArray *labels;

@property(nonatomic) BOOL loopRun;
// For Update Data

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *myPhone;
@property(nonatomic, retain) NSString *last;
@property(nonatomic, retain) NSString *myString;
@property(nonatomic, retain) NSString *abName;
@property (nonatomic, retain) NSArray *firstLastName;
@property (nonatomic, retain) NSArray *selectedDetails;

// For sip

@property (nonatomic, retain) IBOutlet UIImageView* registrationStateImage;
@property (nonatomic, retain) IBOutlet UILabel*     registrationStateLabel;
@property (nonatomic, retain) IBOutlet UIImageView* callQualityImage;
@property (nonatomic, retain) IBOutlet UIImageView* callSecurityImage;
@property (nonatomic, retain) IBOutlet UIButton* callSecurityButton;


- (void)handleCellSwipe:(UIGestureRecognizer *)gestureRecognizer;

-(NSString *) getCountedDataFromCallLog:(NSString *)names;

-(void) drawFrame: (UITableViewCell *) cell;

-(UIImage *) getABImages:(NSString *)myPhoneStr;

-(NSMutableArray *) myCompareData;

-(NSString *) currentDatetime;

-(IBAction)getAddContact:(UIControl *) button withEvent: (UIEvent *) event;



@end
