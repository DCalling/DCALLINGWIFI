//
//  CallerIDViewController.m
//  DCalling WiFi
//
//  Created by David C. Son on 13.01.12.
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

#import "CallerIDViewController.h"
#import "FlatrateXMLParser.h"
#import "RestAPICaller.h"
#import "PreferencesHandler.h"
#import "VerificationCodeViewController.h"
#import "CountryPrefixHandler.h"
#import "AddressBookHandler.h"
#import "GTCRagistration.h"
#import "getCreditHandler.h"
#import "FavViewHandler.h"
#import "NetworkProvider.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation CallerIDViewController

//Start Code Prastant.
@synthesize callerIDField, fullNumber;
@synthesize helloCallerID;
@synthesize status, prefixCode, picker, textView, dropDown, prefixName, mcc, prefixCountryCode,newSimStatus, previousName;
@synthesize tokenInt, updateTimer;

//end code Prashant

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    
}


- (void)viewForiOSSeven{
    //helloCallerID, callerIDField, backgoundImg,downArrow textView unsere footer VerificationButton
    CGRect frame0 = helloCallerID.frame;
    CGRect frame1 = callerIDField.frame;
    CGRect frame2 = backgoundImg.frame;
    CGRect frame3 = downArrow.frame;
    CGRect frame4 = textView.frame;
    CGRect frame5 = unsere.frame;
    CGRect frame6 = footer.frame;
    CGRect frame7 = VerificationButton.frame;
    CGRect frame8 = dropDown.frame;
    CGRect frame9 = picker.frame;
    
    frame0.origin.y +=20;
    helloCallerID.frame = frame0;
    
    frame1.origin.y +=20;
    callerIDField.frame = frame1;
    
    frame2.origin.y +=20;
    backgoundImg.frame = frame2;
    
    frame3.origin.y +=20;
    downArrow.frame = frame3;
    
    frame4.origin.y +=20;
    textView.frame = frame4;
    
    frame5.origin.y +=20;
    unsere.frame = frame5;
    
    frame6.origin.y +=20;
    footer.frame = frame6;
    
    frame7.origin.y +=20;
    VerificationButton.frame = frame7;
    
    frame8.origin.y +=20;
    dropDown.frame = frame8;
    
    frame9.origin.y +=20;
    picker.frame = frame9;
}


-(NSString *) currentDatetime{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss:SSS";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *date = [dateFormatter stringFromDate:now];
    [dateFormatter release];
    return date;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if(result.height == 960) {
        NSLog(@"iPhone 4 Resolution");
    }
    else if(result.height == 1136) {
        
        [self foriPhoneFiveDraw];
    }
    else{
        NSLog(@"iPhone standard");
    }
    if(version>=7.0)
        [self viewForiOSSeven];
    
    helloCallerID.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"calleridTitleHeading"];
    [helloCallerID setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    footer.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Callerid_footer_name"];
    UILabel *buttonLbl;
     NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"tr"]){
        buttonLbl = [[UILabel alloc]initWithFrame:CGRectMake(3, 1, 125, 20)];
        [buttonLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    }
    else {
        buttonLbl = [[UILabel alloc]initWithFrame:CGRectMake(3, -1, 110, 20)];
        [buttonLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    }
    
    buttonLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Callerid_footer_name_link"] ;
    [buttonLbl setBackgroundColor:[UIColor clearColor]];
    [buttonLbl setTextColor:[UIColor blackColor]];
    
    [unsere addSubview:buttonLbl];
    [unsere setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter| UIControlContentHorizontalAlignmentCenter];
    [buttonLbl release];
    
    
    
    [footer setFont:[UIFont fontWithName:@"ArialMT" size:18]];
    
    textView.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Callerid_textview"] ;
    if ([language isEqualToString:@"tr"]) {
        [textView setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    }
    else{
        [textView setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    }
    
    
    UILabel *buttonVLbl ;
    if([language isEqualToString:@"tr"] && result.height != 1136){
        buttonVLbl= [[UILabel alloc]initWithFrame:CGRectMake(50, 3, 250, 30)];
    }
    else{
        buttonVLbl= [[UILabel alloc]initWithFrame:CGRectMake(25, 3, 250, 30)];
    }
    buttonVLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"callerId_Verification_button"] ;
    [buttonVLbl setBackgroundColor:[UIColor clearColor]];
    [buttonVLbl setTextColor:[UIColor whiteColor]];
    [buttonLbl setTextAlignment:UIControlContentVerticalAlignmentCenter| UIControlContentHorizontalAlignmentCenter];
    [buttonVLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
    [VerificationButton addSubview:buttonVLbl];
    [VerificationButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter| UIControlContentHorizontalAlignmentCenter];
    
    [buttonVLbl release];
    
    
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    
    // Do any additional setup after loading the view from its nib.
    // Setup the Network Info and create a CTCarrier object
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    // Get carrier name
    NSString *carrierName = [carrier carrierName];
    if (carrierName != nil){
        NSLog(@"Carrier: %@", carrierName);
       
    }    
    // Get mobile country code
    mcc = [carrier mobileCountryCode];
    
    // Get mobile network code
    NSString *mnc = [carrier mobileNetworkCode];
    if (mnc != nil){
        NSLog(@"Mobile Network Code (MNC): %@", mnc);
        
    }
    
    
    //NSLog(@"3  - %@", [self currentDatetime]);
    
    if((token != NULL) && (token != nil)){
        NSLog(@"in if token != NULL: %@",token);
        NSString *model = [[UIDevice currentDevice] model];
        if (![model isEqualToString:@"iPhone Simulator"])
            [self performSelectorInBackground:@selector(updateCreditCon) withObject:nil];
        //[self performSelectorInBackground:@selector(updateCredit) withObject:nil];
        //[self getCredit];
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
        [self.navigationController pushViewController:tab animated:YES];
        //[self performSegueWithIdentifier:@"toTabBar" sender:token];
    }
    
    
    //PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *dropBoxText = [preferences getDropBox];
    NSString *callerBoxText = [preferences getCallerBox];
    [picker setHidden:YES];
    //[dropDown resignFirstResponder];
    int droLen = (int)dropBoxText.length;
    if(droLen ==0){
        //dropDown.text = @"+49";
    }
    else{
        dropDown.text = dropBoxText;
        callerIDField.text = callerBoxText;
    }
    if([mnc length]==0){
        dropDown.text =@"";
    }
    CountryPrefixHandler *countryHandler = [[CountryPrefixHandler alloc]init];
    //NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"de"]){
        [countryHandler getCountryName];
    }
    else if([language isEqualToString:@"tr"]){
        [countryHandler getCountryNameTr];
    }
    else {
        [countryHandler getCountryNameEN];
    }
    //[countryHandler getCountryName];
    prefixCode = [countryHandler.countryPrefix retain];
    
    [countryHandler release];
    //dropDown.delegate = self;
    
    [super viewDidLoad];
    [callerIDField resignFirstResponder];
    
    self.navigationController.navigationBar.hidden = YES;
   //[callerIDField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    newSimStatus=TRUE;
   /* NSString *model = [[UIDevice currentDevice] model];
    if (![model isEqualToString:@"iPhone Simulator"])
        [self performSelectorInBackground:@selector(updateCreditCon) withObject:nil];*/
   // [self performSelectorInBackground:@selector(deleteCache) withObject:nil];
    
}

-(void)textFieldDidChange:(NSNotification*)aNotification {
    //[self forBackgroundButton];
    if(callerIDField.text.length==1){
        if([callerIDField.text isEqualToString:@"0"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NOTIFY_CON"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NOT_ZERO"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            callerIDField.text=@"";
            [alert show];
            [alert release];
        }
            
                
    }
}

- (void) updateCredit {
    /*NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self  selector:@selector(getCredit) userInfo:nil repeats:NO];
    
    [runLoop run];
    [pool release];*/
}

-(void) getCredit
{
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] init];
    [mGetCrHandler getCredit];
    
    
}
-(BOOL)CheckNetwork   {
    NSError *error = nil;
    BOOL internetStatus = TRUE;
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.apple.com"];
    NSURLRequest* request = [NSURLRequest requestWithURL: scriptUrl 
                                             cachePolicy: NSURLRequestReloadIgnoringCacheData 
                                         timeoutInterval:5.0];
    NSURLResponse* response;
    NSData* myData = [NSURLConnection sendSynchronousRequest:request 
                                           returningResponse:&response
                                                       error:&error];
    // NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    //NSLog(@"ERROR %d", [error code]);
    if ( myData != nil && [error code] == 0 )
        internetStatus = TRUE;
    else
        internetStatus = FALSE;
    return internetStatus;
}

-(NSString *) getMCCPrefix:(NSString *)mcPreCode{
    CountryPrefixHandler *countryHandler = [[CountryPrefixHandler alloc]init];
    NSString *code = @"";
    NSMutableArray *getMCC = [countryHandler getMCCCode];
     //NSLog(@"kkk %@", getMCC);
    for(int i=0; i<[getMCC count]; i++){
        NSMutableArray *mccCode = [getMCC objectAtIndex:i] ;
        //NSLog(@"llll %@", mccCode);
        for(NSString *str in mccCode){
           // NSLog(@"%d --- %@", i, str);
            if([str isEqualToString:mcPreCode]){
                int s = i + 1;
                code = [countryHandler getPreMCCCode:s];
                //NSLog(@"%d --- %@", s, str);
                break;
            }
        }
    }
    
    return code;
}


-(void) viewWillAppear:(BOOL)animated{
    //dropDown.text=@"+49";
    [super viewWillAppear:animated];
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    if((token != NULL) && (token != nil)){
        NSLog(@"in if token != NULL: %@",token);
        //[self performSelectorInBackground:@selector(updateCredit) withObject:nil];
        //[self getCredit];
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
        [self.navigationController pushViewController:tab animated:YES];
        //[self performSegueWithIdentifier:@"toTabBar" sender:token];
    }
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    // Get carrier name
    NSString *carrierName = [carrier carrierName];
    if (carrierName != nil){
        NSLog(@"Carrier: %@", carrierName);
        
    }
    
    
    // Get mobile country code
    mcc = [carrier mobileCountryCode];
    
    prefixCountryCode = [self getMCCPrefix:mcc];
    //select code from tfixCoutrnpreifxcode where mcc =  mcc  
    if (prefixCountryCode.length != 0){
        //NSLog(@"Mobile Country Code (MCC): %@", prefixCountryCode);
        NSString *preCode = @"+";
        NSString *countryCode = [preCode stringByAppendingFormat:@"%@",prefixCountryCode];
        dropDown.text = nil;
       // if([countryCode isEqualToString:@"+49"]) {
        //BOOL matched = FALSE;
        //CountryPrefixHandler *countryHandler = [[CountryPrefixHandler alloc]init];
        
        //matched = [countryHandler staticDialinNumbers:prefixCountryCode];
        //if (matched == TRUE) {

            dropDown.text = countryCode;
            
        /*} else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"ERROR_MSG"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SELECT_OTHER_COUNTRY"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            //dropDown.text = countryCode;
            dropDown.text = @"";
            //[preferences setToken:nil];
            
        }*/
        
    }
    if([mcc length]==0){
        dropDown.text =@"";
    }
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

//Start Code Prashant

- (IBAction)callerIDFieldReturn:(id)sender{
    [sender resignFirstResponder];
}
- (IBAction)backgroundTouched:(id)sender {
    [callerIDField resignFirstResponder];
    [textView resignFirstResponder];
    
    [picker setHidden:YES];
}

- (IBAction)callerIdTouched:(id)sender{
    [picker setHidden:YES];
    dropDown.userInteractionEnabled = YES;
}

FlatrateXMLParser * flatrateXMLParser;

-(void)doVerification:(id)sender{
    //NSLog(@"prepareForSegue: %@", segue.identifier  ); 
    [callerIDField resignFirstResponder];
    
    
    NSString *firsTBox= dropDown.text;
    NSString *secoBox = callerIDField.text;
    int firstBox = (int)firsTBox.length;
    int secondBox = (int)secoBox.length;
    // NSLog(@"hell %d kjkk %d gh", firstBox, secondBox);
    if((firstBox == 0 )|| (secondBox < 8)){
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg11"]
                                                          message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg9"]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
        
    }
    else{
        
        AddressBookHandler *mAdd = [[AddressBookHandler alloc]init];
        NSString *dropBox = [mAdd trimWhiteSpace:secoBox];
        fullNumber = [firsTBox stringByAppendingString:dropBox ];
        PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
        NSString *callerBox = firsTBox;
        [preferences setCallerBox:dropBox];
        [preferences setDropBox:callerBox];
        [mAdd release];
        NSString *model = [[UIDevice currentDevice] model];
        if (![model isEqualToString:@"iPhone Simulator"])
            [self performSelectorInBackground:@selector(updateCreditCon) withObject:nil];
        /*if([callerBox isEqualToString:@"+49"]){
            [self performSegueWithIdentifier:@"callerToProvider" sender:sender];
        }
        else{*/
            // 1. verificationSMS send verification code by sms
            RestAPICaller *rapi = [[RestAPICaller alloc]init];
            NSData *restAPI = [rapi getVerificationSMSXML:fullNumber];
            
            flatrateXMLParser = [[FlatrateXMLParser alloc] initWithDCallingPostDelegate: self xmlData:restAPI];
            [activityIndicator release];
            [flatrateXMLParser release];
       // }
        
    }
    // add callerid format check
    
    
    // 1. verificationSMS send verification code by sms
   /* RestAPICaller *rapi = [[RestAPICaller alloc]init];
    NSData *restAPI = [rapi getVerificationSMSXML:fullNumber];
    
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithDCallingPostDelegate: self xmlData:restAPI];
    [activityIndicator release];
    [flatrateXMLParser release];*/
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSLog(@"prepareForSegue: %@", segue.identifier  ); 
    // NSLog(@"sds %@", [segue identifier]);
    /*if([[segue identifier] isEqualToString:@"callerToProvider"]){
        NetworkProvider *myPush = [segue destinationViewController];
        myPush.title=@"";
        //NSLog(@"dfd %@", myPush);
    }*/
    if([[segue identifier] isEqualToString:@"MySegue"]){
        VerificationCodeViewController *myPush = [segue destinationViewController];
        myPush.title=@"";
        //NSLog(@"dfd %@", myPush);
    }
    
    if([[segue identifier] isEqualToString:@"moveToGTC"]){
        GTCRagistration *myPush = [segue destinationViewController];
        myPush.buttonTitle=@"unsere";
    }
}

-(void) dCallingParsePostDidComplete: (NSMutableString *) result{ // call by thread. in xmlParser class
    //NSLog(result);
    
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
        //NSLog(@"success true");
        AddressBookHandler *mAdd = [[AddressBookHandler alloc]init];
        NSString *dropBox = [mAdd trimWhiteSpace:callerIDField.text];
        
        [mAdd release];
        NSString *myCallerid = [dropDown.text stringByAppendingString:dropBox];
        PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
        [preferences setCallerID:myCallerid];
        
        [self performSegueWithIdentifier:@"MySegue" sender:self];
    }
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [prefixCode count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    return [prefixCode objectAtIndex:row];
}




-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *cName = [prefixCode objectAtIndex:row] ;
    previousName = cName;
    CountryPrefixHandler *countryHandler = [[CountryPrefixHandler alloc]init];
    
    NSString *sym = @"+";
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"de"]){
        prefixName =(NSString *) [countryHandler getCountryPrefix:cName];
    }
    else if([language isEqualToString:@"tr"]){
        prefixName =(NSString *) [countryHandler getCountryPrefixTr:cName];
    }
    else {
        prefixName =(NSString *) [countryHandler getCountryPrefixEN:cName];
    }
    
   
    dropDown.text = @"";
    NSString *values = [sym stringByAppendingString:prefixName];
    //if([values isEqualToString:@"+49"]){
        //BOOL matched = FALSE;
        //matched = [countryHandler staticDialinNumbers:prefixName];
    //if (matched == TRUE) {
        dropDown.text = values;        
        values = nil;
   /* }
        
    
   // }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"ERROR_MSG"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SELECT_OTHER_COUNTRY"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        dropDown.text = @"";
        //dropDown.text = values;
    }*/
    [picker setHidden:YES];
    [callerIDField becomeFirstResponder];
    [countryHandler release];
}



- (IBAction)touchesBegan {
   // if([callerIDField resignFirstResponder] ==NO){
        [callerIDField resignFirstResponder];
        //NSLog(@"resign");
   // }
    
    
}

-(IBAction) dropBoxHide{
    [dropDown resignFirstResponder];
    [callerIDField resignFirstResponder];
}

-(IBAction) openPicker{
    
    [picker setHidden:NO];
    
    //[self textFieldDidEndEditing:dropDown];
    [self touchesBegan];
    [self dropBoxHide];
    [self.view addSubview:picker];
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    picker.backgroundColor = [UIColor whiteColor];
    FavViewHandler *mFav = [[FavViewHandler alloc]autorelease];
    NSString *countryName;
    NSString *cName2 = [mFav removedPlus:dropDown.text];
    CountryPrefixHandler *countryHandler = [[CountryPrefixHandler alloc]init];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSMutableArray *preCode =[[NSMutableArray alloc]init];
    if([language isEqualToString:@"de"]){
        preCode = [countryHandler getCountryPrefixCode];
        countryName =(NSString *) [countryHandler getCountryNamePrefix:cName2];
    }
    else if([language isEqualToString:@"tr"]){
        preCode = [countryHandler getCountryPrefixCodeTr];
        countryName =(NSString *) [countryHandler getCountryNamePrefixTr:cName2];
    }
    else {
        preCode = [countryHandler getCountryPrefixCodeEN];
        countryName =(NSString *) [countryHandler getCountryNamePrefixEN:cName2];
    }
   // NSLog(@"%@ -- %@ -- %d", countryName, dropDown.text, [prefixCode count]);
    
    
    if([dropDown.text length] !=0 && [dropDown.text isEqualToString:@"+1"]){
        for(int i=0; i < [prefixCode count]; i++){
            NSString *str = [prefixCode objectAtIndex:i];
            if([dropDown.text length] !=0 && [previousName isEqualToString:str]){
                [picker selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
    }
    else{
        for(int i=0; i < [prefixCode count]; i++){
            NSString *str = [prefixCode objectAtIndex:i];
            if([dropDown.text length] !=0 && [countryName isEqualToString:str]){
                [picker selectRow:i inComponent:0 animated:NO];
                break;
                
                
            }
        }
    }
    
    
    [preCode release];
    [countryHandler release];
}

-(IBAction)pushToGTC:(id)sender{
    
    [self performSegueWithIdentifier:@"moveToGTC" sender:self];
}

+ (NSString *)GetCurrentWIFIInfo{
    NSString *wifiName = @"";
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    for(NSString *ifname in ifs){
        NSDictionary *info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifname);
        NSLog(@"check name : %@", info);
        if(info[@"SSID"])
            wifiName=info[@"SSID"];
    }
    return wifiName;
}

-(void)checkPrefix{
   
   /* NSURL *theURL = [[NSURL alloc] initWithString:@"http://ip-api.com/line/?fields=countryCode"];
    NSString* myIP = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:theURL] encoding:NSUTF8StringEncoding];
    NSLog(@"IP Adress : %@", myIP);*/
    
    /*NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode
                                                value: countryCode];
    
   
    NSLog(@"countt %@", countryName);*/
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *carrierName = [carrier carrierName];
    //NSLog(@"CarrierNames: %@", carrierName);
    mcc = [carrier mobileCountryCode];
    NSString *mnc1 = [carrier mobileNetworkCode];
    prefixCountryCode = [self getMCCPrefix:mcc];
    //NSLog(@"Mobile Network Code (MNC): %@ --%d  %@", mnc1, [mnc1 length], mcc);
   // NSString *preCode = @"+";
    //NSString *countryCode = [preCode stringByAppendingFormat:@"%@",prefixCountryCode];
    BOOL matched = FALSE;
    CountryPrefixHandler *countryHandler = [[CountryPrefixHandler alloc]init];
    //NSString *token = [preferences getToken];
    matched = [countryHandler staticDialinNumbers:prefixCountryCode];
    newSimStatus = TRUE;
    
    
        if ([[preferences getMNC] length] == 0 ){
            //NSLog(@"MCC : %@ %@", mcc, [preferences getMCC]);
            [preferences setToken:nil];
            [preferences setMCC:nil];
            [preferences setMNC:nil];
            [preferences setCarrier:nil];
            [preferences setMCC:mcc];
            [preferences setMNC:mnc1];
            [preferences setCarrier:carrierName];
            [preferences setAllGermanProvider:NO];
            [preferences setTmobile:NO];
            [preferences setVodafone:NO];
            [preferences setEPlus:NO];
            [preferences setOTwo:NO];
            [preferences setTelogic:NO];
             [preferences setRoaming:NO];
            //dropDown.text = countryCode;
            //[preferences setCallerBox:nil];
        
        }
        else if([mnc1 length]==0){
            newSimStatus = TRUE;
        }
    
         else if (![mnc1 isEqualToString:[preferences getMNC]] || ![mcc isEqualToString:[preferences getMCC]]){
            //NSLog(@"MCC : %@ %@ %d -- %@", mcc, [preferences getMCC], [[preferences getMCC]length], mnc1);
            // prefixCountryCode = [self getMCCPrefix:mcc];
             NSString *preCode = @"+";
             NSString *countryCode = [preCode stringByAppendingFormat:@"%@",prefixCountryCode];
             dropDown.text = nil;
             // if([countryCode isEqualToString:@"+49"]) {
             BOOL matched = FALSE;
             CountryPrefixHandler *countryHandler = [[CountryPrefixHandler alloc]init];
             
             matched = [countryHandler staticDialinNumbers:prefixCountryCode];
             if (matched == TRUE) {
                 
                 dropDown.text = countryCode;
             } else{
                  
                  dropDown.text = @"";
             }
             if([mnc1 length]==0){
                 dropDown.text =@"";
             }
            [preferences setToken:nil];
            [preferences setMCC:nil];
            [preferences setMNC:nil];
            [preferences setCarrier:nil];
            [preferences setMCC:mcc];
            [preferences setMNC:mnc1];
            [preferences setCarrier:carrierName];
            //dropDown.text = countryCode;
            [preferences setCallerBox:nil];
             [preferences setAllGermanProvider:NO];
             [preferences setTmobile:NO];
             [preferences setVodafone:NO];
             [preferences setEPlus:NO];
             [preferences setOTwo:NO];
             [preferences setTelogic:NO];
             [preferences setRoaming:NO];
             
            newSimStatus = FALSE;
             tokenInt=22;
             if(self.updateTimer){
                 [self.updateTimer invalidate];
                 self.updateTimer = nil;
             }
            [self pushtoSelf];
             
        }
        else{
            newSimStatus = TRUE;
            NSLog(@"Using Same Number");
           // NSLog(@"SELF %@", self.title);
        }
   
}

-(void)pushtoSelf{
    dispatch_sync(dispatch_get_main_queue(), ^{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_WARN"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_MSG"] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];});
    
    newSimStatus=TRUE;
   // NSLog(@"Self : %@", self.title);
    //if([self.title isEqualToString:@"callerid"]){
        [self viewWillAppear:YES];
   // }
    /*else if([self.title isEqualToString:@"VerificationId"]){
        [self performSegueWithIdentifier:@"backAgain" sender:self];
    }
    else{
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    }*/
    
    //[self performSegueWithIdentifier:@"pushToCallerID" sender:self];
}

- (void) updateCreditCon {
    pool = [[NSAutoreleasePool alloc] init];
    runLoop = [NSRunLoop currentRunLoop];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self  selector:@selector(checkPrefix) userInfo:nil repeats:YES];
    
    [runLoop run];
    [pool release];
}

- (void) deleteCache {
    pool = [[NSAutoreleasePool alloc] init];
    runLoop = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self  selector:@selector(deletedChache) userInfo:nil repeats:YES];
    
    [runLoop run];
    [pool release];
}

-(void)deletedChache{
    PreferencesHandler *mPref = [[PreferencesHandler alloc]autorelease];
    [mPref setProviderInfo:nil];
}

-(void)foriPhoneFiveDraw{
    //NSLog(@"iPhone 5 Resolution");
    CGRect frame = helloCallerID.frame;
    frame.origin.y += 25;
    //frame.size.height = 37;
    //frame.size.width = 280;
    helloCallerID.frame=frame;
    //pickerButton = [[UIButton alloc] initWithFrame:frame];
    CGRect frame2 = dropDown.frame;
    frame2.origin.y += 25;
    //frame.size.height = 37;
    //frame.size.width = 280;
    dropDown.frame=frame2;
    CGRect frame3 = downArrow.frame;
    frame3.origin.y += 25;
    //frame.size.height = 37;
    //frame.size.width = 280;
    downArrow.frame=frame3;
    CGRect frame4 = callerIDField.frame;
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
    [self.view addSubview:picker];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && tokenInt ==22) {
        tokenInt =0;
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    }
}


-(void) dealloc{
    [prefixName release];
    [prefixCode release];
    [prefixCountryCode release];
    [super dealloc];
}


@end
