//
//  GTCRagistration.m
//  DCalling WiFi
//
//  Created by Prashant Kumar on 13/07/12.
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

#import "GTCRagistration.h"
#import "PreferencesHandler.h"
#import "CallerIDViewController.h"

@interface GTCRagistration ()

@end

@implementation GTCRagistration
@synthesize buttonTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewForiOSSeven{
    //helloCallerID, callerIDField, backgoundImg,downArrow textView unsere footer VerificationButton
    CGRect frame0 = webView.frame;
    CGRect frame1 = topBar.frame;
    CGRect frame2 = backBtn.frame;
    
    
    frame0.origin.y +=20;
    webView.frame = frame0;
    
    frame1.origin.y +=20;
    topBar.frame = frame1;
    
    frame2.origin.y +=20;
    backBtn.frame = frame2;
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"";
    // NSLog(@"dfdf %@", buttonTitle);
    if([buttonTitle isEqualToString:@"unsere"]){
        [self drawFrame];
        
    }   
    else{
        webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 10, 320, 420)];
        [self.view addSubview:webView];
        [mybutton setHidden:YES];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        //UIImage *tImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topbar_agb1" ofType:@"png"]];
        //[self.navigationController.navigationBar setBackgroundImage:tImage forBarMetrics:UIBarMetricsDefault];
        //[tImage release];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        [self viewForiOSSeven];
    }
    
    //[button release]; 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GTC" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    //[super viewDidLoad];
    
	// Do any additional setup after loading the view.
}


-(void) viewWillAppear:(BOOL)animated{
    // self.navigationController.navigationBar.hidden = YES;
    //PreferencesHandler *mPref = [[PreferencesHandler alloc]autorelease];
    //NSString *token = [mPref getToken];
    //NSLog(@"google : %@", [mPref getMNC]);
   /* if((token == NULL) && (token == nil)){
        UITabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"callerid"];
        [self.navigationController pushViewController:tab animated:YES];
    }*/
    [super viewWillAppear:YES];
}
- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    //topBar  = [[UIImageView alloc]initWithFrame:frame];
    
        [topBar setImage:[UIImage imageNamed:@"topbar_agb.png"]];
    
    //[self.view addSubview:topHeaderMV];
    frame.origin.x = 10;
    frame.origin.y = 6;
    frame.size.height = 31;
    frame.size.width = 61;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        frame.origin.y = 26;
    }
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:frame];
    //backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    UILabel *buttonLbl = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, 60, 18)];
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
    [self performSegueWithIdentifier:@"pushToCallerID" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"pushToCallerID"]){
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
