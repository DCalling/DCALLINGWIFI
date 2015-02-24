//
//  RecentViewController.m
//  DCalling WiFi
//
//  Created by Prashant on 06/02/12.
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

#import "RecentViewController.h"
#import "PreferencesHandler.h"
#import "SQLiteDBHandler.h"
#import "ContactsViewController.h"
#import "FavViewHandler.h"
#import "getCreditHandler.h"
#import "DataModelRecent.h"
#import "DCallingWIFIAppDelegate.h"
#import "tabBarview.h"
#import "LinphoneManager.h"


@implementation RecentViewController

//@synthesize tableView;
@synthesize phoneNumbers, allPhoneFromAB, compareNumbers, namesFromAB;
@synthesize getMatchedPhone, getMatchedWithRecent, labels;

@synthesize tv;
@synthesize myRecent, dialNumberCount, myRecentCall, arrayNumbers, phoneLabels;

@synthesize name, last, myPhone, abName, myString;
@synthesize firstLastName, selectedDetails, userData, mVal, tokenInt, loopRun;

@synthesize callQualityImage, callSecurityButton, callSecurityImage, registrationStateImage, registrationStateLabel;

NSTimer *callQualityTimerRecent;
NSTimer *callSecurityTimerRecent;

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

- (void) viewforiosSeven{
    CGRect headFrame = headerImage.frame;
    CGRect titleTextFrame = topHeader.frame;
    CGRect topRightFrame = toprightHeader.frame;
    CGRect downRightFrame = topRightBottomHeader.frame;
    CGRect tableFrame = self.tv.frame;
    
    //CGRect tableFrame = self.tv.frame;
    headFrame.origin.y +=20;
    headerImage.frame = headFrame;
    
    titleTextFrame.origin.y+=20;
    topHeader.frame=titleTextFrame;
    
    topRightFrame.origin.y+=20;
    toprightHeader.frame=topRightFrame;
    
    downRightFrame.origin.y+=20;
    topRightBottomHeader.frame=downRightFrame;
    
    tableFrame.origin.y+=20;
    self.tv.frame=tableFrame;
   
}

#pragma mark - View lifecycle


-(UIImage *) getABImages:(NSString *)myPhoneStr{
    mAddr = [[AddressBookHandler alloc]init];
    userImage = [mAddr imageFetchFromAB:myPhoneStr];
    return userImage;
}

-(NSMutableArray *) myCompareData{
    arrayNumbers = [[NSMutableArray alloc ]init];
    SQLiteDBHandler *mSQLite = [[SQLiteDBHandler alloc]init];
    arrayNumbers = [mSQLite getCallLogRec];
    
    myRecentCall = [[NSMutableArray alloc]init];
    myRecentCall = [[mSQLite getCallLogRecNameDemo:arrayNumbers] retain];
    mVal=0;
    return myRecentCall;    
}

-(NSString *) currentDatetime{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss:SSS";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    NSString *date = [dateFormatter stringFromDate:now];
    [dateFormatter release];
    return date;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    topHeader.text=[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"recent_title"];
    [topHeader setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    
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
    recentTab.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"recent_tab"];
    [self performSelectorInBackground:@selector(updateLog) withObject:nil];    
    //[self myCompareData];
    mVal = 0;
   // PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
   // NSLog(@"%d - %d--%d - %d---%d - %d",[mPref getAllGermanProvider],[mPref getTmobile],[mPref getTelogic],[mPref getOTwo],[mPref getEPlus],[mPref getVodafone]);
    
    //float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version>=7.0){
        [self viewforiosSeven];
    }
    if(version >= 7.0){
        UIImage *selectedImg = [UIImage imageNamed:@"tabbar__verlauf.png"];
        UIImage *unSelectedImg = [UIImage imageNamed:@"tabbar__verlauf_active.png"];
        
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unSelectedImg = [unSelectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = unSelectedImg;
        self.tabBarItem.image = selectedImg;
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"recent_title"] image:selectedImg selectedImage:unSelectedImg];
    }
    else
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__verlauf_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__verlauf.png"]];
    // Do any additional setup after loading the view from its nib.
}

/*- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tv numberOfRowsInSection:0] - 1 inSection:0];
    [self.tv scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}*/

- (void)viewDidUnload
{
    [myRecentCall release];
    [arrayNumbers release];
    [myRecent release];
    [selectedDetails release];

    arrayNumbers=nil;
    selectedDetails=nil;
    myRecentCall=nil;
    myRecent=nil;
    [super viewDidUnload];    
}


-(void)viewWillAppear:(BOOL)animated{
            
    //[self performSelectorInBackground:@selector(updateCredit) withObject:nil];
    ContactsViewController *mContactView = [[ContactsViewController alloc]autorelease];
    BOOL internetStatus = [mContactView CheckNetwork];
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    [mPref setViewSt:YES];
    NSString *token = [mPref getToken];
    BOOL sts = [mPref getCallingStatus];
    [mPref setViewSt:YES];
    if(sts == TRUE && internetStatus==TRUE){
        /*DataModelRecent *mDataM = [[DataModelRecent alloc]autorelease];
        [mDataM stopTimer];
         NSLog(@"release timer");*/
        //mVal=0;
        loopRun=YES;
        //[self performSelectorInBackground:@selector(updateCredit) withObject:nil];
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
    if(internetStatus == FALSE && ![[mPref getInternetVal] isEqualToString:@"RECENT"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] 
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"] 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [mPref setInternetVal:@"RECENT"];

    self.navigationController.navigationBar.hidden = YES;
    [self myCompareData];
    mVal=0;
    
    
    
    // NSLog(@"2  - %@", [self currentDatetime]);
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
    toprightHeader.text = [mPrefs getCredit];
    recentTab = [[UITabBarItem alloc]initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"recent_tab"] image:nil tag:100];
    [recentTab setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__verlauf_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__verlauf.png"]];
    [super viewWillDisappear:YES];
    //mCallWebview.delegate=self;
    

    [[self tv] reloadData];
    
    // For SIP registration update
    
    callQualityTimerRecent = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(callQualityUpdate)
                                                         userInfo:nil
                                                          repeats:YES];
    
    // Set callQualityTimer
	callSecurityTimerRecent = [NSTimer scheduledTimerWithTimeInterval:1
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
}


- (void) updateLog {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:3600.0f target:self  selector:@selector(updateRecent) userInfo:nil repeats:YES];
    
    [runLoop run];
    [pool release];
}

-(void) updateRecent
{
    mAddr = [[AddressBookHandler alloc]autorelease];
    [mAddr updateCallLogdata];
    //NSLog(@"update recent");
}

- (void) updateCredit {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self  selector:@selector(getCredit) userInfo:nil repeats:NO];
    if(loopRun == YES){
        [runLoop run];
    }
    [pool release];
}

-(void) getCredit
{
    loopRun=NO;
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] init];
    [mGetCrHandler getCredit];
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]init];
    toprightHeader.text = [mPrefs getCredit];
    //NSLog(@"Recent updatee");
    //[mPrefs setCallingStatus:FALSE];
    //[self viewWillAppear:YES];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //[self myCompareData];
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    //return [[self myCompareData] count];
    [self myCompareData];
    return [arrayNumbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recentCells";
    [self myCompareData] ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [self drawFrame:cell];        
        
        
    }
    else {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        // cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease] ;
        [self drawFrame:cell];
        
        UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellSwipe:)];
        gr.direction = UISwipeGestureRecognizerDirectionRight + UISwipeGestureRecognizerDirectionLeft;
        gr.delegate = self;
        [cell addGestureRecognizer:gr];
        //[cell.accessoryView addGestureRecognizer:gr];
        [gr release];
    }
    //NSLog(@"3  - %@", [self currentDatetime]);
    NSDictionary *dic = [myRecentCall objectAtIndex:indexPath.row];
    NSString *fnames = [dic objectForKey:@"fnames"];
    NSString *mobLbl = [dic objectForKey:@"label"];
    NSString *phone = [dic objectForKey:@"phone"];
   // NSLog(@"%@", dic);
    @try {
        //NSLog(@"qqqq %@", fnames);
        [cellName setText:fnames];
       //NSLog(@"RRRRR %@", fnames);
        //[cellName setText:[[self myCompareData] objectAtIndex:indexPath.row]];
        //[cellName setText:[recOBJ.callName objectAtIndex:indexPath.row]];
        //[cellName setText:fname];
        //NSString *getData = cellName.text;
        NSString *getData = fnames;
        //NSString *getUserNumber = [[arrayNumbers retain]  objectAtIndex:indexPath.row];///arrayNumbers
         //NSLog(@"sdd %@ -- %@", getData, getUserNumber);
        NSString *getUserNumber = phone;
        NSString *myCount;
        if([getUserNumber length] == 0)
            myCount = [self getCountedDataFromCallLog:getData];
        else{
            myCount = [self getCountedDataFromCallLog:getUserNumber];
        }
        int values = [myCount intValue];
        if(values > 1){
            NSString *str = [NSString stringWithFormat:@"(%@)", myCount];
            [countNumberLbl setText:str];
            
        }
        [cellMobile setText:getUserNumber];
        FavViewHandler *mFav = [[FavViewHandler alloc] autorelease];
        //NSString *mobLbl = [[phoneLabels retain] objectAtIndex:indexPath.row];
        [cellTime setText:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:mobLbl]];
       // [mobLbl release];
        BOOL isValid = [mFav scanNumber:fnames];
        if(isValid == true){
            [self drawFrameButton:cell];
            [addButton addTarget:self action:@selector(getAddContact:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    @catch (NSException *exception) {
        //[[self tv] reloadData];
        NSLog(@"sdd %@", exception);
    }
    
   
   
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    [self myCompareData];
    FavViewHandler *mFav = [[FavViewHandler alloc]init];
    int selectedRow = (int)[indexPath row];    
    NSDictionary *dict = [myRecentCall objectAtIndex:selectedRow];
    NSString *fistLastName = [dict objectForKey:@"fnames"];
    NSString *myUserDatastr = [dict objectForKey:@"phone"];
    NSString *mobLbl = [dict objectForKey:@"label"];
   
    fistLastName = [fistLastName stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *fName = @"";;
    NSString *lName = @"";
    if([fistLastName length] >= 1){
        NSArray *personNames = [fistLastName componentsSeparatedByString: @" "];
        if([personNames count]>2){
            fName = [personNames objectAtIndex:0];
            NSString *extra = [personNames objectAtIndex:1];
            fName = [fName stringByAppendingFormat:@" %@", extra];
            BOOL isValid = [mFav scanNumber:fName];
            if(isValid == true){
                fName = @"";
                lName = @"";
            }
            else {
                //if([personNames count] > 1)
                    lName = [personNames objectAtIndex:2];
            }
        }
        else{
            fName = [personNames objectAtIndex:0];
            BOOL isValid = [mFav scanNumber:fName];
            if(isValid == true){
                fName = @"";
                lName = @"";
            }
            else {
                if([personNames count] > 1)
                    lName = [personNames objectAtIndex:1];
            }
        }
        
        
    }
    
    //NSLog(@"Roaming status %hhd", stt);
    NSString *phoneLabel = mobLbl;
    NSString *original = myUserDatastr;
    mAddr = [[AddressBookHandler alloc]init];
    myUserDatastr = [mAddr prefixStr:myUserDatastr];
    NSString *fullName = [fName stringByAppendingFormat:@" %@", lName];
    NSArray *userData2;
    userData2 = [[NSArray alloc] initWithObjects:fName,lName,original,phoneLabel,@"6", nil];
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    [sqliteDB saveCallLog:userData2];
    //FavViewHandler *mFav = [[FavViewHandler alloc]init];
    BOOL checkNum = [mFav checkPrefixStr:original];
    if(!checkNum){
        original = [mFav convertNumber:original];
        //NSLog(@"converted Number %@", original);
    }
    if(linphone_core_is_network_reachable([LinphoneManager getLc]) && [original length]>2)
        [self call:original:fullName];
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
    //commented for SIP calling Prashant
    /*DataModelRecent *mCalling = [[DataModelRecent alloc]init];
    [mCalling callingMethod:fName :lName :phoneLabel :original :myUserDatastr: self];*/
    mVal = 1;
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
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
    // KeypadViewController *controller = [[KeypadViewController alloc]init];
    //[controller callScreen];
    [[self appDelegate] setCheckVal:TRUE];
    tabBarview *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    [controller setSelectedIndex:3];
    [self.navigationController pushViewController:controller animated:NO];
    //[controller callScreen];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"CallScreen" object:nil];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    FavViewHandler *hanRec = [[FavViewHandler alloc]init];
    [self myCompareData];
    NSString *myNumber = [[arrayNumbers retain] objectAtIndex:[indexPath row]];
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
        
    {        
        
        BOOL status = [hanRec delete:myNumber];
        if(status){
            [self viewWillAppear:YES];
        }
        [hanRec release]; 
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert)
        
    {
        
        [myRecent insertObject:@"Dalason" atIndex:[myRecent count]];
        
        [[self tv] reloadData];
        
    }
    
}

- (void)handleCellSwipe:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer.state == UIGestureRecognizerStateRecognized ) {
        CGPoint location = [gestureRecognizer locationInView:self.tv];
        NSIndexPath *indexPath = [self.tv indexPathForRowAtPoint:location];
        if ( indexPath.row != 0 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cell Swipe"
                                                            message:@"Cell in row not equal to 0 swiped"
                                                           delegate:nil 
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    BOOL swipeDetected = NO;
    CGPoint location = [touch locationInView:self.tv];
    NSIndexPath *indexPath = [self.tv indexPathForRowAtPoint:location];
    if ( indexPath.row != 0 ){
        swipeDetected = NO;
    }  // do alert
    return swipeDetected;
}

-(NSString *) getCountedDataFromCallLog:(NSString *)names{
    
    FavViewHandler *mFavView = [[FavViewHandler alloc]init];
    NSString *mCounted;
    NSArray *firstLastName1 = [[NSArray alloc]init];
    if([mFavView scanNumber:names] == false){
        NSString *strString = [names stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        firstLastName1 = [strString componentsSeparatedByString: @" "];
        mCounted =  [mFavView getCallLogCount:firstLastName1];
    }
    else{
        mCounted = [mFavView getCallLogCountPhone:names];
        
        
    }
    [mFavView release];
    
    return mCounted;
    
}


-(void) drawFrameButton:(UITableViewCell *)cell{
    
    CGRect frame;
    frame.origin.x = 280;
    frame.origin.y = 4;
    frame.size.height = 32;
    frame.size.width = 32;   
    
    addButton = [[UIButton alloc] initWithFrame:frame];    
    UIImage *buttonImage = [UIImage imageNamed:@"detailDisclosure.png"];
    [addButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [cell addSubview:addButton];
}


-(void) drawFrame:(UITableViewCell *)cell{
    CGRect frame;
    frame.origin.x = 12;
    frame.origin.y = 2;
    frame.size.height = 20;
    frame.size.width = 184;
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    cellName = [[UILabel alloc] initWithFrame:frame];
    
    cellName.textAlignment = UITextAlignmentLeft;
    
    cellName.textColor =  [UIColor blackColor];
    [cellName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    
    
    frame.origin.x += 1;
    frame.origin.y += 24;
    frame.size.height -= 4;
    if(![language isEqualToString:@"de"]){
        frame.size.width -= 122;
    }
    else
        frame.size.width -= 100;
    cellTime = [[UILabel alloc] initWithFrame:frame];
    cellTime.textAlignment = UITextAlignmentLeft;
    cellTime.textColor =  [UIColor darkGrayColor];
    [cellTime setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    
    if(![language isEqualToString:@"de"]){
        frame.origin.x += 65;
    }
    else
        frame.origin.x += 85;
    frame.size.width += 78;
    
    cellMobile = [[UILabel alloc] initWithFrame:frame];
    cellMobile.textAlignment = UITextAlignmentLeft;
    cellMobile.textColor =  [UIColor lightGrayColor];
    [cellMobile setFont:[UIFont fontWithName:@"ArialMT" size:14]];
    
    
    frame.origin.x += 111;
    frame.origin.y -=24;
    frame.size.height -=2 ;
    frame.size.width -= 70;
    countNumberLbl = [[UILabel alloc] initWithFrame:frame];
    
    countNumberLbl.textAlignment = UITextAlignmentLeft;
    countNumberLbl.textColor =  [UIColor darkGrayColor];
    [countNumberLbl setFont:[UIFont fontWithName:@"ArialMT" size:12]];
    [cell.contentView addSubview:cellName];
    [cell.contentView addSubview:cellMobile];
    
    [cell.contentView addSubview:cellTime];
    
    [cell.contentView addSubview:countNumberLbl];
    
    
    [cellName release];
    
    [cellMobile release];
    
    [cellTime release];
    
    [countNumberLbl release];
    
    
}


-(IBAction)getAddContact:(UIControl *) button withEvent: (UIEvent *) event
{ 
    //UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    NSIndexPath * indexPath = [self.tv indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.tv]];   
    [self myCompareData];
    //NSString *myNumber = [[self myCompareData] objectAtIndex:[indexPath row]];
    NSDictionary *dict = [myRecentCall objectAtIndex:[indexPath row]];
   // NSString *fistLastName = [dict objectForKey:@"fnames"];
    NSString *myNumber = [dict objectForKey:@"phone"];
   // NSString *mobLbl = [dict objectForKey:@"label"];
    //NSLog(@"Hi this is add %@", myNumber);
    ABRecordRef aContact = ABPersonCreate();
	CFErrorRef anError = NULL;
       
	ABMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	//bool didAdd = ABMultiValueAddValueAndLabel(email, CallNumber.text, kABPersonPhoneMobileLabel, NULL);
    bool didAdd = ABMultiValueAddValueAndLabel(email, myNumber, kABPersonPhoneMobileLabel, NULL);
	
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
    //CFRelease(addressBook);
}


- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
    //NSLog(@"cxcx %@", person);
     
    if(person != NULL){
        //NSLog(@"Added");
        mAddr = [[AddressBookHandler alloc] autorelease];
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

-(void)dealloc{
    [userImage release];
    name = nil;
    last = nil;
    myPhone = nil;
    myString = nil;
    abName = nil;
    [myRecent release];
    [firstLastName release];
    [selectedDetails release];
    [namesFromAB release];
    [mAddr release];
    [myRecentCall release];
    [arrayNumbers release];
    [getMatchedPhone release];
    [addButton release];
    [npNav release];
    [phoneLabels release];
    arrayNumbers=nil;
    selectedDetails=nil;
    myRecentCall=nil;
    myRecent=nil;
    //[mCallWebview release];
    [callQualityTimerRecent invalidate];
    callQualityTimerRecent = nil;
    [callSecurityTimerRecent invalidate];
    callSecurityTimerRecent = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

// for sip

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
    NSLog(@"REG recent view %@ ", message);
    [registrationStateLabel setText:message];
    //[registrationStateImage setImage:image];
    
    PreferencesHandler *mPref = [[[PreferencesHandler alloc]init]autorelease];
    [mPref setRegisterSIP:message];
    
    
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
                                                    name:@"changeScreen"
                                                  object:nil];
    
    if(callQualityTimerRecent != nil) {
        [callQualityTimerRecent invalidate];
        callQualityTimerRecent = nil;
    }
    if(callSecurityTimerRecent != nil) {
        [callSecurityTimerRecent invalidate];
        callSecurityTimerRecent = nil;
    }
}


@end