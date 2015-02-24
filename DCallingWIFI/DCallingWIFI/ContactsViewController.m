//
//  ContactsViewController.m
//  DCalling WiFi
//
//  Created by David C. Son on 11.01.12.
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

#import "ContactsViewController.h"
#import "SQLiteDBHandler.h"
#import "PreferencesHandler.h"
#import "AddressBookHandler.h"
#import "getCreditHandler.h"
#import "DataModelRecent.h"
#import "KeypadViewController.h"
#import "tabBarview.h"
#import "DCallingWIFIAppDelegate.h"
// For Linphone Integration

#import "LinphoneCoreSettingsStore.h"
#import "LinphoneManager.h"
#import "FlatrateXMLParser.h"

#import <XMLRPCConnection.h>
#import <XMLRPCConnectionManager.h>
#import <XMLRPCResponse.h>
#import <XMLRPCRequest.h>

@implementation ContactsViewController

@synthesize PhoneBook, selectedDetails, mVal, tokenInt, rect, stDr, checkConnectivity;

@synthesize callQualityImage, callSecurityButton, callSecurityImage, registrationStateImage, registrationStateLabel;

NSTimer *callQualityTimerContact;
NSTimer *callSecurityTimerContact;

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

-(DCallingWIFIAppDelegate *)appDelegate{
    return (DCallingWIFIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - View lifecycle

-(void)onSignInExternalClick:(id)sender {
    //LinphoneManager* lLinphoneMgr = [LinphoneManager instance];
    //NSLog(@"internet %u , ",lLinphoneMgr.connectivity);
    NSLog(@"%hhu", linphone_core_is_network_reachable([LinphoneManager getLc]));
    
   // if([self CheckNetwork] && checkConnectivity==1){
        checkConnectivity=2;
        PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
        NSLog(@"sip details %@ - %@ - %@", [mPref getUserSIPLogin], [mPref getUserSIPPass], [mPref getUserSIPProxy]);
        NSString *username = [mPref getUserSIPLogin];
        NSString *password = [mPref getUserSIPPass];
        NSString *domain = [mPref getUserSIPProxy];
        NSString *token = [mPref getToken];
        if(username.length==0){
            [self setSIPUserPrefrences:token];
        }
    
        NSMutableString *errors = [NSMutableString string];
        if ([username length] == 0) {
        
            [errors appendString:[NSString stringWithFormat:NSLocalizedString(@"Please enter a username.\n", nil)]];
        }
    
        if ([domain length] == 0) {
            [errors appendString:[NSString stringWithFormat:NSLocalizedString(@"Please enter a domain.\n", nil)]];
        }
    
        if([errors length]) {
        /*UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Check error(s)",nil)
         message:[errors substringWithRange:NSMakeRange(0, [errors length] - 1)]
         delegate:nil
         cancelButtonTitle:NSLocalizedString(@"Continue",nil)
         otherButtonTitles:nil,nil];
         [errorView show];
         [errorView release];*/
        } else {
            //[self.waitView setHidden:false];
            //[self addProxyConfig:username password:password domain:domain server:nil];
            [self addProxyConfig:username password:password domain:domain];
        }
    /*}
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"]
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }*/
}

- (void)addProxyConfig:(NSString*)username password:(NSString*)password domain:(NSString*)domain {
    LinphoneCore* lc = [LinphoneManager getLc];
	LinphoneProxyConfig* proxyCfg = linphone_core_create_proxy_config(lc);
    
    char normalizedUserName[256];
    linphone_proxy_config_normalize_number(proxyCfg, [username cStringUsingEncoding:[NSString defaultCStringEncoding]], normalizedUserName, sizeof(normalizedUserName));
    
    const char* identity = linphone_proxy_config_get_identity(proxyCfg);
    if( !identity || !*identity ) identity = "sip:user@example.com";
    
    LinphoneAddress* linphoneAddress = linphone_address_new(identity);
    linphone_address_set_username(linphoneAddress, normalizedUserName);
    
    if( domain && [domain length] != 0) {
        // when the domain is specified (for external login), take it as the server address
        linphone_proxy_config_set_server_addr(proxyCfg, [domain UTF8String]);
        linphone_address_set_domain(linphoneAddress, [domain UTF8String]);
    }
    
    identity = linphone_address_as_string_uri_only(linphoneAddress);
    
    linphone_proxy_config_set_identity(proxyCfg, identity);
    
    
    
    LinphoneAuthInfo* info = linphone_auth_info_new([username UTF8String]
													, NULL, [password UTF8String]
													, NULL
													, NULL
													,linphone_proxy_config_get_domain(proxyCfg));
    
    [self setDefaultSettings:proxyCfg];
    
    [self clearProxyConfig];
    
    linphone_proxy_config_enable_register(proxyCfg, true);
	linphone_core_add_auth_info(lc, info);
    linphone_core_add_proxy_config(lc, proxyCfg);
	linphone_core_set_default_proxy(lc, proxyCfg);
}

- (void)setDefaultSettings:(LinphoneProxyConfig*)proxyCfg {
    /*BOOL pushnotification = [[LinphoneManager instance] lpConfigBoolForKey:@"push_notification" forSection:@"wizard"];
     [[LinphoneManager instance] lpConfigSetBool:pushnotification forKey:@"pushnotification_preference"];
     if(pushnotification) {
     [[LinphoneManager instance] addPushTokenToProxyConfig:proxyCfg];
     }
     int expires = [[LinphoneManager instance] lpConfigIntForKey:@"expires" forSection:@"wizard"];
     linphone_proxy_config_expires(proxyCfg, expires);
     
     NSString* transport = [[LinphoneManager instance] lpConfigStringForKey:@"transport" forSection:@"wizard"];
     LinphoneCore *lc = [LinphoneManager getLc];
     LCSipTransports transportValue={0};
     if (transport!=nil) {
     if (linphone_core_get_sip_transports(lc, &transportValue)) {
     [LinphoneLogger logc:LinphoneLoggerError format:"cannot get current transport"];
     }
     // Only one port can be set at one time, the others's value is 0
     if ([transport isEqualToString:@"tcp"]) {
     transportValue.tcp_port=transportValue.tcp_port|transportValue.udp_port|transportValue.tls_port;
     transportValue.udp_port=0;
     transportValue.tls_port=0;
     } else if ([transport isEqualToString:@"udp"]){
     transportValue.udp_port=transportValue.tcp_port|transportValue.udp_port|transportValue.tls_port;
     transportValue.tcp_port=0;
     transportValue.tls_port=0;
     } else if ([transport isEqualToString:@"tls"]){
     transportValue.tls_port=transportValue.tcp_port|transportValue.udp_port|transportValue.tls_port;
     transportValue.tcp_port=0;
     transportValue.udp_port=0;
     } else {
     [LinphoneLogger logc:LinphoneLoggerError format:"unexpected transport [%s]",[transport cStringUsingEncoding:[NSString defaultCStringEncoding]]];
     }
     if (linphone_core_set_sip_transports(lc, &transportValue)) {
     [LinphoneLogger logc:LinphoneLoggerError format:"cannot set transport"];
     }
     }
     
     NSString* sharing_server = [[LinphoneManager instance] lpConfigStringForKey:@"sharing_server" forSection:@"wizard"];
     [[LinphoneManager instance] lpConfigSetString:sharing_server forKey:@"sharing_server_preference"];
     
     BOOL ice = [[LinphoneManager instance] lpConfigBoolForKey:@"ice" forSection:@"wizard"];
     [[LinphoneManager instance] lpConfigSetBool:ice forKey:@"ice_preference"];
     
     NSString* stun = [[LinphoneManager instance] lpConfigStringForKey:@"stun" forSection:@"wizard"];
     [[LinphoneManager instance] lpConfigSetString:stun forKey:@"stun_preference"];
     
     if ([stun length] > 0){
     linphone_core_set_stun_server(lc, [stun UTF8String]);
     if(ice) {
     linphone_core_set_firewall_policy(lc, LinphonePolicyUseIce);
     } else {
     linphone_core_set_firewall_policy(lc, LinphonePolicyUseStun);
     }
     } else {
     linphone_core_set_stun_server(lc, NULL);
     linphone_core_set_firewall_policy(lc, LinphonePolicyNoFirewall);
     }*/
    
    LinphoneManager* lm = [LinphoneManager instance];
    
    BOOL pushnotification = [lm lpConfigBoolForKey:@"pushnotification_preference"];
    if(pushnotification) {
        [lm addPushTokenToProxyConfig:proxyCfg];
    }
}

- (void)clearProxyConfig {
	linphone_core_clear_proxy_config([LinphoneManager getLc]);
	linphone_core_clear_all_auth_info([LinphoneManager getLc]);
}


- (void)viewDidLoad
{
    
    mVal = 0;
    //NSLog(@"%d", stDr);
    [picker.view setFrame:CGRectMake(0, 0, 0, 0)];
    [self getAddressBook];
    contactTab.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_title"];
    [super viewDidLoad];
    
    /*NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"version %@, %@, %@",appDisplayName, majorVersion, minorVersion );*/
    //[self performSelectorInBackground:@selector(schedule) withObject:nil];
    // Do any additional setup after loading the view from its nib.
    rect=1;
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        UIImage *selectedImg = [UIImage imageNamed:@"tabbar__kontakte.png"];
        UIImage *unSelectedImg = [UIImage imageNamed:@"tabbar__kontakte_active.png"];
        
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unSelectedImg = [unSelectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = unSelectedImg;
        self.tabBarItem.image = selectedImg;
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_title"] image:selectedImg selectedImage:unSelectedImg];
        self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    }
    else
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__kontakte_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__kontakte.png"]];
    checkConnectivity = 1;
    [self onSignInExternalClick:self];
    LinphoneCoreSettingsStore *settingsCore = [[[LinphoneCoreSettingsStore alloc]init]autorelease];
    [settingsCore synchronize];
    
}

- (void) schedule {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    timerSim = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self  selector:@selector(tidklick) userInfo:nil repeats:YES];
    
    [runLoop run];
    [pool release];
}

-(void) tidklick
{
    BOOL statusNew=FALSE;  
    //NSLog(@"Mobile Network Code (MNC):");
    networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    //NSLog(@"Mobile Network Code (MNC):");
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *carrierName = [carrier carrierName];
    //[preferences setToken:nil];
    if (mnc != nil){
        //NSLog(@"Mobile Network Code (MNC): %@", mnc);
        NSString *oldMNC = [preferences getMNC];
        NSString *oldMCC = [preferences getMCC];
        if([oldMNC isEqualToString:mnc] || [oldMCC isEqualToString:mcc]){
        }
        else {
            statusNew = TRUE;
            
            [preferences setToken:nil];
            [preferences setMCC:nil];
            [preferences setMNC:nil];
            [preferences setCarrier:nil];
            [preferences setMCC:mcc];
            [preferences setMNC:mnc];
            [preferences setCarrier:carrierName];
            [preferences setCallerBox:nil];
        }
    }
    // return statusNew;
}

- (void) updateCreditCon {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self  selector:@selector(getCreditCon) userInfo:nil repeats:NO];
    
    [runLoop run];
    [pool release];
}

-(void) getCreditCon
{
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] init];
    [mGetCrHandler getCredit];
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
    rect=0;
    [super viewDidUnload];
    
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //[self performSelectorInBackground:@selector(updateCreditCon) withObject:nil];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeBottom;
        
    }
    BOOL internetStatus = [self CheckNetwork];
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    NSString *token = [mPref getToken];
    BOOL sts = [mPref getCallingStatus];
    if(sts == TRUE && internetStatus==TRUE){
        /*DataModelRecent *mDataM = [[DataModelRecent alloc]autorelease];
        [mDataM stopTimer];
        //NSLog(@"release timer");*/
        //mVal=0;
        //[self performSelectorInBackground:@selector(updateCreditCon) withObject:nil];
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
    
    if(internetStatus == FALSE && ![[mPref getInternetVal] isEqualToString:@"CONTACT"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] 
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"] 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [mPref setInternetVal:@"CONTACT"];
    mVal=0;
    [self.view reloadInputViews];
    contactTab = [[UITabBarItem alloc]initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_title"] image:nil tag:100];
    [contactTab setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__kontakte_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__kontakte.png"]];
    //rect=1;
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent=NO;
        self.wantsFullScreenLayout = YES;
    }
    
    // Set callQualityTimerContact
	callQualityTimerContact = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(callQualityUpdate)
                                                      userInfo:nil
                                                       repeats:YES];
    
    // Set callQualityTimer
	callSecurityTimerContact = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(callSecurityUpdate)
                                                       userInfo:nil
                                                        repeats:YES];
    
    // Set observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationUpdate:)
                                                 name:kLinphoneRegistrationUpdate
                                               object:nil];
    
    
    [callQualityImage setHidden: true];
    [callSecurityImage setHidden: true];
    
    // Update to default state
    LinphoneProxyConfig* config = NULL;
    if([LinphoneManager isLcReady])
        linphone_core_get_default_proxy([LinphoneManager getLc], &config);
    [self proxyConfigUpdate: config];
   
    /*if([self CheckNetwork] && checkConnectivity==1){
        [self onSignInExternalClick:self];
    }*/
    //picker.navigationController.topViewController.navigationItem.rightBarButtonItem = nil;
}

-(BOOL)CheckNetwork   {
    NSError *error = nil;
    BOOL internetStatus = TRUE;
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com"];
    NSURLRequest* request = [NSURLRequest requestWithURL: scriptUrl                                              cachePolicy: NSURLRequestReloadIgnoringCacheData                                          timeoutInterval:0.5];
    //NSURLRequest *request=[NSURLRequest requestWithURL:scriptUrl];     

    NSURLResponse* response;
    NSData* myData = [NSURLConnection sendSynchronousRequest:request 
                                           returningResponse:&response
                                                       error:&error];   
    int vari = (int)[error code];
    //NSLog(@"slow12 %d", vari);
    
    if ( myData != nil  && [error code] == 0 )
        internetStatus = TRUE;
    else if(vari ==-1009 || vari==-1004){
        //NSLog(@"slow %d", [error code]);
        internetStatus = FALSE;
        // mVal=2;
    }
    else
        internetStatus = TRUE;
    return internetStatus;
}


-(void) getAddressBook{
    //PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    picker =   [[ABPeoplePickerNavigationController alloc] init];
    //picker.navigationBar.tintColor = [UIColor colorWithRed:33.0f/255.0f green:54.0f/255.0f blue:63.0f/255.0f alpha:0.20f];

    picker.peoplePickerDelegate = self;
    picker.delegate=self;
    //picker.navigationItem.rightBarButtonItem=nil;
    [picker setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]]];
    rect=2;
    /* // start comments for header background image change
     CGSize result = [[UIScreen mainScreen] bounds].size;
     CGFloat scale = [UIScreen mainScreen].scale;
     result = CGSizeMake(result.width * scale, result.height * scale);
     UIImage *navBarImg = nil;
     if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
     navBarImg = [UIImage imageNamed:@"tabp_left_ios7.png"];
     }
     else if (result.height==480){
     navBarImg = [UIImage imageNamed:@"topbar_more.png"];
     
     }
     else{
     navBarImg = [UIImage imageNamed:@"topbar_background_mehr.png"];
     }
     picker.topViewController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
     [picker.topViewController.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
     //end comments */
    picker.topViewController.navigationItem.leftBarButtonItem=nil;
    [self.view addSubview:picker.view];
    //[self.navigationController presentModalViewController:picker animated:YES];
    //[self.navigationController pushViewController:picker animated:NO];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //NSLog(@"%f-- %d", version, [mPref getViewSt]);
     PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    //NSLog(@"cd %2f-- %2f", picker.view.frame.origin.y, viewController.view.frame.origin.x);
    
    if ([navigationController.viewControllers indexOfObject:viewController] == 0) {
        
        viewController.navigationItem.rightBarButtonItem = nil;
    }
    
    //[mPref setViewSt:NO];
    //NSLog(@"val %d", rect);
    if([mPref getViewSt]==NO && version > 5.9 && result.height != 1136){
        //[mPref setViewSt:YES];
        [picker.view setFrame:CGRectMake(0, -1, 320, 480)];
    }
    
    else if([mPref getViewSt]==YES && version >= 7.0 && result.height == 960){
        //[mPref setViewSt:YES];
        [picker.view setFrame:CGRectMake(0, 0, 320, 480)];
    }
    else if([mPref getViewSt]==NO && version >= 7.0 && result.height == 960){
        //[mPref setViewSt:YES];
        [picker.view setFrame:CGRectMake(0, 40, 320, 480)];
    }
    
    else if([mPref getViewSt]==YES && version >= 7.0 && result.height == 1136){
        //[mPref setViewSt:YES];
        [picker.view setFrame:CGRectMake(0, 0, 320, 480)];
    }
    else if([mPref getViewSt]==NO && version >= 7.0 && result.height == 1136){
        //[mPref setViewSt:YES];
        [picker.view setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    else if([mPref getViewSt]==YES && version > 5.9 && result.height != 1136){
        //[mPref setViewSt:YES];
        [picker.view setFrame:CGRectMake(0, -20, 320, 480)];
    }
    else if([mPref getViewSt]==NO && version > 5.9 && result.height != 1136){
        //[mPref setViewSt:YES];
        [picker.view setFrame:CGRectMake(0, -20, 320, 480)];
    }
    
    else if ([mPref getViewSt]==NO && version > 5.9 && result.height == 1136){
        //[mPref setViewSt:YES];
        [picker.view setFrame:CGRectMake(0, -20, 320, 520)];
    }
    else if ([mPref getViewSt]==YES  && version > 5.9 && result.height == 1136){
        [picker.view setFrame:CGRectMake(0, 0, 320, 520)];
    }
    else if ([mPref getViewSt]==YES && rect==1 && version < 5.9 && result.height != 1136){
        [picker.view setFrame:CGRectMake(0, -20, 320, 520)];
    }
    
    else{
        [picker.view setFrame:CGRectMake(0, 0, 320, 420)];
    }
    rect=0;
    //viewController.navigationItem.rightBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// custom code

@synthesize contactNames;
@synthesize contactIDs;
@synthesize callerid;




- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker {
    peoplePicker.navigationItem.rightBarButtonItem = nil;
    
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
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
        return NO;
    }
    // here we will add the callLog
    //if(property == kABPersonPhoneProperty){
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    CFStringRef phone = ABMultiValueCopyValueAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifier)); // either put zero or identifier.
    
    NSString *myPhone = (NSString *) phone;
    // ABMutableMultiValueRef multi1 = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *first = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if([first length] == 0){
        first = (NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        if ([first length] == 0) {
            first = @"";
        }
        
    }
    //ABMutableMultiValueRef multi2 = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *last = (NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty);
    if([last length] == 0)
        last =@"";
    
    // for Mobile label
    
    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifier));
    NSString *phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
    //CFRelease(locLabel);
    NSLog(@"  - %@",  phoneLabel);
    
    if([phoneLabel length] == 0)
        phoneLabel =@"mobile";
    
    //NSLog(@"phone numbner %@", myPhone);
    AddressBookHandler *mAdd = [[AddressBookHandler alloc]init];
    NSString *myPhoneNo = [mAdd trimWhiteSpaceNotZero:myPhone];
    NSString *trim = [mAdd trimWhiteSpace:myPhone];
    NSLog(@"phone numbner %@ %@ ", myPhone, trim);
    NSString *fullName = [first stringByAppendingFormat:@" %@", last];
    NSArray *userData2;
    userData2 = [[NSArray alloc] initWithObjects:first,last,myPhoneNo,phoneLabel,@"6", nil];
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    [sqliteDB saveCallLog:userData2];
    FavViewHandler *mFav = [[FavViewHandler alloc]init];
    BOOL checkNum = [mFav checkPrefixStr:myPhoneNo];
    if(!checkNum){
        myPhoneNo = [mFav convertNumber:myPhoneNo];
        //NSLog(@"converted Number %@", myPhoneNo);
    }
    if(linphone_core_is_network_reachable([LinphoneManager getLc]) && [myPhoneNo length]>2)
        [self call:myPhoneNo:fullName];
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"]
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [userData2 release];
    [mFav release];
    // commet for sip calling prashant
    /*DataModelRecent *mCalling = [[DataModelRecent alloc]init];
     [mCalling callingMethod:first :last :phoneLabel :myPhoneNo :trim:self];
     */
    mVal = 1;
    // [self viewWillAppear:YES];
    //personViewController.navigationItem.rightBarButtonItem=nil;
    return NO;
}



//add this fuction for reduce Wanrning by Prashant 

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    //[peoplePicker dismissViewControllerAnimated:NO completion:nil];
    
    ABAddressBookRef addressBook = ABAddressBookCreate(); // this will open the AddressBook of the iPhone
    CFErrorRef error             = NULL;
    
    //peoplePicker.editing = YES;
    //ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    ABPersonViewController *personController = [[ABPersonViewController alloc] init];
    //peoplePicker.navigationBar.tintColor = [UIColor colorWithRed:33.0f/255.0f green:54.0f/255.0f blue:63.0f/255.0f alpha:0.20f];

    personController.addressBook                       = addressBook; // this passes the reference of the Address Book
    personController.displayedPerson                   = person; // this sets the person reference
    personController.allowsEditing                     = YES; // this allows the user to edit the details
    personController.allowsActions=NO;
    personController.personViewDelegate                = self;
    personController.shouldShowLinkedPeople=YES;
    personController.navigationItem.rightBarButtonItem = [self editButtonItem]; // this will add the inbuilt Edit button to the view
    //peoplePicker.navigationItem.rightBarButtonItem=[self editButtonItem];
    //peoplePicker.predicateForSelectionOfPerson = [NSPredicate predicateWithFormat:@"%K.@count > 0"];

    /**
     * This does not work
     */
    /*ABRecordSetValue(person, kABPersonPhoneProperty, multi, &error);
     ABRecordSetValue(person, kABPersonFirstNameProperty, multi, &error);
     ABRecordSetValue(person, kABPersonLastNameProperty, multi, &error);
     ABRecordSetValue(person, kABPersonOrganizationProperty, multi, &error);*/
    ABAddressBookSave(addressBook, &error);
    
    CFRelease(addressBook);
    
    personController.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    
    double currSysVer = [[[UIDevice currentDevice] systemVersion]floatValue];
    if(currSysVer >= 8.0){
        personController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ClosePeoplePicker)];
        
        UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:personController];
        //[self presentModalViewController:ctrl animated:NO];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self presentModalViewController:ctrl animated:YES];
            //[peoplePicker pushViewController:personController animated:YES];
        });
    }
    else{
        [peoplePicker pushViewController:personController animated:YES];
    }
    // this displays the contact with the details and presents with an Edit button
    //[peoplePicker pushViewController:personController animated:YES];
    
    [personController release];
    
    return NO;
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue {
    //NSLog(@"peoplePickerNavigationController");
    
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
        return NO;
    }
    // here we will add the callLog
    //if(property == kABPersonPhoneProperty){
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    CFStringRef phone = ABMultiValueCopyValueAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifierForValue)); // either put zero or identifier.
    
    NSString *myPhone = (NSString *) phone;
    // ABMutableMultiValueRef multi1 = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *first = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if([first length] == 0){
        first = (NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        if ([first length] == 0) {
            first = @"";
        }
        
    }
    //ABMutableMultiValueRef multi2 = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *last = (NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty);
    if([last length] == 0)
        last =@"";
    
    // for Mobile label
    
    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifierForValue));
    NSString *phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
    //CFRelease(locLabel);
    NSLog(@"  - %@",  phoneLabel);
    
    if([phoneLabel length] == 0)
        phoneLabel =@"mobile";
    
    //NSLog(@"phone numbner %@", myPhone);
    AddressBookHandler *mAdd = [[AddressBookHandler alloc]init];
    NSString *myPhoneNo = [mAdd trimWhiteSpaceNotZero:myPhone];
    NSString *trim = [mAdd trimWhiteSpace:myPhone];
    NSLog(@"phone numbner %@ %@ ", myPhone, trim);
    NSString *fullName = [first stringByAppendingFormat:@" %@", last];
    NSArray *userData2;
    userData2 = [[NSArray alloc] initWithObjects:first,last,myPhoneNo,phoneLabel,@"6", nil];
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    [sqliteDB saveCallLog:userData2];
    FavViewHandler *mFav = [[FavViewHandler alloc]init];
    BOOL checkNum = [mFav checkPrefixStr:myPhoneNo];
    if(!checkNum){
        myPhoneNo = [mFav convertNumber:myPhoneNo];
        //NSLog(@"converted Number %@", myPhoneNo);
    }
    if(linphone_core_is_network_reachable([LinphoneManager getLc]) && [myPhoneNo length]>2)
        [self call:myPhoneNo:fullName];
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"]
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [userData2 release];
    [mFav release];
    // commet for sip calling prashant
    /*DataModelRecent *mCalling = [[DataModelRecent alloc]init];
    [mCalling callingMethod:first :last :phoneLabel :myPhoneNo :trim:self];
     */
    mVal = 1;
    // [self viewWillAppear:YES];
    //personViewController.navigationItem.rightBarButtonItem=nil;
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}

- (void)ClosePeoplePicker{
    [self dismissModalViewControllerAnimated:YES];
}


-(void)call : (NSString *)address : (NSString *)cName{
    // LinphoneManager *lm = [[LinphoneManager alloc]init];
    /*NSString *displayName = nil;
    ABRecordRef contact = [[[LinphoneManager instance] fastAddressBook] getContact:address];
    if(contact) {
        displayName = [FastAddressBook getContactDisplayName:contact];
    }*/
    //[[LinphoneManager instance] call:address displayName:displayName transfer:FALSE];
    //[self performSegueWithIdentifier:@"inCallScreen" sender:self];
    [self dismissModalViewControllerAnimated:YES];
    [[self appDelegate]setNumbers:address];
    if(![cName isEqualToString:@""])
        [[self appDelegate]setDName:cName];
    else
        [[self appDelegate]setDName:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inscreen:)   name:@"changeScreen"                                              object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeScreen" object:nil];
    
}

- (void)inscreen:(NSNotification*) notif {
   // KeypadViewController *controller = [[KeypadViewController alloc]init];
    //[controller callScreen];
    [[self appDelegate] setCheckVal:TRUE];
    tabBarview *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    [controller setSelectedIndex:3];
    [self.navigationController pushViewController:controller animated:NO];
    //[controller callScreen];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"CallScreen" object:nil];
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

- (void) setSIPUserPrefrences : (NSString *)authSessionToken{
    RestAPICaller *callTORestAPI = [[RestAPICaller alloc]init];
    NSData *restSIPDATAParser = [callTORestAPI getUserSIPAccount:authSessionToken];
    FlatrateXMLParser *flatrateXMLParser;
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithUserSIPAccount:self xmlData:restSIPDATAParser];
}

-(void)userSIPAccountParserDidComplete:(NSMutableString *) result{
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    NSString *myString = [NSString stringWithString:result];
    NSLog(@"strng : %@", myString);
    NSString *myString2 = [myString stringByReplacingOccurrencesOfString:
                           @"POST" withString: @""];
    NSString *myString3 = [myString2 stringByReplacingOccurrencesOfString:
                           @"close" withString: @""];
    NSString *myString4 = [myString3 stringByReplacingOccurrencesOfString:
                           @"\n" withString: @""];
    
    NSLog(@"strng 4: %@", myString4);
    
    NSString *status1=@"";
    //NSString *credit=@"";
    NSString *username=@"";
    NSString *password=@"";
    NSString *domain=@"";
    if([myString4 length] > 10){
        NSArray *personNames = [myString4 componentsSeparatedByString: @"//"];
        if([personNames count] > 2){
            status1 = [personNames objectAtIndex:0];
            //credit = [personNames objectAtIndex:1];
            username = [personNames objectAtIndex:1];
            password = [personNames objectAtIndex:2];
            domain = [personNames objectAtIndex:3];
        }
    }
    NSRange textRange;
    textRange =[result rangeOfString:@"success"];
    if(textRange.location != NSNotFound){
        
        [mPref setUserSIPLogin:username];
        [mPref setUserSIPPass:password];
        [mPref setUserSIPProxy:domain];
        //[self registerDefaultsFromSettingsBundle:domain:username:password];
        if([[mPref getUserSIPLogin] length]>2)
            [self onSignInExternalClick:self];
    }
    else {
        NSLog(@"There is error : not identified token");
        NSString *cid = [mPref getCallerID];
        [self checkAuthToken:cid];
    }
    
}

-(void)checkAuthToken:(NSString *)AuthToken{
    RestAPICaller *restApiCaller = [[RestAPICaller alloc]init];
    NSData *restData = [restApiCaller getAuthUser:AuthToken];
    FlatrateXMLParser *flatrateXMLParser;
    NSLog(@"%d", (int)[restData length]);
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithAuthSessionDelegate:self xmlData:restData];
    //[restData release];
}

-(void)authSessionParserDidComplete:(NSMutableString *) result {
    
    // NSLog(@"######## in AuthSessionParseDidComplete");
    
    // NSLog(@"Hello AuthSession - %@",result);
    NSString *myString = [NSString stringWithString:result];
    NSRange range = NSMakeRange (25, 32);
    
    NSString *authSessionToken = [myString substringWithRange:range];
    //AddressBookHandler *mAdd = [[AddressBookHandler alloc]autorelease];
    //NSString *trNumber1 = [mAdd trimWhiteSpace:oNumber];
    //NSLog(@"token :- %@", [myString substringWithRange:range]);
    //[activityIndicator stopAnimating];
    
    // read token from xml and save to preferences
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    //NSLog(@"TOken %@", [preferences getToken]);
    if(![[preferences getToken] isEqualToString:authSessionToken]){
        [preferences setToken:authSessionToken];
        /*if([preferences getRoaming]==YES){
         alertValues=567;
         NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"];
         NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"];
         NSString *msgText  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SMS_CALLING"];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SMS_CALLING_TITLE"] message:msgText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
         //[[alert viewWithTag:1] removeFromSuperview];
         //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
         [alert show];
         [alert release];
         }*/
        if([[preferences getUserSIPLogin] length]>2)
            [self onSignInExternalClick:self];
        
    }
}

- (void)registrationUpdate: (NSNotification*) notif {
    LinphoneProxyConfig* config = NULL;
    linphone_core_get_default_proxy([LinphoneManager getLc], &config);
    [self proxyConfigUpdate:config];
}


#pragma mark -

- (void)proxyConfigUpdate: (LinphoneProxyConfig*) config {
    LinphoneRegistrationState state;
    NSString* message = nil;
    //UIImage* image = nil;
    
    if (config == NULL) {
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
    /*switch(state) {
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
    }*/
    NSLog(@"REG contact view %@ ", message);
    [registrationStateLabel setText:message];
    //[registrationStateImage setImage:image];
    
    PreferencesHandler *mPref = [[[PreferencesHandler alloc]init]autorelease];
    [mPref setRegisterSIP:message];
    /*if([message isEqualToString:@"Registration failed"] && [[mPref getUserSIPLogin]length]>2)
        [self onSignInExternalClick:self];*/
    
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
        if(securitySheet) {
            [securitySheet dismissWithClickedButtonIndex:securitySheet.destructiveButtonIndex animated:TRUE];
        }
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


#pragma mark - Action Functions

- (IBAction)doSecurityClick:(id)sender {
    if([LinphoneManager isLcReady] && linphone_core_get_calls_nb([LinphoneManager getLc])) {
        LinphoneCall *call = linphone_core_get_current_call([LinphoneManager getLc]);
        if(call != NULL) {
            LinphoneMediaEncryption enc = linphone_call_params_get_media_encryption(linphone_call_get_current_params(call));
            if(enc == LinphoneMediaEncryptionZRTP) {
                bool valid = linphone_call_get_authentication_token_verified(call);
                NSString *message = nil;
                if(valid) {
                    message = NSLocalizedString(@"Remove trust in the peer?",nil);
                } else {
                    message = [NSString stringWithFormat:NSLocalizedString(@"Confirm the following SAS with the peer:\n%s",nil),
                               linphone_call_get_authentication_token(call)];
                }
                if( securitySheet == nil ){
                    securitySheet = [[DTActionSheet alloc] initWithTitle:message];
                    //[securitySheet setDelegate:self];
                    [securitySheet addButtonWithTitle:NSLocalizedString(@"Ok",nil) block:^(){
                        linphone_call_set_authentication_token_verified(call, !valid);
                        [securitySheet release];
                        securitySheet = nil;
                    }];
                    
                    [securitySheet addDestructiveButtonWithTitle:NSLocalizedString(@"Cancel",nil) block:^(){
                        [securitySheet release];
                        securitySheet = nil;
                    }];
                    //[securitySheet showInView:[PhoneMainView instance].view];
                }
            }
        }
    }
}

/*
 #pragma mark - TPMultiLayoutViewController Functions
 
 - (NSDictionary*)attributesForView:(UIView*)view {
 NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
 
 [attributes setObject:[NSValue valueWithCGRect:view.frame] forKey:@"frame"];
 [attributes setObject:[NSValue valueWithCGRect:view.bounds] forKey:@"bounds"];
 [attributes setObject:[NSNumber numberWithInteger:view.autoresizingMask] forKey:@"autoresizingMask"];
 
 return attributes;
 }
 
 - (void)applyAttributes:(NSDictionary*)attributes toView:(UIView*)view {
 view.frame = [[attributes objectForKey:@"frame"] CGRectValue];
 view.bounds = [[attributes objectForKey:@"bounds"] CGRectValue];
 view.autoresizingMask = [[attributes objectForKey:@"autoresizingMask"] integerValue];
 }
 
 */

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneRegistrationUpdate
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneRegistrationUpdate
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"changeScreen"
                                                  object:nil];
    
    if(callQualityTimerContact != nil) {
        [callQualityTimerContact invalidate];
        callQualityTimerContact = nil;
    }
    if(callSecurityTimerContact != nil) {
        [callSecurityTimerContact invalidate];
        callSecurityTimerContact = nil;
    }
}


-(void)dealloc{
    //[mCallWebview release];
    rect=0;
    [picker.view release];
    [registrationStateImage release];
    [registrationStateLabel release];
    [callQualityImage release];
    [callSecurityImage release];
    [callSecurityButton release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [callQualityTimerContact invalidate];
    [callQualityTimerContact release];
    [callSecurityTimerContact invalidate];
    [callSecurityTimerContact release];
    [picker release];
    [super dealloc];
}

@end
