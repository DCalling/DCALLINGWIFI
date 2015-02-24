//
//  GTC.m
//  DCalling WiFi
//
//  Created by Prashant Kumar on 15/03/12.
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

#import "GTC.h"
#import "CallerIDViewController.h"
#import "PreferencesHandler.h"


@implementation GTC
@synthesize buttonTitle;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.title=@"";
   // NSLog(@"dfdf %@", buttonTitle);
    if([buttonTitle isEqualToString:@"unsere"]){
        [self drawFrame];
        
    }   
    else{
        webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 10, 320, 420)];
        [self.view addSubview:webView];
        [mybutton setHidden:YES];
        //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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
    } 
    
    //[button release]; 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GTC" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
   // self.navigationController.navigationBar.hidden = YES;
    PreferencesHandler *mPref = [[PreferencesHandler alloc]autorelease];
    NSString *token = [mPref getToken];
    //NSLog(@"google : %@", [mPref getMNC]);
    if((token == NULL) && (token == nil)){
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    }
    [super viewWillAppear:YES];
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

-(void) drawFrame{
    CGRect frame;
    /* frame.origin.x = 12;
     frame.origin.y = 4;
     frame.size.height = 66;
     frame.size.width = 66;
     
     imagePerson = [[UIImageView alloc]initWithFrame:frame];*/
    
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height = 43;
    frame.size.width = 321;
    UIImageView *topHeaderMV  = [[UIImageView alloc]initWithFrame:frame];
    [topHeaderMV setImage:[UIImage imageNamed:@"topbar_agb.png"]];
    
    [self.view addSubview:topHeaderMV];
    frame.origin.x = 10;
    frame.origin.y = 6;
    frame.size.height = 31;
    frame.size.width = 61;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    //backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    UILabel *buttonLbl = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, 40, 18)];
    //buttonLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Favorite_add_button"];
    buttonLbl.text = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"AGB_back_title"];
    [buttonLbl setBackgroundColor:[UIColor clearColor]];
    [buttonLbl setTextColor:[UIColor whiteColor]];
    [buttonLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:12]];
    [backButton addSubview:buttonLbl];
    [backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter| UIControlContentHorizontalAlignmentCenter];
    [backButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setEnabled:YES];
    [backButton setUserInteractionEnabled:YES];
    [self.view addSubview:backButton];
    [buttonLbl release];
    
    
    //[topHeaderMV release];
    //[imagePerson release];
    
    
}

-(IBAction)clearAction:(id)sender{
    [self performSegueWithIdentifier:@"pushToAGB" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
       if([[segue identifier] isEqualToString:@"pushToAGB"]){
        CallerIDViewController *myPush = [segue destinationViewController];
        myPush.title = @"Callerid";
        // [myPush release];
    }
}

-(void)dealloc{
    buttonTitle = nil;
    [buttonTitle release];
    [webView release];
    [super dealloc];
}

@end
