//
//  IASKAppSettingsWebViewController.h
//
//  Created by Prashant on 23/02/12.
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
#import "IASKAppSettingsWebViewController.h"

@implementation IASKAppSettingsWebViewController

@synthesize url;
@synthesize webView;

- (id)initWithFile:(NSString*)urlString key:(NSString*)key {
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:urlString];
        if (!self.url || ![self.url scheme]) {
            NSString *path = [[NSBundle mainBundle] pathForResource:[urlString stringByDeletingPathExtension] ofType:[urlString pathExtension]];
            if(path)
                self.url = [NSURL fileURLWithPath:path];
            else
                self.url = nil;
        }
    }
    return self;
}

- (void)loadView
{
    webView = [[UIWebView alloc] init];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    
    self.view = webView;
}

- (void)dealloc {
	[webView release], webView = nil;
	[url release], url = nil;
	
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {  
	[webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *newURL = [request URL];
	
	// intercept mailto URL and send it to an in-app Mail compose view instead
	if ([[newURL scheme] isEqualToString:@"mailto"]) {

		NSArray *rawURLparts = [[newURL resourceSpecifier] componentsSeparatedByString:@"?"];
		if (rawURLparts.count > 2) {
			return NO; // invalid URL
		}
		
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;

		NSMutableArray *toRecipients = [NSMutableArray array];
		NSString *defaultRecipient = [rawURLparts objectAtIndex:0];
		if (defaultRecipient.length) {
			[toRecipients addObject:defaultRecipient];
		}
		
		if (rawURLparts.count == 2) {
			NSString *queryString = [rawURLparts objectAtIndex:1];
			
			NSArray *params = [queryString componentsSeparatedByString:@"&"];
			for (NSString *param in params) {
				NSArray *keyValue = [param componentsSeparatedByString:@"="];
				if (keyValue.count != 2) {
					continue;
				}
				NSString *key = [[keyValue objectAtIndex:0] lowercaseString];
				NSString *value = [keyValue objectAtIndex:1];
				
				value =  (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																							 (CFStringRef)value,
																							 CFSTR(""),
																							 kCFStringEncodingUTF8);
				[value autorelease];
				
				if ([key isEqualToString:@"subject"]) {
					[mailViewController setSubject:value];
				}
				
				if ([key isEqualToString:@"body"]) {
					[mailViewController setMessageBody:value isHTML:NO];
				}
				
				if ([key isEqualToString:@"to"]) {
					[toRecipients addObjectsFromArray:[value componentsSeparatedByString:@","]];
				}
				
				if ([key isEqualToString:@"cc"]) {
					NSArray *recipients = [value componentsSeparatedByString:@","];
					[mailViewController setCcRecipients:recipients];
				}
				
				if ([key isEqualToString:@"bcc"]) {
					NSArray *recipients = [value componentsSeparatedByString:@","];
					[mailViewController setBccRecipients:recipients];
				}
			}
		}
		
		[mailViewController setToRecipients:toRecipients];

		[self presentModalViewController:mailViewController animated:YES];
		[mailViewController release];
		return NO;
	}
	
	// open inline if host is the same, otherwise, pass to the system
	if (![newURL host] || [[newURL host] isEqualToString:[self.url host]]) {
		return YES;
	}
	[[UIApplication sharedApplication] openURL:newURL];
	return NO;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}



@end
