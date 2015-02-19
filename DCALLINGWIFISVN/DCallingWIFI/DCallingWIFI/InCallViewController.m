//
//  InCallViewController.m
//  FRBooster
//
//  Created by Ramesh on 29/05/14.
//
//

#import "InCallViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import "LinphoneManager.h"
#import "Utils.h"
#import "CAAnimation+Blocks.h"
#import "UIToggleButton.h"
#import "DCallingWIFIAppDelegate.h"
#include "linphonecore.h"
#import "PreferencesHandler.h"
#import "getCreditHandler.h"
#import "tabBarview.h"
#import "KeypadViewController.h"

static NSString *const kLinphoneInCallCellData = @"LinphoneInCallCellData";
enum TableSection {
    ConferenceSection = 0,
    CallSection = 1
};

@implementation UICallCellData

@synthesize address;
@synthesize image;

- (id)init:(LinphoneCall*)acall minimized:(BOOL)minimized{
    self = [super init];
    if(self != nil) {
        self->minimize = minimized;
        //self->view = UICallCellOtherView_Avatar;
        self->call = acall;
        image = [[UIImage imageNamed:@"avatar_unknown.png"] retain];
        address = [@"Unknown" retain];
        [self update];
    }
    return self;
}

- (void)update {
    if(call == NULL) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot update call cell: null call or data"];
        return;
    }
    const LinphoneAddress* addr = linphone_call_get_remote_address(call);
    
    if(addr != NULL) {
        BOOL useLinphoneAddress = true;
        // contact name
        char* lAddress = linphone_address_as_string_uri_only(addr);
        if(lAddress) {
            NSString *normalizedSipAddress = [FastAddressBook normalizeSipURI:[NSString stringWithUTF8String:lAddress]];
            ABRecordRef contact = [[[LinphoneManager instance] fastAddressBook] getContact:normalizedSipAddress];
            if(contact) {
                useLinphoneAddress = false;
                self.address = [FastAddressBook getContactDisplayName:contact];
                /*UIImage *tmpImage = [FastAddressBook getContactImage:contact thumbnail:false];
                if(tmpImage != nil) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
                        //UIImage *tmpImage2 = [UIImage decodedImageWithImage:tmpImage];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setImage: tmpImage2];
                        });
                    });
                }*/
            }
            ms_free(lAddress);
        }
        if(useLinphoneAddress) {
            const char* lDisplayName = linphone_address_get_display_name(addr);
            const char* lUserName = linphone_address_get_username(addr);
            if (lDisplayName)
                self.address = [NSString stringWithUTF8String:lDisplayName];
            else if(lUserName)
                self.address = [NSString stringWithUTF8String:lUserName];
        }
    }
}

- (void)dealloc {
    //[address release];
    [image release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end

@interface InCallViewController ()

@end

@implementation InCallViewController
@synthesize audioCodecLabel;
@synthesize videoCodecLabel;
@synthesize conferenceCell;
@synthesize currentCall;
@synthesize data;
@synthesize pauseButton;
@synthesize conferenceButton;
@synthesize videoButton;
@synthesize microButton;
@synthesize speakerButton;
@synthesize routesButton;
@synthesize optionsButton;
@synthesize hangupButton;
@synthesize routesBluetoothButton;
@synthesize routesReceiverButton;
@synthesize routesSpeakerButton;
@synthesize optionsAddButton;
@synthesize optionsTransferButton;
@synthesize dialerButton;

@synthesize padView;
@synthesize routesView;
@synthesize optionsView;

@synthesize oneButton;
@synthesize twoButton;
@synthesize threeButton;
@synthesize fourButton;
@synthesize fiveButton;
@synthesize sixButton;
@synthesize sevenButton;
@synthesize eightButton;
@synthesize nineButton;
@synthesize starButton;
@synthesize zeroButton;
@synthesize sharpButton;
@synthesize speakerEnable;
@synthesize nameAddress;
@synthesize durationTimer;
@synthesize muteEnable;
@synthesize topRightBottom;
@synthesize topRightUpper;
@synthesize buttons;
@synthesize endlbl;
@synthesize contactButton;
@synthesize mergerButton;
@synthesize flipView;
@synthesize smallEndButton, dialTextView, hideButton, infoImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(DCallingWIFIAppDelegate *)appDelegate{
    return (DCallingWIFIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc {
    [pauseButton release];
    [conferenceButton release];
    [videoButton release];
    [microButton release];
    [speakerButton release];
    [routesButton release];
    [optionsButton release];
    [routesBluetoothButton release];
    [routesReceiverButton release];
    [routesSpeakerButton release];
    [optionsAddButton release];
    [optionsTransferButton release];
    [dialerButton release];
    
    [oneButton release];
	[twoButton release];
	[threeButton release];
	[fourButton release];
	[fiveButton release];
	[sixButton release];
	[sevenButton release];
	[eightButton release];
	[nineButton release];
	[starButton release];
	[zeroButton release];
	[sharpButton release];
    
    [padView release];
    [routesView release];
    [optionsView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [flipView release];
    [smallEndButton release];
    [dialTextView release];
    [hideButton release];
    [infoImageView release];
    [super dealloc];
}

- (void) viewforiosSeven{
    CGRect headFrame = buttons.frame;
    CGRect microFrame = microButton.frame;
    CGRect hangFrame = hangupButton.frame;
    CGRect endFrame = endlbl.frame;
    CGRect optionTFrame = optionsTransferButton.frame;
    CGRect optionAframe = optionsAddButton.frame;
    CGRect speakerframe = speakerButton.frame;
    CGRect videoFrame = videoButton.frame;
    CGRect contactFrame = contactButton.frame;
    CGRect mergeFrame = mergerButton.frame;
    CGRect infoFrame = infoImageView.frame;
    CGRect nameFrame = nameAddress.frame;
    CGRect durationFrame = durationTimer.frame;
    //CGRect tableFrame = self.tv.frame;
    
    infoFrame.origin.y +=30;
    infoImageView.frame = infoFrame;
    
    nameFrame.origin.y +=30;
    nameAddress.frame = nameFrame;
    
    durationFrame.origin.y +=30;
    durationTimer.frame = durationFrame;
    
    headFrame.origin.y +=30;
    headFrame.size.height +=50;
    buttons.frame = headFrame;
    microFrame.origin.y +=35;
    //microFrame.size.height +=20;
    microButton.frame=microFrame;
    
    optionTFrame.origin.y +=35;
    //optionTFrame.size.height +=20;
    optionsTransferButton.frame=optionTFrame;
    
    optionAframe.origin.y +=55;
    //optionAframe.size.height +=20;
    optionsAddButton.frame=optionAframe;
    
    speakerframe.origin.y +=35;
    //speakerframe.size.height +=20;
    speakerButton.frame=speakerframe;
    
    videoFrame.origin.y +=55;
   // videoFrame.size.height +=20;
    videoButton.frame=videoFrame;
    
    contactFrame.origin.y +=55;
   // contactFrame.size.height +=20;
    contactButton.frame=contactFrame;
    
    mergeFrame.origin.y += 55;
    //mergeFrame.size.height += 20;
    mergerButton.frame = mergeFrame;
    
    hangFrame.origin.y +=70;
    hangupButton.frame=hangFrame;
   /* endFrame.origin.y +=90;
    endlbl.frame = endFrame;
    
    // for dialpad
    CGRect flipFrame = flipView.frame;
    flipFrame.origin.y += 20;
    flipFrame.size.height +=50;
    flipView.frame = flipFrame;
    
    [self buttonFram:oneButton :30];
    [self buttonFram:twoButton :30];
    [self buttonFram:threeButton :30];
    [self buttonFram:fourButton :00];
    [self buttonFram:fiveButton :00];
    [self buttonFram:sixButton :00];
    [self buttonFram:sevenButton :40];
    [self buttonFram:eightButton :40];
    [self buttonFram:nineButton :40];
    [self buttonFram:zeroButton :50];
    [self buttonFram:starButton :50];
    [self buttonFram:sharpButton :50];
    
    
    CGRect smallEndFrame = smallEndButton.frame;
    smallEndFrame.origin.y += 80;
    smallEndFrame.size.height +=10;
    smallEndButton.frame = smallEndFrame;
    
    CGRect hideFrame = hideButton.frame;
    hideFrame.origin.y += 80;
    hideFrame.size.height +=10;
    hideButton.frame = hideFrame;
    
    CGRect dialTxtframe = dialTextView.frame;
    dialTxtframe.origin.y -=20;
    dialTxtframe.size.height +=50;
    dialTextView.frame = dialTxtframe;*/
    
}

- (void)buttonFram:(UIButton *)button : (int)i{
    //NSLog(@"tag %d", i);
    CGRect frame = button.frame;
    if(i == 30){
        frame.origin.y =1;
        frame.size.height +=12;
        button.frame=frame;
    }
    else if(i == 40){
        frame.origin.y +=26;
        frame.size.height +=12;
        button.frame=frame;
    }
    else if(i == 50){
        frame.origin.y +=39;
        frame.size.height +=12;
        button.frame=frame;
    }
    else{
        frame.origin.y +=12;
        frame.size.height +=12;
        button.frame=frame;
        
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            [self viewforiosSeven];
        } else {
            /*Do iPhone Classic stuff here.*/
        }
    }
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(![language isEqualToString:@"en"] && version>=7.0){
        CGRect downRightFrame = topRightBottom.frame;
        downRightFrame.size.width-=17;
        topRightBottom.frame=downRightFrame;
    }
    [padView setHidden:true];
    [topRightUpper setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    topRightBottom.text=[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"recent_recharge_title"];
    [topRightBottom setFont:[UIFont fontWithName:@"ArialMT" size:12]];
    [dialTextView setFont:[UIFont fontWithName:@"Arial-BoldMT" size:30]];
   
    [optionsAddButton setEnabled:false];
    [optionsTransferButton setEnabled:false];
    [videoButton setEnabled:false];
    [contactButton setEnabled:false];
    [dialerButton setEnabled:false];
    [mergerButton setEnabled:false];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self dataNumbers];
    if([[self appDelegate]checkVal]){
       [[self appDelegate]setCheckVal:FALSE];
        [[self appDelegate]setNumbers:@""];
        [[self appDelegate]setDName:@""];
    }
    [dialTextView setHidden:true];
    [smallEndButton setHidden:true];
    [hideButton setHidden:true];
    
    dutaionTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update)                                                userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdateEvent:)
                                                 name:kLinphoneCallUpdate
                                               object:nil];
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdate:)
                                                 name:kLinphoneCallUpdate
                                               object:nil];
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bluetoothAvailabilityUpdateEvent:)
                                                 name:kLinphoneBluetoothAvailabilityUpdate
                                               object:nil];
    // Update on show
    LinphoneCall* call = linphone_core_get_current_call([LinphoneManager getLc]);
    LinphoneCallState state = (call != NULL)?linphone_call_get_state(call): 0;
    [self callUpdate:call state:state];
    [self hideRoutes:FALSE];
    [self hideOptions:FALSE];
    [self hidePad:FALSE];
    [self showSpeaker];
    
    PreferencesHandler *mPrefs = [[PreferencesHandler alloc]init];
    topRightUpper.text = [mPrefs getCredit];
    [self onUpdate];
}

- (bool)onUpdate {
	if([LinphoneManager isLcReady]) {
		return linphone_core_is_mic_muted([LinphoneManager getLc]) == false;
	} else {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot update mic button: Linphone core not ready"];
		return true;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (dutaionTime != nil) {
        [dutaionTime invalidate];
        dutaionTime = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLinphoneCallUpdate
                                                  object:nil];
	if (linphone_core_get_calls_nb([LinphoneManager getLc]) == 0) {
		//reseting speaker button because no more call
		speakerButton.selected=FALSE;
	}
    [self getCreditKey];
}

/*- (void)callUpdate:(NSNotification*)notif {
    LinphoneCall *call = [[notif.userInfo objectForKey: @"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
    NSString *message = [notif.userInfo objectForKey: @"message"];
    
    bool canHideInCallView = (linphone_core_get_calls([LinphoneManager getLc]) == NULL);
    
    // Don't handle call state during incoming call view
    if([[self currentView] equal:[IncomingCallViewController compositeViewDescription]] && state != LinphoneCallError && state != LinphoneCallEnd) {
        return;
    }
    
	switch (state) {
		case LinphoneCallIncomingReceived:
        {
			//[self displayIncomingCall:call];
			break;
        }
		case LinphoneCallOutgoingInit:
        case LinphoneCallPausedByRemote:
		case LinphoneCallConnected:
        case LinphoneCallStreamsRunning:
        {
            //[self changeCurrentView:[InCallViewController compositeViewDescription]];
            break;
        }
        case LinphoneCallUpdatedByRemote:
        {
            const LinphoneCallParams* current = linphone_call_get_current_params(call);
            const LinphoneCallParams* remote = linphone_call_get_remote_params(call);
            
            if (linphone_call_params_video_enabled(current) && !linphone_call_params_video_enabled(remote)) {
                //[self changeCurrentView:[InCallViewController compositeViewDescription]];
            }
            break;
        }
		case LinphoneCallError:
        {
            [self displayCallError:call message: message];
        }
		case LinphoneCallEnd:
        {
            if (canHideInCallView) {
                // Go to dialer view
                DialerViewController *controller = DYNAMIC_CAST([self changeCurrentView:[DialerViewController compositeViewDescription]], DialerViewController);
                if(controller != nil) {
                    [controller setAddress:@""];
                    [controller setTransferMode:FALSE];
                }
            } else {
                [self changeCurrentView:[InCallViewController compositeViewDescription]];
			}
			break;
        }
        default:
            break;
	}
    //[self updateApplicationBadgeNumber];
}

- (void)displayCallError:(LinphoneCall*) call message:(NSString*) message {
    const char* lUserNameChars=linphone_address_get_username(linphone_call_get_remote_address(call));
    NSString* lUserName = lUserNameChars?[[[NSString alloc] initWithUTF8String:lUserNameChars] autorelease]:NSLocalizedString(@"Unknown",nil);
    NSString* lMessage;
    NSString* lTitle;
    
    //get default proxy
    LinphoneProxyConfig* proxyCfg;
    linphone_core_get_default_proxy([LinphoneManager getLc],&proxyCfg);
    if (proxyCfg == nil) {
        lMessage = NSLocalizedString(@"Please make sure your device is connected to the internet and double check your SIP account configuration in the settings.", nil);
    } else {
        lMessage = [NSString stringWithFormat : NSLocalizedString(@"Cannot call %@", nil), lUserName];
    }
    
    if (linphone_call_get_reason(call) == LinphoneReasonNotFound) {
        lMessage = [NSString stringWithFormat : NSLocalizedString(@"'%@' not registered", nil), lUserName];
    } else {
        if (message != nil) {
            lMessage = [NSString stringWithFormat : NSLocalizedString(@"%@\nReason was: %@", nil), lMessage, message];
        }
    }
    lTitle = NSLocalizedString(@"Call failed",nil);
    UIAlertView* error = [[UIAlertView alloc] initWithTitle:lTitle
                                                    message:lMessage
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                          otherButtonTitles:nil];
    [error show];
    [error release];
}*/



#pragma mark - Event Functions

- (void)callUpdateEvent:(NSNotification*)notif {
    LinphoneCall *call = [[notif.userInfo objectForKey: @"call"] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
    [self callUpdate:call state:state];
    [self callUpdate:call state:state animated:TRUE];
}

- (void)bluetoothAvailabilityUpdateEvent:(NSNotification*)notif {
    bool available = [[notif.userInfo objectForKey:@"available"] intValue];
    [self bluetoothAvailabilityUpdate:available];
}


#pragma mark -

- (void)callUpdate:(LinphoneCall*)call state:(LinphoneCallState)state {
    if(![LinphoneManager isLcReady]) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot update call bar: Linphone core not ready"];
        return;
    }
    LinphoneCore* lc = [LinphoneManager getLc];
    [optionsAddButton setHidden:false];
    [mergerButton setHidden:true];
    
    // comment for hide pause button prashant
    //[pauseButton update];
    /*[speakerButton update];
     [microButton update];
     [pauseButton update];
     [videoButton update];
     [hangupButton update];*/
    NSLog(@"Khatri %u", state);
    bool canHideInCallView = (linphone_core_get_calls(lc) == NULL);
    // Show Pause/Conference button following call count
    if(linphone_core_get_calls_nb(lc) > 1) {
        if(![pauseButton isHidden]) {
            [pauseButton setHidden:true];
            [conferenceButton setHidden:false];
            [mergerButton setHidden:false];
            [optionsAddButton setHidden:true];
            [[self appDelegate]setAddCallValue:false];
            
        }
        bool enabled = true;
        const MSList *list = linphone_core_get_calls(lc);
        while(list != NULL) {
            LinphoneCall *call = (LinphoneCall*) list->data;
            LinphoneCallState state = linphone_call_get_state(call);
            if(state == LinphoneCallIncomingReceived ||
               state == LinphoneCallOutgoingInit ||
               state == LinphoneCallOutgoingProgress ||
               state == LinphoneCallOutgoingRinging ||
               state == LinphoneCallOutgoingEarlyMedia ||
               state == LinphoneCallConnected) {
                enabled = false;
            }
            list = list->next;
        }
        [conferenceButton setEnabled:enabled];
    } else {
        if([pauseButton isHidden]) {
            [pauseButton setHidden:true]; // change it false if reuired prashant
            [conferenceButton setHidden:true];
        }
    }
    
    // Disable transfert in conference
    if(linphone_core_get_current_call(lc) == NULL) {
        [optionsTransferButton setEnabled:FALSE];
    } else {
        [optionsTransferButton setEnabled:FALSE]; // change false if required prashant
    }
    
    switch(state) {
        LinphoneCallEnd:
        LinphoneCallError:
        LinphoneCallIncoming:
        LinphoneCallOutgoing:
            [self hidePad:TRUE];
            [self hideOptions:TRUE];
            [self hideRoutes:TRUE];
        default:
            break;
    }
    /*if(state==LinphoneCallReleased){
        optionsTransferButton.enabled=FALSE;
        if (dutaionTime != nil) {
            [dutaionTime invalidate];
            dutaionTime = nil;
        }
        [self onHangTouch:self];
        [self.navigationController popViewControllerAnimated: YES];
        
    }*/
    if(optionsTransferButton.enabled==FALSE && state!=LinphoneCallReleased){
        //[self getCreditKey];
        if(canHideInCallView)
            [self.navigationController popViewControllerAnimated: YES];
    }
    FastAddressBook *fastAddressBook = [[FastAddressBook alloc] init];
    const LinphoneAddress *addr = linphone_call_get_remote_address(call);
    NSString* address = nil;
    NSString *normalizedSipAddress = nil;
    if(addr != NULL) {
        BOOL useLinphoneAddress = true;
        // contact name
        char* lAddress = linphone_address_as_string_uri_only(addr);
        if(lAddress) {
            normalizedSipAddress = [FastAddressBook normalizeSipURI:[NSString stringWithUTF8String:lAddress]];
            ABRecordRef contact = [fastAddressBook getContact:normalizedSipAddress];
            if(contact) {
                address = [FastAddressBook getContactDisplayName:contact];
                useLinphoneAddress = false;
            }
            ms_free(lAddress);
        }
        if(useLinphoneAddress) {
            //NSString *nums = nil;
            const char* lDisplayName = linphone_address_get_display_name(addr);
            if (lDisplayName)
                address = [NSString stringWithUTF8String:lDisplayName];
            else{
                //address = [FastAddressBook normalizeSipURI:[NSString stringWithUTF8String:lAddress]];
                NSArray *coutNum = [normalizedSipAddress componentsSeparatedByString:@":"];
                if(coutNum.count > 1){
                    NSString *dd = [coutNum objectAtIndex:1];
                    NSArray *atRate = [dd componentsSeparatedByString:@"@"];
                    if(atRate.count > 1){
                        address = [atRate objectAtIndex:0];
                    }
                }
            }
            [nameAddress setText:address];
        }
    }
    if(address == nil) {
        address = @"Unknown";
    }
     //NSLog(@"check log %@", [[LinphoneManager instance].logs componentsJoinedByString:@"\n"]);
}

/*- (void) updateTimer{
    //LinphoneCore* lc = [LinphoneManager getLc];
    BOOL pending = false;
    BOOL security = true;
    LinphoneCall* call = nil;
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
    //linpho
    int duration = linphone_call_get_duration(call);
    //[durationTimer setTextColor:[UIColor darkGrayColor]];
    //NSString *dura =[NSString stringWithFormat:@"%02i:%02i", (duration/60), duration - 60 * (duration / 60), nil];
    [durationTimer setText:[NSString stringWithFormat:@"%02i:%02i", (duration/60), duration - 60 * (duration / 60), nil]];
}*/

- (void)callUpdate:(LinphoneCall *)call state:(LinphoneCallState)state animated:(BOOL)animated {
	LinphoneCore *lc = [LinphoneManager getLc];
    
    
    
    // Fake call update
    if(call == NULL) {
        return;
    }
    
	switch (state) {
		case LinphoneCallIncomingReceived:
		case LinphoneCallOutgoingInit:
        {
            if(linphone_core_get_calls_nb(lc) > 1) {
                [self minimizeAll];
            }
        }
        case LinphoneCallOutgoingRinging:
        {
            NSLog(@"call connected Khatri");
        }
		case LinphoneCallConnected:
        {
            NSLog(@"call connected Khatri");
        }
		case LinphoneCallStreamsRunning:
        {
			//check video
            NSLog(@"call connected Khatri streaming");
			if (linphone_call_params_video_enabled(linphone_call_get_current_params(call))) {
				[self displayVideoCall:animated];
			} else {
				[self displayTableCall:animated];
                const LinphoneCallParams* param = linphone_call_get_current_params(call);
				const LinphoneCallAppData* callAppData = linphone_call_get_user_pointer(call);
				if(state == LinphoneCallStreamsRunning
				   && callAppData->videoRequested
				   && linphone_call_params_low_bandwidth_enabled(param)) {
					//too bad video was not enabled because low bandwidth
					UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Low bandwidth", nil)
																	message:NSLocalizedString(@"Video cannot be activated because of low bandwidth condition, only audio is available", nil)
																   delegate:nil
														  cancelButtonTitle:NSLocalizedString(@"Continue", nil)
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					callAppData->videoRequested=FALSE; /*reset field*/
				}
            }
            if(state!=LinphoneCallPaused || state != LinphoneCallPausing){
                [pauseButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            }
			break;
        }
        case LinphoneCallUpdatedByRemote:
        {
            const LinphoneCallParams* current = linphone_call_get_current_params(call);
            const LinphoneCallParams* remote = linphone_call_get_remote_params(call);
            
            /* remote wants to add video */
            if (linphone_core_video_enabled(lc) && !linphone_call_params_video_enabled(current) &&
                linphone_call_params_video_enabled(remote) &&
                !linphone_core_get_video_policy(lc)->automatically_accept) {
                linphone_core_defer_call_update(lc, call);
                [self displayAskToEnableVideoCall:call];
            } else if (linphone_call_params_video_enabled(current) && !linphone_call_params_video_enabled(remote)) {
                [self displayTableCall:animated];
            }
            break;
        }
        case LinphoneCallPausing:{
            [pauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            
        }
        case LinphoneCallPaused:
        {
            [pauseButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        }
        case LinphoneCallPausedByRemote:
        {
            [self displayTableCall:animated];
            break;
        }
        case LinphoneCallEnd:
        case LinphoneCallError:
        {
            if(linphone_core_get_calls_nb(lc) <= 2 && !videoShown) {
                [self maximizeAll];
            }
            break;
        }
        default:
            break;
	}
    
}

- (void)displayVideoCall:(BOOL)animated {
    //[self enableVideoDisplay:animated];
}

- (void)displayTableCall:(BOOL)animated {
    //[self disableVideoDisplay:animated];
}

- (void)displayAskToEnableVideoCall:(LinphoneCall*) call{
    
}

- (void)update {
    if(data == nil || data->call == NULL) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot update call cell: null call or data"];
        return;
    }
    LinphoneCall *call = data->call;
    
    //[pauseButton setType:UIPauseButtonType_Call call:call];
    
    //[addressLabel setText:data.address];
    //[avatarImage setImage:data.image];
    
    LinphoneCallState state = linphone_call_get_state(call);
    if(!conferenceCell) {
        if(state == LinphoneCallOutgoingRinging) {
            //[stateImage setImage:[UIImage imageNamed:@"call_state_ringing_default.png"]];
            //[stateImage setHidden:false];
            [pauseButton setHidden:true];
        } else if(state == LinphoneCallOutgoingInit || state == LinphoneCallOutgoingProgress){
            //[stateImage setImage:[UIImage imageNamed:@"call_state_outgoing_default.png"]];
            //[stateImage setHidden:false];
            [pauseButton setHidden:true];
        } else {
            //[stateImage setHidden:true];
            [pauseButton setHidden:true]; // change false if required prashant
            [pauseButton update];
        }
        //[removeButton setHidden:true];
        /*if(firstCell) {
            [headerBackgroundImage setImage:[UIImage imageNamed:@"cell_call_first.png"]];
            [headerBackgroundHighlightImage setImage:[UIImage imageNamed:@"cell_call_first_highlight.png"]];
        } else {
            [headerBackgroundImage setImage:[UIImage imageNamed:@"cell_call.png"]];
            [headerBackgroundHighlightImage setImage:[UIImage imageNamed:@"cell_call_highlight.png"]];
        }*/
    } else {
        //[stateImage setHidden:true];
        [pauseButton setHidden:true];
        //[removeButton setHidden:false];
        //[headerBackgroundImage setImage:[UIImage imageNamed:@"cell_conference.png"]];
    }
    
    int duration = linphone_call_get_duration(call);
    [durationTimer setText:[NSString stringWithFormat:@"%02i:%02i", (duration/60), (duration%60), nil]];
    
    /*if(!data->minimize) {
        CGRect frame = [self frame];
        frame.size.height = [otherView frame].size.height;
        [self setFrame:frame];
        [otherView setHidden:false];
    } else {
        CGRect frame = [self frame];
        frame.size.height = [headerView frame].size.height;
        [self setFrame:frame];
        [otherView setHidden:true];
    }*/
    
    //[self updateStats];
    
    //[self updateDetailsView];
}

- (void)updateStats {
    if(data == nil || data->call == NULL) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot update call cell: null call or data"];
        return;
    }
    LinphoneCall *call = data->call;
    
    const LinphoneCallParams *params = linphone_call_get_current_params(call);
    {
        const PayloadType* payload = linphone_call_params_get_used_audio_codec(params);
        if(payload != NULL) {
            [audioCodecLabel setText:[NSString stringWithFormat:@"%s/%i/%i", payload->mime_type, payload->clock_rate, payload->channels]];
        } else {
            [audioCodecLabel setText:NSLocalizedString(@"No codec", nil)];
        }
        /*const LinphoneCallStats *stats = linphone_call_get_audio_stats(call);
        if(stats != NULL) {
            [audioUploadBandwidthLabel setText:[NSString stringWithFormat:@"%1.1f kbits/s", stats->upload_bandwidth]];
            [audioDownloadBandwidthLabel setText:[NSString stringWithFormat:@"%1.1f kbits/s", stats->download_bandwidth]];
            [audioIceConnectivityLabel setText:[UICallCell iceToString:stats->ice_state]];
        } else {
            [audioUploadBandwidthLabel setText:@""];
            [audioDownloadBandwidthLabel setText:@""];
            [audioIceConnectivityLabel setText:@""];
        }*/
    }
    
    {
        const PayloadType* payload = linphone_call_params_get_used_video_codec(params);
        if(payload != NULL) {
            [videoCodecLabel setText:[NSString stringWithFormat:@"%s/%i", payload->mime_type, payload->clock_rate]];
        } else {
            [videoCodecLabel setText:NSLocalizedString(@"No codec", nil)];
        }
        
        const LinphoneCallStats *stats = linphone_call_get_video_stats(call);
        
        MSVideoSize sentSize = linphone_call_params_get_sent_video_size(params);
        MSVideoSize recvSize = linphone_call_params_get_received_video_size(params);
        
        /*if(stats != NULL) {
            [videoUploadBandwidthLabel setText:[NSString stringWithFormat:@"%1.1f kbits/s", stats->upload_bandwidth]];
            [videoDownloadBandwidthLabel setText:[NSString stringWithFormat:@"%1.1f kbits/s", stats->download_bandwidth]];
            [videoIceConnectivityLabel setText:[UICallCell iceToString:stats->ice_state]];
            [videoSentSizeLabel setText:[NSString stringWithFormat:@"%dx%d",sentSize.width, sentSize.height]];
            [videoRecvSizeLabel setText:[NSString stringWithFormat:@"%dx%d",recvSize.width, recvSize.height]];
        } else {
            [videoUploadBandwidthLabel setText:@""];
            [videoDownloadBandwidthLabel setText:@""];
            [videoIceConnectivityLabel setText:@""];
            [videoSentSizeLabel setText:@"0x0"];
            [videoRecvSizeLabel setText:@"0x0"];
            
        }*/
    }
}


- (void)updateDetailsView {
    if(data == nil || data->call == NULL) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot update call cell: null call or data"];
        return;
    }
    /*if(data->view == UICallCellOtherView_Avatar && avatarView.isHidden) {
        [self->avatarView setHidden:FALSE];
        [self->audioStatsView setHidden:TRUE];
        [self->videoStatsView setHidden:TRUE];
    } else if(data->view == UICallCellOtherView_AudioStats && audioStatsView.isHidden) {
        [self->avatarView setHidden:TRUE];
        [self->audioStatsView setHidden:FALSE];
        [self->videoStatsView setHidden:TRUE];
    } else if(data->view == UICallCellOtherView_VideoStats && videoStatsView.isHidden) {
        [self->avatarView setHidden:TRUE];
        [self->audioStatsView setHidden:TRUE];
        [self->videoStatsView setHidden:FALSE];
    }*/
}

- (void)selfUpdate {
   /* UITableView *parentTable = (UITableView *)self.superview;
    
    while( parentTable != nil && ![parentTable isKindOfClass:[UITableView class]] ) parentTable = (UITableView *)[parentTable superview];
    
    if(parentTable != nil) {
        NSIndexPath *index= [parentTable indexPathForCell:self];
        if(index != nil) {
            [parentTable reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:index, nil] withRowAnimation:false];
        }
    }*/
}


- (void)bluetoothAvailabilityUpdate:(bool)available {
    if (available) {
        [self hideSpeaker];
    } else {
        [self showSpeaker];
    }
}

#pragma mark -

- (void)showAnimation:(NSString*)animationID target:(UIView*)target completion:(void (^)(BOOL finished))completion {
    CGRect frame = [target frame];
    int original_y = frame.origin.y;
    frame.origin.y = [[self view] frame].size.height;
    [target setFrame:frame];
    [target setHidden:FALSE];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = [target frame];
                         frame.origin.y = original_y;
                         [target setFrame:frame];
                     }
                     completion:^(BOOL finished){
                         CGRect frame = [target frame];
                         frame.origin.y = original_y;
                         [target setFrame:frame];
                         completion(finished);
                     }];
}

- (void)hideAnimation:(NSString*)animationID target:(UIView*)target completion:(void (^)(BOOL finished))completion {
    CGRect frame = [target frame];
    int original_y = frame.origin.y;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = [target frame];
                         frame.origin.y = [[self view] frame].size.height;
                         [target setFrame:frame];
                     }
                     completion:^(BOOL finished){
                         CGRect frame = [target frame];
                         frame.origin.y = original_y;
                         [target setHidden:TRUE];
                         [target setFrame:frame];
                         completion(finished);
                     }];
}

- (void)showPad:(BOOL)animated {
    //[dialerButton setOn];
    if([padView isHidden]) {
        if(animated) {
            [self showAnimation:@"show" target:padView completion:^(BOOL finished){}];
        } else {
            [padView setHidden:FALSE];
        }
    }
}

- (void)hidePad:(BOOL)animated {
    //[dialerButton setOff];
    if(![padView isHidden]) {
        if(animated) {
            [self hideAnimation:@"hide" target:padView completion:^(BOOL finished){}];
        } else {
            [padView setHidden:TRUE];
        }
    }
}

- (void)showRoutes:(BOOL)animated {
    if (![LinphoneManager runningOnIpad]) {
        //[routesButton setOn];
        [routesBluetoothButton setSelected:[[LinphoneManager instance] bluetoothEnabled]];
        [routesSpeakerButton setSelected:[[LinphoneManager instance] speakerEnabled]];
        [routesReceiverButton setSelected:!([[LinphoneManager instance] bluetoothEnabled] || [[LinphoneManager instance] speakerEnabled])];
        if([routesView isHidden]) {
            if(animated) {
                [self showAnimation:@"show" target:routesView completion:^(BOOL finished){}];
            } else {
                [routesView setHidden:FALSE];
            }
        }
    }
}

- (void)hideRoutes:(BOOL)animated {
    if (![LinphoneManager runningOnIpad]) {
        //[routesButton setOff];
        if(![routesView isHidden]) {
            if(animated) {
                [self hideAnimation:@"hide" target:routesView completion:^(BOOL finished){}];
            } else {
                [routesView setHidden:TRUE];
            }
        }
    }
}

- (void)showOptions:(BOOL)animated {
    //[optionsButton setOn];
    if([optionsView isHidden]) {
        if(animated) {
            [self showAnimation:@"show" target:optionsView completion:^(BOOL finished){}];
        } else {
            [optionsView setHidden:FALSE];
        }
    }
}

- (void)hideOptions:(BOOL)animated {
    //[optionsButton setOff];
    if(![optionsView isHidden]) {
        if(animated) {
            [self hideAnimation:@"hide" target:optionsView completion:^(BOOL finished){}];
        } else {
            [optionsView setHidden:TRUE];
        }
    }
}

- (void)showSpeaker {
    if (![LinphoneManager runningOnIpad]) {
        [speakerButton setHidden:FALSE];
        [routesButton setHidden:TRUE];
    }
}

- (void)hideSpeaker {
    if (![LinphoneManager runningOnIpad]) {
        [speakerButton setHidden:TRUE];
        [routesButton setHidden:FALSE];
    }
}


#pragma mark - Action Functions

- (IBAction)onPadClick:(id)sender {
    if([padView isHidden]) {
        [self showPad:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    } else {
        [self hidePad:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    }
}

- (IBAction)onRoutesBluetoothClick:(id)sender {
    [self hideRoutes:TRUE];
    [[LinphoneManager instance] setBluetoothEnabled:TRUE];
}

- (IBAction)onRoutesReceiverClick:(id)sender {
    [self hideRoutes:TRUE];
    [[LinphoneManager instance] setSpeakerEnabled:FALSE];
    [[LinphoneManager instance] setBluetoothEnabled:FALSE];
}

- (IBAction)onRoutesSpeakerClick:(id)sender{
    [self hideRoutes:TRUE];
    [[LinphoneManager instance] setSpeakerEnabled:TRUE];
}

- (IBAction)onRoutesClick:(id)sender {
    if([routesView isHidden]) {
        [self showRoutes:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    } else {
        [self hideRoutes:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    }
}

- (IBAction)onOptionsTransferClick:(id)sender {
    [self hideOptions:TRUE];
    // Go to dialer view
    /*DialerViewController *controller = DYNAMIC_CAST([[PhoneMainView instance] changeCurrentView:[DialerViewController compositeViewDescription]], DialerViewController);
     if(controller != nil) {
     [controller setAddress:@""];
     [controller setTransferMode:TRUE];
     }*/
}

-(IBAction)onOptionsAddClick:(id)sender{
    [[self appDelegate]setAddCallValue:true];
    tabBarview *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    [controller setSelectedIndex:3];
    [self.navigationController pushViewController:controller animated:NO];
    
}

- (IBAction)onOptionsClick:(id)sender {
    if([optionsView isHidden]) {
        [self showOptions:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    } else {
        [self hideOptions:[[LinphoneManager instance] lpConfigBoolForKey:@"animations_preference"]];
    }
}

- (IBAction)onConferenceClick:(id)sender {
    linphone_core_add_all_to_conference([LinphoneManager getLc]);
    UIImage *btnImage = [UIImage imageNamed:@"mer_btn_act.png"];
    [mergerButton setImage:btnImage forState:UIControlStateNormal];
    [mergerButton addTarget:self action:@selector(onRemoveConference:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onRemoveConference:(id)sender{
    UIImage *btnImage = [UIImage imageNamed:@"mer_btn.png"];
    [mergerButton setImage:btnImage forState:UIControlStateNormal];
    [mergerButton addTarget:self action:@selector(onConferenceClick:) forControlEvents:UIControlEventTouchUpInside];
    if(data != nil && data->call != NULL) {
        linphone_core_remove_from_conference([LinphoneManager getLc], data->call);
    }
}

#pragma mark - TPMultiLayoutViewController Functions

- (NSDictionary*)attributesForView:(UIView*)view {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    [attributes setObject:[NSValue valueWithCGRect:view.frame] forKey:@"frame"];
    [attributes setObject:[NSValue valueWithCGRect:view.bounds] forKey:@"bounds"];
    if([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        [LinphoneUtils buttonMultiViewAddAttributes:attributes button:button];
    }
    [attributes setObject:[NSNumber numberWithInteger:view.autoresizingMask] forKey:@"autoresizingMask"];
    
    return attributes;
}

- (void)applyAttributes:(NSDictionary*)attributes toView:(UIView*)view {
    view.frame = [[attributes objectForKey:@"frame"] CGRectValue];
    view.bounds = [[attributes objectForKey:@"bounds"] CGRectValue];
    if([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        [LinphoneUtils buttonMultiViewApplyAttributes:attributes button:button];
    }
    view.autoresizingMask = [[attributes objectForKey:@"autoresizingMask"] integerValue];
}

-(IBAction)onHangTouch:(id)sender{
    NSLog(@"HANG Button");
    if(![flipView isHidden]){
        [flipView setHidden:true];
        [dialTextView setHidden:true];
        [smallEndButton setHidden:true];
        [hideButton setHidden:true];
        [hangupButton setHidden:false];
        [nameAddress setHidden:false];
        [durationTimer setHidden:false];
        [endlbl setHidden:false];
    }
    if([LinphoneManager isLcReady]) {
        LinphoneCore* lc = [LinphoneManager getLc];
        LinphoneCall* currentcall = linphone_core_get_current_call(lc);
        if (linphone_core_is_in_conference(lc) || // In conference
            (linphone_core_get_conference_size(lc) > 0 && [self callCount:lc] == 0) // Only one conf
            ) {
            linphone_core_terminate_conference(lc);
        } else if(currentcall != NULL) { // In a call
            linphone_core_terminate_call(lc, currentcall);
        } else {
            const MSList* calls = linphone_core_get_calls(lc);
            if (ms_list_size(calls) == 1) { // Only one call
                linphone_core_terminate_call(lc,(LinphoneCall*)(calls->data));
            }
        }
    } else {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot trigger hangup button: Linphone core not ready"];
    }
}

- (int)callCount:(LinphoneCore*) lc {
    int count = 0;
    const MSList* calls = linphone_core_get_calls(lc);
    
    while (calls != 0) {
        if (![self isInConference:((LinphoneCall*)calls->data)]) {
            count++;
        }
        calls = calls->next;
    }
    return count;
}

- (bool)isInConference:(LinphoneCall*) call {
    if (!call)
        return false;
    return linphone_call_is_in_conference(call);
}

#pragma mark - Static Functions

-(IBAction)onSpeakerTouch:(id)sender{
    
    //UISpeakerButton *sb = [[UISpeakerButton alloc]init];
    if(!speakerEnable){
        /*[sb onOn];
         [sb onUpdate];*/
        speakerEnable=TRUE;
        [[LinphoneManager instance] setSpeakerEnabled:speakerEnable];
        [speakerButton setSelected:YES];
        //[speakerButton setImage:[UIImage imageNamed:@"3_en_enb.png"] forState:UIControlStateNormal];
    }
    else{
        /*[sb onOff];
         [sb onUpdate];*/
        speakerEnable=FALSE;
        [[LinphoneManager instance] setSpeakerEnabled:speakerEnable];
        [speakerButton setSelected:NO];
        //[speakerButton setImage:[UIImage imageNamed:@"3_en.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)onMuteTouch:(id)sender{
    
    if(!self.muteEnable){
        if(![LinphoneManager isLcReady]) {
         [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle mic button: Linphone core not ready"];
         return;
         }
        linphone_core_mute_mic([LinphoneManager getLc], true);
        self.muteEnable=TRUE;
        [microButton setSelected:YES];
    }
    else{
        if(![LinphoneManager isLcReady]) {
         [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle mic button: Linphone core not ready"];
         return;
         }
        linphone_core_mute_mic([LinphoneManager getLc], false);
        self.muteEnable=FALSE;
        [microButton setSelected:NO];
    }
    
}

- (IBAction)onAddTouch:(id)sender{
    
}

- (IBAction)onVideoTouch:(id)sender{
    
}
- (IBAction)onDialTouch:(id)sender{
    if([flipView isHidden]){
        [flipView setHidden:false];
        [dialTextView setHidden:false];
        [smallEndButton setHidden:false];
        [hideButton setHidden:false];
        [hangupButton setHidden:true];
        [nameAddress setHidden:true];
        [durationTimer setHidden:true];
        [endlbl setHidden:true];
        //UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseIn | UIViewAnimationTransitionFlipFromRight;
        //[UIView transitionWithView:flipView duration:1.0  options:options animations:^(void) {                            flipView.transform = CGAffineTransformMakeScale(1, 0); } completion:nil];
        self.view.alpha=0.6;
        dialTextView.text=@"";
        [UIView transitionFromView:routesView toView:flipView duration:0.2 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
        
    }
    else{
        self.view.alpha=1.0;
        [flipView setHidden:true];
        [dialTextView setHidden:true];
        [smallEndButton setHidden:true];
        [hideButton setHidden:true];
        [hangupButton setHidden:false];
        [nameAddress setHidden:false];
        [durationTimer setHidden:false];
        [endlbl setHidden:false];
        //[UIView transitionFromView:flipView toView:routesView duration:0.2 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    }
}


- (void)viewDidUnload {
    
    [self setFlipView:nil];
    [self setSmallEndButton:nil];
    [self setDialTextView:nil];
    [self setHideButton:nil];
    [self setInfoImageView:nil];
    [super viewDidUnload];
}

-(void) getCreditKey
{
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] init];
    [mGetCrHandler getCredit];
    
    //NSLog(@"Dails updatee");
    
}

// start calltableview

-(NSInteger)dataNumbers{
    int count = 0;
    
    LinphoneCore* lc = [LinphoneManager getLc];
    
    //if(section == CallSection) {
        count = [self callCount:lc];
   /* } else {
        count = linphone_core_get_conference_size(lc);
        if(linphone_core_is_in_conference(lc)) {
            count--;
        }
    }*/
    NSInteger i=0;
    //for(NSInteger i =0; i<1; i++){
        LinphoneCall* currentCall = linphone_core_get_current_call(lc);
        LinphoneCall* call = [InCallViewController retrieveCallAtIndex:i inConference:false];
        [self setData:[self addCallData:call]];
    //}
    
    return count;
}

+ (LinphoneCall*)retrieveCallAtIndex: (NSInteger) index inConference:(bool) conf{
    const MSList* calls = linphone_core_get_calls([LinphoneManager getLc]);
    
    while (calls != 0) {
        if ([self isInConference:(LinphoneCall*)calls->data] == conf) {
            if (index == 0)
                break;
            index--;
        }
        calls = calls->next;
    }
    
    if (calls == 0) {
        [LinphoneLogger logc:LinphoneLoggerError format:"Cannot find call with index %d (in conf: %d)", index, conf];
        return nil;
    } else {
        return (LinphoneCall*)calls->data;
    }
}

+ (bool)isInConference:(LinphoneCall*) call {
    if (!call)
        return false;
    return linphone_call_is_in_conference(call);
}

- (UICallCellData*)addCallData:(LinphoneCall*) call {
    // Handle data associated with the call
    UICallCellData * data1 = nil;
    if(call != NULL) {
        LinphoneCallAppData* appData = (LinphoneCallAppData*) linphone_call_get_user_pointer(call);
        if(appData != NULL) {
            data1 = [appData->userInfos objectForKey:kLinphoneInCallCellData];
            if(data1 == nil) {
                data1 = [[[UICallCellData alloc] init:call minimized:minimized] autorelease];
                [appData->userInfos setObject:data1 forKey:kLinphoneInCallCellData];
            }
        }
    }
    NSLog(@"DATA 1 - %@", data1);
    return data1;
}

// start calltable

- (void)setData:(UICallCellData *)adata {
    if(adata == data) {
        return;
    }
    if(data != nil) {
        [data release];
        data = nil;
    }
    if(adata != nil) {
        data = [adata retain];
    }
    
}

- (UICallCellData*)getCallData:(LinphoneCall*) call {
    // Handle data associated with the call
    UICallCellData * data1 = nil;
    if(call != NULL) {
        LinphoneCallAppData* appData = (LinphoneCallAppData*) linphone_call_get_user_pointer(call);
        if(appData != NULL) {
            data1 = [appData->userInfos objectForKey:kLinphoneInCallCellData];
        }
    }
    return data1;
}

- (void)minimizeAll {
    
    const MSList *list = linphone_core_get_calls([LinphoneManager getLc]);
    minimized = true;
    while(list != NULL) {
        UICallCellData *data1 = [self getCallData:(LinphoneCall*)list->data];
        if(data1) {
            data1->minimize = true;
        } else {
        }
        list = list->next;
    }
    //[self.view reloadData];
}

- (void)maximizeAll {
    const MSList *list = linphone_core_get_calls([LinphoneManager getLc]);
    minimized = false;
    while(list != NULL) {
        UICallCellData *data1 = [self getCallData:(LinphoneCall*)list->data];
        if(data1) {
            data1->minimize = false;
        }
        list = list->next;
    }
    //[self.view reloadData];
}

- (IBAction)callContact{
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
    NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    // NSLog(@"[AddressBook] Person selected: %@, %@", lastName, firstName);
    
    [firstName release];
    [lastName release];
    
    return YES;
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
    
    
    
    //NSLog(@"details %@", selectedDetails);
    
    NSArray *userData2;
    userData2 = [[NSArray alloc] initWithObjects:first,last,myPhone,phoneLabel,@"6", nil];
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    //[sqliteDB saveCallLog:userData2];
    if(linphone_core_is_network_reachable([LinphoneManager getLc]) && [myPhone length]>2){
        [[LinphoneManager instance] call:myPhone displayName:first transfer:FALSE];
        //[self performSegueWithIdentifier:@"inCallScreen" sender:self];
    }
        
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
    
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)onRemoveConf{
    
}

- (IBAction)addOne:(id)sender{
    NSString *number = @"1";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addTwo:(id)sender{
    NSString *number = @"2";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addThree:(id)sender{
    NSString *number = @"3";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addFour:(id)sender{
    NSString *number = @"4";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addFive:(id)sender{
    NSString *number = @"5";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addSix:(id)sender{
    NSString *number = @"6";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addSeven:(id)sender{
    NSString *number = @"7";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addEight:(id)sender{
    NSString *number = @"8";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addNine:(id)sender{
    NSString *number = @"9";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addZero:(id)sender{
    NSString *number = @"0";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addAstrik:(id)sender{
    NSString *number = @"*";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}

- (IBAction)addHash:(id)sender{
    NSString *number = @"#";
    NSString *allNumber =  dialTextView.text;
    if(allNumber.length < 17){
        if(allNumber.length==0)
            allNumber=@"";
        NSString *newNumber = [allNumber stringByAppendingString:number];
        dialTextView.text = newNumber;
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
