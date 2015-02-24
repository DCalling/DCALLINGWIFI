 //
//  DataModelRecent.m
//  DCalling WiFi
//
//  Created by Prashant Kumar on 20/06/12.
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

#import "DataModelRecent.h"
#import "FavViewHandler.h"
#import "SQLiteDBHandler.h"
#import "RestAPICaller.h"
#import "AddressBookHandler.h"
#import "FlatrateXMLParser.h"
#import "PreferencesHandler.h"
#import "getCreditHandler.h"
#import "ContactsViewController.h"


@implementation DataModelRecent
@synthesize window=_window, selectedDetails, param, fName,lName,oNumber,tNumber,mLabel,pController, mainValues, alertValues, noInternet, mProvider, mvaluesProvider, callingCallBack;

-(void) callingMethod:(NSString *)firstName :(NSString *)lastname :(NSString *)mobileLabel :(NSString *)originalNumber :(NSString *)trimNumber :(UIViewController *) param1{
    param = param1;
    fName = firstName;
    lName=lastname;
    mLabel=mobileLabel;
    oNumber=originalNumber;
    tNumber=trimNumber;
    pController=param1;
    mainValues = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,originalNumber,param1, nil];
    //NSLog(@"%@--- uu - %@", param1, pController);
    FavViewHandler *mFav = [[FavViewHandler alloc] init];
    AddressBookHandler *mAddr;
    if([mobileLabel length] < 2)
        mobileLabel = @" ";
    // NSLog(@"dssd %d", [mobileLabel length]);
    //BOOL scanValid = [mFav scanNumber:myUserDatastr];
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    NSString *calleridNo = [preferences getCallerID];
    NSString *getPrefix = [preferences getDropBox];
    
    //end code for servic e provider.
    //ContactsViewController *mContactView = [[ContactsViewController alloc]autorelease];
    //BOOL internetStatus = [mContactView CheckNetwork];
    alertValues=1;
    
    NSString *dialPrefix  = @"";
    NSString *getCountryCode = @"";
    //NSString *removedPrefix = @"";
    // int prefixLenght = [getPrefix length];
    //[preferences setCallingStatus:TRUE];
    getCountryCode = [mFav removedPlus:getPrefix];
    int prefixLen = (int)[getCountryCode length];
    NSRange RangeOfDial = NSMakeRange (0, prefixLen);
    dialPrefix = [trimNumber substringWithRange:RangeOfDial];
    //BOOL doubleZer1 = [mFav checkRemovedPlus:originalNumber];
    /*if(doubleZer1){
        originalNumber = [mFav removedPlus:originalNumber];
        originalNumber = [@"00" stringByAppendingFormat:@"%@", originalNumber];
    }*/
    BOOL checkStatus = [mFav checkNumberNational:trimNumber :originalNumber];
    mProvider=[preferences getServiceProvider];
    mvaluesProvider = [mFav checkProvider:mProvider];    
    //NSLog(@"helo %@---%@", mProvider, mvaluesProvider);
    [preferences setServiceProvider:nil];
    if([preferences getInternetConnection]==YES && [preferences getRoaming]==NO && checkStatus==FALSE && [getPrefix isEqualToString:@"+49"]){
        mAddr = [[AddressBookHandler alloc]init];
        NSString *dialin = [mAddr getDialin:getCountryCode];
        NSString *codePre=@"";
        NSArray *userData2;
        if(fName==nil || fName==NULL){
            fName=@"";
        }
        if(lName==nil || lName==NULL){
            lName=@"";
        }
        if(mLabel==nil || mLabel==NULL){
            mLabel=@"";
        }
        if(tNumber==nil || tNumber==NULL){
            tNumber=@"";
        }
        if(oNumber==nil || oNumber==NULL){
            oNumber=@"";
        }
        NSString *tri=@"";
        BOOL oris = [mFav checkPrefixStrLandLine:oNumber];
        if(oris == TRUE){
            tri = [@"0" stringByAppendingFormat:@"%@",tNumber];
            noInternet = [[NSArray alloc] initWithObjects:fName,lName,tri,mLabel,oNumber,dialin,getCountryCode, nil];
        }
        else{
            noInternet = [[NSArray alloc] initWithObjects:fName,lName,tNumber,mLabel,oNumber,dialin,getCountryCode, nil];
        }
        
        
        alertValues=303;
        BOOL checkAllGerman = [preferences getAllGermanProvider];
        BOOL vodafone = [preferences getVodafone];
        BOOL tmobile = [preferences getTmobile];
        BOOL oTwo = [preferences getOTwo];
        BOOL telogic = [preferences getTelogic];
        BOOL eplus = [preferences getEPlus];
        if(checkAllGerman==YES || vodafone==YES || tmobile==YES || oTwo==YES || telogic==YES || eplus==YES){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NO_INTERNET_NO_CACHE"] delegate:self cancelButtonTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"] otherButtonTitles:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"],nil];
            [alert show];
            [alert release];
        }
        else{
            BOOL st = [mFav checkPrefixStr:originalNumber];
            if(st == true){
                // NSLog(@"International");
                BOOL doubleZero = [mFav checkPrefixStr:trimNumber];
                if(doubleZero == FALSE)
                    trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
            }
            else{
                trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                
            }
            
            if([codePre length]>0){
                int counting = (int)[codePre length];
                NSRange range = NSMakeRange (counting, [trimNumber length]-counting);
                NSString *oriNumbs = [trimNumber substringWithRange:range];
                oris = [mFav checkPrefixStrLandLine:oNumber];
                if(oris == TRUE){
                    tri = [@"0" stringByAppendingFormat:@"%@",tNumber];
                    userData2 = [[NSArray alloc] initWithObjects:firstName,lastname,tri,mobileLabel,mvaluesProvider, nil];
                }
                else
                    userData2 = [[NSArray alloc]initWithObjects:firstName,lastname,oriNumbs,mobileLabel,mvaluesProvider, nil];
            }
            else{
                 userData2 = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
            }
            
           
            SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
            [sqliteDB saveCallLog:userData2];
            NSString *valNumber = [userData2 objectAtIndex:2];
            NSString *tel = [@"tel:" stringByAppendingFormat:@"%@",valNumber];
            NSURL *URL = [NSURL URLWithString:[tel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [pController viewWillAppear:YES];
            //[[UIApplication sharedApplication] openURL:URL];
            UIWebView *mCallWebview = [[UIWebView alloc] init]  ;
            //mCallWebview.delegate = self;
            [self.window addSubview:mCallWebview];
            [userData2 release];
            [mCallWebview loadRequest:[NSURLRequest requestWithURL:URL]];
        }
        [preferences setBestSearchProvider:nil];
        [preferences setInternetConnection:NO];
    }
    
    else if([preferences getInternetConnection]==YES  && [preferences getRoaming]==NO && checkStatus==TRUE && [getPrefix isEqualToString:@"+49"]){
        mAddr = [[AddressBookHandler alloc]init];
        NSString *dialin = [mAddr getDialin:getCountryCode];
        NSString *codePre=@"";
        //NSArray *userData2;
        
        if(fName==nil || fName==NULL){
            fName=@"";
        }
        if(lName==nil || lName==NULL){
            lName=@"";
        }
        if(mLabel==nil || mLabel==NULL){
            mLabel=@"";
        }
        if(tNumber==nil || tNumber==NULL){
            tNumber=@"";
        }
        if(oNumber==nil || oNumber==NULL){
            oNumber=@"";
        }
        NSString *tri=@"";
        BOOL oris = [mFav checkPrefixStrLandLine:oNumber];
        if(oris == TRUE){
            tri = [@"0" stringByAppendingFormat:@"%@",tNumber];
            noInternet = [[NSArray alloc] initWithObjects:fName,lName,tri,mLabel,oNumber,dialin,getCountryCode, nil];
        }
        else{
            noInternet = [[NSArray alloc] initWithObjects:fName,lName,tNumber,mLabel,oNumber,dialin,getCountryCode, nil];
        }
        
       // NSLog(@"val %@,%@,%@,%@,%@,%@,%@", fName,lName,tNumber,mLabel,oNumber,dialin,getCountryCode);
       // if([[preferences getBestSearchProvider]isEqualToString:@"NOCON"]){
            alertValues=202;
        BOOL checkAllGerman = [preferences getAllGermanProvider];
        if(checkAllGerman ==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NO_INTERNET_NOCACHE"] delegate:self cancelButtonTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"] otherButtonTitles:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"],nil];
        [alert show];
        [alert release];
        }
        else{
            BOOL st = [mFav checkPrefixStr:originalNumber];
            if(st == true){
                // NSLog(@"International");
                BOOL doubleZero = [mFav checkPrefixStr:trimNumber];
                if(doubleZero == FALSE)
                    trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
            }
            else{
                /*if([getPrefix isEqualToString:@"+1"]){
                    trimNumber = [@"011" stringByAppendingFormat:@"%@",trimNumber];
                    
                }
                else{
                    trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                    
                }*/
                trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];

                
            }
            if([codePre length]>0){
                int counting = (int)[codePre length];
                NSRange range = NSMakeRange (counting, [trimNumber length]-counting);
                NSString *oriNumbs = [trimNumber substringWithRange:range];
               selectedDetails = [[NSArray alloc]initWithObjects:firstName,lastname,oriNumbs,mobileLabel,mvaluesProvider, nil];
            }
            else{
                selectedDetails = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
            }
            
            
            mAddr = [[AddressBookHandler alloc]init];
            NSString *dialin = [mAddr getDialin:getCountryCode];
            //NSLog(@" Recent dialin %@",dialin);
            
            if([dialin isEqualToString:@""]){
                //[mAddr getAlterView:param1:trimNumber];
                [self getSMSLayout];
                //[mAddr smsController:param1 :trimNumber];
            }
            else {
                //commeted block on  27 jan 2014 for sqlite only
                
               /* SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
                [sqliteDB saveCallLog:selectedDetails];
               // NSString *plusNumber = nil;
                st = [mFav checkPrefixStr:trimNumber];*/
                /*if(st==TRUE){
                    BOOL doubleZero = [mFav checkRemovedPlus:trimNumber];
                    if(doubleZero==FALSE){
                        NSRange RangeOfDial = NSMakeRange (2, [trimNumber length]-2);
                        plusNumber = [trimNumber substringWithRange:RangeOfDial];
                        plusNumber = [@"+" stringByAppendingFormat:@"%@", plusNumber];
                    }
                    else{
                        plusNumber=trimNumber;
                    }
                }
                else{
                    plusNumber=[getPrefix stringByAppendingFormat:@"%@", trimNumber];
                }*/
                BOOL doubleZero = [mFav checkRemovedPlus:trimNumber];
                if(doubleZero){
                    trimNumber = [mFav removedPlus:trimNumber];
                    trimNumber = [@"00" stringByAppendingFormat:@"%@", trimNumber];
                }
                /*NSString *telString = [NSString stringWithFormat:@"tel:%@,,%@#", dialin, trimNumber];
                [param1 viewWillAppear:YES];
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
                NSURL *telURL = [NSURL URLWithString:telString];
                UIWebView *mCallWebview = [[UIWebView alloc] init] ;
                [preferences setCallingStatus:TRUE];
                //mCallWebview.delegate = self;
                [self.window addSubview:mCallWebview];
                [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                [selectedDetails release];*/
                alertValues=202;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NO_INTERNET_NOCACHE"] delegate:self cancelButtonTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"] otherButtonTitles:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"],nil];
                [alert show];
                [alert release];
                
            }
            
        }
        [preferences setBestSearchProvider:nil];
        [preferences setInternetConnection:NO];
    }
    
    /*else if(internetStatus==FALSE  && [preferences getRoaming]==YES && [getPrefix isEqualToString:@"+49"]){
        
                
        if(fName==nil || fName==NULL){
            fName=@"";
        }
        if(lName==nil || lName==NULL){
            lName=@"";
        }
        if(mLabel==nil || mLabel==NULL){
            mLabel=@"";
        }
        if(tNumber==nil || tNumber==NULL){
            tNumber=@"";
        }
        if(oNumber==nil || oNumber==NULL){
            oNumber=@"";
        }
        
                
        BOOL st = [mFav checkPrefixStr:originalNumber];
        BOOL checkZero = [mFav checkPrefixStrLandLine:originalNumber];
        NSArray *userdata ;
        if(st==TRUE){
            trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
            userdata = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
        }
        else{
            if(checkZero){
                NSString *trtr = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                userdata = [[NSArray alloc]initWithObjects:firstName,lastname,trtr,mobileLabel,mvaluesProvider, nil];
            }else{
                //trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                userdata = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
            }
            trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
            
        }
        
        callingCallBack = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
        
        SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
        [sqliteDB saveCallLog:userdata];
        NSLog(@"dsds %@", userdata);
        [self getSMSLayout];
        [preferences setBestSearchProvider:nil];
        [preferences setInternetConnection:NO];
        [userdata release];
    }*/
    
    else if(checkStatus == FALSE){
        
        int count = (int)[originalNumber length];
        
        if(count < 7){
            trimNumber=originalNumber;
        }
        else{
            BOOL st = [mFav checkPrefixStr:originalNumber];
            if(st == true){
            // NSLog(@"International");
                BOOL doubleZero = [mFav checkPrefixStr:trimNumber];
                if(doubleZero == FALSE)
                    trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
            }
            if(st == FALSE){
                // NSLog(@"International");
                BOOL singleZero = [mFav checkSingleZero:originalNumber];
                if(singleZero == TRUE)
                    trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
            }
            /*else{
                if(![getPrefix isEqualToString:@"+1"]){
                    trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                }
                
                            
            }*/
        }
        NSArray *userData2 = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
        SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
        [sqliteDB saveCallLog:userData2];
        NSString *tel = [@"tel:" stringByAppendingFormat:@"%@",trimNumber];
        NSURL *URL = [NSURL URLWithString:[tel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [pController viewWillAppear:YES];
        //[[UIApplication sharedApplication] openURL:URL];
        UIWebView *mCallWebview = [[UIWebView alloc] init]  ;
        //mCallWebview.delegate = self;
        [self.window addSubview:mCallWebview];
        
        [mCallWebview loadRequest:[NSURLRequest requestWithURL:URL]];
        [userData2 release];
        // mVal = 1;
        //[self viewWillAppear:YES];
        //[self performSelectorInBackground:@selector(updateCreditModel) withObject:nil];
    }
    else {        
        BOOL st = [mFav checkPrefixStr:originalNumber];
        NSLog(@"values %d -- %d, %d,  %@",[preferences getInternetConnection], [preferences getRoaming],checkStatus,getPrefix );
        BOOL foundPrefix=FALSE;
        if(st == true){
            if([getPrefix isEqualToString:@"+65"]){
                
                NSArray* inputArray = [NSArray arrayWithObjects:@"001",@"002", @"008",@"013", @"018", @"019", nil];
                
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [originalNumber substringWithRange:prefixRange];
                
                for (NSString* item in inputArray)
                {
                    if ([item rangeOfString:originalPrefix].location != NSNotFound){
                        foundPrefix=TRUE;
                        break;
                    }
                }
                if(foundPrefix==TRUE){
                    trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
                    NSRange prefixRange = NSMakeRange (3, [originalNumber length]-3);
                    originalNumber = [originalNumber substringWithRange:prefixRange];
                    originalNumber=[@"00" stringByAppendingFormat:@"%@",originalNumber];
                }
                else
                    trimNumber=originalNumber;
            }
            else if([getPrefix isEqualToString:@"+61"]){
                
                NSString *code = @"0011";
                
                NSRange prefixRange = NSMakeRange (0, 4);
                NSString *originalPrefix = [originalNumber substringWithRange:prefixRange];
                
                if([originalPrefix isEqualToString:code]){
                    foundPrefix=TRUE;
                    trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
                    NSRange prefixRange = NSMakeRange (4, [originalNumber length]-4);
                    originalNumber = [originalNumber substringWithRange:prefixRange];
                    originalNumber=[@"00" stringByAppendingFormat:@"%@",originalNumber];
                }
                else
                    trimNumber=originalNumber;
                
            }
            else if([getPrefix isEqualToString:@"+57"]){
                
                NSArray* inputArray = [NSArray arrayWithObjects:@"005", @"007", @"009", nil];
                
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [originalNumber substringWithRange:prefixRange];
                
                for (NSString* item in inputArray)
                {
                    if ([item rangeOfString:originalPrefix].location != NSNotFound){
                        foundPrefix=TRUE;
                        break;
                    }
                }
                if(foundPrefix==TRUE){
                    trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
                    NSRange prefixRange = NSMakeRange (3, [originalNumber length]-3);
                    originalNumber = [originalNumber substringWithRange:prefixRange];
                    originalNumber=[@"00" stringByAppendingFormat:@"%@",originalNumber];
                }
                else
                    trimNumber=originalNumber;
            }
            else if([getPrefix isEqualToString:@"+81"]){
                
                NSString *code = @"001";
                
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [originalNumber substringWithRange:prefixRange];
                
                if([originalPrefix isEqualToString:code]){
                    foundPrefix=TRUE;
                    trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
                    NSRange prefixRange = NSMakeRange (3, [originalNumber length]-3);
                    originalNumber = [originalNumber substringWithRange:prefixRange];
                    originalNumber=[@"00" stringByAppendingFormat:@"%@",originalNumber];
                }                
                
                else if (foundPrefix==FALSE){
                    NSArray* inputArray = [NSArray arrayWithObjects:@"0061", @"0041", nil];
                    
                    NSRange prefixRange = NSMakeRange (0, 4);
                    NSString *originalPrefix = [originalNumber substringWithRange:prefixRange];
                    
                    for (NSString* item in inputArray)
                    {
                        if ([item rangeOfString:originalPrefix].location != NSNotFound){
                            foundPrefix=TRUE;
                            break;
                        }
                    }
                    if(foundPrefix==TRUE){
                        trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
                        NSRange prefixRange = NSMakeRange (4, [originalNumber length]-4);
                        originalNumber = [originalNumber substringWithRange:prefixRange];
                        originalNumber=[@"00" stringByAppendingFormat:@"%@",originalNumber];
                    }
                    else
                        trimNumber=originalNumber;
                }
                else
                    trimNumber=originalNumber;
            }
            else if([getPrefix isEqualToString:@"+82"]){
                
                NSArray* inputArray = [NSArray arrayWithObjects:@"001", @"002",@"003", @"005", @"006",@"007", @"008", nil];
                
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [originalNumber substringWithRange:prefixRange];
                
                for (NSString* item in inputArray)
                {
                    
                    if ([item rangeOfString:originalPrefix].location != NSNotFound){
                        foundPrefix=TRUE;
                        break;
                    }
                }
                if(foundPrefix==TRUE){
                    if([originalPrefix isEqualToString:@"003"] || [originalPrefix isEqualToString:@"007"]){
                        trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
                        NSRange prefixRange = NSMakeRange (5, [originalNumber length]-5);
                        originalNumber = [originalNumber substringWithRange:prefixRange];
                        originalNumber=[@"00" stringByAppendingFormat:@"%@",originalNumber];
                    }
                    else{
                        trimNumber = [@"00" stringByAppendingFormat:@"%@",trimNumber];
                        NSRange prefixRange = NSMakeRange (3, [originalNumber length]-3);
                        originalNumber = [originalNumber substringWithRange:prefixRange];
                        originalNumber=[@"00" stringByAppendingFormat:@"%@",originalNumber];
                    }
                    
                }
                else
                    trimNumber=originalNumber;
            }
            else{
                trimNumber=originalNumber;
            }
            selectedDetails = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
            restApiCaller = [[RestAPICaller alloc]init];           
            
            if(foundPrefix==TRUE){
                restData = [restApiCaller getDialinXML:originalNumber :calleridNo :token];
                if(restData == NULL){
                    //NSLog(@"Empty");
                    mAddr = [[AddressBookHandler alloc]init];
                    NSString *dialin = [mAddr getDialin:getCountryCode];
                    //NSLog(@" Recent dialin %@",dialin);
                    
                    if([dialin isEqualToString:@""]){
                        //[mAddr getAlterView:param1:originalNumber];
                        [self getSMSLayout];
                        //[mAddr smsController:param1 :trimNumber];
                    }
                    else if([dialin length]>2 && [preferences getRoaming]==NO) {
                        
                        //SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
                       // [sqliteDB saveCallLog:selectedDetails];
                        //NSString *plusNumber = nil;
                        st = [mFav checkPrefixStr:originalNumber];
                        /*if(st==TRUE){
                            BOOL doubleZero = [mFav checkRemovedPlus:originalNumber];
                            if(doubleZero==FALSE){
                                NSRange RangeOfDial = NSMakeRange (2, [originalNumber length]-2);
                                plusNumber = [originalNumber substringWithRange:RangeOfDial];
                                plusNumber = [@"+" stringByAppendingFormat:@"%@", plusNumber];
                            }
                            else{
                                plusNumber=originalNumber;
                            }
                        }
                        else{
                            plusNumber=[getPrefix stringByAppendingFormat:@"%@", originalNumber];
                        }*/
                        BOOL doubleZero = [mFav checkRemovedPlus:originalNumber];
                        if(doubleZero){
                            originalNumber = [mFav removedPlus:originalNumber];
                            originalNumber = [@"00" stringByAppendingFormat:@"%@", originalNumber];
                        }
                        
                         noInternet = [[NSArray alloc] initWithObjects:firstName,lastname,originalNumber,mobileLabel,oNumber,dialin,getCountryCode, nil];
                         alertValues=202;
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NO_INTERNET_INTERNATIONAL"] delegate:self cancelButtonTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"] otherButtonTitles:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"],nil];
                         [alert show];
                         [alert release];
                        
                        /*NSString *telString = [NSString stringWithFormat:@"tel:%@,,%@#", dialin, originalNumber];
                        [param1 viewWillAppear:YES];
                        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
                        NSURL *telURL = [NSURL URLWithString:telString];
                        UIWebView *mCallWebview = [[UIWebView alloc] init] ;
                        [preferences setCallingStatus:TRUE];
                        //mCallWebview.delegate = self;
                        [self.window addSubview:mCallWebview];
                        [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];*/
                        [selectedDetails release];
                        //[mCallWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telString]]];
                        //mVal = 1;
                        //[self viewWillAppear:YES];
                    }
                    else{
                        if(foundPrefix ==TRUE)
                            [self getCallBackNotify:originalNumber:trimNumber];
                        else
                            [self getCallBackNotify:originalNumber:originalNumber];
                    }
                    
                }
                
                else if ([preferences getRoaming]==YES){
                    
                    
                    callingCallBack = [[NSArray alloc] initWithObjects:fName,lName,originalNumber, nil];
                    alertValues=123;
                    restApiCaller =[[RestAPICaller alloc]init];
                    NSData *apiData = [restApiCaller getcallBackRate:calleridNo :originalNumber :token];
                    // NSString *myString = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
                    [self CallBackRate:apiData];
                    NSArray *provider = [outstring componentsSeparatedByString: @"//"];
                    
                    
                    //NSLog(@"All Details C--%@, D--%@, T--%@, Arra--%@", calleridNo, trimNumber,token, provider);
                    NSString *calRate=@"";
                    //float price = [calRate floatValue];
                    //price = price*100;
                    if([provider count] > 0){
                        NSString *stratus =[provider objectAtIndex:0];
                        if([stratus isEqualToString:@"success\n"]){
                            if([provider count] > 1){
                                calRate =[provider objectAtIndex:1];
                                calRate = [calRate stringByReplacingOccurrencesOfString:@"//"  withString:@"\n"];
                            }
                            else{
                                calRate=@"00.00";
                            }
                        }
                        else{
                            calRate=@"00.00";
                        }
                    }
                    float zero = [@"00.00" floatValue];
                    float price = [calRate floatValue];
                    price = price*100;
                    zero = zero*100;
                    //NSLog(@"All Details C--%.2f", price);
                    NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES_OK"];
                    NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Cancel"];
                    
                    NSString *msg = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING"];
                    NSString *format = @"Cent/Min";
                    NSString *nos = [@"" stringByAppendingFormat:@"[%@]",trimNumber];
                    NSString *conf=@"";
                    if(zero !=price){
                        conf = [nos stringByAppendingFormat:@"[%.2f %@]",price,format];
                    /*else{
                        conf = [nos stringByAppendingFormat:@""];
                        
                    }
                    if(zero !=price){*/
                    NSString *priceVal = [@" " stringByAppendingFormat:@"%@",conf];
                    NSString *messageText = [msg stringByAppendingFormat:@"%@", priceVal];
                    //NSLog(@"msg -%@", messageText);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING_TITLE"] message:messageText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
                    //[[alert viewWithTag:1] removeFromSuperview];
                    //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
                    [alert show];
                    [alert release];
                    }
                    else{
                        [self getSMSLayout];
                    }
                    //[self callBackMethod:fName :lName :trimNumber];
                    
                }
                
                else {
                    FlatrateXMLParser *flatrateXMLParser;
                    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithDCallingPostDelegate: self xmlData:restData];
                    //[restData release];
                    
                }
            }
            else{
                restData = [restApiCaller getDialinXML:trimNumber :calleridNo :token];
                if(restData == NULL){
                    //NSLog(@"Empty");
                    mAddr = [[AddressBookHandler alloc]init];
                    NSString *dialin = [mAddr getDialin:getCountryCode];
                    //NSLog(@" Recent dialin %@",dialin);
                    noInternet = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,oNumber, dialin,getCountryCode, nil];
                    if([dialin isEqualToString:@""]){
                        //[mAddr getAlterView:param1:trimNumber];
                        //[mAddr smsController:param1 :trimNumber];
                        [self getSMSLayout];
                    }
                    else if([dialin length]>2 && [preferences getRoaming]==NO) {
                        
                        //SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
                        //[sqliteDB saveCallLog:selectedDetails];
                        /*NSString *plusNumber=nil;
                        BOOL doubleZero = [mFav checkPrefixStr:trimNumber];
                        if(doubleZero==TRUE){
                            doubleZero = [mFav checkRemovedPlus:trimNumber];
                            if(doubleZero == FALSE){
                                NSRange RangeOfDial = NSMakeRange (2, [trimNumber length]-2);
                                plusNumber = [trimNumber substringWithRange:RangeOfDial];
                                plusNumber = [@"+" stringByAppendingFormat:@"%@", plusNumber];
                            }
                            else{
                                plusNumber=trimNumber;
                            }
                        }
                        else{
                            plusNumber=[getPrefix stringByAppendingFormat:@"%@", trimNumber];
                        }*/
                       /* BOOL doubleZero = [mFav checkRemovedPlus:trimNumber];
                        if(doubleZero){
                            trimNumber = [mFav removedPlus:trimNumber];
                            trimNumber = [@"00" stringByAppendingFormat:@"%@", trimNumber];
                        }
                        NSString *telString = [NSString stringWithFormat:@"tel:%@,,%@#", dialin, trimNumber];
                        [param1 viewWillAppear:YES];
                        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
                        NSURL *telURL = [NSURL URLWithString:telString];
                        UIWebView *mCallWebview = [[UIWebView alloc] init] ;
                        [preferences setCallingStatus:TRUE];
                        //mCallWebview.delegate = self;
                        [self.window addSubview:mCallWebview];
                        [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                        [selectedDetails release];*/
                        
                        alertValues=202;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NO_INTERNET_INTERNATIONAL"] delegate:self cancelButtonTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"] otherButtonTitles:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"],nil];
                        [alert show];
                        [alert release];
                        //[mCallWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telString]]];
                        //mVal = 1;
                        //[self viewWillAppear:YES];
                    }
                    else{
                        //[self getCallBackNotify:trimNumber:trimNumber];
                        [self getSMSLayout];
                    }
                    
                }
                
                else if ([preferences getRoaming]==YES){
                    
                    
                    callingCallBack = [[NSArray alloc] initWithObjects:fName,lName,trimNumber, nil];
                    alertValues=123;
                    restApiCaller =[[RestAPICaller alloc]init];
                    NSData *apiData = [restApiCaller getcallBackRate:calleridNo :trimNumber :token];
                    // NSString *myString = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
                    [self CallBackRate:apiData];
                    NSArray *provider = [outstring componentsSeparatedByString: @"//"];
                    
                    
                    //NSLog(@"All Details C--%@, D--%@, T--%@, Arra--%@", calleridNo, trimNumber,token, provider);
                    NSString *calRate=nil;
                    //float price = [calRate floatValue];
                    //price = price*100;
                    if([provider count] > 0){
                        NSString *stratus =[provider objectAtIndex:0];
                        if([stratus isEqualToString:@"success\n"]){
                            if([provider count] > 1){
                                calRate =[provider objectAtIndex:1];
                                calRate = [calRate stringByReplacingOccurrencesOfString:@"//"  withString:@"\n"];
                            }
                            else{
                                calRate=@"00.00";
                            }
                        }
                        else{
                            calRate=@"00.00";
                        }
                    }
                    float zero = [@"00.00" floatValue];
                    float price = [calRate floatValue];
                    price = price*100;
                    zero = zero*100;
                    //NSLog(@"All Details C--%.2f", price);
                    NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES_OK"];
                    NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Cancel"];
                    
                    NSString *msg = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING"];
                    NSString *format = @"Cent/Min";
                    NSString *nos = [@"" stringByAppendingFormat:@"[%@]",originalNumber];
                    NSString *conf=@"";
                    if(zero !=price){
                        conf = [nos stringByAppendingFormat:@"[%.2f %@]",price,format];
                    /*else{
                        conf = [nos stringByAppendingFormat:@""];
                        
                    }
                    if(zero !=price){*/
                    NSString *priceVal = [@" " stringByAppendingFormat:@"%@",conf];
                    NSString *messageText = [msg stringByAppendingFormat:@"%@", priceVal];
                     //NSLog(@"msg -%@", messageText);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING_TITLE"] message:messageText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
                    //[[alert viewWithTag:1] removeFromSuperview];
                    //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
                    [alert show];
                    [alert release];
                    }
                    else{
                        [self getSMSLayout];
                    }
                    //[self callBackMethod:fName :lName :trimNumber];
                    
                }
                
                else {
                    FlatrateXMLParser *flatrateXMLParser;
                    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithDCallingPostDelegate: self xmlData:restData];
                    //[restData release];
                }
            }
            //NSLog(@"Length core %d", [restData length]);
            
            
            
        }
        else {
            NSString *codePre=@"";
            [preferences setCallingStatus:TRUE];
            
            BOOL checkZero = [mFav checkPrefixStrLandLine:originalNumber];
            BOOL st = [mFav checkPrefixStr:originalNumber];
            if(checkZero == true){
                if([getPrefix isEqualToString:@"+49"]){
                    //BOOL oris = [mFav checkPrefixStrLandLine:originalNumber];
                    if(checkZero == true){
                        trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                    }
                    else{
                        trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                        codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                    }
                }
                else{
                    if([getPrefix isEqualToString:@"+1"]){
                        NSRange RangeOfDial = NSMakeRange (0, 2);
                        NSString *landLine = [trimNumber substringWithRange:RangeOfDial];
                        if([landLine isEqualToString:@"11"]){
                            NSRange RangeOfDial = NSMakeRange (2, [trimNumber length]-2);
                            NSString *landLine = [trimNumber substringWithRange:RangeOfDial];
                            originalNumber=landLine;
                            trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                            originalNumber = [@"00" stringByAppendingFormat:@"%@",originalNumber];
                        }
                        else{
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                        }
                    }
                    else if([getPrefix isEqualToString:@"+61"]){
                        originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                        trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                    }
                    else if([getPrefix isEqualToString:@"+81"]){
                        
                        if([preferences getRoaming]==YES){
                            NSRange RangeOfDial = NSMakeRange (0, 2);
                            NSString *landLine = [trimNumber substringWithRange:RangeOfDial];
                            if([landLine isEqualToString:@"10"]){
                                NSRange RangeOfDial = NSMakeRange (2, [trimNumber length]-2);
                                NSString *landLine = [trimNumber substringWithRange:RangeOfDial];
                                originalNumber=landLine;
                                trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                                originalNumber = [@"00" stringByAppendingFormat:@"%@",originalNumber];
                            }
                            else{
                                originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                                trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                            }
                            
                        }
                        else{
                            NSRange RangeOfDial = NSMakeRange (2, [trimNumber length]-2);
                            NSString *landLine = [trimNumber substringWithRange:RangeOfDial];
                            originalNumber=landLine;
                            trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                            originalNumber = [@"00" stringByAppendingFormat:@"%@",originalNumber];
                        }
                    }
                    else if([getPrefix isEqualToString:@"+65"]){
                        
                        NSArray* inputArray = [NSArray arrayWithObjects:@"013", @"018", @"019", nil];
                        
                        NSRange prefixRange = NSMakeRange (0, 3);
                        NSString *originalPrefix = [originalNumber substringWithRange:prefixRange];
                        
                        for (NSString* item in inputArray)
                        {
                            if ([item rangeOfString:originalPrefix].location != NSNotFound){
                                foundPrefix = TRUE;
                                break;
                            }
                            else
                                foundPrefix = FALSE;
                        }
                        if(foundPrefix==TRUE){
                            NSRange RangeOfDial = NSMakeRange (2, [trimNumber length]-2);
                            NSString *landLine = [trimNumber substringWithRange:RangeOfDial];
                            originalNumber=landLine;
                            trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                            originalNumber = [@"00" stringByAppendingFormat:@"%@",originalNumber];
                        }
                        else{
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                        }
                        
                        
                    }
                    else if([getPrefix isEqualToString:@"+972"]){
                        NSArray* inputArray = [NSArray arrayWithObjects:@"012", @"013", @"014", @"015", @"016", @"017",@"018", @"019", nil];
                        
                        NSRange prefixRange = NSMakeRange (0, 3);
                        NSString *originalPrefix = [originalNumber substringWithRange:prefixRange];
                        
                        for (NSString* item in inputArray)
                        {
                            if ([item rangeOfString:originalPrefix].location != NSNotFound){
                                foundPrefix = TRUE;
                                break;
                            }
                            else
                                foundPrefix = FALSE;
                        }
                        if(foundPrefix==TRUE){
                            NSRange RangeOfDial = NSMakeRange (2, [trimNumber length]-2);
                            NSString *landLine = [trimNumber substringWithRange:RangeOfDial];
                            originalNumber=landLine;
                            trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                            originalNumber = [@"00" stringByAppendingFormat:@"%@",originalNumber];
                        }
                        else{
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                        }
                        
                    }
                    else {
                        originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                        trimNumber = [@"0" stringByAppendingFormat:@"%@",trimNumber];
                    }
                    
                }
                
               
            }
                
            else if (st==FALSE && checkZero==FALSE){
                
                if([getPrefix isEqualToString:@"+49"]){
                    if([trimNumber length] > 5){
                        trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                        codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                    }
                    else{
                        trimNumber=originalNumber;
                    }
                }
                else{
                    if([getPrefix isEqualToString:@"+1"]){
                        if([preferences getRoaming]==YES){
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                        }
                    }
                    else if([getPrefix isEqualToString:@"+61"]){
                        if([preferences getRoaming]==YES){
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                        }
                    }
                    else if([getPrefix isEqualToString:@"+81"]){
                        if([preferences getRoaming]==YES){
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                        }
                    }
                    else if([getPrefix isEqualToString:@"+65"]){
                        if([preferences getRoaming]==YES){
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                        }
                    }
                    else if([getPrefix isEqualToString:@"+972"]){
                        if([preferences getRoaming]==YES){
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                        }
                    }
                    else {
                        if([preferences getRoaming]==YES){
                            originalNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
                            codePre = [@"00" stringByAppendingFormat:@"%@",getCountryCode];
                        }
                    }
                }
                          
            }
            if([getPrefix isEqualToString:@"+49"] && [codePre length]>0){
                int counting = (int)[codePre length];
                NSRange range = NSMakeRange (counting, [trimNumber length]-counting);
                NSString *oriNumbs = [trimNumber substringWithRange:range];
                if(checkZero == TRUE){
                    if([getPrefix isEqualToString:@"+1"]){
                        oriNumbs = [@"0" stringByAppendingFormat:@"%@",oriNumbs];
                        trimNumber=oriNumbs;
                    }
                    else if([getPrefix isEqualToString:@"+61"]){
                        oriNumbs = [@"0" stringByAppendingFormat:@"%@",oriNumbs];
                        trimNumber=oriNumbs;
                    }
                    else if([getPrefix isEqualToString:@"+81"]){
                        oriNumbs = [@"0" stringByAppendingFormat:@"%@",oriNumbs];
                        trimNumber=oriNumbs;
                    }
                    else if([getPrefix isEqualToString:@"+65"]){
                        oriNumbs = [@"0" stringByAppendingFormat:@"%@",oriNumbs];
                        trimNumber=oriNumbs;
                    }                    
                    else if([getPrefix isEqualToString:@"+972"]){
                        oriNumbs = [@"0" stringByAppendingFormat:@"%@",oriNumbs];
                        trimNumber=oriNumbs;
                    }
                    
                    else{
                        oriNumbs = [@"0" stringByAppendingFormat:@"%@",oriNumbs];
                    }
                    //oriNumbs = [@"0" stringByAppendingFormat:@"%@",oriNumbs];
                }
                selectedDetails = [[NSArray alloc]initWithObjects:firstName,lastname,oriNumbs,mobileLabel,mvaluesProvider, nil];
            }
            else{
                selectedDetails = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
            }
            
            restApiCaller = [[RestAPICaller alloc]init];
            
            if (![getPrefix isEqualToString:@"+49"] && st==FALSE){
                restData = [restApiCaller getDialinXML:originalNumber :calleridNo :token];
            }
            else
                restData = [restApiCaller getDialinXML:trimNumber :calleridNo :token];
            NSLog(@"Length %lu", (unsigned long)[restData length]);
            if(restData == NULL){
                //NSLog(@"Empty");
                mAddr = [[AddressBookHandler alloc]init];
                NSString *dialin = [mAddr getDialin:getCountryCode];
                //NSLog(@" Recent dialin %@",dialin);
                
                if([dialin isEqualToString:@""]){
                    //[mAddr getAlterView:param1:trimNumber];
                    BOOL checking = [mFav checkPrefixStrLandLine:trimNumber];
                    if(checking==TRUE){
                        trimNumber = [mAddr prefixStr:trimNumber];
                        trimNumber = [@"00" stringByAppendingFormat:@"%@%@", getCountryCode, trimNumber];
                    }
                    else{
                        trimNumber = [@"00" stringByAppendingFormat:@"%@%@", getCountryCode, trimNumber];
                    }
                    callingCallBack = [[NSArray alloc]initWithObjects:firstName,lastname,trimNumber,mobileLabel,mvaluesProvider, nil];
                    [self getSMSLayout];
                    //[mAddr smsController:param1 :trimNumber];
                }
                
                else if([dialin length]>2 && [preferences getRoaming]==NO) {
                    //NSLog(@"orig %@", originalNumber);
                    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
                    [sqliteDB saveCallLog:selectedDetails];
                    NSString *telString=@"";
                   // NSString *plusNumber=nil;
                    //BOOL doubleZero = [mFav checkPrefixStr:trimNumber];
                    /*if(doubleZero==TRUE){
                        doubleZero = [mFav checkRemovedPlus:trimNumber];
                        if(doubleZero==FALSE){
                            NSRange RangeOfDial = NSMakeRange (2, [trimNumber length]-2);
                            plusNumber = [trimNumber substringWithRange:RangeOfDial];
                            plusNumber = [@"+" stringByAppendingFormat:@"%@", plusNumber];
                        }
                        else{
                            plusNumber=trimNumber;
                        }
                    }
                    else{
                        plusNumber=[getPrefix stringByAppendingFormat:@"%@", trimNumber];
                    }*/
                    NSString *bothNumbers = nil;
                    if (![getPrefix isEqualToString:@"+49"] && st==FALSE){
                        BOOL doubleZero = [mFav checkRemovedPlus:originalNumber];
                        if(doubleZero){
                            originalNumber = [mFav removedPlus:originalNumber];
                            originalNumber = [@"00" stringByAppendingFormat:@"%@", originalNumber];
                        }
                        bothNumbers=originalNumber;
                        telString = [NSString stringWithFormat:@"tel:%@,,%@#", dialin, originalNumber];
                    }
                    else{
                        BOOL doubleZero = [mFav checkRemovedPlus:trimNumber];
                        if(doubleZero){
                            trimNumber = [mFav removedPlus:trimNumber];
                            trimNumber = [@"00" stringByAppendingFormat:@"%@", trimNumber];
                        }
                        bothNumbers=trimNumber;
                        telString = [NSString stringWithFormat:@"tel:%@,,%@#", dialin, trimNumber];
                    }
                    
                    noInternet = [[NSArray alloc] initWithObjects:firstName,lastname,bothNumbers,mobileLabel,oNumber,dialin,getCountryCode, nil];
                    alertValues=202;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_CONNECTION_WARNING"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NO_INTERNET_INTERNATIONAL"] delegate:self cancelButtonTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"] otherButtonTitles:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"],nil];
                    [alert show];
                    [alert release];
                    
                   // NSString *telString = [NSString stringWithFormat:@"tel:%@,,%@#", dialin, trimNumber];
                   /* [param1 viewWillAppear:YES];
                    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
                    NSURL *telURL = [NSURL URLWithString:telString];
                    UIWebView *mCallWebview = [[UIWebView alloc] init] ;
                    [preferences setCallingStatus:TRUE];
                    //mCallWebview.delegate = self;
                    [self.window addSubview:mCallWebview];
                    [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];*/
                    [selectedDetails release];
                    //[mCallWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telString]]];
                    // mVal = 1;
                    //[self viewWillAppear:YES];
                }
                else{
                    if (![getPrefix isEqualToString:@"+49"] && st==FALSE){
                        [self getCallBackNotify:originalNumber:trimNumber];
                    }
                    else if([getPrefix isEqualToString:@"+49"] && st==FALSE){
                        callingCallBack = [[NSArray alloc] initWithObjects:fName,lName,trimNumber, nil];
                        [self getSMSLayout];
                    }
                    else
                        [self getCallBackNotify:trimNumber:originalNumber];
                }
                
                
            }
            else if ([preferences getRoaming]==YES){
                
                //NSString *oriNos = [selectedDetails objectAtIndex:2];
                if([getPrefix isEqualToString:@"+49"])
                    callingCallBack = [[NSArray alloc] initWithObjects:fName,lName,trimNumber, nil];
                else                    
                    callingCallBack = [[NSArray alloc] initWithObjects:fName,lName,originalNumber, nil];
                alertValues=123;
                
                restApiCaller =[[RestAPICaller alloc]init];
                NSData *apiData;
                if([getPrefix isEqualToString:@"+49"])
                    apiData = [restApiCaller getcallBackRate:calleridNo :trimNumber :token];
                else                    
                    apiData = [restApiCaller getcallBackRate:calleridNo :originalNumber :token];
                
                if(![getPrefix isEqualToString:@"+49"] && st==FALSE)
                    originalNumber=trimNumber;
                else if ([getPrefix isEqualToString:@"+49"] && st==FALSE){
                    trimNumber=originalNumber;
                }
                else{
                    NSLog(@"Nothing");
                }
                //NSString *myString = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
                [self CallBackRate:apiData];
                NSArray *provider = [outstring componentsSeparatedByString: @"//"];
                NSString *calRate =@"";
                //NSLog(@"All Details C--%@, D--%@, T--%@, Arra--%@", calleridNo, trimNumber,token, provider);
                
                //float price = [calRate floatValue];
                //price = price*100;
                if([provider count] > 0){
                    NSString *stratus =[provider objectAtIndex:0];
                    if([stratus isEqualToString:@"success\n"]){
                        if([provider count] > 1){
                            calRate =[provider objectAtIndex:1];
                            calRate = [calRate stringByReplacingOccurrencesOfString:@"//"  withString:@"\n"];
                        }
                        else{
                            calRate=@"00.00";
                        }
                        
                    }
                    else{
                        calRate=@"00.00";
                    }
                }
                float zero = [@"00.00" floatValue];
                float price = [calRate floatValue];
                price = price*100;
                zero = zero*100;
                //NSLog(@"All Details C--%.2f", price);
                NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES_OK"];
                NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Cancel"];
                
                NSString *msg = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING"];
                NSString *format = @"Cent/Min";
                NSString *nos = [@"" stringByAppendingFormat:@"[%@]",originalNumber];
                NSString *conf=@"";
                if(zero !=price){
                    conf = [nos stringByAppendingFormat:@"[%.2f %@]",price,format];
                /*else{
                    conf = [nos stringByAppendingFormat:@""];
                    
                }*/
                
                NSString *priceVal = [@" " stringByAppendingFormat:@"%@",conf];
                NSString *messageText = [msg stringByAppendingFormat:@"%@", priceVal];
                 //NSLog(@"msg -%@", messageText);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING_TITLE"] message:messageText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
                //[[alert viewWithTag:1] removeFromSuperview];
                //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
                [alert show];
                [alert release];
            }
                else{
                    [self getSMSLayout];
                }
                //[self callBackMethod:fName :lName :trimNumber];
            }
            else {
                //NSLog(@"data -- %@", selectedDetails);
                FlatrateXMLParser *flatrateXMLParser;
                flatrateXMLParser = [[FlatrateXMLParser alloc] initWithDCallingPostDelegate: self xmlData:restData];
                //[restData release];
            }
            
        }
        
    }
    [mFav release];
    //[mAddr release];
}

-(void) dCallingParsePostDidComplete: (NSMutableString *) result{ // call by thread. in xmlParser class
    NSLog(@"result: %@",result);
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *myStringth = [result stringByReplacingOccurrencesOfString:
                            @"dialin" withString: @""];
    NSString *myString2 = [myStringth stringByReplacingOccurrencesOfString:
                           @"POST" withString: @""];
    NSString *myString3 = [myString2 stringByReplacingOccurrencesOfString:
                           @"\n" withString: @""];
    NSString *dialin = [myString3 stringByReplacingOccurrencesOfString:
                        @"success" withString: @""];
    NSString *rate = [dialin stringByReplacingOccurrencesOfString:
                      @"callingrate" withString: @""];
    NSArray *personNames = [dialin componentsSeparatedByString: @"//"];
    if([personNames count]>1){
        dialin = [personNames objectAtIndex:0];
        rate = [personNames objectAtIndex:2];
    }
   // NSLog(@"hh %@--%@",dialin, selectedDetails);
    
    
    NSRange textRange;
    NSRange textRangeError;
    textRangeError =[result rangeOfString:@"error"];
    textRange = [result rangeOfString:@"success"];
    [pController viewWillAppear:YES];
    if(textRange.location != NSNotFound){
        SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
        BOOL status = [sqliteDB saveCallLog:selectedDetails];
        NSLog(@"first %d", status);
        
        //if(status == YES){
           /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NOTIFY_CON"] message:messageText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];*/
            //oNumber=[mainValues objectAtIndex:4];
            fName=[selectedDetails objectAtIndex:0];
            lName=[selectedDetails objectAtIndex:1];
            tNumber=[selectedDetails objectAtIndex:2];            
            mLabel=[selectedDetails objectAtIndex:3];
        float price = [rate floatValue];
        price = price*100;
        
           // pController=[mainValues objectAtIndex:5];
            mainValues = [[NSArray alloc] initWithObjects:fName,lName,tNumber,mLabel,dialin, nil];
        //NSLog(@"International -- %@", mainValues);
        if([preferences getDoNot]==NO){
            alertValues=101;
            NSString *textFirst  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTE"];
            //NSString *textSecond  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES"];
            NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES_OK"];
            NSString *doNotButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES_CANCEL"];
            NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Cancel"];
            NSString *format = @"Cent/Min";
            NSString *conf = [tNumber stringByAppendingFormat:@" %.2f %@", price,format];
            NSString *priceVal = [@" " stringByAppendingFormat:@"%@",conf];
            NSString *messageText = [textFirst stringByAppendingFormat:@"%@", priceVal];
            float version = [[UIDevice currentDevice].systemVersion floatValue];
            UIAlertView *alert = nil;
            if(version >= 7.0 )
                alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTE_TITLE"] message:messageText delegate:self cancelButtonTitle:nil otherButtonTitles:OKButton,doNotButton,cancelButton,  nil];
            else{
                alertValues=606;
                alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTE_TITLE"] message:messageText delegate:self cancelButtonTitle:@"" otherButtonTitles:OKButton,doNotButton,cancelButton,  nil];
            }
            [[alert viewWithTag:1] removeFromSuperview];
            //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
                [alert show];
                [alert release];
            [selectedDetails release];
        }
        else{
            //[preferences setDoNot:NO];
            [self callinggSome];
        }
            //[self performSelectorInBackground:@selector(updateCreditModel) withObject:nil];
            // mVal = 1;
            //[self viewWillAppear:YES];
        //}
    }
    else if(textRangeError.location != NSNotFound){
        NSString *errorEl = [myString3 stringByReplacingOccurrencesOfString:
                             @"error" withString: @""];
        // NSLog(@"sds %@", errorEl);
        NSString *myString4 = [errorEl stringByReplacingOccurrencesOfString:
                               @"Authentication failureInvalid token or no token found in data" withString: @""];
        myString4 = [myString4 stringByReplacingOccurrencesOfString:
                     @"No s foundNo s found in the database. Contact support." withString: @""];
        myString4 = [myString4 stringByTrimmingCharactersInSet:  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // NSLog(@"sds %@", myString4);
        if([myString4 isEqualToString:@"1001"] || [myString4 isEqualToString:@"1005"]){
            
            NSString *caller = [preferences getCallerID];
            [self checkAuthToken:caller];
            /*//55acde6bd3357e835d479546cf46e729
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"ERROR_MSG"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SELECT_OTHER_COUNTRY"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [alert release];*/
            
        }
        else if([myString4 isEqualToString:@"1018"]) {
            //NSString *caller = [preferences getCallerID];
            //[self getCallBackNotify:tNumber:originalNumber];
            //[self checkAuthToken:caller];
            //NSLog(@"not support %@", myString4);
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"ERROR_MSG"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SELECT_OTHER_COUNTRY"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];*/
            NSString *getPrefix = [preferences getDropBox];
            NSString *calleridNo = [preferences getCallerID];
            NSString *token = [preferences getToken];
            BOOL st = TRUE;
            //NSLog(@"save log %@", selectedDetails);
            SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
            BOOL status = [sqliteDB saveCallLog:selectedDetails];
            NSLog(@"first %d", status);
            //[self getSMSLayout];
            [self otherCountriesDialing:getPrefix :tNumber :oNumber :calleridNo :token :st];
            
            
        }
        
    }
    /* else if (textRangeError.location != NSNotFound) {
     NSLog(@"fdsf -%@", result);
     NSString *numbers = [dialin stringByReplacingOccurrencesOfString:
     @"No s foundNo s found in the database. Contact support" withString: @""];
     NSString *num = [numbers stringByReplacingOccurrencesOfString:                            @"error" withString: @""];
     num = [num stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
     
     
     NSLog(@"fdsf -%@", num);
     }*/
    
    /* else if (textRangeError.location != NSNotFound) {
     NSString *fname;
     NSString *lname;
     NSString *trimNumber;
     if([selectedDetails count] == 4){
     fname = [selectedDetails objectAtIndex:0];
     lname = [selectedDetails objectAtIndex:1];
     trimNumber = [selectedDetails objectAtIndex:2];
     }
     [self callBackMethod:fname :lname :trimNumber];
     
     }*/
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg11"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg9"]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
        
    }
}

-(void)callBackMethod:(NSString *)firstName :(NSString *)lastname :(NSString *)trimNumber{
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    NSString *calleridNo = [preferences getCallerID];
    restApiCaller = [[RestAPICaller alloc]init];
    restData = [restApiCaller getCallBackXML:trimNumber :calleridNo :token];
    // add comment on 15 April 2014
    /*if(restData == NULL){
        alertValues=567;
        NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"];
        NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"];
        NSString *msgText  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SMS_CALLING"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SMS_CALLING_TITLE"] message:msgText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
        //[[alert viewWithTag:1] removeFromSuperview];
        //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
        [alert show];
        [alert release];
        
    }
    else{*/
        FlatrateXMLParser *flatrateXMLParser;
        flatrateXMLParser = [[FlatrateXMLParser alloc] initWithCallBackDCallingPostDelegate: self xmlData:restData];
        //[restData release];
    //}
}

-(void) callBackDCallingParsePostDidComplete: (NSMutableString *) result{ // call by thread. in xmlParser class
    //NSLog(@"result: %@",result);
    
    NSString *myStringth = [result stringByReplacingOccurrencesOfString:
                            @"dialin" withString: @""];
    NSString *myString2 = [myStringth stringByReplacingOccurrencesOfString:
                           @"POST" withString: @""];
    NSString *myString3 = [myString2 stringByReplacingOccurrencesOfString:
                           @"\n" withString: @""];
    NSString *dialin = [myString3 stringByReplacingOccurrencesOfString:
                        @"success" withString: @""];
    
    NSLog(@"hh1 %@ -- %lu",dialin, (unsigned long)result.length);
    
    NSRange textRange;
    NSRange textRangeError;
    textRangeError =[result rangeOfString:@"error"];
    textRange = [result rangeOfString:@"success"];
    //NSLog(@"xml %@", selectedDetails);
    /*PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *getPrefix = [preferences getDropBox];
    if([getPrefix isEqualToString:@"+1"]){
        NSString *onu;
        NSString *oneOne = [selectedDetails objectAtIndex:2];
        NSString *fna = [selectedDetails objectAtIndex:0];
        NSString *lna = [selectedDetails objectAtIndex:1];
        NSString *mna = [selectedDetails objectAtIndex:3];
        NSString *valna = [selectedDetails objectAtIndex:4];
        NSRange RangeOfDial = NSMakeRange (0, 3);
        NSString *dialPrefix = [oneOne substringWithRange:RangeOfDial];
        NSString *dialPrefixCh = [oNumber substringWithRange:RangeOfDial];
        if(![dialPrefix isEqualToString:dialPrefixCh]){
            NSRange RangeOfDial = NSMakeRange (3, oneOne.length);
            onu = [oneOne substringWithRange:RangeOfDial];
            selectedDetails = nil;
            selectedDetails = [[NSArray alloc]initWithObjects:fna,lna,onu,mna,valna, nil];
        }
        [oneOne release];
        [fna release];
        [lna release];
        [valna release];
        [onu release];
        //[oneOne release];
        [dialPrefixCh release];
        [dialPrefix release];
        
    }*/
    
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    BOOL status = [sqliteDB saveCallLog:selectedDetails];
    if(textRange.location != NSNotFound){
        
        if(status == YES){
            //PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
            //[preferences setCallingStatus:TRUE];
            //[self performSelectorInBackground:@selector(updateCreditModel) withObject:nil];
        }
        [selectedDetails release];
    }
    
    else if (textRangeError.location !=NSNotFound ){
         PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
        NSString *errorEl = [myString3 stringByReplacingOccurrencesOfString:
                             @"error" withString: @""];
        // NSLog(@"sds %@", errorEl);
        NSString *myString4 = [errorEl stringByReplacingOccurrencesOfString:
                               @"No creditYou don t have enough credit to call you back !!!" withString: @""];
        myString4 = [myString4 stringByReplacingOccurrencesOfString:
                     @"callback\t\t" withString: @""];
        myString4 = [myString4 stringByTrimmingCharactersInSet:  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([myString4 isEqualToString:@"1023"]){
            
            //NSLog(@"Not Suffienct Balance  ");
             NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES_OK"];
            NSString *msgText  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CREDIT_NOT_SUFFICIENT"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CREDIT_NOT_SUFFICIENT_TITLE"] message:msgText delegate:nil cancelButtonTitle:OKButton  otherButtonTitles:nil];
            
            
            [alert show];
            [alert release];
            
            
        }
        else{
            NSString *caller = [mPref getCallerID];
            [self checkAuthToken:caller];
            NSString *fname;
            NSString *lname;
            NSString *trimNumber;
            if([selectedDetails count] == 5){
                fname = [selectedDetails objectAtIndex:0];
                lname = [selectedDetails objectAtIndex:1];
                trimNumber = [selectedDetails objectAtIndex:2];
            }
            [selectedDetails release];
        }
    }
    
    else{
        
        /*PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
        NSString *caller = [mPref getCallerID];
        [self checkAuthToken:caller];
        NSString *fname;
        NSString *lname;
        NSString *trimNumber;
        if([selectedDetails count] == 5){
            fname = [selectedDetails objectAtIndex:0];
            lname = [selectedDetails objectAtIndex:1];
            trimNumber = [selectedDetails objectAtIndex:2];
        }
        [selectedDetails release];*/
        //[mAddr getAlterView:param:trimNumber];
        
        
        /*UIAlertView *message = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg11"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg9"]
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         
         [message show];
         return;*/
        
    }
}

- (void) updateCreditModel {
    pool = [[NSAutoreleasePool alloc] init];
    runLoopData = [NSRunLoop currentRunLoop];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self  selector:@selector(getCreditModel) userInfo:nil repeats:YES];
    
    [runLoopData run];
    [pool release];
}

-(void) getCreditModel
{
    
    getCreditHandler *mGetCrHandler = [[getCreditHandler alloc] init];
    [mGetCrHandler getCredit];
    // PreferencesHandler *mPrefs = [[PreferencesHandler alloc]init];
    //[mPrefs setCallingStatus:FALSE];
    NSLog(@"update credit");
}

-(void)stopTimer{
    
    [updateTimer invalidate];
    updateTimer = nil;
    [pool drain];
    
}

-(void)checkAuthToken:(NSString *)AuthToken{
    restApiCaller = [[RestAPICaller alloc]init];
    restData = [restApiCaller getAuthUser:AuthToken];
    FlatrateXMLParser *flatrateXMLParser;
    NSLog(@"%lu", (unsigned long)[restData length]);
    flatrateXMLParser = [[FlatrateXMLParser alloc] initWithAuthSessionDelegate:self xmlData:restData];
    //[restData release];
}

-(void)authSessionParserDidComplete:(NSMutableString *) result {
    
    // NSLog(@"######## in AuthSessionParseDidComplete");
    
    // NSLog(@"Hello AuthSession - %@",result);
    NSString *myString = [NSString stringWithString:result];
    NSRange range = NSMakeRange (25, 32);
    
    NSString *authSessionToken = [myString substringWithRange:range];
    AddressBookHandler *mAdd = [[AddressBookHandler alloc]autorelease];
    NSString *trNumber1 = [mAdd trimWhiteSpace:oNumber];
    //NSLog(@"token :- %@", [myString substringWithRange:range]);
    //[activityIndicator stopAnimating];
    
    // read token from xml and save to preferences
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    //NSLog(@"TOken %@", [preferences getToken]);
    if(![[preferences getToken] isEqualToString:authSessionToken]){
        [preferences setToken:authSessionToken];
        if([preferences getRoaming]==YES){
            alertValues=567;
            NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"];
            NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"];
            NSString *msgText  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SMS_CALLING"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SMS_CALLING_TITLE"] message:msgText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
            //[[alert viewWithTag:1] removeFromSuperview];
            //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
            [alert show];
            [alert release];
        }
        else
           [self callingMethod:fName :lName :mLabel :oNumber :trNumber1 :pController];
    }
}

-(void) callinggSome {
    fName=[mainValues objectAtIndex:0];
    lName=[mainValues objectAtIndex:1];
    tNumber=[mainValues objectAtIndex:2];
    mLabel=[mainValues objectAtIndex:3];
    NSString *dialin = [mainValues objectAtIndex:4];
    NSString *tel = [@"tel:" stringByAppendingFormat:@"%@",dialin];
    [pController viewWillAppear:YES];
    
    NSURL *URL = [NSURL URLWithString:[tel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //[[UIApplication sharedApplication] openURL:URL];
    UIWebView *mCallWebview = [[UIWebView alloc] init]  ;
    //mCallWebview.delegate = self;
    [self.window addSubview:mCallWebview];
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    if((token == NULL) && (token == nil)){
        return;
    }
    NSLog(@"url %@", URL);
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:URL]];
    [mainValues release];
    [preferences setCallingStatus:TRUE];
    //NSLog(@"Calling %@--%@",fName, lName, tNumber);
}

/*- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if([[[request URL] absoluteString] hasPrefix:@"tel:"]){
        NSArray *components = [[[request URL] absoluteString] componentsSeparatedByString:@":"];
        NSString *function = [components objectAtIndex:1];
        NSLog(@"%@ - %@ - %u ", components, function, navigationType);
        [request accessibilityLabel];
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}*/
-(void) callingDirect {
    fName=[noInternet objectAtIndex:0];
    lName=[noInternet objectAtIndex:1];
    tNumber=[noInternet objectAtIndex:2];
    mLabel=[noInternet objectAtIndex:3];
    //NSString *dialin = [noInternet objectAtIndex:4];
    oNumber=[noInternet objectAtIndex:4];
    //NSString *getCountryCode = [noInternet objectAtIndex:6];
    FavViewHandler *mFav = [[FavViewHandler alloc] init];
   /* BOOL st = [mFav checkPrefixStr:oNumber];
    if(st == true){
        // NSLog(@"International");
        BOOL doubleZero = [mFav checkPrefixStr:tNumber];
        if(doubleZero == FALSE)
            tNumber = [@"00" stringByAppendingFormat:@"%@",tNumber];
    }
    else{
        tNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,tNumber];
        
        
    }*/
    
    int count = (int)[oNumber length];
    
    if(count < 7){
        tNumber=oNumber;
    }
    else{
        BOOL st = [mFav checkPrefixStr:oNumber];
        if(st == true){
            // NSLog(@"International");
            BOOL doubleZero = [mFav checkPrefixStr:tNumber];
            if(doubleZero == FALSE)
                tNumber = [@"00" stringByAppendingFormat:@"%@",tNumber];
        }
        
        /*else{
         if(![getPrefix isEqualToString:@"+1"]){
         trimNumber = [@"00" stringByAppendingFormat:@"%@%@",getCountryCode,trimNumber];
         }
         
         
         }*/
    }
    
    //NSLog(@"fname-%@, lname-%@, tno-%@,mlabel-%@,ono-%@", fName,lName,tNumber, mLabel, oNumber);
    NSArray *userData2 = [[NSArray alloc]initWithObjects:fName,lName,oNumber,mLabel,mvaluesProvider, nil];
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    [sqliteDB saveCallLog:userData2];
    
    NSString *tel = [@"tel:" stringByAppendingFormat:@"%@",oNumber];
    [pController viewWillAppear:YES];
    NSURL *URL = [NSURL URLWithString:[tel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //[[UIApplication sharedApplication] openURL:URL];
    UIWebView *mCallWebview = [[UIWebView alloc] init]  ;
    ////mCallWebview.delegate = self;
    [self.window addSubview:mCallWebview];
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    if((token == NULL) && (token == nil)){
        return;
    }
    NSLog(@"url %@", URL);
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:URL]];
    [userData2 release];
    [preferences setCallingStatus:TRUE];
    //NSLog(@"Calling %@--%@",fName, lName, tNumber);
}

-(void) callingFRB {
    //NSLog(@"Arr %@", noInternet);
    fName=[noInternet objectAtIndex:0];
    lName=[noInternet objectAtIndex:1];
    tNumber=[noInternet objectAtIndex:2];
    mLabel=[noInternet objectAtIndex:3];
    oNumber = [noInternet objectAtIndex:4];
    NSString *dialin = [noInternet objectAtIndex:5];
   
    FavViewHandler *mFav = [[FavViewHandler alloc] init];
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    BOOL st = [mFav checkPrefixStr:oNumber];
    if(st == true){
        // NSLog(@"International");
        BOOL doubleZero = [mFav checkPrefixStr:tNumber];
        if(doubleZero == FALSE)
            tNumber = [@"00" stringByAppendingFormat:@"%@",tNumber];
    }
    
    //NSLog(@"fname-%@, lname-%@, tno-%@,mlabel-%@,ono-%@, dialin-%@, cou-%@", fName,lName,tNumber, mLabel, oNumber, dialin, getCountryCode);
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    
        noInternet=[[NSArray alloc] initWithObjects:fName,lName,oNumber,mLabel,mvaluesProvider, nil];
       
    [sqliteDB saveCallLog:noInternet];
    [noInternet release];
    //int prefixLen = [getCountryCode length];
    //NSString *plusNumber = nil;
    st = [mFav checkPrefixStr:tNumber];
   // NSString *getPrefix = [preferences getDropBox];
    /*if(st==TRUE){
        BOOL doubleZero = [mFav checkRemovedPlus:tNumber];
        if(doubleZero==FALSE){
            NSRange RangeOfDial = NSMakeRange (2, [tNumber length]-2);
            plusNumber = [tNumber substringWithRange:RangeOfDial];
            plusNumber = [@"+" stringByAppendingFormat:@"%@", plusNumber];
        }
        else{
            plusNumber=tNumber;
        }
    }
    else{
        
        plusNumber=[getPrefix stringByAppendingFormat:@"%@", tNumber];
    }*/
    NSString *plusNumb =nil;
    NSString *tel = nil;
    BOOL doubleZero = [mFav checkRemovedPlus:tNumber];
    if(doubleZero){
        plusNumb = [mFav removedPlus:tNumber];
        plusNumb = [@"00" stringByAppendingFormat:@"%@", plusNumb];
        tel = [NSString stringWithFormat:@"tel:%@,,%@#", dialin, plusNumb];
    }
    else{
        tel = [NSString stringWithFormat:@"tel:%@,,%@#", dialin, tNumber];
    }
    
    [pController viewWillAppear:YES];
    NSURL *URL = [NSURL URLWithString:tel];
    //[[UIApplication sharedApplication] openURL:URL];
    UIWebView *mCallWebview = [[UIWebView alloc] init]  ;
    ////mCallWebview.delegate = self;
    [self.window addSubview:mCallWebview];
    NSString *token = [preferences getToken];
    if((token == NULL) && (token == nil)){
        return;
    }
    NSLog(@"url %@", URL);
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:URL]];
    
    [preferences setCallingStatus:TRUE];
    //NSLog(@"Calling %@--%@",fName, lName, tNumber);
}

- (void)callingCallBackMethod {
    fName=[callingCallBack objectAtIndex:0];
    lName=[callingCallBack objectAtIndex:1];
    tNumber=[callingCallBack objectAtIndex:2];
    NSLog(@"name : %@ -- %@ --- %@", fName, lName, tNumber);
    [self callBackMethod:fName :lName :tNumber];
    
}

- (void) saveRecentDial{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    BOOL status = [sqliteDB saveCallLog:selectedDetails];
    NSLog(@"saveRecentDial method %u", status);
}

-(void) getSMSLayout{
    alertValues=567;
    NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_NO"];
    NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"INTERNET_YES"];
    NSString *msgText  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SMS_CALLING"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SMS_CALLING_TITLE"] message:msgText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
    
    [alert show];
    [alert release];
}

-(void) getCallBackNotify:(NSString *)data :(NSString *)trim{
    callingCallBack = [[NSArray alloc] initWithObjects:fName,lName,data, nil];
    alertValues=768;
     //NSLog(@"All Details C--%.2f", price);
    NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES_OK"];
    NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Cancel"];
    
    NSString *msg = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING"];
    
    NSString *nos = [@"" stringByAppendingFormat:@"[%@]",trim];
    NSString *conf=@"";
    
    conf = [nos stringByAppendingFormat:@""];
    
    NSString *priceVal = [@" " stringByAppendingFormat:@"%@",conf];
    NSString *messageText = [msg stringByAppendingFormat:@"%@", priceVal];
    //NSLog(@"msg -%@", messageText);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING_TITLE"] message:messageText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
    //[[alert viewWithTag:1] removeFromSuperview];
    //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    PreferencesHandler *mPref = [[PreferencesHandler alloc]autorelease];
    //NSLog(@"%d", alertValues);
    if (buttonIndex == 0 && alertValues==101) {
        
        //NSLog(@"clicked");
        [mPref setDoNot:NO];
         [self callinggSome];
    }
    else if (buttonIndex ==2 && alertValues==101){
        
        NSLog(@"cancel");
    }
    else if (buttonIndex == 1 && alertValues==101){
        
        [mPref setDoNot:YES];
         [self callinggSome];
    }
    else if (buttonIndex ==3 && alertValues==606){
        
        NSLog(@"cancel");
    }
    else if (buttonIndex == 1 && alertValues==606){
        
        //[mPref setDoNot:YES];
        [self callinggSome];
    }
    else if (buttonIndex == 2 && alertValues==606){
        
        [mPref setDoNot:YES];
        [self callinggSome];
    }
    else if (buttonIndex ==1 && alertValues==202){
        alertValues=1;
        [self callingFRB];
        //NSLog(@"cancel");
    }
    else if (buttonIndex ==0 && alertValues==202){
        alertValues=1;
        [self callingDirect];
    }
    else if (buttonIndex ==1 && alertValues==303){
        alertValues=1;
        [self callingDirect];
        //NSLog(@"cancel");
    }
    else if (buttonIndex ==0 && alertValues==303){
        alertValues=1;
        [self callingFRB];
        
    }
    else if (buttonIndex ==1 && alertValues==123){
        alertValues=1;
        [self callingCallBackMethod];
        //NSLog(@"cancel");
    }
    else if (buttonIndex ==0 && alertValues==123){
        alertValues=1;
        
        //[self callingFRB];
        
    }
    else if (buttonIndex ==0 && alertValues==567){
        alertValues=1;
    }
    else if (buttonIndex ==1 && alertValues==567){
        
        alertValues=1;
        AddressBookHandler *mAddr = [[AddressBookHandler alloc]init];
        //NSLog(@"%d", [callingCallBack count]);
        if([callingCallBack count]>1){
            NSString *nos = [callingCallBack objectAtIndex:2];
            [mAddr smsController:param :nos];
        }
        else{
            [mAddr smsController:param :oNumber];
        }
        
        //[self callingFRB];
        
    }
    else if (buttonIndex ==1 && alertValues==768){
        alertValues=1;
        [self getSMSLayout];
        //NSLog(@"cancel");
    }
    else if (buttonIndex ==0 && alertValues==768){
        alertValues=1;
        
        
    }
    else{
        //NSLog(@"%d", alertValues);
        alertValues=1;
    }
   
    
}

-(void)willPresentAlertView:(UIAlertView *)alertView{
    if(alertValues==101){
        //alertValues=1;
        [alertView setFrame:CGRectMake(15, 90, 290, 300)];
    }
}

-(void)serviceProviderNameParseDidComplete:(NSMutableString *) result{
    NSLog(@"Service provider name %@", result);
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    [mPref setServiceProvider:result];
}

-(void)CallBackRate:(NSData *)apiData{
    
    outstring = [[NSMutableString alloc]init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:apiData];
    parser.delegate=self;   
    
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    // Kick off file parsing
    [parser parse];
    //NSLog(@"fdf %@", outstring);
    [parser release];
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
	if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", @"\n"];
    else if([current isEqualToString:@"rate"]) [outstring appendFormat:@"%@", @"\n"];
	current = nil;
}



- (void)parser:(NSXMLParser *)verificationSMSParser foundCharacters:(NSString *)string {
	if (!current) return;
	if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"rate"]) [outstring appendFormat:@"//%@", string];
}

-(void)otherCountriesDialing : (NSString *)getPrefix : (NSString *)trimNumber : (NSString *)originalNumber : (NSString *)calleridNo : (NSString *)token :(BOOL)st{
    //NSString *oriNos = [selectedDetails objectAtIndex:2];
    if([getPrefix isEqualToString:@"+49"])
        callingCallBack = [[NSArray alloc] initWithObjects:fName,lName,trimNumber, nil];
    else
        callingCallBack = [[NSArray alloc] initWithObjects:fName,lName,originalNumber, nil];
    alertValues=123;
    
    restApiCaller =[[RestAPICaller alloc]init];
    NSData *apiData;
    if([getPrefix isEqualToString:@"+49"])
        apiData = [restApiCaller getcallBackRate:calleridNo :trimNumber :token];
    else
        apiData = [restApiCaller getcallBackRate:calleridNo :originalNumber :token];
    
    if(![getPrefix isEqualToString:@"+49"] && st==FALSE)
        originalNumber=trimNumber;
    else if ([getPrefix isEqualToString:@"+49"] && st==FALSE){
        trimNumber=originalNumber;
    }
    else{
        NSLog(@"Nothing");
    }
    //NSString *myString = [[NSString alloc] initWithData:apiData encoding:NSUTF8StringEncoding];
    [self CallBackRate:apiData];
    NSArray *provider = [outstring componentsSeparatedByString: @"//"];
    NSString *calRate =@"";
    //NSLog(@"All Details C--%@, D--%@, T--%@, Arra--%@", calleridNo, trimNumber,token, provider);
    
    //float price = [calRate floatValue];
    //price = price*100;
    if([provider count] > 0){
        NSString *stratus =[provider objectAtIndex:0];
        if([stratus isEqualToString:@"success\n"]){
            if([provider count] > 1){
                calRate =[provider objectAtIndex:1];
                calRate = [calRate stringByReplacingOccurrencesOfString:@"//"  withString:@"\n"];
            }
            else{
                calRate=@"00.00";
            }
            
        }
        else{
            calRate=@"00.00";
        }
    }
    float zero = [@"00.00" floatValue];
    float price = [calRate floatValue];
    price = price*100;
    zero = zero*100;
    //NSLog(@"All Details C--%.2f", price);
    NSString *OKButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SHORT_DIALIN_NOTES_OK"];
    NSString *cancelButton  = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"Cancel"];
    
    NSString *msg = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING"];
    NSString *format = @"Cent/Min";
    NSString *nos = [@"" stringByAppendingFormat:@"[%@]",originalNumber];
    NSString *conf=@"";
    if(zero !=price){
        conf = [nos stringByAppendingFormat:@"[%.2f %@]",price,format];
    /*else{
        conf = [nos stringByAppendingFormat:@""];
        
    }
    if(zero !=price){*/
    NSString *priceVal = [@" " stringByAppendingFormat:@"%@",conf];
    NSString *messageText = [msg stringByAppendingFormat:@"%@", priceVal];
    //NSLog(@"msg -%@", messageText);
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CALLBACK_CALLING_TITLE"] message:messageText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
    //[[alert viewWithTag:1] removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Callback" message:messageText delegate:self cancelButtonTitle:cancelButton otherButtonTitles:OKButton,  nil];
    //[alert setFrame:CGRectMake(100, 60, 2700, 100)];
    [alert show];
    [alert release];
    }
    else{
        [self getSMSLayout];
    }
}


-(void) dealloc{
    [selectedDetails release];
    [param release];
    [fName release];
    [lName release];
    [mLabel release];
    [oNumber release];
    [pController release];
    [updateTimer invalidate];
    updateTimer = nil;
    [restApiCaller release];
    [restData release];
    restData=nil;
    [super dealloc];
}

@end
