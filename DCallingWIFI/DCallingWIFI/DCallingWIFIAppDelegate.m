//
//  DCallingWIFIAppDelegate.m
//  DCalling WiFi
//
//  Created by David C. Son on 03.01.12.
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

#import "DCallingWIFIAppDelegate.h"
#import "PreferencesHandler.h"
#import "DataModelRecent.h"
#import "getCreditHandler.h"

//FOR SIP

#import "KeypadViewController.h"
#import "AddressBook/ABPerson.h"

#import "CoreTelephony/CTCallCenter.h"
#import "CoreTelephony/CTCall.h"
#import "LinphoneCoreSettingsStore.h"
#include "LinphoneManager.h"
#include "linphonecore.h"
#import "tabBarview.h"

@implementation DCallingWIFIAppDelegate

@synthesize window = _window;

@synthesize started, checkVal, numbers, dName, configURL, addCallValue;

- (id)init {
    self = [super init];
    if(self != nil) {
        self->started = FALSE;
    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    sqliteDB = [[SQLiteDBHandler alloc]init];
    BOOL status = [sqliteDB initDB];
    NSLog(@"Delegates Status LINPHONE SIP %d", status);
    LinphoneManager* instance = [LinphoneManager instance];
    BOOL background_mode = [instance lpConfigBoolForKey:@"backgroundmode_preference"];
    BOOL start_at_boot   = [instance lpConfigBoolForKey:@"start_at_boot_preference"];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]
		&& [UIApplication sharedApplication].applicationState ==  UIApplicationStateBackground)
    {
        // we've been woken up directly to background;
        if( !start_at_boot || !background_mode ) {
            // autoboot disabled or no background, and no push: do nothing and wait for a real launch
			/*output a log with NSLog, because the ortp logging system isn't activated yet at this time*/
			NSLog(@"DCalling launch doing nothing because start_at_boot or background_mode are not activated.", NULL);
            return YES;
        }
        
    }
	bgStartId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
		[LinphoneLogger log:LinphoneLoggerWarning format:@"Background task for application launching expired."];
		[[UIApplication sharedApplication] endBackgroundTask:bgStartId];
	}];
    [self startApplication];
    // other setup tasks here….
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    [mPref setInstalledDB:YES];
    NSString *deviceToken  = [mPref getDeviceToken];
    if([deviceToken length] < 4){
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    }
    
    //[FBProfilePictureView class];
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    [LinphoneLogger logc:LinphoneLoggerLog format:"applicationWillResignActive"];
    if(![LinphoneManager isLcReady]) return;
    LinphoneCore* lc = [LinphoneManager getLc];
    LinphoneCall* call = linphone_core_get_current_call(lc);
	
	
    if (call){
		/* save call context */
		LinphoneManager* instance = [LinphoneManager instance];
		instance->currentCallContextBeforeGoingBackground.call = call;
		instance->currentCallContextBeforeGoingBackground.cameraIsEnabled = linphone_call_camera_enabled(call);
        
		const LinphoneCallParams* params = linphone_call_get_current_params(call);
		if (linphone_call_params_video_enabled(params)) {
			linphone_call_enable_camera(call, false);
		}
	}
    
    if (![[LinphoneManager instance] resignActive]) {
        
    }
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [LinphoneLogger logc:LinphoneLoggerLog format:"applicationDidEnterBackground"];
	if(![LinphoneManager isLcReady]) return;
	[[LinphoneManager instance] enterBackgroundMode];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];    
    NSString *tk = [mPref getToken];
   // NSLog(@"log %@", tk);
    
    if([tk length]>0){
        [self performSelectorInBackground:@selector(superCredit) withObject:nil];
        
    }
    
    [LinphoneLogger logc:LinphoneLoggerLog format:"applicationDidBecomeActive"];
    [self startApplication];
    
	[[LinphoneManager instance] becomeActive];
    
    
    LinphoneCore* lc = [LinphoneManager getLc];
    LinphoneCall* call = linphone_core_get_current_call(lc);
    
	if (call){
		LinphoneManager* instance = [LinphoneManager instance];
		if (call == instance->currentCallContextBeforeGoingBackground.call) {
			const LinphoneCallParams* params = linphone_call_get_current_params(call);
			if (linphone_call_params_video_enabled(params)) {
				linphone_call_enable_camera(
                                            call,
                                            instance->currentCallContextBeforeGoingBackground.cameraIsEnabled);
			}
			instance->currentCallContextBeforeGoingBackground.call = 0;
		} else if ( linphone_call_get_state(call) == LinphoneCallIncomingReceived ) {
            //[[PhoneMainView  instance ] displayIncomingCall:call];
            // in this case, the ringing sound comes from the notification.
            // To stop it we have to do the iOS7 ring fix...            
            [self fixRing];
        }
	}
    //[FBSession.activeSession handleDidBecomeActive];
    //[FBSettings publishInstall:[FBSession defaultAppID]];
    NSString *fbAppID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookAppID"];
    //NSLog(@"version %@", fbAppID);
    [FBSettings setDefaultAppID:fbAppID];
    [FBAppEvents activateApp];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)startApplication {
    // Restart Linphone Core if needed
    if(![LinphoneManager isLcReady]) {
        [[LinphoneManager instance]	startLibLinphone];
    }
    if([LinphoneManager isLcReady]) {
     
     
     // Only execute one time at application start
        if(!started) {
            started = TRUE;
            [self startUp];
        }
     }
}

- (void)fixRing{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        // iOS7 fix for notification sound not stopping.
        // see http://stackoverflow.com/questions/19124882/stopping-ios-7-remote-notification-sound
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *scheme = [[url scheme] lowercaseString];
    if ([scheme isEqualToString:@"linphone-config-http"] || [scheme isEqualToString:@"linphone-config-https"]) {
        configURL = [[NSString alloc] initWithString:[[url absoluteString] stringByReplacingOccurrencesOfString:@"linphone-config-" withString:@""]];
        UIAlertView* confirmation = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remote configuration",nil)
                                                               message:NSLocalizedString(@"This operation will load a remote configuration. Continue ?",nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"No",nil)
                                                     otherButtonTitles:NSLocalizedString(@"Yes",nil),nil];
        confirmation.tag = 1;
        [confirmation show];
        [confirmation release];
    } else {
        [self startApplication];
        if([LinphoneManager isLcReady]) {
            /*if([[url scheme] isEqualToString:@"sip"]) {
                // Go to Dialer view
                DialerViewController *controller = DYNAMIC_CAST([[PhoneMainView instance] changeCurrentView:[DialerViewController compositeViewDescription]], DialerViewController);
                if(controller != nil) {
                    [controller setAddress:[url absoluteString]];
                }
            }*/
        }
    }
	return YES;
}

- (void)processRemoteNotification:(NSDictionary*)userInfo{
	if ([LinphoneManager instance].pushNotificationToken==Nil){
		[LinphoneLogger log:LinphoneLoggerLog format:@"Ignoring push notification we did not subscribed."];
		return;
	}
	
	NSDictionary *aps = [userInfo objectForKey:@"aps"];
	
    if(aps != nil) {
        NSDictionary *alert = [aps objectForKey:@"alert"];
        if(alert != nil) {
            NSString *loc_key = [alert objectForKey:@"loc-key"];
			/*if we receive a remote notification, it is probably because our TCP background socket was no more working.
			 As a result, break it and refresh registers in order to make sure to receive incoming INVITE or MESSAGE*/
			LinphoneCore *lc = [LinphoneManager getLc];
			if (linphone_core_get_calls(lc)==NULL){ //if there are calls, obviously our TCP socket shall be working
				linphone_core_set_network_reachable(lc, FALSE);
				[LinphoneManager instance].connectivity=none; /*force connectivity to be discovered again*/
				if(loc_key != nil) {
					if([loc_key isEqualToString:@"IM_MSG"]) {
						//[[PhoneMainView instance] addInhibitedEvent:kLinphoneTextReceived];
						//[[PhoneMainView instance] changeCurrentView:[ChatViewController compositeViewDescription]];
					} else if([loc_key isEqualToString:@"IC_MSG"]) {
						//it's a call
                         NSLog(@"CHECK INCOMING RINGING 42");
						NSString *callid=[userInfo objectForKey:@"call-id"];
						if (callid)
							[[LinphoneManager instance] enableAutoAnswerForCallId:callid];
						else
							[LinphoneLogger log:LinphoneLoggerError format:@"PushNotification: does not have call-id yet, fix it !"];
                        
						[self fixRing];
					}
				}
			}
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [LinphoneLogger log:LinphoneLoggerLog format:@"Application Will Terminate"];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    //[FBSession.activeSession close];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //NSLog(@"devToken=%@",deviceToken);
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    
    //NSString *device = [[NSString alloc] initWithData:deviceToken encoding:NSASCIIStringEncoding];
    
    NSString *device = [[[deviceToken description]
      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
     //NSLog(@"StringToken=%@",device);
    if(![[mPref getDeviceToken] isEqualToString:device]){
        [mPref setDeviceToken:device];
        //[self alertNotice:@"" withMSG:[NSString stringWithFormat:@"devToken=%@",deviceToken] cancleButtonTitle:@"OK" otherButtonTitle:@""];
    }
    [LinphoneLogger log:LinphoneLoggerLog format:@"PushNotification: Token %@", deviceToken];
    [[LinphoneManager instance] setPushNotificationToken:deviceToken];
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
    //[self alertNotice:@"" withMSG:[NSString stringWithFormat:@"Error in registration. Error: %@", err] cancleButtonTitle:@"Ok" otherButtonTitle:@""];
    [[LinphoneManager instance] setPushNotificationToken:nil];
}
-(void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle{
    UIAlertView *alert;
    if([otherTitle isEqualToString:@""])
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:nil,nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
    [alert show];
    [alert release];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        /*NSString *cancelTitle = @"OK";
        //NSString *showTitle = @"Show";
        NSString *message = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
        // NSLog(@"mSG %@", message);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatrateBooster"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];*/
        //PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
        //NSString *tk = [mPref getPushRegistrationStatus];
        // NSLog(@"log %@", tk);
        
        //if([tk isEqualToString:@"success\n"]){
            [self performSelectorInBackground:@selector(superCredit) withObject:nil];
            
       // }
    }
    
    [LinphoneLogger log:LinphoneLoggerLog format:@"PushNotification: Receive %@", userInfo];
	
	[self processRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [self fixRing];
    
    
    if([notification.userInfo objectForKey:@"callId"] != nil) {
        BOOL auto_answer = TRUE;
        // some local notifications have an internal timer to relaunch themselves at specified intervals
        if( [[notification.userInfo objectForKey:@"timer"] intValue] == 1 ){
            [[LinphoneManager instance] cancelLocalNotifTimerForCallId:[notification.userInfo objectForKey:@"callId"]];
            auto_answer = [[LinphoneManager instance] lpConfigBoolForKey:@"autoanswer_notif_preference"];
        }
        if(auto_answer)
        {
            [[LinphoneManager instance] acceptCallForCallId:[notification.userInfo objectForKey:@"callId"]];
        }
    } /*else if([notification.userInfo objectForKey:@"from"] != nil) {
        NSString *remoteContact = (NSString*)[notification.userInfo objectForKey:@"from"];
        // Go to ChatRoom view
        [[PhoneMainView instance] changeCurrentView:[ChatViewController compositeViewDescription]];
        ChatRoomViewController *controller = DYNAMIC_CAST([[PhoneMainView instance] changeCurrentView:[ChatRoomViewController compositeViewDescription] push:TRUE], ChatRoomViewController);
        if(controller != nil) {
            LinphoneChatRoom*room = [self findChatRoomForContact:remoteContact];
            [controller setChatRoom:room];
        }
    } else if([notification.userInfo objectForKey:@"callLog"] != nil) {
        NSString *callLog = (NSString*)[notification.userInfo objectForKey:@"callLog"];
        // Go to HistoryDetails view
        [[PhoneMainView instance] changeCurrentView:[HistoryViewController compositeViewDescription]];
        HistoryDetailsViewController *controller = DYNAMIC_CAST([[PhoneMainView instance] changeCurrentView:[HistoryDetailsViewController compositeViewDescription] push:TRUE], HistoryDetailsViewController);
        if(controller != nil) {
            [controller setCallLogId:callLog];
        }
    }*/
}

// this method is implemented for iOS7. It is invoked when receiving a push notification for a call and it has "content-available" in the aps section.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    LinphoneManager* lm = [LinphoneManager instance];
	
	if (lm.pushNotificationToken==Nil){
		[LinphoneLogger log:LinphoneLoggerLog format:@"Ignoring push notification we did not subscribed."];
		return;
	}
    
    // check that linphone is still running
    if( ![LinphoneManager isLcReady] )
        [lm startLibLinphone];
    
	[LinphoneLogger log:LinphoneLoggerLog format:@"Silent PushNotification; userInfo %@", userInfo];
    
    // save the completion handler for later execution.
    // 2 outcomes:
    // - if a new call/message is received, the completion handler will be called with "NEWDATA"
    // - if nothing happens for 15 seconds, the completion handler will be called with "NODATA"
    lm.silentPushCompletion = completionHandler;
    [NSTimer scheduledTimerWithTimeInterval:15.0 target:lm selector:@selector(silentPushFailed:) userInfo:nil repeats:FALSE];
    
	LinphoneCore *lc=[LinphoneManager getLc];
	// If no call is yet received at this time, then force Linphone to drop the current socket and make new one to register, so that we get
	// a better chance to receive the INVITE.
	if (linphone_core_get_calls(lc)==NULL){
		linphone_core_set_network_reachable(lc, FALSE);
		lm.connectivity=none; /*force connectivity to be discovered again*/
		[lm refreshRegisters];
	}
}

- (void)ConfigurationStateUpdateEvent: (NSNotification*) notif {
    LinphoneConfiguringState state = [[notif.userInfo objectForKey: @"state"] intValue];
    if (state == LinphoneConfiguringSuccessful) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:kLinphoneConfiguringStateUpdate
                                                      object:nil];
        //[_waitingIndicator dismissWithClickedButtonIndex:0 animated:true];
        
        UIAlertView* error = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",nil)
                                                        message:NSLocalizedString(@"Remote configuration successfully fetched and applied.",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
        [error show];
        [error release];
        [self startUp];
    }
    if (state == LinphoneConfiguringFailed) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:kLinphoneConfiguringStateUpdate
                                                      object:nil];
        //[_waitingIndicator dismissWithClickedButtonIndex:0 animated:true];
        UIAlertView* error = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failure",nil)
                                                        message:NSLocalizedString(@"Failed configuring from the specified URL." ,nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
        [error show];
        [error release];
        
    }
}

- (void)attemptRemoteConfiguration {
    
    if ([LinphoneManager isLcReady]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ConfigurationStateUpdateEvent:)
                                                     name:kLinphoneConfiguringStateUpdate
                                                   object:nil];
        linphone_core_set_provisioning_uri([LinphoneManager getLc] , [configURL UTF8String]);
        [[LinphoneManager instance] destroyLibLinphone];
        [[LinphoneManager instance] startLibLinphone];
    } else {
        //[_waitingIndicator dismissWithClickedButtonIndex:0 animated:true];
        UIAlertView* error = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failure",nil)
                                                        message:NSLocalizedString(@"Linphone is not ready.",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
        [error show];
        [error release];
        
    }
}

- (void)startUp {
    
    if( linphone_core_get_global_state([LinphoneManager getLc]) != LinphoneGlobalOn ){
        //[self changeCurrentView: [DialerViewController compositeViewDescription]];
    } else if ([[LinphoneManager instance] lpConfigBoolForKey:@"enable_first_login_view_preference"]  == true) {
        // Change to fist login view
        //[self changeCurrentView: [FirstLoginViewController compositeViewDescription]];
    } else {
        // Change to default view
        const MSList *list = linphone_core_get_proxy_config_list([LinphoneManager getLc]);
        if(list != NULL || ([[LinphoneManager instance] lpConfigBoolForKey:@"hide_wizard_preference"]  == true)) {
            //[self changeCurrentView: [DialerViewController compositeViewDescription]];
        } else {
            /*WizardViewController *controller = DYNAMIC_CAST([[PhoneMainView instance] changeCurrentView:[WizardViewController compositeViewDescription]], WizardViewController);
            if(controller != nil) {
                [controller reset];
            }*/
        }
    }
    
    [self updateApplicationBadgeNumber]; // Update Badge at startup
}

- (void)updateApplicationBadgeNumber {
    int count = 0;
    count += linphone_core_get_missed_calls_count([LinphoneManager getLc]);
    count += [LinphoneManager unreadMessageCount];
    count += linphone_core_get_calls_nb([LinphoneManager getLc]);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
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

-(void)superCredit{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    creditTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self  selector:@selector(creditUpdate) userInfo:nil repeats:NO];
    
    [runLoop run];
    [pool release];
}

-(void) creditUpdate
{    
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] init];
    [mGetCrHandler getCredit];
}



-(void)dealloc{
    [sqliteDB release];
    
    [super dealloc];
}

@end
