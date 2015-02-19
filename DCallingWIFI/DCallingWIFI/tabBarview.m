//
//  tabBarview.m
//  FRBooster
//
//  Created by Ramesh on 17/10/13.
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
