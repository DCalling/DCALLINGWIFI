//
//  AboutViewController.h
//  DCalling WiFi
//
//  Created by David C. Son on 17.01.12.
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
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>{
    IBOutlet UILabel *comapnyNameLbl;
    IBOutlet UILabel *address1Lbl;
    IBOutlet UILabel *address2Lbl;
    IBOutlet UILabel *countryNameLbl;
    IBOutlet UILabel *telephoneLbl;
    IBOutlet UILabel *faxLbl;
    IBOutlet UILabel *emailLbl;
    IBOutlet UIImageView *details;
    IBOutlet UILabel *emailID;
    IBOutlet UILabel *faxNo;
    IBOutlet UILabel *TelNo;
    IBOutlet UILabel *versionNo;
    IBOutlet UIButton *telBTN;
    IBOutlet UIButton *faxBTN;
    IBOutlet UIButton *emailBTN;
    IBOutlet UITextView *tvGNU;
}


@property (nonatomic) int tokenInt;

-(IBAction)mailToNumber:(id)sender;

-(IBAction)callToNumber:(id)sender;

@end
