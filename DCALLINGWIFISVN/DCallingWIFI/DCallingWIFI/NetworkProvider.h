//
//  NetworkProvider.h
//  DCalling WiFi
//
//  Created by Dileep Nagesh on 21/11/12.
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
//
//

#import <UIKit/UIKit.h>
#import "FlatrateXMLParser.h"
#import <QuartzCore/QuartzCore.h>

@interface NetworkProvider : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    IBOutlet UITableView *tv;
    IBOutlet UILabel *providerName;
    IBOutlet UITextField *mTextf;
    IBOutlet UILabel *questionHeader;
    IBOutlet UIButton *saveAndCountinue;
    UITextField* textfield;
    UIImageView *droparrow;
    FlatrateXMLParser *flatrateXMLParser;
    //IBOutlet UIPickerView *dropPicker;
    UISwitch *switchObj;
    IBOutlet UILabel *helpText;
    IBOutlet UIImageView *backgroundImg;
}

@property (nonatomic, retain) NSMutableArray *networkProviderNames;
@property (retain, nonatomic) NSMutableArray *selectionCode;
@property (nonatomic) int rowth;

-(IBAction)saveAndContinue:(id)sender;

@end
