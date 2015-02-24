//
//  MoreViewController.m
//  DCalling WiFi
//
//  Created by David C. Son on 17.01.12.
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

#import "MoreViewController.h"
#import "RestAPICaller.h"
#import "FlatrateXMLParser.h"
#import "getCreditHandler.h"
#import "DCallingWIFIAppDelegate.h"
#import "ContactsViewController.h"
#import "tabBarview.h"
#import "KeypadViewController.h"
#import "LinphoneManager.h"

@implementation MoreViewController
@synthesize tableViewCus, tokenInt, mVal;


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

#pragma mark - View lifecycle

-(DCallingWIFIAppDelegate *)appDelegate{
    return (DCallingWIFIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    /*CGRect frma = callReport.frame;
    frma.origin.x +=53;
    //frma.origin.y +=100;
    callReport.frame=frma;
    
    [callS addSubview:callReport];*/
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_background.png"]];
    [tempImageView setFrame:self.tableViewCus.frame]; 
    mVal=0;
    self.tableViewCus.backgroundView = tempImageView;
    [tempImageView release];
    //mPref = [[PreferencesHandler alloc] autorelease];
    [self navHeader];
    [self backgroundHeader];
    recharge.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_recharge"];
    [recharge setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    priceList.text=[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_price_list"];
    [priceList setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    //priceValue.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_price_list"];
    //priceValue.text = [mPref getCredit];
    [priceValue setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    priceDetails.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_details"];
    [priceDetails setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    callReport.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_callreport"];
    
    [callReport setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    callreportDetails.text =[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_details"];
    [callreportDetails setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    facebook.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_facebook"];
    [facebook setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    //fbBonus.text = @"";
   // smsLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Callerid_textview"];
    smsDetails.text =[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_details"];
    [smsDetails setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    emailLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"contact_email"];
    [emailLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    emailDetails.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_details"];
    [emailDetails setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    NSString *helpText = [[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_FAQ"] stringByAppendingFormat:@" / %@", [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_help"]];
    lblHelp.text = helpText;
    [lblHelp setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    helpDetails.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_details"];
    [helpDetails setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    NSString *aboutText = [[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_contact_title"] stringByAppendingFormat:@" / %@", [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_section_title_Three"]];
    lblAbout.text = aboutText;
    [lblAbout setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    abotDetails.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_details"];
    [abotDetails setFont:[UIFont fontWithName:@"ArialMT" size:17]];
  //  lblGTC.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Callerid_textview"];
    [lblGTC setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    gtcDetails.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_screen_details"];
    [gtcDetails setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    moreTab.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_title"];
    [lblCall setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    [hotLine setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    //self.title
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
   // self.navigationController.navigationBar.hidden = YES;  
   // [self performSelectorInBackground:@selector(updateCredit) withObject:nil];
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
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    ContactsViewController *mContactView = [[ContactsViewController alloc]autorelease];
    BOOL internetStatus = [mContactView CheckNetwork];
    mPref = [[PreferencesHandler alloc]init];
    [mPref setViewSt:YES];
    NSString *token = [mPref getToken];
    BOOL sts = [mPref getCallingStatus];
    [mPref setViewSt:YES];
    NSLog(@"VIEW: %d",[mPref getRoaming]);
    if(sts == TRUE && internetStatus){
        /*DataModelRecent *mDataM = [[DataModelRecent alloc]autorelease];
         [mDataM stopTimer];
         //NSLog(@"release timer");*/
        mVal=0;
        //[self performSelectorInBackground:@selector(updateCredit) withObject:nil];
        [mPref setCallingStatus:FALSE];
    }
    //NSLog(@"google : %@", [mPref getMNC]);
    if((token == NULL) && (token == nil)){
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_WARN"]
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_MSG"]
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        tokenInt = 22;*/
        //UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
       // [self.navigationController pushViewController:tab animated:YES];
        [self performSegueWithIdentifier:@"moretocallerid" sender:self];
        
    }
   if(internetStatus == FALSE && ![[mPref getInternetVal] isEqualToString:@"MORE"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] 
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"] 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [mPref setInternetVal:@"MORE"];
    label.text = @"";
    label.text = [mPref getCredit];
    priceValue.text = [mPref getCredit];
    [super viewWillAppear:YES];
}

- (void) updateCredit {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self  selector:@selector(getCredit) userInfo:nil repeats:NO];
    
    [runLoop run];
    [pool release];
}

-(void) getCredit
{
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] init];
    [mGetCrHandler getCredit];
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]init];
    priceValue.text = [mPrefs getCredit];
    label.text = [mPref getCredit];
    [self viewWillAppear:YES];
    [self.view setNeedsDisplay];
    //NSLog(@"More updatee");
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
    //[self setMakCall:nil];
    [self navHeader];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) backgroundHeader{
    //UIImage *tImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar_background_mehr" ofType:@"png"]];
    //CGRect frame = self.navigationController.navigationBar.frame;
    [self.navigationController.navigationBar addSubview:label];
    [self.navigationController.navigationBar addSubview:label2];
    
    //frame.origin.y+=20;
    //self.navigationController.navigationBar.frame=frame;
    /*CGRect frame2 = CGRectMake(0, 0, 320, 45);
    self.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_title"];
    //CGRect frame = CGRectMake(0, 0, [self.title sizeWithFont:[UIFont boldSystemFontOfSize:16.0]].width, 40);
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:tImage];
    [tempImageView setFrame:frame2];
    //[tImage drawAsPatternInRect:frame2];
    //[tImage drawInRect:frame2];
    CGRect frame = CGRectMake(118, 4, 93, 40);
    UILabel *label3 = [[UILabel alloc] initWithFrame:frame];
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont boldSystemFontOfSize:17.0];
    label3.textAlignment = UITextAlignmentCenter;
    [label3 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    //self.navigationItem.titleView = label;
    label3.text = self.title;
    
    //[self.navigationController.navigationBar insertSubview:imageV atIndex:0];
    [tempImageView addSubview:label];
    [tempImageView addSubview:label2];
    [tempImageView addSubview:label3];
    tempImageView.contentMode= UIViewContentModeScaleAspectFit;
    mNav.titleView=tempImageView;
    [self.navigationController.navigationBar setTintColor:[[UIColor alloc]initWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:0.0]];

    [label3 release];
    //UINavigationBar *navBarName = [[self navigationController] navigationBar];
    //[navBarName setBackgroundImage:tImage forBarMetrics:UIBarMetricsDefault];
   // [self.navigationController.navigationBar setBackgroundImage:tImage forBarMetrics:UIBarMetricsDefault];
    [tImage release];*/
}

-(void) navHeader{
    mPref = [[PreferencesHandler alloc] autorelease];    
   
    CGRect frame1 = CGRectMake(259, 4, 60, 24);
    label = [[[UILabel alloc] initWithFrame:frame1] autorelease];
    label.text = @"";
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.text = @"";
    label.text = [mPref getCredit];
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    CGRect frame2;
    if([language isEqualToString:@"tr"]){
         frame2 = CGRectMake(248, 21, 67, 21);
        label2 = [[[UILabel alloc] initWithFrame:frame2] autorelease];
        label2.textAlignment = UITextAlignmentCenter;
    }
    else {
        if([language isEqualToString:@"de"] && [[UIDevice currentDevice].systemVersion floatValue]>=7.0)
            frame2 = CGRectMake(215, 21, 85, 21);
            else
         frame2 = CGRectMake(215, 21, 100, 21);
        label2 = [[[UILabel alloc] initWithFrame:frame2] autorelease];
        label2.textAlignment = UITextAlignmentRight;
    }
   
    
    label2.backgroundColor = [UIColor clearColor];
    
    label2.textColor = [UIColor lightGrayColor];
    label2.text = @"";
    label2.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"recent_recharge_title"];
    [label2 setFont:[UIFont fontWithName:@"ArialMT" size:12]];
    //[self.navigationController.navigationBar addSubview:label]; 
    //[self.navigationController.navigationBar addSubview:label2];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //... code regarding other sections goes here
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *getPrefix = [preferences getDropBox];
    /*if (section == 4 && [getPrefix isEqualToString:@"+49"]) {// "1" is the section I want to hide
        [self forSwitchRoaming];
        return 2; // show no cells
    }
    if (section == 4 && ![getPrefix isEqualToString:@"+49"]) {// "1" is the section I want to hide
        [self forSwitchRoaming];
        return 1; // show no cells
    }*/
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return 2;
    }
    else if(section == 2){
        return 2;
    }
    else if(section == 3){
        return 3;
    }
    else
        return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    //NSString *getPrefix = [preferences getDropBox];
    //NSLog(@"%@ pre", getPrefix);
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.bounds.size.width, tableView.bounds.size.height)];
    if(section == 0){
              
        
    }
    else if(section == 1){
        UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero]autorelease] ;
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:20];
        headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
        
        
        headerLabel.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_section_title_One"]; // i.e. array element
        
        [v addSubview:headerLabel];
    }
    else if(section == 2){
        UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero]autorelease] ;
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:20];
        headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
        
        
        headerLabel.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_section_title_Two"]; // i.e. array element
        
        [v addSubview:headerLabel];
    }
    else if(section == 3){
        UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero]autorelease] ;
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:20];
        headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
        
        
        headerLabel.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_section_title_Three"]; // i.e. array element
        
        [v addSubview:headerLabel];
    }
    
    /*else if(section == 4 ){
        UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero]autorelease] ;
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:20];
        headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
        
        
        headerLabel.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_section_title_Four"]; // i.e. array element
        
        [v addSubview:headerLabel];
    }*/
    
    
    return v;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    //NSLog(@"%d--- %d", indexPath.section, indexPath.row);
    
    self.navigationController.navigationBar.hidden = NO;
    if (indexPath.section == 2) {
    switch (indexPath.row) {

        case 0:
        {
            MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg3"];
                controller.recipients = [NSArray arrayWithObjects: nil];
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];
            }
            break;
        }
        case 1:
        {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                
                mailer.mailComposeDelegate = self;
                
                [mailer setSubject:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg2"]];
                
                NSArray *toRecipients = [NSArray arrayWithObjects: nil];
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
            break;
        }
     }
        
    }
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Error");
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
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

-(IBAction)makeCallToSupport:(id)sender{
    /*PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    NSString *callerid = [preferences getCallerID];
    NSString *getPrefix = [preferences getDropBox];
    NSString *supportNumber = @"4922199999939";
    mFav = [[FavViewHandler alloc]init];
    NSString *getCountryCode = [mFav removedPlus:getPrefix];
    int prefixLen = [getCountryCode length];
    NSRange RangeOfDial = NSMakeRange (0, prefixLen);
    NSString *dialPrefix = [supportNumber substringWithRange:RangeOfDial];*/
    //if([getCountryCode isEqualToString:dialPrefix]){
    // start to add popup for hotline support by prashant khatri
    
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
    
    //end popup
    /* comment on 10 Sep 2014 by prashant
        NSString *support = @"+4922117739610";
        NSString *tel = [@"tel:" stringByAppendingFormat:@"%@",support];
        NSURL *URL = [NSURL URLWithString:tel];
       // [[UIApplication sharedApplication] openURL:URL];
        UIWebView *mCallWebview = [[UIWebView alloc] init]  ;
        [self.view addSubview:mCallWebview];
        [mCallWebview loadRequest:[NSURLRequest requestWithURL:URL]];*/
        
    /*}
    else {
        supportNumber = [@"+" stringByAppendingFormat:@"%@",supportNumber];
        RestAPICaller *rapi = [[RestAPICaller alloc]init];
        NSData *restAPIXML = [rapi getDialinXML:supportNumber :callerid :token];
        if(restAPIXML == NULL){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]  delegate:nil  cancelButtonTitle:@"OK"  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else {
            FlatrateXMLParser *flatrateXMLParser;
            flatrateXMLParser = [[FlatrateXMLParser alloc] initWithDCallingPostDelegate: self xmlData:restAPIXML];
        }
       
    }*/
   
    
   
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
    //[controller release];
    //[navigationController release];
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

-(void) dCallingParsePostDidComplete: (NSMutableString *) result{ // call by thread. in xmlParser class
    //NSLog(@"result: %@",result);
    
    NSString *myString = [result stringByReplacingOccurrencesOfString:
                          @"dialin" withString: @""];
    NSString *myString2 = [myString stringByReplacingOccurrencesOfString:
                           @"POST" withString: @""];
    NSString *myString3 = [myString2 stringByReplacingOccurrencesOfString:
                           @"\n" withString: @""];
    NSString *dialin = [myString3 stringByReplacingOccurrencesOfString:
                        @"success" withString: @""];
    
    //NSLog(@"hh %@",dialin);
    
    NSRange textRange;
    textRange = [result rangeOfString:@"success"];
    //NSLog(@"xml %@", result);
    if(textRange.location != NSNotFound){
        NSString *tel = [@"tel:" stringByAppendingFormat:@"%@",dialin];
        NSURL *URL = [NSURL URLWithString:tel];
        
        UIWebView *mCallWebview = [[UIWebView alloc] init]  ;
        [self.view addSubview:mCallWebview];
        [mCallWebview loadRequest:[NSURLRequest requestWithURL:URL]];
     
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg11"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg9"]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
        
    } 
    
}

-(void)forSwitchRoaming{
    switchRoaming =[[UISwitch alloc] initWithFrame:CGRectMake(225, 10, 79, 27)];
    mPref=[[PreferencesHandler alloc]init];
    switchRoaming.on = [mPref getRoaming];
    //NSLog(@"result: %d",[mPref getRoaming]);
    
    switchRoaming.tag=0;
    [switchRoaming addTarget:self action:@selector(switchSwitched:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
    [roamingcell addSubview:switchRoaming];
    [switchRoaming release];
    
}

- (IBAction)switchSwitched:(UISwitch*)sender {
    //NSLog(@"%d", sender.tag);
    mPref =[[PreferencesHandler alloc]init];
    //NSLog(@"result: %d",[mPref getRoaming]);
    if (sender.on) {
        
        switch (sender.tag) {
            case 0:
                [mPref setRoaming:YES];
                //[self viewWillAppear:YES];
                break;
            default:
                break;
        }
       
    }
    else{
        switch (sender.tag) {
            case 0:
                [mPref setRoaming:NO];
                //[self viewWillAppear:YES];
                break;          
                
            default:
                break;
        }
        // NSLog(@"Case of OFF %d", sender.tag);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && tokenInt ==22) {
        tokenInt =0;
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    }
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneRegistrationUpdate
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"changeScreen"
                                                  object:nil];
    
    
}

- (void)dealloc {
    //[label2 release];
    //[label release];
    [mPref release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
