//
//  FlatrateXMLParser.m
//  DCalling WiFi
//
//  Created by Prashant Kumar on 19/01/12.
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

#import "FlatrateXMLParser.h"

@implementation FlatrateXMLParser

//@synthesize token;

- (FlatrateXMLParser *) initWithVerificationSMSDelegate: (id) d xmlData:(NSData *)u {
	self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object: nil];
    [myThread start];
	return self;
}




- (FlatrateXMLParser *) initWithDCallingPostDelegate: (id) d xmlData:(NSData *)u {
	self = [super init];
	delegate = d;
    
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runDCallingPost:) object: nil];
    [myThread start];
	return self;
}

- (FlatrateXMLParser *) initWithCallBackDCallingPostDelegate:(id)d xmlData:(NSData *)u {
	self = [super init];
	callbacks = d;
    
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runCallBackDCallingPost:) object: nil];
    [myThread start];
	return self;
}



- (FlatrateXMLParser *) initWithUserProviderDelegate: (id) d xmlData:(NSData *)u {
	self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runUserProvider:) object: nil];
    [myThread start];
	return self;
}


- (FlatrateXMLParser *) initWithUserPasswordDelegate: (id) d xmlData:(NSData *)u{
    self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runUserPassword:) object: nil];
    [myThread start];
	return self;
}


- (FlatrateXMLParser *) initWithDCallingDelegate: (id) d xmlData:(NSData *)u {
	self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runDCalling:) object: nil];
    [myThread start];
	return self;
}


- (FlatrateXMLParser *) initWithAuthSessionDelegate: (id) d xmlData:(NSData *)u {
	self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runAuthSession:) object: nil];
    [myThread start];
	return self;
}

-(FlatrateXMLParser *) initWithUserCreditDelegate:(id)d xmlData:(NSData *)u {
    self = [super init];
	userCredit = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runUserCredit:) object: nil];
    [myThread start];
	return self;
}

- (FlatrateXMLParser *) initWithVerficationCodeProvider:(id)d xmlData:(NSData *)u {
	self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runVerificationCodeProvider:) object: nil];
    [myThread start];
	return self;
}

- (FlatrateXMLParser *) initWithPriceValueforCountry: (id) d xmlData: (NSData *) u{
    self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runPriceValueforCountry:) object: nil];
    [myThread start];
	return self;
}

- (FlatrateXMLParser *) initWithServiceProvideName: (id) d xmlData: (NSData *) u{
    self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runServiceProvideName:) object: nil];
    [myThread start];
	return self;
}

-(FlatrateXMLParser *) initWithPushRegistration:(id)d xmlData:(NSData *)u{
    self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runPushRegistration:) object: nil];
    [myThread start];
	return self;
}

- (FlatrateXMLParser *) initWithUserSIPAccount: (id) d xmlData: (NSData *) u{
    self = [super init];
	delegate = d;
    xmlData = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(runUserSIPAccount:) object: nil];
    [myThread start];
	return self;
}


- (void) run: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *verificationSMSParser = [NSXMLParser alloc];
    
    [verificationSMSParser initWithData:xmlData];
    [verificationSMSParser setDelegate: self];
    [verificationSMSParser parse];
    [verificationSMSParser release];
    
    if ([delegate respondsToSelector:@selector(verificationSMSParseDidComplete:)])
        [delegate performSelector:@selector(verificationSMSParseDidComplete:) onThread: thread 
                       withObject: outstring waitUntilDone:YES];
    
    [pool drain];
} 



- (void) runDCallingPost: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *dCallingPostParser = [NSXMLParser alloc];
    [dCallingPostParser initWithData:xmlData];
    [dCallingPostParser setDelegate: self];
    [dCallingPostParser parse];
    [dCallingPostParser setShouldResolveExternalEntities:YES];
    [dCallingPostParser release];
    
    if ([delegate respondsToSelector:@selector(dCallingParsePostDidComplete:)])
        [delegate performSelector:@selector(dCallingParsePostDidComplete:) onThread: thread 
                       withObject: outstring waitUntilDone:YES];
    
    [pool drain];
}

- (void) runCallBackDCallingPost: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *callBackdCallingPostParser = [NSXMLParser alloc];
    [callBackdCallingPostParser initWithData:xmlData];
    [callBackdCallingPostParser setDelegate: self];
    [callBackdCallingPostParser parse];
    [callBackdCallingPostParser setShouldResolveExternalEntities:YES];
    [callBackdCallingPostParser release];
    
    if ([callbacks respondsToSelector:@selector(callBackDCallingParsePostDidComplete:)])
        [callbacks performSelector:@selector(callBackDCallingParsePostDidComplete:) onThread: thread 
                       withObject: outstring waitUntilDone:YES];
    
    [pool drain];
}
 


- (void) runUserProvider: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *userProviderParser = [NSXMLParser alloc];
    //[userProviderParser initWithContentsOfURL: url];
    [userProviderParser initWithData:xmlData];
    [userProviderParser setDelegate: self];
    [userProviderParser parse];
    [userProviderParser release];
    
    if ([delegate respondsToSelector:@selector(userProviderDidComplete:)])
        [delegate performSelector:@selector(userProviderDidComplete:) onThread: thread 
                       withObject: outstring waitUntilDone:YES];
    
    [pool release];
} 


- (void) runUserPassword: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *userPasswordParser = [NSXMLParser alloc];
    //[userPasswordParser initWithContentsOfURL: url];
    [userPasswordParser initWithData:xmlData];
    [userPasswordParser setDelegate: self];
    [userPasswordParser parse];
    [userPasswordParser release];
    
    if ([delegate respondsToSelector:@selector(userPasswordDidComplete:)])
        [delegate performSelector:@selector(userPasswordDidComplete:) onThread: thread 
                       withObject: outstring waitUntilDone:NO];
    
    [pool drain];
}


- (void) runDCalling: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *dCallingParser = [NSXMLParser alloc];
    [dCallingParser initWithData:xmlData];
    [dCallingParser setDelegate: self];
    [dCallingParser parse];
    [dCallingParser release];
    
    if ([self respondsToSelector:@selector(dCallingParseDidComplete:)])
        [self performSelector:@selector(dCallingParseDidComplete:) onThread: thread 
                       withObject: outstring waitUntilDone:YES];
    
    [pool drain];
} 

- (void) runAuthSession: (id) param  {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *authSessionParser = [NSXMLParser alloc];
    [authSessionParser initWithData:xmlData];
    [authSessionParser setDelegate: self];
    [authSessionParser parse];
    [authSessionParser setShouldResolveExternalEntities:YES];
    
    
    if ([delegate respondsToSelector:@selector(authSessionParserDidComplete:)])
        [delegate performSelector:@selector(authSessionParserDidComplete:) onThread: thread                       withObject: outstring waitUntilDone:YES];
       // [delegate performSelectorOnMainThread:@selector(authSessionParserDidComplete:) withObject:outstring waitUntilDone:YES];
    
    [authSessionParser release];
    [pool release];
    
    
} 

- (void) runUserCredit: (id) param  {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *userCreditParser = [NSXMLParser alloc];
    [userCreditParser initWithData:xmlData];
    [userCreditParser setDelegate: self];
    [userCreditParser parse];
    [userCreditParser release];
    if ( [userCredit respondsToSelector:@selector(getCreditParserDidComplete:)]){
        @try {
            //[userCredit performSelector:@selector(getCreditParserDidComplete:) onThread: thread withObject: outstring waitUntilDone:YES];
             [userCredit performSelectorOnMainThread:@selector(getCreditParserDidComplete:) withObject:outstring waitUntilDone:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"error -- %@", exception);
        }
        
       
    }
        
     
    [pool release];
}

- (void) runPriceValueforCountry: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *priceValueCountryParser = [NSXMLParser alloc];
    
    [priceValueCountryParser initWithData:xmlData];
    [priceValueCountryParser setDelegate: self];
    [priceValueCountryParser parse];
    [priceValueCountryParser release];
    
    if ([delegate respondsToSelector:@selector(priceValueCountryParserDidComplete:)])
        [delegate performSelector:@selector(priceValueCountryParserDidComplete:) onThread: thread
                       withObject: outstring waitUntilDone:YES];
    
    [pool drain];
}


- (void) dealloc  {
    
	[outstring release];
    //[userCredit release];
    [url release];
    [xmlData release];
	[super dealloc];
}

- (void) runVerificationCodeProvider: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *verificationCodeParser = [NSXMLParser alloc];
    
    [verificationCodeParser initWithData:xmlData];
    [verificationCodeParser setDelegate: self];
    [verificationCodeParser parse];
    [verificationCodeParser release];
    
    if ([delegate respondsToSelector:@selector(verificationCodeParseDidComplete:)])
        [delegate performSelector:@selector(verificationCodeParseDidComplete:) onThread: thread 
                       withObject: outstring waitUntilDone:YES];
    
    [pool drain];
}

- (void) runServiceProvideName: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *serviceProviderName = [NSXMLParser alloc];
    
    [serviceProviderName initWithData:xmlData];
    [serviceProviderName setDelegate: self];
    [serviceProviderName parse];
    [serviceProviderName release];
    
    if ([delegate respondsToSelector:@selector(serviceProviderNameParseDidComplete:)])
        [delegate performSelector:@selector(serviceProviderNameParseDidComplete:) onThread: thread
                       withObject: outstring waitUntilDone:YES];
    
    [pool drain];
}

- (void) runPushRegistration: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *pushRegistration = [NSXMLParser alloc];
    
    [pushRegistration initWithData:xmlData];
    [pushRegistration setDelegate: self];
    [pushRegistration parse];
    [pushRegistration release];
    
    if ([delegate respondsToSelector:@selector(pushRegistrationParseDidComplete:)])
        [delegate performSelector:@selector(pushRegistrationParseDidComplete:) onThread: thread
                       withObject: outstring waitUntilDone:YES];
    
    [pool drain];
}

- (void) runUserSIPAccount: (id) param  {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *userSIPAccountParser = [NSXMLParser alloc];
    [userSIPAccountParser initWithData:xmlData];
    [userSIPAccountParser setDelegate: self];
    [userSIPAccountParser parse];
    [userSIPAccountParser setShouldResolveExternalEntities:YES];
    
    
    if ([delegate respondsToSelector:@selector(userSIPAccountParserDidComplete:)])
        [delegate performSelector:@selector(userSIPAccountParserDidComplete:) onThread: thread                       withObject: outstring waitUntilDone:YES];
    // [delegate performSelectorOnMainThread:@selector(authSessionParserDidComplete:) withObject:outstring waitUntilDone:YES];
    
    [userSIPAccountParser release];
    [pool release];
    
    
}



- (void)parser:(NSXMLParser *)verificationSMSParser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
    // NSLog(@"TOKEN1"); 
}



- (void)parser:(NSXMLParser *)verificationSMSParser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"token"])  [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"dialin"])  [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"credit"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"callingrate"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"registrationstatus"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"sipdetails"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"account"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"sipusername"])  [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"sipsecret"])  [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"sipdomain"]) [outstring appendFormat:@"%@", @"\n"];
	current = nil;
}



- (void)parser:(NSXMLParser *)verificationSMSParser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"token"])  [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"dialin"]) [outstring appendFormat:@"%@", string]; 
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"credit"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"callingrate"]) [outstring appendFormat:@"//%@", string];
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"//%@", string];
    else if([current isEqualToString:@"registrationstatus"]) [outstring appendFormat:@"//%@", string];
    else if([current isEqualToString:@"sipdetails"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"account"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"sipusername"])  [outstring appendFormat:@"//%@", string];
    else if([current isEqualToString:@"sipsecret"]) [outstring appendFormat:@"//%@", string];
    else if([current isEqualToString:@"sipdomain"]) [outstring appendFormat:@"//%@", string];
}


- (void)dCallingPostParser:(NSXMLParser *)dCallingPostParser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
    // NSLog(@"TOKEN2"); 
}



- (void)dCallingPostParser:(NSXMLParser *)dCallingPostParser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", @"\n"];

	current = nil;
}



- (void)dCallingPostParser:(NSXMLParser *)dCallingPostParser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", string];
}

- (void)callBackdCallingPostParser:(NSXMLParser *)callBackdCallingPostParser didStartElement:(NSString *)elementName 
              namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
                attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
    // NSLog(@"TOKEN2"); 
}



- (void)callBackdCallingPostParser:(NSXMLParser *)callBackdCallingPostParser didEndElement:(NSString *)elementName 
              namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", @"\n"];
    
	current = nil;
}



- (void)callBackdCallingPostParser:(NSXMLParser *)callBackdCallingPostParser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", string];
}




- (void)userProviderParser:(NSXMLParser *)userProviderParser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
   //  NSLog(@"TOKEN3"); 
}



- (void)userProviderParser:(NSXMLParser *)userProviderParser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @"\n"];
     else if([current isEqualToString:@"result"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"%@", @"\n"];
    
	current = nil;
}



- (void)userProviderParser:(NSXMLParser *)userProviderParser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"result"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"%@", string];
    
}



- (void)userPasswordParser:(NSXMLParser *)userPasswordParser didStartElement:(NSString *)elementName 
              namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
                attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
   //  NSLog(@"TOKEN4"); 
}



- (void)userPasswordParser:(NSXMLParser *)userPasswordParser didEndElement:(NSString *)elementName 
              namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", @"\n"];
	current = nil;
}



- (void)userPasswordParser:(NSXMLParser *)userPasswordParser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", string];
}


- (void)dCallingParser:(NSXMLParser *)dCallingParser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
   //  NSLog(@"TOKEN5"); 
}



- (void)dCallingParser:(NSXMLParser *)dCallingParser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", @"\n"];
	current = nil;
}



- (void)dCallingParser:(NSXMLParser *)dCallingParser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"error"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", string];
}

- (void)authSessionParser:(NSXMLParser *)authSessionParser didStartElement:(NSString *)elementName 
          namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
            attributes:(NSDictionary *)attributeDict  {
   if (qName) elementName = qName;
   if (elementName) current = [NSString stringWithString:elementName];
   // NSLog(@"TOKEN6");   
}

- (void)authSessionParser:(NSXMLParser *)authSessionParser parseErrorOccurred:(NSError *)parseError 
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)authSessionParser:(NSXMLParser *)authSessionParser didEndElement:(NSString *)elementName 
          namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
	else if ([current isEqualToString:@"method"])[outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"token"])[outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @""];
  	current = nil;
}


- (void)authSessionParser:(NSXMLParser *)authSessionParser foundCharacters:(NSString *)string {
	if (!current) return;
    if([current isEqualToString:@"resource"])[outstring appendFormat:@"%@", string];
	else if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"token"])[outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
}

- (void)userCreditParser:(NSXMLParser *)userCreditParser didStartElement:(NSString *)elementName 
             namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
               attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
    // NSLog(@"TOKEN6");   
}

- (void)userCreditParser:(NSXMLParser *)userCreditParser parseErrorOccurred:(NSError *)parseError 
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)userCreditParser:(NSXMLParser *)authSessionParser didEndElement:(NSString *)elementName 
             namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
	else if ([current isEqualToString:@"method"])[outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"token"])[outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @""];
    else if([current isEqualToString:@"credit"]) [outstring appendFormat:@"%@", @""];
  	current = nil;
}


- (void)userCreditParser:(NSXMLParser *)userCreditParser foundCharacters:(NSString *)string {
	if (!current) return;
    if([current isEqualToString:@"resource"])[outstring appendFormat:@"%@", string];
	else if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"token"])[outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"credit"]) [outstring appendFormat:@"%@", string];
}

- (void)verificationCodeParser:(NSXMLParser *)verificationCodeParser didStartElement:(NSString *)elementName 
            namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
              attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
    // NSLog(@"TOKEN6");   
}

- (void)verificationCodeParser:(NSXMLParser *)verificationCodeParser parseErrorOccurred:(NSError *)parseError 
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)verificationCodeParser:(NSXMLParser *)verificationCodeParser didEndElement:(NSString *)elementName 
            namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
	else if ([current isEqualToString:@"method"])[outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"token"])[outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @""];
    else if([current isEqualToString:@"credit"]) [outstring appendFormat:@"%@", @""];
  	current = nil;
}


- (void)verificationCodeParser:(NSXMLParser *)verificationCodeParser foundCharacters:(NSString *)string {
	if (!current) return;
    if([current isEqualToString:@"resource"])[outstring appendFormat:@"%@", string];
	else if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"token"])[outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"credit"]) [outstring appendFormat:@"%@", string];
}

- (void)serviceProviderNameParser:(NSXMLParser *)serviceProviderNameParser didStartElement:(NSString *)elementName
                  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
                    attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
    // NSLog(@"TOKEN6");
}

- (void)serviceProviderNameParser:(NSXMLParser *)serviceProviderNameParser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)serviceProviderNameParser:(NSXMLParser *)serviceProviderNameParser didEndElement:(NSString *)elementName
                  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
	else if ([current isEqualToString:@"method"])[outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"token"])[outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @""];
    else if([current isEqualToString:@"credit"]) [outstring appendFormat:@"%@", @""];
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"%@", @""];
  	current = nil;
}


- (void)serviceProviderNameParser:(NSXMLParser *)serviceProviderNameParser foundCharacters:(NSString *)string {
	if (!current) return;
    if([current isEqualToString:@"resource"])[outstring appendFormat:@"%@", string];
	else if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"token"])[outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"credit"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"%@", string];
}






-(void) parserDidEndDocument:(NSXMLParser *)parser {}
-(void) parserDidStartDocument:(NSXMLParser *)parser {}

-(void) userPasswordParserDidStartElement:(NSXMLParser *)userPasswordParser {}
-(void) userPasswordParserDidEndElement:(NSXMLParser *)userPasswordParser {}

-(void) userProviderParserDidStartElement:(NSXMLParser *)userProviderParser {}
-(void) userProviderParserDidEndElement:(NSXMLParser *)userProviderParser {}

-(void) dCallingParserDidStartElement:(NSXMLParser *)dCallingParser {}
-(void) dCallingParserDidEndElement:(NSXMLParser *)dCallingParser {}

-(void) callBackdCallingPostParserDidStartElement:(NSXMLParser *)callBackdCallingPostParser {}
-(void) callBackdCallingPostParserDidEndElement:(NSXMLParser *)callBackdCallingPostParser {}

-(void) dCallingPostParserDidStartElement:(NSXMLParser *)dCallingPostParser {}
-(void) dCallingPostParserDidEndElement:(NSXMLParser *)dCallingPostParser {}


-(void) authSessionParserDidStartElement:(NSXMLParser *)authSessionParser {}
-(void) authSessionParserDidEndElement:(NSXMLParser *)authSessionParser {}

-(void) userCreditParserDidStartElement:(NSXMLParser *)userCreditParser {}
-(void) userCreditParserDidEndElement:(NSXMLParser *)userCreditParser {}

-(void) verificationCodeParserDidStartElement:(NSXMLParser *)verificationCodeParser {}
-(void) verificationCodeParserDidEndElement:(NSXMLParser *)verificationCodeParser {}

-(void) serviceProviderNameParserDidStartElement:(NSXMLParser *)serviceProviderNameParser {}
-(void) serviceProviderNameParserDidEndElement:(NSXMLParser *)serviceProviderNameParser {}

@end
