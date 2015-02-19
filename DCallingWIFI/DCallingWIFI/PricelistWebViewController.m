//
//  PricelistWebViewController.m
//  DCalling WiFi
//
//  Created by David C. Son on 09.02.12.
//  Copyright (C) 2014 DALASON GmbH.
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

#import "PricelistWebViewController.h"
#import "PreferencesHandler.h"
#import "CallerIDViewController.h"
@implementation PricelistWebViewController
//@synthesize cLoadingView;
@synthesize webView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    result = CGSizeMake(result.width * scale, result.height * scale);
    UIImage *tImage = nil;
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0){
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

    // ger token from preferences
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    
    // removed code by prashant khatri for private api
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString * urlAddress;
    if([language isEqualToString:@"de"] || [language isEqualToString:@"tr"])
        urlAddress = [NSString stringWithFormat:@"https://login.dcalling.mobi/app/preisliste1.html?token=%@&L=%@", token, @"0"];
    else {
        urlAddress = [NSString stringWithFormat:@"https://login.dcalling.mobi/app/preisliste.html?token=%@&L=%@", token, @"1"];
    }
    
    
    //NSLog(@"%@", urlAddress);
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}


-(void)viewWillAppear:(BOOL)animated{
    PreferencesHandler *mPref = [[PreferencesHandler alloc]autorelease];
    NSString *token = [mPref getToken];
    //NSLog(@"google : %@", [mPref getMNC]);
    if((token == NULL) && (token == nil)){
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    }
    CallerIDViewController *mCallerId = [[CallerIDViewController alloc]autorelease];
    if([mCallerId CheckNetwork] == FALSE){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] 
                                                        message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self webViewDidFinishLoad:webView];
        
    }
    [super viewWillAppear:YES];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [cLoadingView stopAnimating];
    [cLoadingView removeFromSuperview];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.webView stopLoading];   
    self.webView.delegate = self;  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [cLoadingView startAnimating];
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



-(void) dealloc{
    [cLoadingView stopAnimating];
    [cLoadingView removeFromSuperview];
    [super dealloc];
}

@end
