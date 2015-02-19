//
//  InAppPurchaseManager.m
//  DCalling WiFi
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

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager

@synthesize pricing;
- (void) callForTransaction:(NSString *)price :(NSString *)user{
    pricing = price;
    /*SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"Y5FBPR3ZC7.com.dalason.flatratebooster"];
     
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];*/
    
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *myProducts = nil;
    
    int count = (int)[response.products count];
    //com.dalason.MyApp
    // Populate your UI from the products list.
    // Save a reference to the products list.
    if(count > 0){
        myProducts = [response.products objectAtIndex:0];
    }
    else{
        NSLog(@"No Products Available");
    }
    
        
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:    
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
        NSLog(@"An Error Encountered");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    //If you want to save the transaction
    // [self recordTransaction: transaction];
    
    //Provide the new content
    // [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    
    //Finish the transaction
     NSLog(@"A Restore");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    //If you want to save the transaction
    // [self recordTransaction: transaction];
    
    //Provide the new content
    //[self provideContent: transaction.payment.productIdentifier];
    NSLog(@"Pricing is :%@", pricing);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

-(void)dealloc{
    pricing =nil;
    [pricing release];
    [super dealloc];
}

@end
