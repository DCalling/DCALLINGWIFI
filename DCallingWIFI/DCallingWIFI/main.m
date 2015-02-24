    //
//  main.m
//  DCalling WiFi
//
//  Created by David C. Son on 03.01.12.
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


#import "DCallingWIFIAppDelegate.h"

int main(int argc, char *argv[])
{
    
    @autoreleasepool {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
       
        
        
        int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([DCallingWIFIAppDelegate class]));
        [pool release];
        //return UIApplicationMain(argc, argv, nil, NSStringFromClass([DCallingWIFIAppDelegate class]));
        return retVal;
    }
}


/*
 #import <UIKit/UIKit.h>
 #import <AVFoundation/AVFoundation.h>
 
 #import "vbyantisipAppDelegate.h"
 #import "UIViewControllerStatus.h"
 #import "UIViewControllerDialpad.h"
 #import "UIViewControllerAbout.h"
 #import "UIViewControllerAbook.h"
 #import "UIViewControllerHistory.h"
 
 int main(int argc, char *argv[])
 {
 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
 
 [vbyantisipAppDelegate _initialize];
 [UIViewControllerStatus _keepAtLinkTime];
 [UIViewControllerDialpad _keepAtLinkTime];
 [UIViewControllerAbook _keepAtLinkTime];
 [UIViewControllerHistory _keepAtLinkTime];
 [UIViewControllerAbout _keepAtLinkTime];
 
 int retVal = UIApplicationMain(argc, argv, nil, nil);
 [pool release];
 return retVal;
 }

*/