//
//  NetworkProvider.h
//  DCalling WiFi
//
//  Created by Dileep Nagesh on 21/11/12.
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
