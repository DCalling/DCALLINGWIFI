//
//  DialNavigation.m
//  FlatrateBoooster
//
//  Created by Dileep Nagesh on 10/10/12.
//  Copyright (c) 2012 dileep555@gmail.com. All rights reserved.
//

#import "DialNavigation.h"

@interface DialNavigation ()

@end

@implementation DialNavigation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    //UIImage *tabBackground = [[UIImage imageNamed:@"tab_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [mytab setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__dialpad_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__dialpad.png"]];
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

@end
