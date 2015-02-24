//
//  FavViewController.m
//  DCalling WiFi
//
//  Created by David C. Son on 17/01/12.
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

#import "FavViewController.h"
#import "SQLiteDBHandler.h"
#import "PreferencesHandler.h"
#import "FavViewHandler.h"
#import "getCreditHandler.h"
#import "ContactsViewController.h"
#import "DataModelRecent.h"
#import "DCallingWIFIAppDelegate.h"
#import "tabBarview.h"
#import "LinphoneManager.h"

@implementation FavViewController

@synthesize favCallLog, favPhone, userData, favCallLogPhoneLabel;
@synthesize selectedContact, userCredit, mVal, tokenInt;
@synthesize nsCount, cellNumber;
@synthesize tv;

@synthesize callQualityImage, callSecurityButton, callSecurityImage, registrationStateImage, registrationStateLabel;

NSTimer *callQualityTimerFAV;
NSTimer *callSecurityTimerFAV;

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





-(void) getFavCallLog{
        
    FavViewHandler *delegates = [[FavViewHandler alloc] autorelease];
    [delegates getFavCallLog];
    favCallLog = [[NSMutableArray alloc]init];
    favCallLog = [delegates.favCall retain];
    favPhone = [[NSMutableArray alloc]init];
    favPhone = [delegates.favPhones retain];
    favCallLogPhoneLabel = [[NSMutableArray alloc]init];
    SQLiteDBHandler *mSqlite = [[SQLiteDBHandler alloc]autorelease];
    favCallLogPhoneLabel = [mSqlite getFavPhoneLabel];
    nsCount = (int)[favCallLog count];
    mVal=0;
}

/*-(UIImage *) getABImages:(NSString *)myPhoneStr{
    mAddHandler = [[AddressBookHandler alloc]init];
    userImage = [mAddHandler imageFetchFromAB:myPhoneStr];
    return userImage;
}*/

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
    //[self performSelectorInBackground:@selector(updateCredit) withObject:nil];
    [toprightHeader setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];  
    topHeader.text=[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Favorite"];
    [topHeader setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if([language isEqualToString:@"de"] && version>=7.0){
        CGRect downRightFrame = topRightBottomHeader.frame;
        downRightFrame.size.width-=15;
        topRightBottomHeader.frame=downRightFrame;
    }
    topRightBottomHeader.text=[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"recent_recharge_title"];
    [topRightBottomHeader setFont:[UIFont fontWithName:@"ArialMT" size:12]];    
    favTab.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Favorite"];
    [self getFavCallLog];
    UILabel *buttonLbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 8, 180, 18)];
    buttonLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Favorite_add_button"];
    [buttonLbl setBackgroundColor:[UIColor clearColor]];
    [buttonLbl setTextColor:[UIColor whiteColor]];
    [buttonLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [pickerButton addSubview:buttonLbl];
    [pickerButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter| UIControlContentHorizontalAlignmentCenter];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    
    if(result.height == 1136) {
        //NSLog(@"iPhone 5 Resolution");
        CGRect frame = pickerButton.frame;
        //frame.origin.x = 20;
        frame.origin.y += 70;
        //frame.size.height = 37;
        //frame.size.width = 280;
        pickerButton.frame=frame;
        //pickerButton = [[UIButton alloc] initWithFrame:frame];
        [self.view addSubview:pickerButton];
    }
    
    if(version>=7.0){
        [self viewforiosSeven];
        UIImage *selectedImg = [UIImage imageNamed:@"tabbar__favoriten.png"];
        UIImage *unSelectedImg = [UIImage imageNamed:@"tabbar__favoriten_active.png"];
        
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unSelectedImg = [unSelectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = unSelectedImg;
        self.tabBarItem.image = selectedImg;
    }
    
    else
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__favoriten_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__favoriten.png"]];
    [buttonLbl release];
    [super viewDidLoad];
    //NSLog(@"path:%@",[[NSBundle mainBundle]bundlePath]);
    mVal = 0;
    // Do any additional setup after loading the view from its nib.
    [self performSelectorInBackground:@selector(updateLog) withObject:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    //[acView setHidden:YES];
    //[self performSelectorInBackground:@selector(updateCredit) withObject:nil];
    ContactsViewController *mContactView = [[ContactsViewController alloc]autorelease];
    BOOL internetStatus = [mContactView CheckNetwork];
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    [mPref setViewSt:YES];
    //NSLog(@"Device %@", [mPref getDeviceToken]);
    NSString *token = [mPref getToken];
    BOOL sts = [mPref getCallingStatus];
    [mPref setViewSt:YES];
    if(sts == TRUE && internetStatus==TRUE){
         //mVal=0;
        //[self performSelectorInBackground:@selector(updateCredit) withObject:nil];
        [mPref setCallingStatus:FALSE];
    }
    //NSLog(@"google : %@", [mPref getMNC]);
    if((token == NULL) && (token == nil)){
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_WARN"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NEW_SIM_MSG"] delegate:self   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        tokenInt = 22;*/
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
        
    }
    
    if(internetStatus == FALSE && ![[mPref getInternetVal] isEqualToString:@"FAVORITE"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"] delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [mPref setInternetVal:@"FAVORITE"];
    [self getFavCallLog];
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
    //NSLog(@"hello else %d", [[mPrefs getCredit] length]);
    toprightHeader.text = [mPrefs getCredit];
    //NSLog(@"%@", [mPrefs getCredit]);
    [toprightHeader setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    favTab = [[UITabBarItem alloc]initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Favorite"] image:nil tag:100];
    [favTab setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__favoriten_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__favoriten.png"]];
    [super viewWillAppear:YES];
    mVal=0;
    [[self tv] reloadData];
    
    // For SIP registration update
    
    callQualityTimerFAV = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(callQualityUpdate)
                                                             userInfo:nil
                                                              repeats:YES];
    
    // Set callQualityTimer
	callSecurityTimerFAV = [NSTimer scheduledTimerWithTimeInterval:1
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
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:3600.0f target:self  selector:@selector(updateFavorites) userInfo:nil repeats:YES];
    
    [runLoop run];
    [pool release];
}

-(void) updateFavorites
{
    mAddHandler = [[AddressBookHandler alloc]autorelease];
    [mAddHandler updateFavLogdata];
    //NSLog(@"update Fav");
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
    //NSLog(@"Favourites updatee");
   // [super viewWillAppear:YES];
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"button -- %d", buttonIndex);
    if (buttonIndex == 0 && tokenInt ==22) {
        tokenInt =0;
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    } 
}


-(void) getValues{
   // if(mVal != 0){
        getCreditHandler *mGetCrHandler = [[getCreditHandler alloc]init];
        [mGetCrHandler getCredit];
        mVal =0;
   // }
    
}

-(IBAction)callContact{
    UITabBarController *tabBarController = [[[UITabBarController alloc] init] retain];
    [[self tabBarController] delegate];
    self.tabBarController.selectedIndex=2;
    [tabBarController release];
}


- (void)viewDidUnload
{
    static NSString *CellIdentifier = @"favCells";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    [self drawFrame:cell];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    [self getFavCallLog];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
    
    [self getFavCallLog];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    //NSString *continent = [self tableView:tableView titleForHeaderInSection:section];
    
    return nsCount;
}


- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getFavCallLog];
   // NSLog(@"3  - %@", [self currentDatetime]);
    static NSString *CellIdentifier = @"favCells";
    //static NSInteger name =1;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease] ;
        [self drawFrame:cell];
        
    }
    else {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [self drawFrame:cell];
       
        UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellSwipe:)];
        gr.direction = UISwipeGestureRecognizerDirectionRight + UISwipeGestureRecognizerDirectionLeft;
        gr.delegate = self;
        [cell addGestureRecognizer:gr];
        [gr release];
    }
     //NSLog(@"%2f - %2f - %2f", cell.frame.origin.x, cellName.frame.origin.x, cell.contentView.frame.origin.x);
    // Configure the cell...
   
    @try {
        [cellName setText:[[favCallLog retain] objectAtIndex:indexPath.row]];
        //FavViewHandler *mFav = [[FavViewHandler alloc] autorelease];
        NSString *mLabel = [[favCallLogPhoneLabel retain] objectAtIndex:indexPath.row];
        [cellMobile setText:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:mLabel]];
        //[cellMobile setText:@"Mobil"];
        [cellNumber setText:[[favPhone retain] objectAtIndex:indexPath.row]];
    }
    @catch (NSException *exception) {
       // [[self tv] reloadData];
        NSLog(@"Fav exception %@", exception);
    }
    
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
 // UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
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
    int selectedRow = (int)[indexPath row];
    NSString *myNumber;
    myNumber = [favPhone objectAtIndex:selectedRow];
   
    NSString *fName;
    NSString *lName;
    NSString *phoneLabel;
    NSString *myUserDatastr;
    FavViewHandler *mFav = [[FavViewHandler alloc]init];
    myUserDatastr = [mFav getUserName:myNumber];
    //[mFav release];
    NSArray *userArrayData = [myUserDatastr componentsSeparatedByString: @"}"];
    //NSLog(@"dsdd -%@", userArrayData);
    int count = (int)[userArrayData count];
    fName = [userArrayData objectAtIndex: 0];
    lName = [userArrayData objectAtIndex:1];
    NSString *mobLbl = [userArrayData objectAtIndex:count-1];
    phoneLabel =  [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:mobLbl];
    
    AddressBookHandler *mAdd = [[AddressBookHandler alloc]init];
    NSString *myTNumber = [mAdd trimWhiteSpace:myNumber];
    NSString *mynum = [mAdd trimWhiteSpaceNotZero:myNumber];
    NSString *fullName = [fName stringByAppendingFormat:@" %@", lName];
    NSArray *userData2;
    userData2 = [[NSArray alloc] initWithObjects:fName,lName,mynum,phoneLabel,@"6", nil];
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    [sqliteDB saveCallLog:userData2];
    //FavViewHandler *mFav = [[FavViewHandler alloc]init];
    BOOL checkNum = [mFav checkPrefixStr:mynum];
    if(!checkNum){
        mynum = [mFav convertNumber:mynum];
       // NSLog(@"converted Number %@", mynum);
    }
    if(linphone_core_is_network_reachable([LinphoneManager getLc]) && [mynum length]>2)
        [self call:mynum:fullName];
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
    // commeted for SIP calling prashant
    /*DataModelRecent *mCalling = [[DataModelRecent alloc]init];
    [mCalling callingMethod:fName :lName :phoneLabel :mynum :myTNumber:self];*/
    mVal = 1;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self viewWillAppear:YES];
    //[self viewWillAppear:YES];
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
   // UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    int selectedRow = (int)[indexPath row];
    NSString *myNumber;
    for(int i=0; i<=[favPhone count]; i++){
        if(i == selectedRow){
            myNumber = [favPhone objectAtIndex:i];
        }
    }
    FavViewHandler *hanRec = [[FavViewHandler alloc]init];
    if (editingStyle == UITableViewCellEditingStyleDelete)
        
    {        
        
        BOOL status = [hanRec deleteInFavView:myNumber];
        if(status){
            
            //[[self tv] reloadData];
            [self viewWillAppear:YES];
        }
        [hanRec release]; 
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert)
        
    {
        
        [favCallLog insertObject:@"Tutorial" atIndex:nsCount];
        
        [[self tv] reloadData];
        
    }
    
}

- (void)handleCellSwipe:(UIGestureRecognizer *)gestureRecognizer
{
   // gestureRecognizer.delegate = self;
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


-(IBAction)getAddressBook{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [picker setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]]];
    [self presentModalViewController:picker animated:YES];
    
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissModalViewControllerAnimated:YES];
   // [peoplePicker autorelease];
    //[self resignFirstResponder];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    //NSLog(@"%@", person);
    BOOL status = NO;
    //NSLog(@"%@", person);
    double currSysVer = [[[UIDevice currentDevice] systemVersion]floatValue];
    if(currSysVer >= 8.0){
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        
        ABAddressBookRef addressBook = ABAddressBookCreate(); // this will open the AddressBook of the iPhone
        CFErrorRef error             = NULL;
        
        //peoplePicker.editing = YES;
        //ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
        ABPersonViewController *personController = [[ABPersonViewController alloc] init];
        //peoplePicker.navigationBar.tintColor = [UIColor colorWithRed:33.0f/255.0f green:54.0f/255.0f blue:63.0f/255.0f alpha:0.20f];
        
        personController.addressBook                       = addressBook; // this passes the reference of the Address Book
        personController.displayedPerson                   = person; // this sets the person reference
        personController.allowsEditing                     = YES; // this allows the user to edit the details
        personController.personViewDelegate                = self;
        personController.shouldShowLinkedPeople=YES;
        personController.allowsActions = NO;
        personController.navigationItem.rightBarButtonItem = [self editButtonItem]; // this will add the inbuilt Edit button to the view
        peoplePicker.navigationItem.rightBarButtonItem=[self editButtonItem];
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
        
        
        
        personController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ClosePeoplePicker)];
        
        UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:personController];
        [self presentModalViewController:ctrl animated:YES];
        [personController release];
        status = NO;
    }
    else{
        NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        // NSLog(@"[AddressBook] Person selected: %@, %@", lastName, firstName);
        
        [firstName release];
        [lastName release];
        status = YES;
    }
    
    
    
    return status;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier 
{
    //NSLog(@"peoplePickerNavigationController");
    // here we will add the callLog
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFStringRef phone = ABMultiValueCopyValueAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifier)); // either put zero or identifier.
    //NSLog(@"fdf %@", phone);
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
        last = @"";
    
    // for Mobile label
    
    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifier));
    NSString *phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
    CFRelease(locLabel);
    //NSLog(@"  - %@",  phoneLabel);
    
    if([phoneLabel length] == 0)
        phoneLabel =@"mobile";
    
    NSArray *selectedDetails = [[NSArray alloc]initWithObjects:first,last,myPhone,phoneLabel, nil];
        
    
    //NSLog(@"details %@", selectedDetails);
    
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    // UIAlertView *message;
    NSString *getNumber = [ sqliteDB getFavoritesPhone:myPhone];
    [sqliteDB release];
    if([getNumber isEqualToString:myPhone]){
        UIAlertView *message;
        message = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Favorite"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg1"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        [message release];
        return NO;
    }
    else{
        SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
        [sqliteDB saveFavorites:selectedDetails];
        //if(status)
        //    NSLog(@"Added");
        
        [sqliteDB release];
    }
    
   
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue {
    //NSLog(@"peoplePickerNavigationController");
    // here we will add the callLog
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFStringRef phone = ABMultiValueCopyValueAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifierForValue)); // either put zero or identifier.
    //NSLog(@"fdf %@", phone);
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
        last = @"";
    
    // for Mobile label
    
    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(multi, ABMultiValueGetIndexForIdentifier(multi, identifierForValue));
    NSString *phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
    CFRelease(locLabel);
    //NSLog(@"  - %@",  phoneLabel);
    
    if([phoneLabel length] == 0)
        phoneLabel =@"mobile";
    
    NSArray *selectedDetails = [[NSArray alloc]initWithObjects:first,last,myPhone,phoneLabel, nil];
    
    
    //NSLog(@"details %@", selectedDetails);
    
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    // UIAlertView *message;
    NSString *getNumber = [ sqliteDB getFavoritesPhone:myPhone];
    [sqliteDB release];
    if([getNumber isEqualToString:myPhone]){
        UIAlertView *message;
        message = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Favorite"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg1"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
        [message release];
        return NO;
    }
    else{
        SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
        [sqliteDB saveFavorites:selectedDetails];
        //if(status)
        //    NSLog(@"Added");
        
        [sqliteDB release];
    }
    
    
    [self dismissModalViewControllerAnimated:YES];
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


-(void) drawFrame:(UITableViewCell *)cell{
    CGRect frame;
   /* frame.origin.x = 12;
    frame.origin.y = 4;
    frame.size.height = 66;
    frame.size.width = 66;
    
    imagePerson = [[UIImageView alloc]initWithFrame:frame];*/
    //if(frame.origin.x==184.0)
    //NSLog(@"1. %2f", frame.origin.x);
    frame.origin.x=0;
    frame.origin.x += 12;
    frame.origin.y = 2;
    frame.size.height = 20;
    frame.size.width += 184;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    cellName = [[UILabel alloc] initWithFrame:frame];
    
    cellName.textAlignment = UITextAlignmentLeft;
    
    cellName.textColor =  [UIColor blackColor];
    [cellName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    //NSLog(@"2. %2f", frame.origin.x);
    frame.origin.x += 1;
    frame.origin.y += 24;
    frame.size.height -= 4;
    if(![language isEqualToString:@"de"]){
        frame.size.width -= 122;
    }
    else
        frame.size.width -= 100;
    cellMobile = [[UILabel alloc] initWithFrame:frame];
    cellMobile.textAlignment = UITextAlignmentLeft;
    cellMobile.textColor =  [UIColor darkGrayColor];
    [cellMobile setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    
    //float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //NSLog(@"3. %2f", frame.origin.x);
    if(![language isEqualToString:@"de"]){
        frame.origin.x += 65;
    }
    else
        frame.origin.x += 80;
    //frame.origin.x += 65;
    //NSLog(@"4. %2f", frame.origin.x);
    frame.size.width += 78;
    cellNumber = [[UILabel alloc] initWithFrame:frame];
    
    cellNumber.textAlignment = UITextAlignmentLeft;
    cellNumber.textColor =  [UIColor lightGrayColor];
    [cellNumber setFont:[UIFont fontWithName:@"ArialMT" size:14]];
    //[cell.contentView addSubview:imagePerson];
    [cell.contentView addSubview:cellName];
    [cell.contentView addSubview:cellMobile];
    [cell.contentView addSubview:cellNumber];
    
    [cellMobile release];
    [cellNumber release];
    [cellName release];
    //[imagePerson release];
    
    
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
    NSLog(@"REG favourite view %@ ", message);
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
    
    if(callQualityTimerFAV != nil) {
        [callQualityTimerFAV invalidate];
        callQualityTimerFAV = nil;
    }
    if(callSecurityTimerFAV != nil) {
        [callSecurityTimerFAV invalidate];
        callSecurityTimerFAV = nil;
    }
}



-(void) dealloc{
    [userCredit release];
    [favCallLog release];
    [favPhone release];
    [selectedContact release];
    [tv release];
    [mAddHandler release];
    [userImage release];
    [favCallLogPhoneLabel release];
    //[mCallWebview release];
    [callQualityTimerFAV invalidate];
    callQualityTimerFAV = nil;
    [callSecurityTimerFAV invalidate];
    callSecurityTimerFAV = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end
