//
//  CallerIDViewController.h
//  DCalling WiFi
//
//  Created by David C. Son on 13.01.12.
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
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface CallerIDViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,UIActionSheetDelegate, UIAlertViewDelegate> {

    IBOutlet UILabel *helloCallerID;
    IBOutlet UITextField *callerIDField;
    IBOutlet UIImageView *backgoundImg;
    IBOutlet UIImageView *downArrow;
    IBOutlet UITextView *flatrateXMLTextView; // for parsing only prashant should remove.
	IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextView *textView;
    IBOutlet UIButton *unsere;
    IBOutlet UILabel *footer;
    IBOutlet UIButton *VerificationButton;
    
    NSTimer *updateTimer;
    NSAutoreleasePool* pool;
    NSRunLoop* runLoop;
}

-(void)doVerification:(id)sender;



- (IBAction)callerIDFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
//- (IBAction)doVerification:(id)sender;

- (IBAction)callerIdTouched:(id)sender;

@property (retain, nonatomic) IBOutlet IBOutlet UITextView *textView;



@property(retain, nonatomic) IBOutlet UITextField *callerIDField;
@property (retain, nonatomic) IBOutlet UILabel *helloCallerID;
@property (nonatomic) BOOL status;
@property (nonatomic) BOOL newSimStatus;
@property (nonatomic, retain) NSString *fullNumber;

@property (retain, nonatomic) IBOutlet UITextField *dropDown;
@property (retain, nonatomic) IBOutlet UIPickerView *picker;

@property (retain, nonatomic) NSMutableArray *prefixCode;
@property (retain, nonatomic) NSString *prefixName;
@property(nonatomic, retain) NSString *mcc;
@property(nonatomic, retain) NSString *prefixCountryCode;
@property (retain, nonatomic) NSString *previousName;
@property(nonatomic) int tokenInt;
@property(nonatomic, retain) NSTimer *updateTimer;

-(IBAction)openPicker;

- (IBAction)touchesBegan;



-(IBAction)pushToGTC:(id)sender;

-(IBAction) dropBoxHide;

-(NSString *) getMCCPrefix:(NSString *)mcPreCode;

-(NSString *) currentDatetime;
-(BOOL)CheckNetwork;

@end
