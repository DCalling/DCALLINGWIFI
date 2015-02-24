//
//  RechargeViewController.m
//  DCalling WiFi
//
//  Created by Prashant on 23/02/12.
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

#import "RechargeViewController.h"
#import "InAppPurchaseManager.h"
#import "RestAPICaller.h"
#import "PreferencesHandler.h"
#import "FlatrateXMLParser.h"
#import "getCreditHandler.h"
#import "CallerIDViewController.h"
@implementation RechargeViewController

@synthesize tv, myProducts, mydetails;

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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
   
    [super viewDidLoad];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{    
    int count = (int)[response.products count];
    if(count >0){
        [mydetails addObjectsFromArray: response.products];
    }else {
        NSLog(@"No recharge Availbale");
    }
    
    [[self tv] reloadData];
}

-(void)requestDidFinish:(SKRequest *)request
{
    [request release];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //NSLog(@"Failed to connect with error: %@", [error localizedDescription]);
    NSLog(@"request failed: %@,  %@", request, error);
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:[NSNotification notificationWithName:_title object:nil userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]]];    
    
    [request release];
}

-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions)
        {
            switch (transaction.transactionState)
            {
                case SKPaymentTransactionStatePurchasing:
                    // Purchasing... waiting...
                    break;
                    
                case SKPaymentTransactionStatePurchased:
                    [self.tv reloadData];
                    break;
                    
                case SKPaymentTransactionStateFailed:
                    NSLog(@"Transaction is failed!!!");
                    break;
                    
                case SKPaymentTransactionStateRestored:
                    [self getCredit];
                    break;
            }
        }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tv reloadData];
   
        CallerIDViewController *mCallerId = [[CallerIDViewController alloc]autorelease];
        if([mCallerId CheckNetwork] == FALSE){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] 
                                                            message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_MSG"]
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
           
            
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mydetails count];
}


- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"pricingID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    //NSLog(@"Get %@", myProducts);
    //cell.textLabel.text = [self.myProducts objectAtIndex:indexPath.row];
    
    NSUInteger row = [indexPath row];
    
    SKProduct *thisProduct = [mydetails objectAtIndex:row];
     NSLog(@"ssss %@", thisProduct.localizedTitle);
    if([thisProduct.localizedTitle length] > 0)
        NSLog(@"ghghghgh");
    else {
        NSLog(@"aaaa");
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %@", thisProduct.localizedTitle, thisProduct.price]]; 
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedPrice = [[NSString alloc]init];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedPrice = selectedCell.textLabel.text;
    //NSLog(@"PRICE: %@", selectedPrice);
    //InAppPurchaseManager *inAppCall = [[InAppPurchaseManager alloc]init];
    //[inAppCall callForTransaction:selectedPrice :@"user"];
    //[inAppCall release];
    [self getCredit];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



FlatrateXMLParser * flatrateXMLParser;
-(void) getCredit {
    /*PreferencesHandler *mPrefs = [[PreferencesHandler alloc]autorelease];
     NSString *token = [mPrefs getToken];
     RestAPICaller *mRst = [[RestAPICaller alloc]autorelease];
     NSData *restForCredit = [mRst getUserCredit:token];
     
     flatrateXMLParser = [[FlatrateXMLParser alloc] initWithUserCreditDelegate: self xmlData:restForCredit];*/
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] autorelease];
    [mGetCrHandler getCredit];
    
}


-(void)dealloc{
    [myProducts release];
    myProducts = nil;
    [tv release];
    [super dealloc];
}


@end
