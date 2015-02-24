//
//  tabBarview.m
//  DCalling WIFI
//
//  Created by Ramesh on 17/10/13.
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
//
//

#import "tabBarview.h"
#import "DCallingWIFIAppDelegate.h"
@interface tabBarview ()

@end

@implementation tabBarview



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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[UIDevice currentDevice].systemVersion floatValue]< 6.2){
        //[[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
        //self.tabBarController.tabBar.translucent=NO;
        [[UITabBar appearance] setTintColor:[UIColor blackColor]];
        NSUInteger indexToRemove = 4;
        
    }
    if([[self appDelegate]addCallValue]){
        /*NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self.tabBarController viewControllers]];
        [tabbarViewControllers removeObjectAtIndex:4];
        [self.tabBarController setViewControllers: tabbarViewControllers ];*/
        
    }
    
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    NSLog(@"Tab index = %lu ", (unsigned long)indexOfTab);
    //NSInteger tabIndex = self.tabBarController.selectedIndex;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger: indexOfTab forKey:@"activeTab"];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    //[self.tabBar setSelectedImageTintColor:[UIColor clearColor]];
    //self.tabBarController.tabBar.translucent=NO;
}

@end
