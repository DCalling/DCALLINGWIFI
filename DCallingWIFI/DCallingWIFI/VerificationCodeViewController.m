//
//  VerificationCodeViewController.m
//  DCalling WiFi
//
//  Created by David C. Son on 26.01.12.
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

#import "VerificationCodeViewController.h"
#import "FlatrateXMLParser.h"
#import "RestAPICaller.h"
#import "PreferencesHandler.h"
#import "SQLiteDBHandler.h"
#import "getCreditHandler.h"
#import "CallerIDViewController.h"
#import "AddressBookHandler.h"
#import "CallerIDViewController.h"
#import "CountryPrefixHandler.h"

@implementation VerificationCodeViewController

@synthesize callerID;
@synthesize status, newSimStatus, pTim;



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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(NSString *) setVerCallerID:(NSString *)myCaller{
    callerID = myCaller;
    return callerID;
}

- (void)viewForiOSSeven{
    //codeField activityIndicator mCallId anmelden tickImage tickImage2 topHeader midHeader bottomButton codeSMSButton backgroundImg
    CGRect frame0 = backgroundImg.frame;
    CGRect frame1 = codeField.frame;
    CGRect frame2 = activityIndicator.frame;
    CGRect frame3 = mCallId.frame;
    CGRect frame4 = anmelden.frame;
    CGRect frame5 = tickImage.frame;
    CGRect frame6 = tickImage2.frame;
    CGRect frame7 = topHeader.frame;
    CGRect frame8 = midHeader.frame;
    CGRect frame9 = bottomButton.frame;
    CGRect frame10 = codeSMSButton.frame;
    
    frame0.origin.y +=20;
    backgroundImg.frame = frame0;
    
    frame1.origin.y +=20;
    codeField.frame = frame1;
    
    frame2.origin.y +=20;
    activityIndicator.frame = frame2;
    
    frame3.origin.y +=20;
    mCallId.frame = frame3;
    
    frame4.origin.y +=20;
    anmelden.frame = frame4;
    
    frame5.origin.y +=20;
    tickImage.frame = frame5;
    
    frame6.origin.y +=20;
    tickImage2.frame = frame6;
    
    frame7.origin.y +=20;
    topHeader.frame = frame7;
    
    frame8.origin.y +=20;
    midHeader.frame = frame8;
    
    frame9.origin.y +=20;
    bottomButton.frame = frame9;
    
    frame10.origin.y +=20;
    codeSMSButton.frame = frame10;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    if(result.height == 960) {
        NSLog(@"iPhone 4 Resolution");
    }
    else if(result.height == 1136) {
        [self foriPhonefiveDraw];
    }
    else{
        NSLog(@"iPhone standard");
    }

    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0)
        [self viewForiOSSeven];
    topHeader.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"verification_title_heading"];
    [topHeader setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    midHeader.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"verification_check_title"];
    [midHeader setFont:[UIFont fontWithName:@"ArialMT" size:18]];
    [bottomButton setTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"verification_bottom_button"] forState:UIControlStateNormal];
    [self forBackgroundButton];
    tickImage.hidden = YES;
    tickImage2.hidden = YES;
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]init];
    NSString *drop = [mPrefs getDropBox];
    NSString *caller = [mPrefs getCallerBox];
    AddressBookHandler *mAdd = [[AddressBookHandler alloc]autorelease];
    NSString *dropp = [mAdd prefixStr:drop];
    int cout = (int)[caller length];
    NSRange ran = NSMakeRange(0, 3);
    NSString *three = [caller substringWithRange:ran];
    NSRange ran1 = NSMakeRange(3, cout-3);
    NSString *rest = [caller substringWithRange:ran1];
    NSString *firstString = [NSString stringWithFormat:@"+(%@) %@ %@", dropp, three, rest];
    if((dropp == NULL || dropp==nil) || (three== NULL || three==nil) || (rest == NULL || rest==nil)){
        [self performSegueWithIdentifier:@"backAgain" sender:self];
    }
    //NSLog( @"%@", firstString);
    callerID = [mPrefs getCallerID];
    [mPrefs release];
    mCallId.text = firstString;
    [mCallId setFont:[UIFont fontWithName:@"Arial-BoldMT" size:22]];
    mCallId.textAlignment = UITextAlignmentCenter;
    //NSLog(@"dfdf %@", callerID);
    
    [codeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    /*if(anmelden.enabled == NO){
        myTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(BackTOCallerIDTimer:) userInfo:nil repeats:NO];
    }*/
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    NSLog(@"Code %@", drop);
    [codeSMSButton setHidden:YES];
    if([drop isEqualToString:@"+1"]){
        [self getVerificationCode];
    }
    
    
    newSimStatus=TRUE;
    pTim=1;
    [self performSelectorInBackground:@selector(updateCreditCon) withObject:nil];
    //[self checkPrefix];
}

- (void)viewWillDisappear:(BOOL)animated {
    //BEFORE DOING SO CHECK THAT TIMER MUST NOT BE ALREADY INVALIDATED
    if(timer !=nil){
        [timer invalidate];
        timer = nil;
    }
    if(updateTimer!=nil){
        [updateTimer invalidate];
        updateTimer=nil;
    }
    [activityIndicator removeFromSuperview];
    [super viewWillDisappear:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //if(newSimStatus ==FALSE){
        //[self performSegueWithIdentifier:@"backAgain" sender:self];
   // }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"backAgain"]){
        CallerIDViewController *myPush = [segue destinationViewController];
        myPush.title = @"Callerid";
        // [myPush release];
    }
}
-(void) forBackgroundButton{
    UIImage *btnImage = [UIImage imageNamed:@"backround_grey_color_image.png"];
    [anmelden setBackgroundImage:btnImage forState:UIControlStateNormal];
    
   /* UILabel *buttonLbl = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, 30)];
    buttonLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"verification_top_button"] ;
    [buttonLbl setBackgroundColor:[UIColor clearColor]];
    [buttonLbl setTextColor:[UIColor blackColor]];
    [buttonLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [anmelden addSubview:buttonLbl];
    [anmelden setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter| UIControlContentHorizontalAlignmentCenter];
    [buttonLbl release];*/
    
    [anmelden setTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"verification_top_button"] forState:UIControlStateNormal];
    
    //anmelden.titleLabel.textColor = [UIColor blackColor];
    [anmelden setTitleColor:[UIColor whiteColor] forState:UIControlContentVerticalAlignmentCenter|UIControlContentHorizontalAlignmentCenter];
    anmelden.enabled=NO;
   // [myTimer invalidate];
}

FlatrateXMLParser * flatrateXMLParser;

 -(void)textFieldDidChange:(NSNotification*)aNotification {
     [self forBackgroundButton];
     if(codeField.text.length==5){
         
         [tickImage setImage:[UIImage imageNamed:@""]];
         tickImage.hidden = YES;
         
         [codeField resignFirstResponder];
         [self.view addSubview:activityIndicator];
          [activityIndicator startAnimating];
         
             timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(doVerificationCode) userInfo:nil repeats:YES];
             
             
         
                 
     }
 }



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)doVerificationCode{
    NSString *code = codeField.text;
    
    // add code format check
    PreferencesHandler *mPref = [[[PreferencesHandler alloc]init]autorelease];
    callerID = @"";
    callerID = [mPref getCallerID];
    //NSLog(@"121");
    // 2. verify the sms code
    RestAPICaller *rapi = [[RestAPICaller alloc]init];
    NSData *restAPIXMLVerification = [rapi getVerificationXML:callerID :code];
    //NSLog(@"122");
    [rapi release];
    
    
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithDCallingPostDelegate: self xmlData:restAPIXMLVerification];
    //NSLog(@"129");
    //[flatrateXMLParser release];
}



-(void) getCredit {
    /*PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
    NSString *token = [mPrefs getToken];
    RestAPICaller *mRst = [[RestAPICaller alloc]autorelease];
    NSData *restForCredit = [mRst getUserCredit:token];
    
    [[FlatrateXMLParser alloc] initWithUserCreditDelegate: self xmlData:restForCredit];*/
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] autorelease];
    [mGetCrHandler getCredit];
    [self performSelectorInBackground:@selector(pushRegTimer) withObject:nil];
    [self performSegueWithIdentifier:@"MySegue2" sender:self];
}

/*-(void)getCreditParserDidComplete:(NSMutableString *) result{
    NSRange textRange;
    //BOOL status;
    textRange = [result rangeOfString:@"success"];
    //NSLog(@"xml %@", result);
    // NSLog(@"123");
    
    if(textRange.location != NSNotFound){
       // status = true;
        NSString *myString = [NSString stringWithString:result];
        //NSLog(@"length %@", myString);
        //NSRange rangeStr = NSMakeRange (17, [myString length]-6);
        //NSString *trimPhoneNumber = [myString substringWithRange:rangeStr];
        NSString *number = [[myString componentsSeparatedByString:@"\n"] objectAtIndex:3];
        NSRange rangeStr = NSMakeRange (0, [number length]-3);
        NSString *trimPhoneNumber = [number substringWithRange:rangeStr];
        NSString *sign = @" €";
        NSString *creditValue = [trimPhoneNumber stringByAppendingFormat:sign];
        //NSLog(@"cr %@", creditValue);
        PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
        [mPrefs setCredit:creditValue];
        [self performSegueWithIdentifier:@"MySegue2" sender:self];
        
    }
    else{
        //status = false;
        NSLog(@"Not credit");
    }
    
}*/



-(void) redirectTo{
    //NSLog(@"didFinishVerification true");
    // 3. user check for existing user or create new user
    //  [activityIndicator startAnimating];
     //[activityIndicator startAnimating];
     NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
     NSString *reseller = @"2";
     RestAPICaller *rapi = [[RestAPICaller alloc]init];
     NSData *restAPIXMLUser = [rapi getUser:callerID :language :reseller];
    
    //NSLog(@"test for parser ");
    
     flatrateXMLParser = [[FlatrateXMLParser alloc] initWithVerificationSMSDelegate: self xmlData:restAPIXMLUser];
   // NSLog(@"test for parser 12 ");
}

-(void) dealloc{
    callerID = nil;
    [callerID release];
    [activityIndicator removeFromSuperview];
    [super dealloc];
}

-(void) dCallingParsePostDidComplete: (NSMutableString *) result{ // call by thread. in xmlParser class
    
    NSRange textRange;
    textRange = [result rangeOfString:@"success"];
    // NSLog(@"xml %@", result);
   // NSLog(@"123");
    
    if(textRange.location != NSNotFound){
        status = true;
    }
    else{
        status = false;
    }
    
    if(status == false){
        //NSLog(@"didFinishVerification false");
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Verification failed!" message:@"Please provide correct SMS code and try again."
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         
         [message show];
        
        //tickImage.hidden=YES;
        //[tickImage setImage:[UIImage imageNamed:@"wrong_data.png"]];
        //NSLog(@"124");
        
    }else{
        tickImage.hidden=NO; //icon_check
        tickImage2.hidden=NO;
        UIImage *tickName = [UIImage imageNamed:@"icon_check.png"];
        [tickImage setImage:tickName];
        [codeSMSButton setHidden:YES];
        UIImage *btnImage = [UIImage imageNamed:@"button_big_orange_background.png"];
        [anmelden setBackgroundImage:btnImage forState:UIControlStateNormal];
        /*UILabel *buttonVLbl = [[UILabel alloc]initWithFrame:CGRectMake(3, -1, 90, 20)];
        buttonVLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"verification_top_button"] ;
        [buttonVLbl setBackgroundColor:[UIColor clearColor]];
        [buttonVLbl setTextColor:[UIColor blackColor]];
        [buttonVLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [anmelden addSubview:buttonVLbl];
        [anmelden setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter| UIControlContentHorizontalAlignmentCenter];
        [buttonVLbl release];*/
        [anmelden setTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"verification_top_button"] forState:UIControlStateNormal];
        //anmelden.titleLabel.textColor = [UIColor blackColor];
        [anmelden setTitleColor:[UIColor whiteColor] forState:UIControlContentVerticalAlignmentCenter|UIControlContentHorizontalAlignmentCenter];
        anmelden.enabled=YES;
        [myTimer invalidate];    
    }
   // NSLog(@"125");
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [timer invalidate];
    timer = nil;
    flatrateXMLParser = nil;
    [flatrateXMLParser release];
    
}


-(void)verificationSMSParseDidComplete:(NSMutableString *) result {
        
   // [activityIndicator stopAnimating];
   // [activityIndicator release];
    flatrateXMLParser = nil;
    //[flatrateXMLParser release];
    //[timer invalidate];
   
    //NSLog(@"test for parser");
   // [activityIndicator startAnimating];
    RestAPICaller *restApi = [[RestAPICaller alloc]init];
    //NSLog(@"CallerID:- %@", callerID);
    NSData *restAPIXMLUserParser = [restApi getAuthUser:callerID];
    
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithAuthSessionDelegate:self xmlData:restAPIXMLUserParser];
    
}

-(void)authSessionParserDidComplete:(NSMutableString *) result {
    
    // NSLog(@"######## in AuthSessionParseDidComplete");
    
    // NSLog(@"Hello AuthSession - %@",result);
    NSString *myString = [NSString stringWithString:result];
    NSRange range = NSMakeRange (25, 32);
    
    NSString *authSessionToken = [myString substringWithRange:range];
    
    //NSLog(@"token :- %@", [myString substringWithRange:range]);
    //[activityIndicator stopAnimating];
    
    // read token from xml and save to preferences
    //CallerIDViewController *mCallerID = [[CallerIDViewController alloc]autorelease];
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *carrierName = [carrier carrierName];
    NSString *mcc = [carrier mobileCountryCode];
    //NSString *prefixCountryCode = [mCallerID getMCCPrefix:mcc];
    NSString *mnc = [carrier mobileNetworkCode];
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    [preferences setToken:authSessionToken];
    [preferences setMCC:mcc];
    [preferences setMNC:mnc];
    [preferences setCarrier:carrierName];
    //[activityIndicator release];
    //[flatrateXMLParser release];
    // redirect to tab controller
    //sleep(1);
    
    /*UITabBarController *tabBarController = [[[UITabBarController alloc] init] retain];
    [[self tabBarController] delegate];
    [[self tabBarController] reloadInputViews];
    self.tabBarController.selectedIndex=0;
    [tabBarController release];*/
    [self getCredit];
    //sleep(2);
    
    
    
}

-(IBAction)getVerificationCode{
    //NSLog(@"CallerID -- %@", callerID);
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    RestAPICaller *rapi = [[RestAPICaller alloc]init];
    NSData *restAPIXMLCode = [rapi getVerificationCodeXML:callerID :language];
    
   // NSLog(@"test for parser %@", restAPIXMLCode);
    
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithVerficationCodeProvider: self xmlData:restAPIXMLCode];
}

-(void) verificationCodeParseDidComplete:(NSMutableString *) result{
    NSRange textRange;
    NSRange textRangeError;
    textRangeError =[result rangeOfString:@"error"];
    textRange = [result rangeOfString:@"success"];
    //NSLog(@"xml %@", result);
    if(textRange.location != NSNotFound){    
        //codeSMSButton.userInteractionEnabled=NO;
        [codeSMSButton setHidden:YES];
    }
    else { 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [codeField resignFirstResponder];
}
- (IBAction)mainMenuSeque:(id)sender{
    
    [self performSegueWithIdentifier:@"MySegue2" sender:sender];
    
}

-(IBAction)BackTOCallerID{
    //[self performSegueWithIdentifier:@"backAgain" sender:self];
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)BackTOCallerIDTimer:(NSTimer *) pTimer{
    [self performSegueWithIdentifier:@"backAgain" sender:pTimer];
}

- (void) updateCreditCon {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   runLoop = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self  selector:@selector(checkPrefix:) userInfo:nil repeats:YES];
    [runLoop addTimer:updateTimer forMode:NSDefaultRunLoopMode];
    [runLoop run];
    [pool release];
}


-(void)checkPrefix:(NSTimer *)pTimer{
    PreferencesHandler *mpref = [[PreferencesHandler alloc]init];
    //NSLog(@"get Caller : %@", [mpref getCallerBox]);
    if(([mpref getCallerBox]==NULL || [mpref getCallerBox]==nil) && pTim==1){
        @autoreleasepool {
            pTimer=nil;
            pTim=0;
            [pTimer invalidate];
            //[[self retain] autorelease];
            // [self pushtoSelf];
            [self performSelectorOnMainThread:@selector(pushtoSelf) withObject:nil waitUntilDone:NO];

        }
    }
}

-(void)pushtoSelf{
   // NSLog(@"get ghghhh Caller" );
    /*CallerIDViewController *newViewController = [[CallerIDViewController alloc]init];
    newViewController.title=@"Callerid";
    [self.navigationController pushViewController:newViewController animated:YES];*/
    [self performSegueWithIdentifier:@"backAgain" sender:self];
   // [self release];
}


-(void)foriPhonefiveDraw{
    //NSLog(@"iPhone 5 Resolution");
    CGRect frame = midHeader.frame;
    frame.origin.y += 25;
    //frame.size.height = 37;
    //frame.size.width = 280;
    midHeader.frame=frame;
    //pickerButton = [[UIButton alloc] initWithFrame:frame];
    CGRect frame2 = mCallId.frame;
    frame2.origin.y += 35;
    //frame.size.height = 37;
    //frame.size.width = 280;
    mCallId.frame=frame2;
    CGRect frame3 = tickImage2.frame;
    frame3.origin.y += 35;
    //frame.size.height = 37;
    //frame.size.width = 280;
    tickImage2.frame=frame3;
    CGRect frame4 = activityIndicator.frame;
    frame4.origin.y += 35;
    //frame.size.height = 37;
    //frame.size.width = 280;
    activityIndicator.frame=frame4;
    CGRect frame5 = bottomButton.frame;
    frame5.origin.y += 50;
    //frame.size.height = 37;
    //frame.size.width = 280;
    bottomButton.frame=frame5;
    
    [self.view addSubview:midHeader];
    [self.view addSubview:tickImage2];
    [self.view addSubview:activityIndicator];
    [self.view addSubview:bottomButton];
    [self.view addSubview:mCallId];
}

-(void)pushRegTimer{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop *Loop = [NSRunLoop currentRunLoop];
    
    myRegTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self  selector:@selector(pushRegistration) userInfo:nil repeats:NO];
    
    [Loop run];
    [pool release];
}

-(void)pushRegistration{
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    NSString *myToken = [mPref getToken];
    NSString *myCallerID = [mPref getCallerID];
    NSString *myDeviceID = [mPref getDeviceToken];
    //NSLog(@"callerid=%@&token=%@&device_token=%@", myCallerID, myToken, myDeviceID);
    if(myDeviceID.length>2){
        RestAPICaller *mRest = [[RestAPICaller alloc]init];
        NSData *reg = [mRest pushRegistration:myCallerID :myToken :myDeviceID];
        if(reg != NULL){
            flatrateXMLParser = [[FlatrateXMLParser alloc] initWithPushRegistration:self xmlData:reg];
        }
    }
    
}

-(void)pushRegistrationParseDidComplete:(NSMutableString *) result{
    NSArray *provider = [result componentsSeparatedByString: @"//"];
    if([provider count]>1){
        NSString *gotStatus = [provider objectAtIndex:1];
        PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
        [mPref setPushRegistrationStatus:gotStatus];
        //NSLog(@"result - //%@//", [mPref getPushRegistrationStatus]);
    }
    //NSLog(@"result - %@", result);
}



@end
