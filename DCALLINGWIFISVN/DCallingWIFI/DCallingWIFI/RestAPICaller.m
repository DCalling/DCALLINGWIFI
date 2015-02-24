//
//  RestAPICaller.m
//  DCalling WiFi
//
//  Created by David C. Son on 19.01.12.
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

#import "RestAPICaller.h"



@implementation RestAPICaller

-(NSString *) currentDatetime{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss:SSS";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    NSString *date = [dateFormatter stringFromDate:now];
    [dateFormatter release];
    return date;
}

-(NSData *) getVerificationSMSXML: (NSString *)callerID
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *strURL = [@"https://rest.dcalling.com/user/VerificationSMS/" stringByAppendingFormat:@"%@/%@",version,callerID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //set HTTP Method
    [request setHTTPMethod:@"GET"];
    
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    return responseData;
}

-(NSData *) getDialinXML: (NSString *)destination : (NSString *)callerid : (NSString *)token
{
    NSString *strURL = @"https://rest.dcalling.com/dialin/";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString
                              stringWithFormat:@"callerid=%@&destination=%@&token=%@",
                              [callerid        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [destination        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [token        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              ];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //NSLog(@"kjkjk -%@", [self currentDatetime]);
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    //[request setTimeoutInterval:3];
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // NSLog(@"kjkjk10 -%@", [self currentDatetime]);
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"getDialin %@", [error localizedDescription]);
        
    }
    
    
    return responseData;
}

-(NSData *) getVerificationXML: (NSString *)callerid : (NSString *)code
{
    NSString *strURL = @"https://rest.dcalling.com/user/verify";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"callerid=%@&code=%@",  [callerid        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [code        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    //NSLog(@"AA");
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // NSLog(@"BB");
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    return responseData;
}

-(NSData *) getUser: (NSString *)callerid : (NSString *)language : (NSString *)reseller
{
    NSString *strURL = @"https://rest.dcalling.com/user";
    
    //NSLog(@"callerid: %@", callerid);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString
                              stringWithFormat:@"callerid=%@&language=%@&reseller=%@",
                              [callerid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [language stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [reseller stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              ];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    
    return responseData;
}

-(NSData *) getAuthUser: (NSString *)callerid
{
    NSString *strURL = @"https://rest.dcalling.com/authSession";
    
    //NSLog(@"callerid: %@", callerid);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString
                              stringWithFormat:@"callerid=%@",
                              [callerid        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              ];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    
    return responseData;
}

-(NSData *) getUserCredit:(NSString *)token{
    NSString *strURL = [@"https://rest.dcalling.com/user/" stringByAppendingString:token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //set HTTP Method
    [request setHTTPMethod:@"GET"];
    
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    
    return responseData;
}

-(NSData *) getCallBackXML: (NSString *)destination : (NSString *)callerid : (NSString *)token
{
    NSString *strURL = @"https://rest.dcalling.com/callback/";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString
                              stringWithFormat:@"callerid=%@&destination=%@&token=%@",
                              [callerid        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [destination        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [token        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              ];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:3];
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        
    }
    
    
    return responseData;
}

-(NSData *)getVerificationCodeXML:(NSString *)callerID :(NSString *)language{
    //NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *strURL = [@"https://rest.dcalling.com/user/verificationCall/" stringByAppendingFormat:@"%@/%@",callerID,language];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //set HTTP Method
    [request setHTTPMethod:@"GET"];
    
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    return responseData;
}

-(NSData *)getPriceValueForCountry:(NSString *)callerID :(NSString *)language{
    //NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *strURL = [@"https://rest.dcalling.com/user/verificationCall/" stringByAppendingFormat:@"%@/%@",callerID,language];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //set HTTP Method
    [request setHTTPMethod:@"GET"];
    
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    return responseData;
}

-(NSData *)getServiceProvideName:(NSString *)destinationNumber{
    //NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *strURL = [@"https://rest.dcalling.com/provider/" stringByAppendingFormat:@"%@",destinationNumber];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //set HTTP Method
    [request setHTTPMethod:@"GET"];
    
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    return responseData;
}

-(NSData *) getcallBackRate:(NSString *)callerid :(NSString *)destination :(NSString *)token
{
    NSString *strURL = @"https://rest.dcalling.com/dialin/";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString
                              stringWithFormat:@"callerid=%@&destination=%@&token=%@&op=rate",
                              [callerid        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [destination        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [token        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              ];
    //set request body into HTTPBody.
    //NSLog(@"URL %@", request_body);
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //NSLog(@"kjkjk -%@", [self currentDatetime]);
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    //[request setTimeoutInterval:3];
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // NSLog(@"kjkjk10 -%@", [self currentDatetime]);
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"getcallBackRate %@", [error localizedDescription]);
        
    }
    
    
    return responseData;
}

-(NSData *) pushRegistration:(NSString *)callerid :(NSString *)token :(NSString *)deviceToken
{
    NSString *strURL = @"https://rest.dcalling.com/apn/register/";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString
                              stringWithFormat:@"callerid=%@&token=%@&device_token=%@",
                              [callerid        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [token        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [deviceToken       stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              ];
    //set request body into HTTPBody.
    //NSLog(@"URL rest %@", request_body);
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //NSLog(@"kjkjk -%@", [self currentDatetime]);
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    //[request setTimeoutInterval:3];
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // NSLog(@"kjkjk10 -%@", [self currentDatetime]);
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"pushRegistration %@", [error localizedDescription]);
        
    }
    
    
    return responseData;
}

-(NSData *) getUserSIPAccount:(NSString *)token
{
    NSString *strURL = @"https://rest.dcalling.com/user/details";
    
    //NSLog(@"callerid: %@", callerid);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString
                              stringWithFormat:@"token=%@",
                              [token        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              ];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"%@", request);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forHTTPHeaderField:@"Accept"];
    
    // Prepare for the response back from the server
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
    }
    
    
    return responseData;
}

@end
