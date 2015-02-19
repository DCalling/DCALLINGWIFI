//
//  MoreNavigation.m
//  DCalling WiFi
//
//  Created by Prashant Kumar on 09/05/12.
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

#import "MoreNavigation.h"

@interface MoreNavigation ()

@end

@implementation MoreNavigation

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
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationBar.translucent=NO;
        self.wantsFullScreenLayout = YES;
        UIImage *selectedImg = [UIImage imageNamed:@"tabbar__mehr.png"];
        UIImage *unSelectedImg = [UIImage imageNamed:@"tabbar__mehr_active.png"];
        
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unSelectedImg = [unSelectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = unSelectedImg;
        self.tabBarItem.image = selectedImg;
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_title"] image:selectedImg selectedImage:unSelectedImg];
    }
    else
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__mehr_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__mehr.png"]];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    //UIImage *tabBackground = [[UIImage imageNamed:@"tab_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    /*myTabBarItem = [[UITabBarItem alloc]initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"more_title"] image:nil tag:100];
    [myTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar__mehr_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar__mehr.png"]];*/
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
