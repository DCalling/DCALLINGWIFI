//
//  KeypadViewController.h
//  DCalling WiFi
//
//  Created by David C. Son on 17.01.12.
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
#import "FavViewHandler.h"

@interface KeypadViewController : UIViewController<ABUnknownPersonViewControllerDelegate, UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate> {
    IBOutlet UILabel *CallNumber;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    IBOutlet UILabel *topHeader;
    IBOutlet UILabel *toprightHeader;
    IBOutlet UILabel *topRightBottomHeader;
    IBOutlet UITabBarItem *dialTab;
    IBOutlet UIButton *callButton;
    UIButton *pasteButton;
    UINavigationController *npNav;
    FavViewHandler *mFav;
    IBOutlet UITabBarItem *myTabBarItem;
    IBOutlet UITextField *CallTxtField;
    IBOutlet UIButton *backBtn;
    IBOutlet UIButton *plusBtn;
    //UIWebView *mCallWebview;
    NSTimer *updateTimer;
    //IBOutlet UIActivityIndicatorView *acView;
    
    IBOutlet UIButton *oneButton;
    IBOutlet UIButton *twoButton;
    IBOutlet UIButton *threeButton;
    IBOutlet UIButton *fourButton;
    IBOutlet UIButton *fiveButton;
    IBOutlet UIButton *sixButton;
    IBOutlet UIButton *sevenButton;
    IBOutlet UIButton *eightButton;
    IBOutlet UIButton *nineButton;
    IBOutlet UIButton *starButton;
    IBOutlet UIButton *hashButton;
    IBOutlet UIButton *contactButton;
    IBOutlet UIImageView *headerImage;
}

-(IBAction)addOne:(id)sender;
-(IBAction)addTwo:(id)sender;
-(IBAction)addThree:(id)sender;
-(IBAction)addFour:(id)sender;
-(IBAction)addFive:(id)sender;
-(IBAction)addSix:(id)sender;
-(IBAction)addSeven:(id)sender;
-(IBAction)addEigth:(id)sender;
-(IBAction)addNine:(id)sender;
-(IBAction)addZero:(id)sender;
-(IBAction)addStar:(id)sender;
-(IBAction)addPound:(id)sender;

-(IBAction)addAdd:(id)sender;
-(IBAction)addBack:(id)sender;
-(IBAction)addCall:(id)sender;


@property (nonatomic) BOOL status;

@property(nonatomic) int mVal;

@property(nonatomic) int tokenInt;

@property(nonatomic) int mButton;

@property (nonatomic, retain) IBOutlet UILabel *CallNumber;

@property(nonatomic, retain) IBOutlet UITextField *CallTxtField;

@property (nonatomic, copy) NSString *abcd;
@property (nonatomic, retain) NSArray *countData;

// sip

@property (nonatomic, retain) IBOutlet UIImageView* registrationStateImage;
@property (nonatomic, retain) IBOutlet UILabel*     registrationStateLabel;
@property (nonatomic, retain) IBOutlet UIImageView* callQualityImage;
@property (nonatomic, retain) IBOutlet UIImageView* callSecurityImage;
@property (nonatomic, retain) IBOutlet UIButton* callSecurityButton;

-(void) getAddContact;

-(IBAction)disableKey:(id)sender;

-(IBAction)callScreen:(id)sender;

@end
