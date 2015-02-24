//
//  AboutViewController.m
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

#import "AboutViewController.h"
#import "PreferencesHandler.h"
#import "DCallingWIFIAppDelegate.h"
#import "LinphoneManager.h"
#import "tabBarview.h"

@implementation AboutViewController

@synthesize tokenInt;

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

- (void)viewDidLoad
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    if(result.height == 1136) {
        [self foriPhoneFiveDraw];
    }
    CALayer *layer = telBTN.layer;
    layer.backgroundColor=[[UIColor clearColor] CGColor];
     layer.borderColor =[[UIColor clearColor] CGColor];
     layer.cornerRadius = 8.0f;
     layer.borderWidth = 1.0f;
    
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIImage *tImage = nil;
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0){
        /*self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent=NO;
        self.wantsFullScreenLayout = YES;*/
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
    //[tImage release];
    [versionNo setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    [versionNo setText:[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    [comapnyNameLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    comapnyNameLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_address_comp_name"];
    [address1Lbl setFont:[UIFont fontWithName:@"Arial" size:15]];
    address1Lbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_address1"];
    [address2Lbl setFont:[UIFont fontWithName:@"Arial" size:15]];
    address2Lbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_address2"];
    [countryNameLbl setFont:[UIFont fontWithName:@"Arial" size:15]];
    countryNameLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_country"];
    [telephoneLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
    telephoneLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_tel"];
    [faxLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
    faxLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_fax"];
    [emailLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
    emailLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_email"];
    
    tvGNU.dataDetectorTypes = UIDataDetectorTypeAll;
    tvGNU.layer.borderColor = [[UIColor redColor] CGColor];
    tvGNU.layer.borderWidth = 1.0;
    tvGNU.layer.cornerRadius = 8;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

-(void) viewWillAppear:(BOOL)animated{
    PreferencesHandler *mPref = [[PreferencesHandler alloc]autorelease];
    tokenInt=0;
    NSString *token = [mPref getToken];
    //NSLog(@"google : %@", [mPref getMNC]);
    if((token == NULL) && (token == nil)){
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    }
    [super viewWillAppear:animated];
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

-(IBAction)callToNumber:(id)sender{
    
    NSString *textFirst  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"HOTLINE_TEXT_POPUP"];
    //NSString *textSecond  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES"];
    NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"HOTLINE_BUTTON_WIFI"];
    NSString *doNotButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"HOTLINE_BUTTON_GSM"];
    NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"HOTLINE_BUTTON_CANCEL"];
    tokenInt=101;
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    UIAlertView *alert = nil;
    if(version >= 7.0 )
        alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"HOTLINE_POPUP_TITLE"] message:textFirst delegate:self cancelButtonTitle:nil otherButtonTitles:OKButton,doNotButton,cancelButton,  nil];
    else{
        tokenInt=201;
        alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"HOTLINE_POPUP_TITLE"] message:textFirst delegate:self cancelButtonTitle:@"" otherButtonTitles:OKButton,doNotButton,cancelButton,  nil];
    }
    [[alert viewWithTag:1] removeFromSuperview];
    //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
    [alert show];
    [alert release];
    
    
}

-(void)throughWifiCalling{
    if(linphone_core_is_network_reachable([LinphoneManager getLc]))
        [self call:@"+4922117739610":@"Hotline Support"];
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"]
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
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
    [[self appDelegate]setNumbers:address];
    if(![cName isEqualToString:@""])
        [[self appDelegate]setDName:cName];
    else
        [[self appDelegate]setDName:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inscreen:)   name:@"changeScreen"                                              object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeScreen" object:nil];
    
}

- (void)inscreen:(NSNotification*) notif {
    
    [[self appDelegate] setCheckVal:TRUE];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    tabBarview *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    [controller setSelectedIndex:3];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion: nil];
    
}

-(void)throughGSMCalling{
    
    PreferencesHandler *preferences = [[[PreferencesHandler alloc]init]autorelease];
    NSString *getPrefix = [preferences getDropBox];
    NSString *support = @"";
    if([getPrefix isEqualToString:@"+1"])
        support = @"0114922117739610";
    else
        support = @"+4922117739610";
    NSString *tel = [@"tel:" stringByAppendingFormat:@"%@",support];
    NSURL *URL = [NSURL URLWithString:tel];
    // [[UIApplication sharedApplication] openURL:URL];
    UIWebView *mCallWebview = [[UIWebView alloc] init]  ;
    [self.view addSubview:mCallWebview];
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:URL]];
}

-(IBAction)mailToNumber:(id)sender{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg2"]];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"support@dcalling.de", nil];
        [mailer setToRecipients:toRecipients];
        
        
        NSString *emailBody = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg3"];
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];
        
        [mailer release];
    }
    else
    {
        NSString *alertTitle = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"alert"];
        NSString *alertMsg = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg5"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && tokenInt ==101) {
        tokenInt =0;
        [self throughWifiCalling];
    }
    if (buttonIndex == 1 && tokenInt ==101) {
        tokenInt =0;
        [self throughGSMCalling];
    }
    if (buttonIndex == 2 && tokenInt ==101) {
        tokenInt =0;
        NSLog(@"No calling.. Cancel it");
    }
    if (buttonIndex == 1 && tokenInt ==201) {
        tokenInt =0;
        [self throughWifiCalling];
    }
    if (buttonIndex == 2 && tokenInt ==201) {
        tokenInt =0;
        [self throughGSMCalling];
    }
    if (buttonIndex == 3 && tokenInt ==201) {
        tokenInt =0;
        NSLog(@"No calling.. Cancel it");
    }
}

-(void)foriPhoneFiveDraw{
    //NSLog(@"iPhone 5 Resolution");
    CGRect frame = details.frame;
    frame.origin.y += 30;
    details.frame=frame;
    [self.view addSubview:details];
    CGRect frame2 = comapnyNameLbl.frame;
    frame2.origin.y += 30;
    comapnyNameLbl.frame=frame2;
    
    CGRect frame3 = address1Lbl.frame;
    frame3.origin.y += 30;
    address1Lbl.frame=frame3;
    
    CGRect frame4 = address2Lbl.frame;
    frame4.origin.y += 30;
    address2Lbl.frame=frame4;
    
    CGRect frame5 = countryNameLbl.frame;
    frame5.origin.y += 30;
    countryNameLbl.frame=frame5;
    
    CGRect frame6 = telephoneLbl.frame;
    frame6.origin.y += 30;
    telephoneLbl.frame=frame6;
    
    CGRect frame7 = faxLbl.frame;
    frame7.origin.y += 30;
    faxLbl.frame=frame7;
    
    CGRect frame8 = emailLbl.frame;
    frame8.origin.y += 30;
    emailLbl.frame=frame8;
    
    CGRect frame9 = emailBTN.frame;
    frame9.origin.y += 30;
    emailBTN.frame=frame9;
    
    CGRect frame10 = telBTN.frame;
    frame10.origin.y += 30;
    telBTN.frame=frame10;
    
    CGRect frame11 = versionNo.frame;
    frame11.origin.y += 20;
    versionNo.frame=frame11;
    CGRect frame14 = versionNo.frame;
    frame11.origin.x += 5;
    versionNo.frame=frame11;
    
    CGRect frame12 = faxBTN.frame;
    frame12.origin.y += 30;
    faxBTN.frame=frame12;
    
    CGRect frame15 = tvGNU.frame;
    frame15.origin.y += 40;
    tvGNU.frame=frame15;
    
    [self.view addSubview:comapnyNameLbl];
    [self.view addSubview:address1Lbl];
    [self.view addSubview:address2Lbl];
    [self.view addSubview:countryNameLbl];
    [self.view addSubview:telephoneLbl];
    [self.view addSubview:faxLbl];
    [self.view addSubview:emailLbl];
    [self.view addSubview:emailBTN];
    [self.view addSubview:faxBTN];
    [self.view addSubview:versionNo];
    [self.view addSubview:telBTN];
    //

}



@end
