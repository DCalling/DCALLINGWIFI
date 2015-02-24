//
//  VerificationCodeViewController.h
//  DCalling WiFi
//
//  Created by David C. Son on 26.01.12.
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

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface VerificationCodeViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>{
    IBOutlet UITextField *codeField;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *mCallId;
    IBOutlet UIButton *anmelden;
    IBOutlet UIImageView *tickImage;
    IBOutlet UIImageView *tickImage2;
    NSTimer *timer;
    IBOutlet UILabel *topHeader;
    IBOutlet UILabel *midHeader;
    IBOutlet UIButton *bottomButton;
    NSTimer *myTimer;
    IBOutlet UIButton *codeSMSButton;
    NSRunLoop *runLoop;
    NSTimer *updateTimer;
    NSTimer *myRegTimer;
    IBOutlet UIImageView *backgroundImg;
}

-(IBAction)doVerificationCode;

@property (nonatomic) BOOL newSimStatus;

@property (nonatomic) int pTim;

-(void) dCallingParsePostDidComplete: (NSMutableString *) result;

-(void)verificationSMSParseDidComplete:(NSMutableString *) result;

-(void)authSessionParserDidComplete:(NSMutableString *) result;


//@property (nonatomic, retain) IBOutlet UILabel *mCallId;


@property (nonatomic, retain) NSString *callerID;

@property (nonatomic) BOOL status;



-(NSString *)setVerCallerID: (NSString *) myCaller;

-(IBAction) redirectTo;

-(void) forBackgroundButton;

-(IBAction)BackTOCallerID;

-(IBAction)mainMenuSeque:(id)sender;

-(void)BackTOCallerIDTimer:(NSTimer *) pTimer;

-(void) getCredit;

-(IBAction) getVerificationCode;

//-(void)getCreditParserDidComplete:(NSMutableString *) result;

@end
