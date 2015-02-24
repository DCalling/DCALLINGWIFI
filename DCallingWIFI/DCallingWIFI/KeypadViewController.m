//
//  KeypadViewController.m
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

#import "KeypadViewController.h"
#import "SQLiteDBHandler.h"
#import "PreferencesHandler.h"
#import "AddressBookHandler.h"
#import "getCreditHandler.h"
#import "ContactsViewController.h"
#import "DataModelRecent.h"
#import "DCallingWIFIAppDelegate.h"
#import "LinphoneManager.h"

@implementation KeypadViewController

@synthesize status;
@synthesize countData, abcd, CallNumber, mVal, mButton, CallTxtField, tokenInt;

@synthesize callQualityImage, callSecurityButton, callSecurityImage, registrationStateLabel, registrationStateImage;

NSTimer *callQualityTimer;
NSTimer *callSecurityTimer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"val %@", nibBundleOrNil);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(DCallingWIFIAppDelegate *)appDelegate{
    return (DCallingWIFIAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void) viewforiosSeven{
    CGRect headFrame = headerImage.frame;
    //CGRect titleTextFrame = topHeader.frame;
    CGRect topRightFrame = toprightHeader.frame;
    CGRect downRightFrame = topRightBottomHeader.frame;
    CGRect calltextFieldFrame = CallTxtField.frame;
    CGRect callLabelFrame = CallNumber.frame;
    CGRect oneFrame = oneButton.frame;
    CGRect twoFrame = twoButton.frame;
    CGRect threeFrame = threeButton.frame;
    CGRect fourFrame = fourButton.frame;
    CGRect fiveFrame = fiveButton.frame;
    CGRect sixFrame = sixButton.frame;
    CGRect sevenFrame = sevenButton.frame;
    CGRect eightFrame = eightButton.frame;
    CGRect nineFrame = nineButton.frame;
    CGRect starFrame = starButton.frame;
    CGRect hashFrame = hashButton.frame;
    CGRect contactFrame = contactButton.frame;
    CGRect plusFrame = plusBtn.frame;
    CGRect backFrame = backBtn.frame;
    CGRect callFrame = callButton.frame;
    
    //CGRect tableFrame = self.tv.frame;
    headFrame.origin.y +=20;
    headerImage.frame = headFrame;
    
    //titleTextFrame.origin.y+=20;
    //topHeader.frame=titleTextFrame;
    
    topRightFrame.origin.y+=20;
    toprightHeader.frame=topRightFrame;
    
    downRightFrame.origin.y+=20;
    topRightBottomHeader.frame=downRightFrame;
    
    calltextFieldFrame.origin.y+=20;
    CallTxtField.frame=calltextFieldFrame;
    
    callLabelFrame.origin.y+=20;
    CallNumber.frame=callLabelFrame;
    
    oneFrame.origin.y+=20;
    oneButton.frame=oneFrame;
    
    twoFrame.origin.y+=20;
    twoButton.frame=twoFrame;
    
    threeFrame.origin.y+=20;
    threeButton.frame=threeFrame;
    
    fourFrame.origin.y+=20;
    fourButton.frame=fourFrame;
    
    fiveFrame.origin.y+=20;
    fiveButton.frame=fiveFrame;
    
    sixFrame.origin.y+=20;
    sixButton.frame=sixFrame;
    
    sevenFrame.origin.y+=20;
    sevenButton.frame=sevenFrame;
    
    eightFrame.origin.y+=20;
    eightButton.frame=eightFrame;
    
    nineFrame.origin.y+=20;
    nineButton.frame=nineFrame;
    
    starFrame.origin.y+=20;
    starButton.frame=starFrame;
    
    hashFrame.origin.y+=20;
    hashButton.frame=hashFrame;
    
    plusFrame.origin.y+=20;
    plusBtn.frame=plusFrame;
    
    backFrame.origin.y+=20;
    backBtn.frame=backFrame;
    
    contactFrame.origin.y+=20;
    contactButton.frame=contactFrame;
    
    callFrame.origin.y+=20;
    callButton.frame=callFrame;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    if(result.height == 1136) {
        [self foriPhoneFiveDraw];
    }
    
    [self.navigationController.navigationBar setTintColor:[[UIColor alloc]initWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:0.0]];
    [toprightHeader setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if([language isEqualToString:@"de"] && version>=7.0){
        CGRect downRightFrame = topRightBottomHeader.frame;
        downRightFrame.size.width-=15;
        topRightBottomHeader.frame=downRightFrame;
    }
    topRightBottomHeader.text=[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"recent_recharge_title"];
    [topRightBottomHeader setFont:[UIFont fontWithName:@"ArialMT" size:12]];
    dialTab.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"keypad_title"];
    CGRect frame = CGRectMake(0, 0, [dialTab.title sizeWithFont:[UIFont boldSystemFontOfSize:16.0]].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textAlignment = UITextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    //self.navigationItem.titleView = label;
    label.text = self.title;
    [label release];
    //[callButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
    [callButton setTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"keypad_call_button"] forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    //self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view from its nib.
    mVal = 0;
    [CallTxtField setFont:[UIFont fontWithName:@"Arial-BoldMT" size:30]];   
    backBtn.tag=100;
    plusBtn.tag=200;
    NSArray *buttons = [NSArray arrayWithObjects:backBtn,plusBtn, nil];
    
    for (UIButton *button in buttons) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        [button addGestureRecognizer:longPress];
    }
    //float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version>=7.0){
        [self viewforiosSeven];
        UIImage *selectedImg = [UIImage imageNamed:@"tabbar__dialpad.png"];
        UIImage *unSelectedImg = [UIImage imageNamed:@"tabbar__dialpad_active.png"];
        
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unSelectedImg = [unSelectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = unSelectedImg;
        self.tabBarItem.image = selectedImg;
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"keypad_title"] image:selectedImg selectedImage:unSelectedImg];
    }
    else
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__dialpad_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__dialpad.png"]];
    //[acView setHidden:YES];
    int c = 0;
    NSLog(@"sdsd %d", c);
    c++;
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        UIButton *whichButton=(UIButton *)[gesture view];
        //UIButton *selectedButton=(UIButton *)[gesture view];
        //NSLog(@"%d", whichButton.tag);
        if(whichButton.tag==200){
            NSString *number = @"+";    
            NSString *allNumber =  CallTxtField.text;
            if(allNumber.length < 17){
                NSString *newNumber = [allNumber stringByAppendingString:number];       
                CallTxtField.text = newNumber;
            }
            [pasteButton setHidden:YES];
        }
        else {
            CallTxtField.text=@"";
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneRegistrationUpdate
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneGlobalStateUpdate
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneCallUpdate
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneCoreUpdate
                                                  object:nil];
    if(callQualityTimer != nil) {
        [callQualityTimer invalidate];
        callQualityTimer = nil;
    }
    if(callSecurityTimer != nil) {
        [callSecurityTimer invalidate];
        callSecurityTimer = nil;
    }
}


-(void) viewWillAppear:(BOOL)animated{
   
    if([[self appDelegate]checkVal])
        [self callScreen:self];
    //[self performSelectorInBackground:@selector(updateCreditKey) withObject:nil];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    ContactsViewController *mContactView = [[ContactsViewController alloc]autorelease];
    BOOL internetStatus = [mContactView CheckNetwork];
    //NSString *lb = mContactView.registrationStateLabel.text;
    //NSLog(@"lala %@", mContactView.registrationStateLabel.text);
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    [mPref setViewSt:YES];
    NSString *token = [mPref getToken];
    BOOL sts = [mPref getCallingStatus];
    [mPref setViewSt:YES];
    if(sts == TRUE && internetStatus==TRUE){
        /*DataModelRecent *mDataM = [[DataModelRecent alloc]autorelease];
        [mDataM stopTimer];
        //NSLog(@"release timer");*/
        //mVal=0;
        //[self performSelectorInBackground:@selector(updateCreditKey) withObject:nil];
        [mPref setCallingStatus:FALSE];
    }
    //NSLog(@"google : %@", [mPref getMNC]);
    if((token == NULL) && (token == nil)){
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_WARN"]
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_MSG"]
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        tokenInt = 22;*/
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
        
    }
    if(internetStatus == FALSE && ![[mPref getInternetVal] isEqualToString:@"KEYPAD"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] 
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"] 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [mPref setInternetVal:@"KEYPAD"];
    [super viewWillAppear:YES];
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
    toprightHeader.text = [mPrefs getCredit];
    mVal=0;
    self.navigationController.navigationBar.hidden = YES;
    //myTabBarItem = [[UITabBarItem alloc]initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"keypad_title"] image:nil tag:100];
    //[myTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__dialpad_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__dialpad.png"]];
    
    mButton = 0;
    
    callQualityTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(callQualityUpdate)
                                                      userInfo:nil
                                                       repeats:YES];
    
    // Set callQualityTimer
	callSecurityTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(callSecurityUpdate)
                                                       userInfo:nil
                                                        repeats:YES];
    
    // Set observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationUpdate:)
                                                 name:kLinphoneRegistrationUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(globalStateUpdate:)
                                                 name:kLinphoneGlobalStateUpdate
                                               object:nil];
    [callQualityImage setHidden: true];
    [callSecurityImage setHidden: true];
    
    // Update to default state
    LinphoneProxyConfig* config = NULL;
    if([LinphoneManager isLcReady])
        linphone_core_get_default_proxy([LinphoneManager getLc], &config);
    [self proxyConfigUpdate: config];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdateEvent:)
                                                 name:kLinphoneCallUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(coreUpdateEvent:)
                                                 name:kLinphoneCoreUpdate
                                               object:nil];
    // Update on show
    if([LinphoneManager isLcReady]) {
        LinphoneCore* lc = [LinphoneManager getLc];
        LinphoneCall* call = linphone_core_get_current_call(lc);
        LinphoneCallState state = (call != NULL)?linphone_call_get_state(call): 0;
        [self callUpdate:call state:state];
        
        if([LinphoneManager runningOnIpad]) {
            /*if(linphone_core_video_enabled(lc) && linphone_core_video_preview_enabled(lc)) {
             linphone_core_set_native_preview_window_id(lc, (unsigned long)videoPreview);
             [backgroundView setHidden:FALSE];
             [videoCameraSwitch setHidden:FALSE];
             } else {*/
            linphone_core_set_native_preview_window_id(lc, (unsigned long)NULL);
            /*[backgroundView setHidden:TRUE];
             [videoCameraSwitch setHidden:TRUE];
             }*/
        }
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0 // attributed string only available since iOS6
        /*if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
         // fix placeholder bar color in iOS7
         UIColor *color = [UIColor grayColor];
         CallTxtField.attributedPlaceholder = [[NSAttributedString alloc]
         initWithString:CallTxtField.placeholder
         attributes:@{NSForegroundColorAttributeName: color}];
         }*/
#endif
        
    }
}

- (void)callUpdateEvent:(NSNotification*)notif {
    LinphoneCall *call = [[notif.userInfo objectForKey: @"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
    [self callUpdate:call state:state];
}

- (void)coreUpdateEvent:(NSNotification*)notif {
    if([LinphoneManager isLcReady] && [LinphoneManager runningOnIpad]) {
        LinphoneCore* lc = [LinphoneManager getLc];
        //NSLog(@"%@", lc);
        /* if(linphone_core_video_enabled(lc) && linphone_core_video_preview_enabled(lc)) {
         linphone_core_set_native_preview_window_id(lc, (unsigned long)videoPreview);
         [backgroundView setHidden:FALSE];
         [videoCameraSwitch setHidden:FALSE];
         } else {
         linphone_core_set_native_preview_window_id(lc, (unsigned long)NULL);
         [backgroundView setHidden:TRUE];
         [videoCameraSwitch setHidden:TRUE];
         }*/
    }
}

- (void)callUpdate:(LinphoneCall*)call state:(LinphoneCallState)state {
    if([LinphoneManager isLcReady]) {
        LinphoneCore *lc = [LinphoneManager getLc];
        if(linphone_core_get_calls_nb(lc) > 0) {
            /*if(transferMode) {
             [addCallButton setHidden:true];
             [transferButton setHidden:false];
             } else {
             [addCallButton setHidden:false];
             [transferButton setHidden:true];
             }*/
            [callButton setHidden:false];
            //[backButton setHidden:false];
            //[addContactButton setHidden:true];
        } else {
            //[addCallButton setHidden:true];
            [callButton setHidden:false];
            //[backButton setHidden:true];
            //[addContactButton setHidden:false];
            //[transferButton setHidden:true];
        }
    }
}

- (void) updateCreditKey {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    //[acView setHidden:NO];
    //[acView startAnimating];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self  selector:@selector(getCreditKey) userInfo:nil repeats:NO];
    
    [runLoop run];
    [pool release];
}

-(void) getCreditKey
{
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] init];
    [mGetCrHandler getCredit];
    
    //NSLog(@"Dails updatee");
    [self viewWillAppear:YES];
    [self.view setNeedsDisplay];
    [self performSelectorInBackground:@selector(refresh) withObject:nil];
}

-(void)refresh{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self  selector:@selector(viewWillAppear:) userInfo:nil repeats:NO];
    mVal=0;
    [runLoop run];
    [pool release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) addOne:(id)sender {
    NSString *number = @"1";    
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];       
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}

-(void) addTwo:(id)sender {
    NSString *number = @"2";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}

-(void) addThree:(id)sender {
    NSString *number = @"3";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}

-(void) addFour:(id)sender {
    NSString *number = @"4";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}
-(void) addFive:(id)sender {
    NSString *number = @"5";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}
-(void) addSix:(id)sender {
    NSString *number = @"6";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}
-(void) addSeven:(id)sender {
    NSString *number = @"7";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}
-(void) addEigth:(id)sender {
    NSString *number = @"8";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}
-(void) addNine:(id)sender {
    NSString *number = @"9";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}
-(void) addZero:(id)sender {
    NSString *number = @"0";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}
-(void) addStar:(id)sender {
    NSString *number = @"*";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}
-(void) addPound:(id)sender {
    NSString *number = @"#";
    NSString *allNumber =  CallTxtField.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        
        CallTxtField.text = newNumber;
    }
     [pasteButton setHidden:YES];
}



-(void) addCall:(id)sender {
    PreferencesHandler *mPref = [[PreferencesHandler alloc]autorelease];
    NSString *token = [mPref getToken];
    if((token == NULL) && (token == nil)){
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_WARN"]
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_MSG"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        tokenInt = 22;*/
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
        return;
    }
     [pasteButton setHidden:YES];
      NSString *destination = CallTxtField.text;
    
    abcd = destination;
    //NSLog(@"%@", abcd);
    if([destination isEqualToString:@"0"] || [destination isEqualToString:@"00"]|| [destination isEqualToString:@"000"]){
        return;
    }
    
    if(destination.length<=0){
        SQLiteDBHandler *mSqlite = [[SQLiteDBHandler alloc]init];
        NSString *lastNumber = [NSString stringWithFormat:@"%@", [mSqlite getLastCallLogRec]];
        CallTxtField.text=lastNumber;
        if(lastNumber.length>2){
            //[callButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12]];
            // [callButton setTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"keypad_Re_call_button"] forState:UIControlStateNormal];
            //[callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [mSqlite release];
        return;
    }
    
    if([callButton.titleLabel.text isEqualToString:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"keypad_Re_call_button"]] ){
        [callButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [callButton setTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"keypad_call_button"] forState:UIControlStateNormal];
        [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
     mFav = [[FavViewHandler alloc] autorelease];
    //BOOL st = [mFav validateMobile:destination];
   
    AddressBookHandler *mAddr = [[AddressBookHandler alloc]init];
    
    NSString *trimDestination = [mAddr trimWhiteSpace:destination];
     //NSString *trimDestination = destination;
   // NSString *trimDestination = destination;
    destination = [mAddr trimWhiteSpaceNotZero:destination];
    NSString *names=@"";
    if(destination.length >5){
        @try{
            names = [mAddr namesFromAB:trimDestination];
        }
        @catch(NSException* ex){
            NSLog(@"failed while fwtching the name: %@",ex);
            names=@"";
        }
    }
        
    NSString *fName = @"";
    NSString *lName = @"";
    NSString *phoneLabel =@"";
    NSString *extra =@"";
    if([names length] > 2){
         NSArray *personNames = [names componentsSeparatedByString: @" "];
        if([personNames count] == 4){
            fName = [personNames objectAtIndex:0];
            extra = [personNames objectAtIndex:1];
            fName = [fName stringByAppendingFormat:@" %@", extra];
            lName = [personNames objectAtIndex:2];
            phoneLabel = [personNames objectAtIndex:3];
        }
        else if([personNames count] > 1){
            fName = [personNames objectAtIndex:0];
            lName = [personNames objectAtIndex:1];
            phoneLabel = [personNames objectAtIndex:2];
        }
        else{
            NSLog(@"count %lu", (unsigned long)[personNames count]);
        }
        
    }
    NSString *fullName = [fName stringByAppendingFormat:@" %@", lName];
    //For sip calling by Prashant
    NSArray *userData2;
    userData2 = [[NSArray alloc] initWithObjects:fName,lName,destination,phoneLabel,@"6", nil];
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    [sqliteDB saveCallLog:userData2];
    mFav = [[FavViewHandler alloc]init];
    BOOL checkNum = [mFav checkPrefixStr:destination];
    if(!checkNum){
        destination = [mFav convertNumber:destination];
        //NSLog(@"converted Number %@", destination);
    }
    if(linphone_core_is_network_reachable([LinphoneManager getLc]) && [destination length]>2)
        if(![fName isEqualToString:@""])
            [self call:destination:fullName];
        else
            [self call:destination:nil];
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"]
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    // end commented for SIP calling , next two for FRB Calling which is commented
    //DataModelRecent *mCalling = [[DataModelRecent alloc]init];
    //[mCalling callingMethod:fName :lName :phoneLabel :destination :trimDestination:self];
    mVal = 1;
    CallTxtField.text = @"";
    [userData2 release];
    //[mFav release];
    //[self updateCreditKey];
    //[self viewWillAppear:YES];
    //[self updateCreditKey];
    
       
}

-(void)call : (NSString *)address : (NSString *)cName{
    // LinphoneManager *lm = [[LinphoneManager alloc]init];
    /*NSString *displayName = nil;
    ABRecordRef contact = [[[LinphoneManager instance] fastAddressBook] getContact:address];
    if(contact) {
        displayName = [FastAddressBook getContactDisplayName:contact];
    }*/
    [[LinphoneManager instance] call:address displayName:cName transfer:FALSE];
    [self performSegueWithIdentifier:@"inCallScreen" sender:self];
}

-(IBAction) callScreen : (id)sender{
    //[self init];
    NSLog(@"Pra name %@", [[self appDelegate]dName]);
    [[LinphoneManager instance] call:[[self appDelegate]numbers] displayName:[[self appDelegate]dName] transfer:FALSE];
    [self performSegueWithIdentifier:@"inCallScreen" sender:self];
}

-(void) addAdd:(id)sender {
    if([[self appDelegate]addCallValue]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    ABRecordRef aContact = ABPersonCreate();
	CFErrorRef anError = NULL;
    if(CallTxtField.text.length==0){
        CallTxtField.text=@"";
    }
	ABMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	//bool didAdd = ABMultiValueAddValueAndLabel(email, CallNumber.text, kABPersonPhoneMobileLabel, NULL);
    bool didAdd = ABMultiValueAddValueAndLabel(email, CallTxtField.text, kABPersonPhoneMobileLabel, NULL);
	
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationItem.leftBarButtonItem.tintColor= [UIColor blackColor];
    }
    
	if (didAdd == YES)
	{
		ABRecordSetValue(aContact, kABPersonPhoneProperty, email, &anError);
		if (anError == NULL)
		{
			ABUnknownPersonViewController *picker = [[ABUnknownPersonViewController alloc] init];
			picker.unknownPersonViewDelegate = self;
			picker.displayedPerson = aContact;
			picker.allowsAddingToAddressBook = YES;
		    picker.allowsActions = NO;
            picker.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Contact_add_button"];
            
            npNav = [[UINavigationController alloc]initWithRootViewController:picker];
            
            self.navigationController.navigationBar.hidden = NO;
            self.navigationItem.hidesBackButton = YES;
            
            [self.navigationController pushViewController:picker animated:YES];
			
			[picker release];   
		}
		else 
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg11"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg8"] 
														   delegate:nil 
												  cancelButtonTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Cancel"]
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
        
	}	
	CFRelease(email);
	CFRelease(aContact); 
    
     
    
}

-(void) getAddContact{
    
    
}

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
    if(person != NULL){
        //NSLog(@"Added");
        AddressBookHandler *mAddr = [[AddressBookHandler alloc] autorelease];
        [mAddr updateCallLogdata];
    }
    
    
	[self dismissModalViewControllerAnimated:YES];
    
}


// Does not allow users to perform default actions such as emailing a contact, when they select a contact property.
- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person 
						   property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}



-(IBAction)disableKey:(id)sender{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (BOOL) findKeyboard:(UIView *) superView; 
{
    UIView *currentView;
    if ([superView.subviews count] > 0) {
        for(int i = 0; i < [superView.subviews count]; i++)
        {
            
            currentView = [superView.subviews objectAtIndex:i];
            //NSLog(@"%@",[currentView description]);
            if([[currentView description] hasPrefix:@"<UIKeyboard"] == YES)
            {
                currentView.alpha=0;
                //NSLog(@"Find it %@", currentView);
                
                return YES;
            }
            if ([self findKeyboard:currentView]){
                currentView.alpha=0;
               // NSLog(@"Find it 12 %@", currentView);
                return YES;
            }
        }
    }
    
    return NO;
    
}

-(void) checkKeyBoard {
    UIWindow* tempWindow;
    
    for(int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c ++)
    {
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
        if ([self findKeyboard:tempWindow]){
           // tempWindow.alpha=0;
            //NSLog(@"Finally, I found it %@", tempWindow);
        }
            
              
    }
}

- (void)keyboardWillShow:(NSNotification *)note {
    [self performSelector:(@selector(checkKeyBoard)) withObject:nil afterDelay:0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [CallTxtField resignFirstResponder];
    
}


-(void) createButton{
    mButton = 1;
    pasteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pasteButton.frame = CGRectMake(120.0, 100.0, 100.0, 50.0);
    UIImage *backButton = [UIImage imageNamed:@"pastes.png"];
    [pasteButton setBackgroundImage:backButton forState:UIControlStateNormal];
    [pasteButton setTitle:@"Paste" forState:UIControlStateNormal];
    
    [pasteButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter| UIControlContentHorizontalAlignmentCenter];
    [pasteButton addTarget:self action:@selector(pastes:) forControlEvents:UIControlEventTouchDown];
    [pasteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    [self.view addSubview:pasteButton];
}


-(void) addBack:(id)sender {
    
    NSString *allNumber =  CallTxtField.text;
    NSString *newNumber;
    if([allNumber length] > 0){
        newNumber  = [allNumber substringToIndex:[allNumber length] - 1];
        
        CallTxtField.text = newNumber;
    }
    [pasteButton setHidden:YES];
}

-(void)registrationUpdate: (NSNotification*) notif {
    LinphoneProxyConfig* config = NULL;
    linphone_core_get_default_proxy([LinphoneManager getLc], &config);
    [self proxyConfigUpdate:config];
}

- (void) globalStateUpdate:(NSNotification*) notif {
    if ([LinphoneManager isLcReady]) [self registrationUpdate:notif];
}


#pragma mark -

- (void)proxyConfigUpdate: (LinphoneProxyConfig*) config {
    LinphoneRegistrationState state = LinphoneRegistrationNone;
    NSString* message = nil;
    UIImage* image = nil;
    LinphoneCore* lc = [LinphoneManager getLc];
    LinphoneGlobalState gstate = linphone_core_get_global_state(lc);
    
    if( gstate == LinphoneGlobalConfiguring ){
        message = NSLocalizedString(@"Fetching remote configuration", nil);
    } else if (config == NULL) {
        state = LinphoneRegistrationNone;
        if(![LinphoneManager isLcReady] || linphone_core_is_network_reachable([LinphoneManager getLc]))
            message = NSLocalizedString(@"No SIP account configured", nil);
        else
            message = NSLocalizedString(@"Network down", nil);
    } else {
        state = linphone_proxy_config_get_state(config);
        
        switch (state) {
            case LinphoneRegistrationOk:
                message = NSLocalizedString(@"Registered", nil); break;
            case LinphoneRegistrationNone:
            case LinphoneRegistrationCleared:
                message =  NSLocalizedString(@"Not registered", nil); break;
            case LinphoneRegistrationFailed:
                message =  NSLocalizedString(@"Registration failed", nil); break;
            case LinphoneRegistrationProgress:
                message =  NSLocalizedString(@"Registration in progress", nil); break;
            default: break;
        }
    }
    
    registrationStateLabel.hidden = NO;
    switch(state) {
        case LinphoneRegistrationFailed:
            registrationStateImage.hidden = NO;
            image = [UIImage imageNamed:@"led_error.png"];
            break;
        case LinphoneRegistrationCleared:
        case LinphoneRegistrationNone:
            registrationStateImage.hidden = NO;
            image = [UIImage imageNamed:@"led_disconnected.png"];
            break;
        case LinphoneRegistrationProgress:
            registrationStateImage.hidden = NO;
            image = [UIImage imageNamed:@"led_inprogress.png"];
            break;
        case LinphoneRegistrationOk:
            registrationStateImage.hidden = NO;
            image = [UIImage imageNamed:@"led_connected.png"];
            break;
    }
    NSLog(@"REG keypad view %@ ", message);
    [registrationStateLabel setText:message];
    [registrationStateImage setImage:image];
}


#pragma mark -

- (void)callSecurityUpdate {
    BOOL pending = false;
    BOOL security = true;
    
    if(![LinphoneManager isLcReady]) {
        [callSecurityImage setHidden:true];
        return;
    }
    const MSList *list = linphone_core_get_calls([LinphoneManager getLc]);
    if(list == NULL) {
        
        [callSecurityImage setHidden:true];
        return;
    }
    while(list != NULL) {
        LinphoneCall *call = (LinphoneCall*) list->data;
        LinphoneMediaEncryption enc = linphone_call_params_get_media_encryption(linphone_call_get_current_params(call));
        if(enc == LinphoneMediaEncryptionNone)
            security = false;
        else if(enc == LinphoneMediaEncryptionZRTP) {
            if(!linphone_call_get_authentication_token_verified(call)) {
                pending = true;
            }
        }
        list = list->next;
    }
    
    if(security) {
        if(pending) {
            [callSecurityImage setImage:[UIImage imageNamed:@"security_pending.png"]];
        } else {
            [callSecurityImage setImage:[UIImage imageNamed:@"security_ok.png"]];
        }
    } else {
        [callSecurityImage setImage:[UIImage imageNamed:@"security_ko.png"]];
    }
    [callSecurityImage setHidden: false];
}

- (void)callQualityUpdate {
    UIImage *image = nil;
    if([LinphoneManager isLcReady]) {
        LinphoneCall *call = linphone_core_get_current_call([LinphoneManager getLc]);
        if(call != NULL) {
            //FIXME double check call state before computing, may cause core dump
			float quality = linphone_call_get_average_quality(call);
            if(quality < 1) {
                image = [UIImage imageNamed:@"call_quality_indicator_0.png"];
            } else if (quality < 2) {
                image = [UIImage imageNamed:@"call_quality_indicator_1.png"];
            } else if (quality < 3) {
                image = [UIImage imageNamed:@"call_quality_indicator_2.png"];
            } else {
                image = [UIImage imageNamed:@"call_quality_indicator_3.png"];
            }
        }
    }
    if(image != nil) {
        [callQualityImage setHidden:false];
        [callQualityImage setImage:image];
    } else {
        [callQualityImage setHidden:true];
    }
}


-(void) dealloc{
    [mFav release];
    [npNav release];
    [abcd release];
    [pasteButton release];
    //[mCallWebview release];
    
    [registrationStateImage release];
    [registrationStateLabel release];
    [callQualityImage release];
    [callSecurityImage release];
    [callSecurityButton release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [callQualityTimer invalidate];
    [callQualityTimer release];
    [super dealloc];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && tokenInt ==22) {
        tokenInt =0;
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    } 
}

-(void)foriPhoneFiveDraw{
   // NSLog(@"iPhone 5 Resolution");
    CGRect frameCall = CallNumber.frame;
    frameCall.size.height += 50;
    
    CallNumber.frame=frameCall;
    [self.view addSubview:CallNumber];
    
    CGRect frame = CallTxtField.frame;
    frame.size.height += 50;
    
    CallTxtField.frame=frame;
    [self.view addSubview:CallTxtField];
    
   
    
    CGRect frame1 = oneButton.frame;
    frame1.origin.y += 50;
    frame1.size.height += 10;
    oneButton.frame=frame1;
    [self.view addSubview:oneButton];
    
    CGRect frame2 = twoButton.frame;
    frame2.origin.y += 50;
    frame2.size.height += 10;
    twoButton.frame=frame2;
    [self.view addSubview:twoButton];
    
    CGRect frame3 = threeButton.frame;
    frame3.origin.y += 50;
    frame3.size.height += 10;
    threeButton.frame=frame3;
    [self.view addSubview:threeButton];
    
    CGRect frame4 = fourButton.frame;
    frame4.origin.y += 60;
    frame4.size.height += 10;
    fourButton.frame=frame4;
    [self.view addSubview:fourButton];
    
    CGRect frame5 = fiveButton.frame;
    frame5.origin.y += 60;
    frame5.size.height += 10;
    fiveButton.frame=frame5;
    [self.view addSubview:fiveButton];
    
    CGRect frame6 = sixButton.frame;
    frame6.origin.y += 60;
    frame6.size.height += 10;
    sixButton.frame=frame6;
    [self.view addSubview:sixButton];
    
    CGRect frame7 = sevenButton.frame;
    frame7.origin.y += 70;
    frame7.size.height += 10;
    sevenButton.frame=frame7;
    [self.view addSubview:sevenButton];
    
    CGRect frame8 = eightButton.frame;
    frame8.origin.y += 70;
    frame8.size.height += 10;
    eightButton.frame=frame8;
    [self.view addSubview:eightButton];
    
    CGRect frame9 = nineButton.frame;
    frame9.origin.y += 70;
    frame9.size.height += 10;
    nineButton.frame=frame9;
    [self.view addSubview:nineButton];
    
    CGRect frame10 = plusBtn.frame;
    frame10.origin.y += 80;
    frame10.size.height += 10;
    plusBtn.frame=frame10;
    [self.view addSubview:plusBtn];
    
    CGRect frame11 = starButton.frame;
    frame11.origin.y += 80;
    frame11.size.height += 10;
    starButton.frame=frame11;
    [self.view addSubview:starButton];
    
    CGRect frame12 = hashButton.frame;
    frame12.origin.y += 80;
    frame12.size.height += 10;
    hashButton.frame=frame12;
    [self.view addSubview:hashButton];
    
    CGRect frame13 = contactButton.frame;
    frame13.origin.y += 90;
    frame13.size.height += 0;
    contactButton.frame=frame13;
    [self.view addSubview:contactButton];
    
    CGRect frame14 = backBtn.frame;
    frame14.origin.y += 90;
    frame14.size.height += 0;
    backBtn.frame=frame14;
    [self.view addSubview:backBtn];
    
    CGRect frame15 = callButton.frame;
    frame15.origin.y += 90;
    frame15.size.height += 0;
    callButton.frame=frame15;
    [self.view addSubview:callButton];
    
    
}

@end
