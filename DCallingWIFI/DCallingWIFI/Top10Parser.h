//
//  Top10Parser.h
//  XMLParser
//
//  Created by Dileep Nagesh on 13/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Top10Parser : NSObject <NSXMLParserDelegate>
{
	NSString		*current;
	NSMutableString	*outstring;
	NSURL			*url;
	id			delegate;
	NSThread		*thread;
    NSThread        *myThread;
}

- (Top10Parser *) initWithDelegate: (id) d url: (NSURL *) u;

@end
