//
//  FavViewController.h
//  DCalling WiFi
//
//  Created by David C. Son on 17/01/12.
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

@interface FavViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate, ABPeoplePickerNavigationControllerDelegate, UIWebViewDelegate, ABPersonViewControllerDelegate>{
    IBOutlet UITableView *tv;
    IBOutlet UIButton *pickerButton;
    //IBOutlet UIImageView *imagePerson;
    IBOutlet UILabel *cellName;
    IBOutlet UILabel *cellMobile;
    IBOutlet UILabel *cellNumber;
    IBOutlet UIImageView *arrowImage;
    AddressBookHandler *mAddHandler;
    UIImage *userImage;
    IBOutlet UILabel *topHeader;
    IBOutlet UILabel *toprightHeader;
    IBOutlet UILabel *topRightBottomHeader;
    IBOutlet UITabBarItem *favTab;
    NSTimer *updateTimer;
    IBOutlet UIImageView *headerImage;
    DTActionSheet *securitySheet;
}

@property (nonatomic, retain) NSMutableArray *favCallLog;

@property (nonatomic, retain) NSMutableArray *favCallLogPhoneLabel;

@property (nonatomic, retain) NSString *selectedContact;

@property (nonatomic) int nsCount;

@property (nonatomic) int mVal;

@property(nonatomic) int tokenInt;

@property(nonatomic, retain) IBOutlet UITableView *tv;

@property(nonatomic, retain) NSMutableArray *favPhone;

@property(nonatomic, retain) IBOutlet UILabel *cellNumber;

@property (nonatomic, retain) NSString *userCredit;

@property(nonatomic, retain) NSArray *userData;
//@property (nonatomic, retain) IBOutlet UITableView *myTableView;

// For SIP


@property (nonatomic, retain) IBOutlet UIImageView* registrationStateImage;
@property (nonatomic, retain) IBOutlet UILabel*     registrationStateLabel;
@property (nonatomic, retain) IBOutlet UIImageView* callQualityImage;
@property (nonatomic, retain) IBOutlet UIImageView* callSecurityImage;
@property (nonatomic, retain) IBOutlet UIButton* callSecurityButton;

-(void) getFavCallLog;

- (IBAction)callContact;


- (void)handleCellSwipe:(UIGestureRecognizer *)gestureRecognizer;

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

-(IBAction)getAddressBook;



-(void) drawFrame: (UITableViewCell *) cell;

//-(UIImage *) getABImages:(NSString *)myPhoneStr;

-(NSString *) currentDatetime;

-(void) getValues;

@end
