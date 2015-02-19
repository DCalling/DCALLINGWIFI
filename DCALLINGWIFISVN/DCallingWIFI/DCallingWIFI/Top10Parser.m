//
//  Top10Parser.m
//  XMLParser
//
//  Created by Dileep Nagesh on 13/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top10Parser.h"

@implementation Top10Parser

- (Top10Parser *) initWithDelegate: (id) d url: (NSURL *) u {
	self = [super init];
	delegate = d;
    url = [u retain];
    
	thread = [NSThread currentThread];				// Assumed delegate's thread
    
	outstring = [[NSMutableString alloc] init];
	
	myThread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object: nil];
    [myThread start];
	return self;
}

- (void) run: (id) param  {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSXMLParser *parser = [NSXMLParser alloc];
    [parser initWithContentsOfURL: url];
    [parser setDelegate: self];
    [parser parse];
    [parser release];
    
    if ([delegate respondsToSelector:@selector(parseDidComplete:)])
        [delegate performSelector:@selector(parseDidComplete:) onThread: thread 
                       withObject: outstring waitUntilDone:NO];
    
    [pool release];
} 

- (void) dealloc  {
	[outstring release];
    [myThread release];
    [url release];
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict  {
    if (qName) elementName = qName;
    if (elementName) current = [NSString stringWithString:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", @"\n"];
	current = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"number"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"message"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"info"]) [outstring appendFormat:@"%@", string];
}

-(void) parserDidEndDocument:(NSXMLParser *)parser {}
-(void) parserDidStartDocument:(NSXMLParser *)parser {}

@end
