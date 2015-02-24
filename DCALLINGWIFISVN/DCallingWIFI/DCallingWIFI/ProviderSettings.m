//
//  ProviderSettings.m
//  DCalling WiFi
//
//  Created by Dileep Nagesh on 14/12/12.
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
//
//

#import "ProviderSettings.h"
#import "PreferencesHandler.h"
#import "RestAPICaller.h"
#import "FlatrateXMLParser.h"
#import "AddressBookHandler.h"

@interface ProviderSettings ()

@end

@implementation ProviderSettings

@synthesize networkProviderNames, selectionCode, rowth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    networkProviderNames = [[NSMutableArray alloc]init];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"de"]){
        [networkProviderNames addObject:@"Alle Mobilfunkanbieter"];
    }
    else if ([language isEqualToString:@"tr"]){
        [networkProviderNames addObject:@"Tüm Mobile Şebekeler"];
    }
    else{
        [networkProviderNames addObject:@"All German mobile networks"];
    }
    [networkProviderNames addObject:@"T-Mobile"];
    [networkProviderNames addObject:@"Vodafone"];
    [networkProviderNames addObject:@"E-Plus"];
    [networkProviderNames addObject:@"O2"];
    [networkProviderNames addObject:@"Telogic"];
    //NSLog(@"fdf %d", [networkProviderNames count]);
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    if(result.height == 960) {
        NSLog(@"iPhone 4 Resolution");
    }
    else if(result.height == 1136) {
        
        [self foriPhoneFiveDraw];
    }
    else{
        NSLog(@"iPhone standard");
    }
    /*PreferencesHandler *mPref =[[PreferencesHandler alloc]init];
    [mPref setAllGermanProvider:NO];
    [mPref setTmobile:NO];
    [mPref setVodafone:NO];
    [mPref setEPlus:NO];
    [mPref setOTwo:NO];
    [mPref setTelogic:NO];*/
    
    selectionCode = [[NSMutableArray alloc]init];
    [selectionCode addObject:@"Use my sim provider"];
    [selectionCode addObject:@"Use DCallingWiFi"];
    //[selectionCode addObject:@""];
    tv.layer.cornerRadius=10;
    rowth=1;
   
    UIImage *tImage = nil;
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0){
        tImage = [UIImage imageNamed:@"top_mid_ios7.png"];
         self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else if (result.height==480){
        tImage = [UIImage imageNamed:@"topbar_agb_agb.png"];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    else{
        tImage = [UIImage imageNamed:@"topbar_agb.png"];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    [self.navigationController.navigationBar setBackgroundImage:tImage forBarMetrics:UIBarMetricsDefault];
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [tv reloadData];
    //[dropPicker setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //cell.textLabel.text = [networkProviderNames objectAtIndex:indexPath.row];
    [self drawCellLabel:cell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //cell.textLabel.text = @"";
    providerName.text=[networkProviderNames objectAtIndex:indexPath.row];
    //NSLog(@"size text %d  - %2f", providerName.text.length, providerName.bounds.size.width);
    if(providerName.text.length > 10){
        providerName.lineBreakMode = UILineBreakModeWordWrap;
        providerName.numberOfLines = 0;
        [providerName sizeToFit];
    }
    // cell.textLabel.text = @"";
    
    switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(3.0, 1.0, 15.0, 10.0)];
    //switchObj.on = indexPath.row;
    switchObj.tag=indexPath.row;
    [switchObj addTarget:self action:@selector(switchSwitched:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
    cell.accessoryView = switchObj;
    //switchObj.transform = CGAffineTransformMakeScale(1.00, 0.90);
    [switchObj release];
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    
    //NSLog(@"Provider ALL %u, tellog %u, vodafo %u, tmobile %u, o2 %u, eplus %u",[mPref getAllGermanProvider] ,[mPref getTelogic], [mPref getVodafone], [mPref getTmobile],[mPref getOTwo], [mPref getEPlus]  );
    //NSLog(@" hello %u", [mPref getAllGermanProvider]);
    if([mPref getAllGermanProvider]==1 && indexPath.row!=0){
        [cell setHidden:YES];
        //cell.backgroundColor=[UIColor lightGrayColor];
    }
    else if([mPref getAllGermanProvider]==1 && indexPath.row==0){
        switchObj.on = YES;
    }
    else if ([mPref getAllGermanProvider]==0){
        if([mPref getTelogic]==1 && indexPath.row==5){
            switchObj.on = YES;
        }
        else if ([mPref getVodafone]==1 && indexPath.row==2){
            switchObj.on = YES;
        }
        else if ([mPref getTmobile]==1 && indexPath.row==1){
            switchObj.on = YES;
        }
        else if ([mPref getOTwo]==1 && indexPath.row==4){
            switchObj.on = YES;
        }
        else if ([mPref getEPlus]==1 && indexPath.row==3){
            switchObj.on = YES;
        }
        else{
            [cell setHidden:NO];
            //cell.backgroundColor=[UIColor whiteColor];
            if(indexPath.row==0){
                switchObj.on = NO;
                [mPref setAllGermanProvider:NO];
            }
            
            
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableViewCell *cell = [theTableView cellForRowAtIndexPath:newIndexPath];
    // NSLog(@"%@ -- %@", cell, newIndexPath);
    if(newIndexPath.row !=0){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    /*NSLog(@"%d", newIndexPath.row);
     
     [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:NO];
     UITableViewCell *cell = [theTableView cellForRowAtIndexPath:newIndexPath];
     if (cell.accessoryType == UITableViewCellAccessoryNone) {
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     // Reflect selection in data model
     } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
     cell.accessoryType = UITableViewCellAccessoryNone;
     // Reflect deselection in data model
     }*/
    [theTableView deselectRowAtIndexPath:newIndexPath animated:YES];
}




- (void)switchSwitched:(UISwitch*)sender {
    //NSLog(@"%d", sender.tag);
    PreferencesHandler *mPref =[[PreferencesHandler alloc]init];
    if (sender.on) {
        
        switch (sender.tag) {
            case 0:
                [mPref setAllGermanProvider:YES];
                [self viewWillAppear:YES];
                break;
            case 1:
                [mPref setTmobile:YES];
                break;
            case 2:
                [mPref setVodafone:YES];
                break;
            case 3:
                [mPref setEPlus:YES];
                break;
            case 4:
                [mPref setOTwo:YES];
                break;
            case 5:
                [mPref setTelogic:YES];
                break;
                
            default:
                break;
        }
        
        // NSLog(@"Case OF ON %d", sender.tag);
        /* UITableViewCell* aCell = [tv cellForRowAtIndexPath:
         [NSIndexPath indexPathForRow:sender.tag inSection:0]];
         
         // NSLog(@"%d", sender.tag);
         aCell.accessoryType = (sender.on == YES ) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;*/
    }
    else{
        switch (sender.tag) {
            case 0:
                [mPref setAllGermanProvider:NO];
                [self viewWillAppear:YES];
                break;
            case 1:
                [mPref setTmobile:NO];
                break;
            case 2:
                [mPref setVodafone:NO];
                break;
            case 3:
                [mPref setEPlus:NO];
                break;
            case 4:
                [mPref setOTwo:NO];
                break;
            case 5:
                [mPref setTelogic:NO];
                break;
                
            default:
                break;
        }
        // NSLog(@"Case of OFF %d", sender.tag);
    }
}

/*-(IBAction)saveAndContinue:(id)sender{
    // 1. verificationSMS send verification code by sms
    
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    NSString *caller = [mPref getCallerBox];
    NSString *dropbox = [mPref getDropBox];
    NSString *fullNumber = [dropbox stringByAppendingString:caller];
    
    RestAPICaller *rapi = [[RestAPICaller alloc]init];
    NSData *restAPI = [rapi getVerificationSMSXML:fullNumber];
    
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithDCallingPostDelegate: self xmlData:restAPI];
    
    [flatrateXMLParser release];
    
}*/

-(void) dCallingParsePostDidComplete: (NSMutableString *) result{ // call by thread. in xmlParser class
    //NSLog(result);
    BOOL status;
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    
    NSString *caller = [mPref getCallerBox];
    NSString *dropbox = [mPref getDropBox];
    NSString *myCallerid= [dropbox stringByAppendingString:caller];
    NSRange textRange;
    textRange = [result rangeOfString:@"success"];
    //NSLog(@"xml %@", result);
    if(textRange.location != NSNotFound){
        status = true;
    }
    else{
        status = false;
    }
    
    if(!status){
        //NSLog(@"error status false");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"]
                                                          message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
    }else{
        [mPref setCallerID:myCallerid];
        
        [self performSegueWithIdentifier:@"providerToVerify" sender:self];
    }
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSLog(@"prepareForSegue: %@", segue.identifier  );
    // NSLog(@"sds %@", [segue identifier]);
    if([[segue identifier] isEqualToString:@"providerToVerify"]){
        
    }
    
}


/*- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
 {
 return 1;
 }
 
 - (NSInteger)pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
 {
 return [selectionCode count];
 }
 - (NSString *)pickerView:(UIPickerView *)pickerView
 titleForRow:(NSInteger)row
 forComponent:(NSInteger)component
 {
 
 return [selectionCode objectAtIndex:row];
 }
 
 -(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
 {
 //NSString *cName = [selectionCode objectAtIndex:row] ;
 //[dropPicker setHidden:YES];
 textfield.text=[selectionCode objectAtIndex:row];
 [textfield resignFirstResponder];
 [dropPicker setHidden:YES];
 
 }
 
 -(void) openPicker{
 
 [dropPicker setHidden:NO];
 
 //[self textFieldDidEndEditing:dropDown];
 [textfield resignFirstResponder];
 [self.view addSubview:dropPicker];
 dropPicker.delegate = self;
 dropPicker.showsSelectionIndicator = YES;
 NSString *selct = textfield.text;
 for(int i=0; i < [selectionCode count]; i++){
 NSString *str = [selectionCode objectAtIndex:i];
 if([textfield.text length] !=0 && [selct isEqualToString:str]){
 [dropPicker selectRow:i inComponent:0 animated:NO];
 break;
 
 
 }
 }
 
 }
 
 
 - (IBAction)touchesBegan {
 // if([callerIDField resignFirstResponder] ==NO){
 [textfield resignFirstResponder];
 //NSLog(@"resign");
 // }
 
 
 }
 
 -(IBAction) dropBoxHide{
 [textfield resignFirstResponder];
 
 }*/



-(void)drawCellLabel:(UITableViewCell *)cell{
    /* CGRect size = cell.frame;
     UIFont *font = cell.textLabel.font;
     //NSLog(@"%f--%f--%f--%f", size.origin.x, size.origin.y, size.size.width, size.size.height);
     // set the font to the minimum size anyway
     size.size.width=0.0;
     size.size.height=100.0;
     CGSize constraintSize = CGSizeMake(size.size.width, 90);
     [cell.textLabel.text sizeWithFont:(font = [font fontWithSize:15.0])
     constrainedToSize:constraintSize
     lineBreakMode:cell.textLabel.lineBreakMode];
     cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
     cell.textLabel.numberOfLines = 0;
     [cell.textLabel sizeToFit];
     cell.textLabel.font = font;
     cell.textLabel.textColor=[UIColor lightGrayColor];
     cell.frame=size;
     [self.view addSubview:cell];*/
    /*CGRect frame;
     frame.origin.x = 162;
     frame.origin.y = 8;
     frame.size.height = 30;
     frame.size.width = 124;
     UISwitch *switchEnabled = [[[UISwitch alloc] initWithFrame:frame] autorelease];
     [cell.contentView addSubview:switchEnabled];*/
    
    
    /*CGRect frame;
     frame.origin.x = 162;
     frame.origin.y = 8;
     frame.size.height = 30;
     frame.size.width = 124;
     textfield = [[UITextField alloc] initWithFrame:frame];
     textfield.delegate = self;
     textfield.backgroundColor=[UIColor lightGrayColor];
     textfield.borderStyle = UITextBorderStyleRoundedRect;
     textfield.textColor=[UIColor whiteColor];
     textfield.font = [UIFont systemFontOfSize:15];
     //textfield.placeholder = @"Select Box";
     [textfield setValue:[UIColor blackColor]
     forKeyPath:@"_placeholderLabel.textColor"];
     [textfield addTarget:self
     action:@selector(touchesBegan)
     forControlEvents:UIControlEventTouchCancel];
     [textfield addTarget:self
     action:@selector(openPicker)
     forControlEvents:UIControlEventEditingDidBegin];
     [textfield addTarget:self
     action:@selector(dropBoxHide)
     forControlEvents:UIControlEventTouchDown];
     [cell.contentView addSubview:textfield];
     
     
     CGRect frame2;
     frame2.origin.x = 100;
     frame2.origin.y = 0;
     frame2.size.height = 30;
     frame2.size.width = 24;
     droparrow=[[UIImageView alloc] initWithFrame:frame2];
     droparrow.image = [UIImage imageNamed:@"dropDown_Arrow_new.png"];
     
     [textfield addSubview:droparrow];*/
    
    CGRect frame1;
    frame1.origin.x = 10;
    frame1.origin.y = 8;
    frame1.size.height = 20;
    frame1.size.width = 200;
    providerName = [[UILabel alloc] initWithFrame:frame1];
    providerName.backgroundColor=[UIColor whiteColor];
    //providerName.borderStyle = UITextBorderStyleRoundedRect;
    providerName.textColor=[UIColor darkGrayColor];
    //providerName.font = [UIFont systemFontOfSize:15];
    [providerName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [cell addSubview:providerName];
    [cell setNeedsDisplay];
    
    //NSLog(@"hello");
    //NSLog(@"%f--%f--%f--%f", frame1.origin.x, frame1.origin.y, frame1.size.width, frame1.size.height);
    
}

-(void)foriPhoneFiveDraw{
    //NSLog(@"iPhone 5 Resolution");
    CGRect frame = questionHeader.frame;
    frame.origin.y += 20;
    //frame.size.height = 37;
    //frame.size.width = 280;
    questionHeader.frame=frame;
    //pickerButton = [[UIButton alloc] initWithFrame:frame];
    CGRect frame2 = tv.frame;
    frame2.origin.y += 30;
    frame2.size.height-=72;
    //frame.size.height = 37;
    //frame.size.width = 280;
    tv.frame=frame2;
    /*CGRect frame3 = saveAndCountinue.frame;
    frame3.origin.y += 70;
    //frame.size.height = 37;
    //frame.size.width = 280;
    saveAndCountinue.frame=frame3;*/
    
    CGRect frame4 = helpText.frame;
    frame4.origin.y += 70;
    //frame.size.height = 37;
    //frame.size.width = 280;
    helpText.frame=frame4;
    
    CGRect frame5 = helpTextSec.frame;
    frame5.origin.y += 75;
    //frame.size.height = 37;
    //frame.size.width = 280;
    helpTextSec.frame=frame5;
    
    [self.view addSubview:questionHeader];
    [self.view addSubview:tv];
    //[self.view addSubview:saveAndCountinue];
    [self.view addSubview:helpText];
    [self.view addSubview:helpTextSec];
    
    /*CGRect frame4 = callerIDField.frame;
     frame4.origin.y += 25;
     //frame.size.height = 37;
     //frame.size.width = 280;
     callerIDField.frame=frame4;
     CGRect frame5 = unsere.frame;
     frame5.origin.y += 70;
     //frame.size.height = 37;
     //frame.size.width = 280;
     unsere.frame=frame5;
     CGRect frame6 = VerificationButton.frame;
     frame6.origin.y += 25;
     //frame.size.height = 37;
     //frame.size.width = 280;
     VerificationButton.frame=frame6;
     CGRect frame7 = textView.frame;
     frame7.origin.y += 40;
     //frame.size.height = 37;
     //frame.size.width = 280;
     textView.frame=frame7;
     CGRect frame8 = footer.frame;
     frame8.origin.y += 70;
     //frame.size.height = 37;
     //frame.size.width = 280;
     footer.frame=frame8;
     CGRect frame9 = picker.frame;
     frame9.origin.y += 70;
     //frame.size.height = 37;
     //frame.size.width = 280;
     picker.frame=frame9;
     [self.view addSubview:helloCallerID];
     [self.view addSubview:dropDown];
     [self.view addSubview:downArrow];
     [self.view addSubview:callerIDField];
     [self.view addSubview:VerificationButton];
     [self.view addSubview:textView];
     [self.view addSubview:footer];
     [self.view addSubview:unsere];
     [self.view addSubview:picker];*/
    
    
}

-(void)dealloc{
    [providerName release];
    [textfield release];
    [droparrow release];
    [super dealloc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32.0;
}

@end
