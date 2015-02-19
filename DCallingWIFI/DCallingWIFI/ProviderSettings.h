//
//  ProviderSettings.h
//  DCalling WiFi
//
//  Created by Dileep Nagesh on 14/12/12.
//
//

#import <UIKit/UIKit.h>
#import "FlatrateXMLParser.h"
#import <QuartzCore/QuartzCore.h>

@interface ProviderSettings : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    IBOutlet UITableView *tv;
    IBOutlet UILabel *providerName;
    IBOutlet UITextField *mTextf;
    IBOutlet UILabel *questionHeader;
    
    UITextField* textfield;
    UIImageView *droparrow;
    FlatrateXMLParser *flatrateXMLParser;
    //IBOutlet UIPickerView *dropPicker;
    UISwitch *switchObj;
    IBOutlet UILabel *helpText;
    IBOutlet UILabel *helpTextSec;
}

@property (nonatomic, retain) NSMutableArray *networkProviderNames;
@property (retain, nonatomic) NSMutableArray *selectionCode;
@property (nonatomic) int rowth;



@end
