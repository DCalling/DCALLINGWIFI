//
//  FavViewHandler.m
//  DCalling WiFi
//
//  Created by Prashant on 17/02/12.
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

#import "FavViewHandler.h"
#import "SQLiteDBHandler.h"
#import "PreferencesHandler.h"
#import "RestAPICaller.h"
#import "FlatrateXMLParser.h"

@implementation FavViewHandler

@synthesize favCall, favPhones, mAddr,userNames, userLabels, myChache, finalStatus;


-(void)getFavCallLog{
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] init];
    favCall = [[NSMutableArray alloc]init];
    favCall= [[mySqlite getFavorites] retain]; // commented by prashant
    favPhones= [[mySqlite getFavNumbers] retain];
    
    [mySqlite release];
}



- (BOOL) delete:(NSString *)phoneNumber{
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] init];
    BOOL status = [mySqlite deleteCallLog:phoneNumber];
    [mySqlite release];
    
    return status;
}

-(BOOL) deleteInFavView:(NSString *)phoneNumber{
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] init];
    BOOL status = [mySqlite deleteFavLog:phoneNumber];
    [mySqlite release];
    
    return status;
}


-(BOOL) scanNumber:(NSString *)str{
    BOOL status = false;
    
    
    NSNumberFormatter *nf = [[[NSNumberFormatter alloc] init] autorelease];
    //BOOL isDecimal = [nf numberFromString:str] != nil;
    if([nf numberFromString:str] != nil){
        status = true;
    }
    else{
        mAddr = [[AddressBookHandler alloc] init];
        NSString *scan = [mAddr prefixStr:str];
        if([nf numberFromString:scan] != nil){
            status = true;
        }
        else {
            status = false;
        }
       
    }
    return status;
}

-(NSString *)getNumber:(NSArray *)strString{
    
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] init];
    NSString *status = [mySqlite getCallLogNumber:strString];
    [mySqlite release];
    
    return status;
}

-(void) dealloc{
   // [mAddr release]; // commented for warning when AddressBookHandler add super dealloc
    //[favCall release];
    [userNames release];
    [userLabels release];
    myChache=nil;
    [super dealloc];
}

-(NSString *) getUserName:(NSString *)phoneNumber{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    NSString *myUserData = [sqliteDB getFavNumberSingle:phoneNumber];
    return myUserData;
}


-(NSString *) getCallLogCount:(NSArray *)nameString{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    NSString *mCount;
    mCount = [sqliteDB getCountFromCallLogName:nameString];
    [sqliteDB release];
    return mCount;
}

-(NSString *) getCallLogCountPhone:(NSString *)phoneString{
    SQLiteDBHandler *sqliteDB = [[SQLiteDBHandler alloc]init];
    NSString *mCount;
    mCount = [sqliteDB getCountFromCallLog:phoneString];
    [sqliteDB release];
    return mCount;
}

-(BOOL) checkLocalNumber:(NSString *)mobile{
    BOOL isValid = false;
    if([mobile length] > 8){
        if([self scanNumber:mobile] == true){
            isValid = true;
        }
    }
    return isValid;
}

-(NSString *) removedPlus:(NSString *) prefixNo{
    int strLen = (int)[prefixNo length];
    NSString *prefixNumber = prefixNo;
    if(strLen >= 2){
        NSRange rangeStr;
        NSRange range = NSMakeRange (0, 1);
        NSString *zeroZero = [prefixNo substringWithRange:range];
        if([zeroZero isEqualToString:@"+"]){
            rangeStr = NSMakeRange (1, strLen-1);
            prefixNumber = [prefixNo substringWithRange:rangeStr];
        }
    }
    
    return prefixNumber; 
}

-(BOOL) checkRemovedPlus:(NSString *) prefixNo{
    int strLen = (int)[prefixNo length];
    BOOL status=FALSE;
    if(strLen >= 2){
        //NSRange rangeStr;
        NSRange range = NSMakeRange (0, 1);
        NSString *zeroZero = [prefixNo substringWithRange:range];
        if([zeroZero isEqualToString:@"+"]){
            status=TRUE;
        }
    }
    
    return status;
}

-(BOOL) validateEmail: (NSString *) email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

-(BOOL) validateMobile: (NSString *) mobile {
    BOOL isValid = NO;
    mAddr = [[AddressBookHandler alloc] init];
    //NSString *trim = [mAddr trimWhiteSpace:mobile];
    [mAddr release];
    if(mobile.length >=7){
        int strLen = (int)[mobile length];
        NSRange rangeStr;
        NSRange range = NSMakeRange (0, 1);
        NSString *zeroZero = [mobile substringWithRange:range];
        if([zeroZero isEqualToString:@"+"] || [zeroZero isEqualToString:@"0"] || [zeroZero isEqualToString:@"4"] || [zeroZero isEqualToString:@"1"] || [zeroZero isEqualToString:@"9"]){
            isValid = YES;
            
            rangeStr = NSMakeRange (1, strLen-1);
            NSString *trimPhoneNumber = [mobile substringWithRange:rangeStr];
            if([self scanNumber:trimPhoneNumber] == YES ){
                rangeStr = NSMakeRange (0, 1);
                int lenStr = (int)[trimPhoneNumber length];
                NSString *againZero = [trimPhoneNumber substringWithRange:rangeStr];
                if([againZero isEqualToString:@"0"] || [againZero isEqualToString:@"1"] || [againZero isEqualToString:@"4"] || [againZero isEqualToString:@"9"]){
                    isValid = YES;
                    NSRange rangeStr = NSMakeRange (1, lenStr-1);
                    NSString *trimPhoneNumber1 = [trimPhoneNumber substringWithRange:rangeStr];
                    NSRange rangeStr1 = NSMakeRange (0, 1);
                    int lenStr1 = (int)[trimPhoneNumber1 length];
                    NSString *againCheck = [trimPhoneNumber1 substringWithRange:rangeStr1];
                    if([againCheck isEqualToString:@"1"] || [againCheck isEqualToString:@"9"] || [againCheck isEqualToString:@"5"] || [againCheck isEqualToString:@"6"] || [againCheck isEqualToString:@"4"] || [againCheck isEqualToString:@"8"]){
                        isValid = YES;
                        NSRange rangeStr2 = NSMakeRange (1, lenStr1-1);
                        NSString *trimPhoneNumber2 = [trimPhoneNumber1 substringWithRange:rangeStr2];
                       
                        if([trimPhoneNumber2 length] >= 9){
                        //NSLog(@"VALID %@", trimPhoneNumber);
                            isValid = YES;
                        
                        }
                        else {
                            isValid = NO;
                       
                        }
                    
                    }
                    else {
                        isValid = NO;
                    }
                }
                else {
                    isValid = NO;
                }
            }
            else {
                isValid = NO;
            }
        }
        
        else {
            isValid = NO;
        }
    }
   
    return isValid;
}

-(BOOL) countryPrefixCheck: (NSString *) mobile{
    BOOL isValid = NO;
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *callerid = [preferences getCallerID];
    NSRange range = NSMakeRange (0, 3);
    NSString *zeroZero = [callerid substringWithRange:range];
    if([zeroZero isEqualToString:mobile]){
        isValid = YES;
    }
    return isValid;
}

-(BOOL) checkPrefixStr:(NSString *)phone{
    //PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    BOOL isValidNumber = false; 
    NSString *trimPhoneNumber = @""; 
    int strLen = (int)[phone length];
   /* if(strLen < 11){
        isValidNumber = false;       
    }
    
    else if(strLen >=11) {   */     
        NSRange rangeStr;
        NSRange range = NSMakeRange (0, 1);
        NSString *zeroZero = [phone substringWithRange:range];
        //NSString *getPrefix = [preferences getDropBox];
        if([zeroZero isEqualToString:@"+"]){
            isValidNumber=true;
        }
        else if([zeroZero isEqualToString:@"0"]){
            isValidNumber = false;
            rangeStr = NSMakeRange (1, strLen-1);
            trimPhoneNumber = [phone substringWithRange:rangeStr];
            rangeStr = NSMakeRange (0, 1);
           // int lenStr = [trimPhoneNumber length];
            NSString *againZero = [trimPhoneNumber substringWithRange:rangeStr];
            if([againZero isEqualToString:@"0"]){
                isValidNumber = true;
            }
            /*else if ([againZero isEqualToString:@"1"] && [getPrefix isEqualToString:@"+1"]){
                isValidNumber = true;
            }*/
        }
        /*else if([getPrefix isEqualToString:@"+1"] && [zeroZero isEqualToString:@"0"]){
            isValidNumber = false;
            rangeStr = NSMakeRange (1, strLen-1);
            trimPhoneNumber = [phone substringWithRange:rangeStr];
            rangeStr = NSMakeRange (0, 1);
            // int lenStr = [trimPhoneNumber length];
            NSString *againZero = [trimPhoneNumber substringWithRange:rangeStr];
            if([againZero isEqualToString:@"1"]){
                isValidNumber = true;
            }
        }*/
        else {
            isValidNumber = false;
        }
    //}
    return isValidNumber;
}

-(BOOL) checkPrefixOne:(NSString *)phone{
    
    BOOL isValidNumber = false;    
    NSRange range = NSMakeRange (0, 1);
    NSString *zeroZero = [phone substringWithRange:range];    
    if([zeroZero isEqualToString:@"1"]){
        isValidNumber=true;
    }    
    else {
        isValidNumber = false;
    }
    //}
    return isValidNumber;
}

-(BOOL) checkSingleZero:(NSString *)phone{
    //PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    BOOL isValidNumber = false;
    NSString *trimPhoneNumber = @"";
    int strLen = (int)[phone length];
    /* if(strLen < 11){
     isValidNumber = false;
     }
     
     else if(strLen >=11) {   */
    NSRange rangeStr;
    NSRange range = NSMakeRange (0, 1);
    NSString *zeroZero = [phone substringWithRange:range];
    //NSString *getPrefix = [preferences getDropBox];    
    if([zeroZero isEqualToString:@"0"]){
        isValidNumber = TRUE;
        rangeStr = NSMakeRange (1, strLen-1);
        trimPhoneNumber = [phone substringWithRange:rangeStr];
        rangeStr = NSMakeRange (0, 1);
        // int lenStr = [trimPhoneNumber length];
        NSString *againZero = [trimPhoneNumber substringWithRange:rangeStr];
        if([againZero isEqualToString:@"0"]){
            isValidNumber = FALSE;
        }
        
    }   
    else {
        isValidNumber = false;
    }
    //}
    return isValidNumber;
}

- (BOOL)checkZeroValue : (NSString *)mobile{
    BOOL isValidNumber = false;
    NSString *trimPhoneNumber = @"";
    int strLen = (int)[mobile length];
    NSRange rangeStr;
    NSRange range = NSMakeRange (0, 1);
    NSString *zeroZero = [mobile substringWithRange:range];
    if([zeroZero isEqualToString:@"0"]){
        isValidNumber = TRUE;
        
    }
    else {
        isValidNumber = FALSE;
    }
    return isValidNumber;
}

- (NSString *)removedZero : (NSString *)mobile{
    int strLen = (int)[mobile length];
    if(strLen >= 2){
        NSRange rangeStr;
        NSRange range = NSMakeRange (0, 1);
        NSString *zeroZero = [mobile substringWithRange:range];
        if([zeroZero isEqualToString:@"0"]){
            rangeStr = NSMakeRange (1, strLen-1);
            mobile = [mobile substringWithRange:rangeStr];
        }
    }
    
    return mobile;
}


-(BOOL) checkPrefixStrLandLine:(NSString *)phone{
    BOOL isValidNumber = false;
    NSString *trimPhoneNumber = @"";
    int strLen = (int)[phone length];
    /*if(strLen < 10){
        isValidNumber = false;       
    }
    
    else if(strLen >=11) { */       
        NSRange rangeStr;
        NSRange range = NSMakeRange (0, 1);
        NSString *zeroZero = [phone substringWithRange:range];
        
        if([zeroZero isEqualToString:@"+"]){
            isValidNumber=false;
        }
        else if([zeroZero isEqualToString:@"0"]){
            isValidNumber = true;
            rangeStr = NSMakeRange (1, strLen-1);
            trimPhoneNumber = [phone substringWithRange:rangeStr];
            rangeStr = NSMakeRange (0, 1);
            // int lenStr = [trimPhoneNumber length];
            NSString *againZero = [trimPhoneNumber substringWithRange:rangeStr];
            if([againZero isEqualToString:@"0"]){
                isValidNumber = false;
            }
            else {
                isValidNumber = true;
            }
        }
        else {
            isValidNumber = false;
        }
    //}
    return isValidNumber;
}


-(NSString *)getAllPhoneFromAB : (NSString *)mobilNumber {
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex n = ABAddressBookGetPersonCount(addressBook);
    NSString *phoneLabel =@"";
    
    for( int i = 0 ; i < n ; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(all, i);
        //NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        //NSLog(@"Name %@", firstName);
        
        ABMultiValueRef phones = (NSString *)ABRecordCopyValue(ref, kABPersonPhoneProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
                       
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, ABMultiValueGetIndexForIdentifier(phones, (int)j));
            phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            //CFRelease(phones);
            NSString *phoneNumber = (NSString *)phoneNumberRef;
            CFRelease(phoneNumberRef);
            //CFRelease(locLabel);
            mAddr = [[AddressBookHandler alloc]autorelease];
            NSString *originalNumber = [mAddr trimWhiteSpace:mobilNumber];
            NSString *original = [mAddr trimWhiteSpace:phoneNumber];
            if([original isEqualToString:originalNumber]){
               // NSLog(@"  - %@ (%@)", original, phoneLabel);
                return phoneLabel;
                break;
            }
            //NSLog(@"  - %@ (%@)", original, phoneLabel);
            [phoneNumber release];
        }
    } 
    return phoneLabel;
}


-(BOOL) checkNumberNational:(NSString *)mobileNumber : (NSString *)originalNumber{
    PreferencesHandler *preferences = [[PreferencesHandler alloc]init];
    NSString *token = [preferences getToken];
    [preferences setInternetStatus:NO];
    NSString *calleridNo = [preferences getCallerID];
    NSString *getPrefix = [preferences getDropBox];
    NSString *dialPrefix  = @"";
    NSString *getCountryCode = @"";
    NSString *otherNos = @"";
    BOOL checkint = [self checkPrefixStr:originalNumber];
    BOOL status = FALSE;
    //BOOL scanValid = [self scanNumber:mobileNumber];
    if([getPrefix isEqualToString:@"+49"] && [mobileNumber length]>2){
        NSRange getRange = NSMakeRange (0, 3);
        NSRange getRangeSec = NSMakeRange (0, 2);
        NSString *takeCodeNos = [mobileNumber substringWithRange:getRangeSec];
        NSString *takeNos = [mobileNumber substringWithRange:getRange];
        if([takeCodeNos isEqualToString:@"49"] && !checkint){
            if([mobileNumber length]>4){
                NSRange getOtherRange = NSMakeRange (2, 3);
                takeCodeNos = [mobileNumber substringWithRange:getOtherRange];
                if([takeCodeNos isEqualToString:@"181"] || [takeCodeNos isEqualToString:@"182"] || [takeCodeNos isEqualToString:@"183"] || [takeCodeNos isEqualToString:@"184"] || [takeCodeNos isEqualToString:@"185"] || [takeCodeNos isEqualToString:@"186"] || [takeCodeNos isEqualToString:@"187"] || [takeCodeNos isEqualToString:@"188"] || [takeCodeNos isEqualToString:@"189"] ){
                    otherNos = @"0181";
                }
            }
        }
        else if(([takeNos isEqualToString:@"181"] || [takeNos isEqualToString:@"182"] || [takeNos isEqualToString:@"183"] || [takeNos isEqualToString:@"184"] || [takeNos isEqualToString:@"185"] || [takeNos isEqualToString:@"186"] || [takeNos isEqualToString:@"187"] || [takeNos isEqualToString:@"188"] || [takeNos isEqualToString:@"189"]) && !checkint ){
            otherNos = @"0181";
        }
        else
            otherNos=@"";
    }
    /*if([getPrefix isEqualToString:@"+49"] && [mobileNumber length]>7){
        NSRange getRange = NSMakeRange (0, 7);
        NSString *takeNos = [mobileNumber substringWithRange:getRange];
        if([takeNos isEqualToString:@"0049181"] || [takeNos isEqualToString:@"0049182"] || [takeNos isEqualToString:@"0049183"] || [takeNos isEqualToString:@"0049184"] || [takeNos isEqualToString:@"0049185"] || [takeNos isEqualToString:@"0049186"] || [takeNos isEqualToString:@"0049187"] || [takeNos isEqualToString:@"0049188"] || [takeNos isEqualToString:@"0049189"] ){
            otherNos = @"0181";
        }
    }*/
    BOOL checkZeromy = [self checkPlusfour:mobileNumber];
    
         
   // 112, 110, +49110, 0049110, +49112, 0049112, 19222, +4919222, 004919222
    if([getPrefix isEqualToString:@"+49"] && ([mobileNumber isEqualToString:@"112"] || [mobileNumber isEqualToString:@"0112"] || [mobileNumber isEqualToString:@"110"] || [mobileNumber isEqualToString:@"0110"] || [mobileNumber isEqualToString:@"+49110"] || [mobileNumber isEqualToString:@"0049110"] || [mobileNumber isEqualToString:@"+49112"] || [mobileNumber isEqualToString:@"0049112"] || [mobileNumber isEqualToString:@"19222"] || [mobileNumber isEqualToString:@"019222"] || [mobileNumber isEqualToString:@"+4919222"] || [mobileNumber isEqualToString:@"004919222"] || [mobileNumber isEqualToString:@"4919222"] || [mobileNumber isEqualToString:@"49110"] || [mobileNumber isEqualToString:@"49112"])){
        status=FALSE;
        
    }
    else if ([otherNos isEqualToString:@"0181"]){
        status=FALSE;
        
    }
    else if([preferences getRoaming]==NO && [getPrefix isEqualToString:@"+49"] && checkZeromy==TRUE){
        status=TRUE;
    }
    else {        
    mAddr = [[AddressBookHandler alloc]autorelease];
    int prefixLenght = (int)[getPrefix length];
    mobileNumber = [mAddr prefixStr:mobileNumber];
        int mobLen = (int)[mobileNumber length];
    if(prefixLenght  >= 1 && mobLen>=prefixLenght){
        getCountryCode = [self removedPlus:getPrefix];
        int prefixLen = (int)[getCountryCode length];
        NSRange RangeOfDial = NSMakeRange (0, prefixLen);
        dialPrefix = [mobileNumber substringWithRange:RangeOfDial];
        
        
        if([preferences getRoaming]==YES && [originalNumber length]>5){
            status=TRUE;
        }
        else if([getCountryCode isEqualToString:dialPrefix]){
            status = [self checkNumberLandline:mobileNumber :calleridNo :token :getPrefix:originalNumber];
        }
        
        else if(![getCountryCode isEqualToString:dialPrefix]){
            status = [self checkNumberInternational:mobileNumber :calleridNo :token :getPrefix: originalNumber];
        }
        else {
            //NSLog(@"Not Valid mobil number");
            status = FALSE;
        }
    }
    }
    
    return status;
}

-(BOOL)checkNumberLandline:(NSString *)mobileNumber : (NSString *) calleridNo : (NSString *) token : (NSString *) getPrefix : (NSString *) original{
    BOOL statusNumber = FALSE;
    mAddr = [[AddressBookHandler alloc]autorelease];
    
    int getCount = (int)[getPrefix length];
   // NSRange prefixRange = NSMakeRange (0, getCount-1);
    //NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
   // NSString *trimPrefix = [mAddr prefixStr:getPrefix];
    NSRange RangeOfDial = NSMakeRange (getCount-1, 1);
    NSString *landLine = [mobileNumber substringWithRange:RangeOfDial];
    int land = [landLine intValue];
    //NSLog(@"landline -- %d", land);
    /*BOOL checkOne = [self checkPrefixStr:original];
    if([getPrefix isEqualToString:@"+1"] && checkOne==TRUE){
        mobileNumber = [@"00" stringByAppendingFormat:@"%@",mobileNumber];
    }
    else if ([getPrefix isEqualToString:@"+1"] && checkOne==FALSE){
        mobileNumber = [@"" stringByAppendingFormat:@"%@",mobileNumber];
    }
    else*/
    BOOL checkZero = [self checkPrefixStrLandLine:original];
     BOOL checkDouble = [self checkPrefixStr:original];
    if(checkZero == TRUE && [getPrefix isEqualToString:@"+49"])
        mobileNumber = [@"0049" stringByAppendingFormat:@"%@",mobileNumber];
    else if(checkZero == FALSE && checkDouble==TRUE){
        mobileNumber = [@"00" stringByAppendingFormat:@"%@",mobileNumber];
    }
    else if (checkZero == TRUE && ![getPrefix isEqualToString:@"+49"]){
        mobileNumber = [@"0" stringByAppendingFormat:@"%@",mobileNumber];
    }
    else{
        NSLog(@"Do nothing");
    }
    
    //NSString *getCountryCode = @"";
    //getCountryCode = [self removedPlus:getPrefix];
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    myChache=@"";
    
    if(([getPrefix isEqualToString:@"+49"] && land == 1)){
        // [mPref setProviderInfo:nil];
        BOOL STS = FALSE;
        if([self CheckNetwork]){
            [mPref setInternetStatus:YES];
            STS = [self campareDate:original];
            if(STS)
                myChache=@"10";
        }
        if(!STS)
            myChache = [self checkProvideInDB:original];
        if(![myChache isEqualToString:@"10"]){
            statusNumber = [self checkSettings:myChache];
            BOOL st = [mPref getInternetStatus];
            if(st)
                [mPref setInternetConnection:NO];
            else
                [mPref setInternetConnection:YES];
           /* NSString *time = @"";
            time = [self checkDateTimeProvider:original];
            
            NSComparisonResult dt = [self dateTime:time];
            
            if(dt == 1){
                BOOL comp = [self timeCompare:@"06"];
                if(comp==TRUE){
                    //NSLog(@"UPDATE PROVIDER");
                    [self updateTheProvider:mobileNumber];
                }
            }
            //NSLog(@"TIME %u", st);
            
            NSArray *provider = [outstring componentsSeparatedByString: @"//"];
            if([provider count] > 1){
                [mPref setInternetConnection:NO];
            }
            else{
                [mPref setInternetConnection:YES];
            }*/
        }
        else{
            statusNumber = [self checkServiceProvider:mobileNumber];
            NSArray *provider = [outstring componentsSeparatedByString: @"//"];
            if([provider count] > 1){
                NSString *name = [provider objectAtIndex:1];
                NSString *removedSlash = [name stringByReplacingOccurrencesOfString:@"//"  withString:@""];
                NSString *removedSpace = [removedSlash stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                //NSLog(@"1 : %@", removedSpace);
            
                statusNumber = [self checkSetting:removedSpace];
               
                ///statusNumber = TRUE;
            }
            else{
                [mPref setInternetStatus:NO];
                [mPref setInternetConnection:YES];
                statusNumber = [self forNoInternet:mobileNumber];
            }
        }
    }
    else if (![getPrefix isEqualToString:@"+49"]) {
        if(checkZero==TRUE){
            if([getPrefix isEqualToString:@"+1"]){
                NSString *code = @"011";
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
                if([originalPrefix isEqualToString:code])
                    statusNumber = TRUE;
                else
                    statusNumber = FALSE;
            }
            else if ([getPrefix isEqualToString:@"+81"]){
                NSString *code = @"010";
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
                if([originalPrefix isEqualToString:code])
                    statusNumber = TRUE;
                else
                    statusNumber = FALSE;
            }
            else if ([getPrefix isEqualToString:@"+972"]){
                NSArray* inputArray = [NSArray arrayWithObjects:@"012", @"013", @"014", @"015", @"016", @"017",@"018", @"019", nil];
                
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
                
                for (NSString* item in inputArray)
                {
                    if ([item rangeOfString:originalPrefix].location != NSNotFound){
                        statusNumber = TRUE;
                        break;
                    }
                    else
                        statusNumber = FALSE;
                }
                
            }
            else if ([getPrefix isEqualToString:@"+65"]){
                NSArray* inputArray = [NSArray arrayWithObjects:@"013", @"018", @"019", nil];
                
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
                
                for (NSString* item in inputArray)
                {
                    if ([item rangeOfString:originalPrefix].location != NSNotFound){
                        statusNumber = TRUE;
                        break;
                    }
                    else
                        statusNumber = FALSE;
                }
                
            }
            else{
                statusNumber = FALSE;
            }
            
        }
        else if(checkDouble==TRUE) {
            if(![getPrefix isEqualToString:@"+1"])
                statusNumber = FALSE;
            else
                statusNumber = TRUE;
        }
        else
            statusNumber = FALSE;
    }
    
    
    
    return statusNumber;
}

-(BOOL)checkNumberInternational:(NSString *)mobileNumber : (NSString *) calleridNo : (NSString *) token : (NSString *) getPrefix : (NSString *) original{
    BOOL statusNumber=FALSE;
    //int getCount = [getPrefix length];
    BOOL st = [self checkPrefixStr:original];
    
    NSString *usDial =@"";
    //BOOL checkDouble = [self checkPrefixStr:original];
    if([mobileNumber length] > 5){
        NSRange twoNumber = NSMakeRange (0, 1);
        usDial = [original substringWithRange:twoNumber];
        
    }
       
    if(st ==FALSE){
        PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
        
        NSRange RangeOfDial = NSMakeRange (0, 1);
        NSString *landLine = [mobileNumber substringWithRange:RangeOfDial];
        int land = [landLine intValue];
        //NSLog(@"landline -- %d", land);
        if([getPrefix isEqualToString:@"+49"] && land == 1){
            mobileNumber = [@"0049" stringByAppendingFormat:@"%@",mobileNumber];
            // [mPref setProviderInfo:nil];
            BOOL STS = FALSE;
            if([self CheckNetwork]){
                [mPref setInternetStatus:YES];
                STS = [self campareDate:original];
                if(STS)
                    myChache=@"10";
            }
            if(!STS)
                myChache = [self checkProvideInDB:original];
            if(![myChache isEqualToString:@"10"]){
                statusNumber = [self checkSettings:myChache];
                BOOL st = [mPref getInternetStatus];
                if(st)
                    [mPref setInternetConnection:NO];
                else
                    [mPref setInternetConnection:YES];
                /* NSString *time = @"";
                 time = [self checkDateTimeProvider:original];
                 
                 NSComparisonResult dt = [self dateTime:time];
                 
                 if(dt == 1){
                 BOOL comp = [self timeCompare:@"06"];
                 if(comp==TRUE){
                 //NSLog(@"UPDATE PROVIDER");
                 [self updateTheProvider:mobileNumber];
                 }
                 }
                 //NSLog(@"TIME %u", st);
                 
                 NSArray *provider = [outstring componentsSeparatedByString: @"//"];
                 if([provider count] > 1){
                 [mPref setInternetConnection:NO];
                 }
                 else{
                 [mPref setInternetConnection:YES];
                 }*/
            }
            else{
                statusNumber = [self checkServiceProvider:mobileNumber];
                //NSLog(@"error %@", outstring);
                NSArray *provider = [outstring componentsSeparatedByString: @"//"];
                if([provider count] > 1){
                    NSString *name = [provider objectAtIndex:1];
                    NSString *removedSlash = [name stringByReplacingOccurrencesOfString:@"//" withString:@""];
                    NSString *removedSpace = [removedSlash stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSLog(@"2 : %@", removedSpace);
                //PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
                    statusNumber = [self checkSetting:removedSpace];
               
                
                    //statusNumber = TRUE;
                }
                
                else {
                    [mPref setInternetStatus:NO];
                    [mPref setInternetConnection:YES];
                    statusNumber = [self forNoInternet:mobileNumber];
                }
            }
            
        }
        if(![getPrefix isEqualToString:@"+49"] && [usDial isEqualToString:@"0"]){
            mobileNumber=original;
            if([getPrefix isEqualToString:@"+1"]){
                NSString *code = @"011";
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
                if([originalPrefix isEqualToString:code])
                    statusNumber = TRUE;
                else
                    statusNumber = FALSE;
            }
            else if ([getPrefix isEqualToString:@"+81"]){
                NSString *code = @"010";
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
                if([originalPrefix isEqualToString:code])
                    statusNumber = TRUE;
                else
                    statusNumber = FALSE;
            }
            else if ([getPrefix isEqualToString:@"+972"]){
                NSArray* inputArray = [NSArray arrayWithObjects:@"012", @"013", @"014", @"015", @"016", @"017",@"018", @"019", nil];
                
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
                
                for (NSString* item in inputArray)
                {
                    if ([item rangeOfString:originalPrefix].location != NSNotFound){
                        statusNumber = TRUE;
                        break;
                    }
                    else
                        statusNumber = FALSE;
                }
                
            }
            else if ([getPrefix isEqualToString:@"+65"]){
                NSArray* inputArray = [NSArray arrayWithObjects:@"001",@"002", @"008",@"013", @"018", @"019", nil];
                
                NSRange prefixRange = NSMakeRange (0, 3);
                NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
                
                for (NSString* item in inputArray)
                {
                    if ([item rangeOfString:originalPrefix].location != NSNotFound){
                        statusNumber = TRUE;
                        break;
                    }                       
                    else
                        statusNumber = FALSE;
                }
                
            }
            else{
                statusNumber = FALSE;
            }
        }
    
    }    
    else {
        if(![getPrefix isEqualToString:@"+49"]){
            statusNumber=[self checkDoubleZero:original :getPrefix];
        }
        else{
            statusNumber = TRUE;
        }
        
    }
      
    return statusNumber;

}

-(NSString *) changeInLocalFormat:(NSString *)mobileNumer{
    int strLen = (int)[mobileNumer length];
    NSRange removeCode = NSMakeRange (0, 2);
    NSString *countryCode = [mobileNumer substringWithRange:removeCode];
    NSString *localFormat = @"";
    if([countryCode isEqualToString:@"91"]){
        NSRange rangeStr = NSMakeRange (2, strLen-2);
        localFormat = [mobileNumer substringWithRange:rangeStr];
        localFormat = [@"0" stringByAppendingFormat:@"%@",localFormat];
    }
    return localFormat;
}

-(BOOL) checkGermanNumber:(NSString *)mobileNumer{
    BOOL status = FALSE;
    NSRange removeCode = NSMakeRange (0, 2);
    NSString *countryCode = [mobileNumer substringWithRange:removeCode];
    if([countryCode isEqualToString:@"49"]){
        status = TRUE;
    }
    
    return status;
}

-(NSMutableArray *)fetchName:(NSMutableArray *)numbers{
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] autorelease];
    userNames = [[NSMutableArray alloc]init];
    userNames = [mySqlite getCallLogRecName:numbers];
    return userNames;
}

-(NSMutableArray *)fetchLabel:(NSMutableArray *)numbers{
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] autorelease];
    userLabels = [[NSMutableArray alloc]init];
    userLabels = [mySqlite getCallLogPhoneLabels:numbers];
    return userLabels;
}

-(BOOL)checkServiceProvider:(NSString *)number{
    BOOL status =NO;
    
    restApi = [[RestAPICaller alloc]init];
    apiData = [restApi getServiceProvideName:number];
    
        //FlatrateXMLParser *flatrateXMLParser;
       // flatrateXMLParser = [[FlatrateXMLParser alloc] initWithServiceProvideName:self xmlData:apiData];
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
    
    
    
    return status;
}

-(void)serviceProviderNameParseDidComplete:(NSMutableString *) result{
    //NSLog(@"Service provider name %@", result);
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    //[mPref setServiceProvider:result];
    NSRange textRange;
    textRange =[result rangeOfString:@"success"];
    if(textRange.location != NSNotFound){
        NSArray *provider = [result componentsSeparatedByString: @"//"];
        if([provider count] > 1){
            NSString *name = [provider objectAtIndex:1];
            NSString *removedSlash = [name stringByReplacingOccurrencesOfString:@"//" withString:@""];
            NSString *removedSpace = [removedSlash stringByReplacingOccurrencesOfString:@"\n" withString:@""];
           // NSLog(@"Name : %@", removedSpace);
            //[mPref setServiceProvider:@""];
            [mPref setServiceProvider:removedSpace];
            
        }
    }
}

-(BOOL)checkSettings:(NSString *)number{
    BOOL status;
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    number = [self checkProviderName:number];
    [mPref setServiceProvider:number];
    BOOL checkAllGerman = [mPref getAllGermanProvider];
    if(checkAllGerman == NO){
        BOOL checkVodafone = [mPref getVodafone];
        BOOL checkePlus = [mPref getEPlus];
        BOOL checkTMobile = [mPref getTmobile];
        BOOL checkOTwo = [mPref getOTwo];
        BOOL checkTellogic = [mPref getTelogic];
        if(checkePlus==YES && [number isEqualToString:@"eplus"]){            
            status=TRUE;
        }
        else if(checkOTwo==YES && [number isEqualToString:@"o2"]){
            status=TRUE;
        }
        else if(checkTellogic==YES && [number isEqualToString:@"telogic"]){
            status=TRUE;
        }
        else if(checkTMobile==YES && [number isEqualToString:@"tmobile"]){
            status=TRUE;
        }
        else if(checkVodafone==YES && [number isEqualToString:@"vodafone"]){
            status=TRUE;
        }
        else{
            status=FALSE;
        }
    
     }
    else{
        status=TRUE;
    }
    
    return status;
}

-(BOOL)checkSetting:(NSString *)number{
    BOOL status;
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    //number = [self checkProviderName:number];
    [mPref setServiceProvider:number];
    BOOL checkAllGerman = [mPref getAllGermanProvider];
    if(checkAllGerman == NO){
        BOOL checkVodafone = [mPref getVodafone];
        BOOL checkePlus = [mPref getEPlus];
        BOOL checkTMobile = [mPref getTmobile];
        BOOL checkOTwo = [mPref getOTwo];
        BOOL checkTellogic = [mPref getTelogic];
        if(checkePlus==YES && [number isEqualToString:@"eplus"]){
            status=TRUE;
        }
        else if(checkOTwo==YES && [number isEqualToString:@"o2"]){
            status=TRUE;
        }
        else if(checkTellogic==YES && [number isEqualToString:@"telogic"]){
            status=TRUE;
        }
        else if(checkTMobile==YES && [number isEqualToString:@"tmobile"]){
            status=TRUE;
        }
        else if(checkVodafone==YES && [number isEqualToString:@"vodafone"]){
            status=TRUE;
        }
        else{
            status=FALSE;
        }
        
    }
    else{
        status=TRUE;
    }
    
    return status;
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
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"%@", @"\n"];
	current = nil;
}



- (void)parser:(NSXMLParser *)verificationSMSParser foundCharacters:(NSString *)string {
	if (!current) return;
	if ([current isEqualToString:@"method"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"resource"]) [outstring appendFormat:@"%@", string];
    else if([current isEqualToString:@"status"]) [outstring appendFormat:@"%@", string];    
    else if([current isEqualToString:@"provider"]) [outstring appendFormat:@"//%@", string];
}

-(BOOL)checkINChache:(NSString *)numbers{
    BOOL status = FALSE;
    //NSMutableArray *arr = [[NSMutableArray alloc]init];
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    [mPref setServiceProvider:numbers];
    //NSLog(@"pro %@", [mPref getProviderInfo]);
    
    return status;
}

-(BOOL)forNoInternet:(NSString *)mobileNumber {
    BOOL statusNumber =FALSE;
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    NSString *removedSpace =@"";
    if(mobileNumber.length>9){
    NSRange prefixRange = NSMakeRange (0, 7);
    NSString *originalPrefix = [mobileNumber substringWithRange:prefixRange];
    if([originalPrefix isEqualToString:@"0049151" ] || [originalPrefix isEqualToString:@"0049160" ] || [originalPrefix isEqualToString:@"0049170" ] || [originalPrefix isEqualToString:@"0049171" ] || [originalPrefix isEqualToString:@"0049175" ]){
        [mPref setBestSearchProvider:@"NOCON"];
        removedSpace = @"tmobile";
    }
    else if([originalPrefix isEqualToString:@"0049152" ] || [originalPrefix isEqualToString:@"0049162" ] || [originalPrefix isEqualToString:@"0049173" ] || [originalPrefix isEqualToString:@"0049172" ] || [originalPrefix isEqualToString:@"0049174" ]){
        [mPref setBestSearchProvider:@"NOCON"];
        removedSpace = @"vodafone";
    }
    else if([originalPrefix isEqualToString:@"0049155" ] || [originalPrefix isEqualToString:@"0049157" ] || [originalPrefix isEqualToString:@"0049163" ] || [originalPrefix isEqualToString:@"0049177" ] || [originalPrefix isEqualToString:@"0049178" ]){
        [mPref setBestSearchProvider:@"NOCON"];
        removedSpace = @"eplus";
    }
    else if([originalPrefix isEqualToString:@"0049159" ] || [originalPrefix isEqualToString:@"0049176" ] || [originalPrefix isEqualToString:@"0049179" ]){
        [mPref setBestSearchProvider:@"NOCON"];
        removedSpace = @"o2";
    }
    else{
        [mPref setBestSearchProvider:@"NOCONINT"];
        removedSpace = @"unknown";
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"ERROR_MSG"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SELECT_OTHER_COUNTRY"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];*/
        statusNumber=FALSE;
    }
        statusNumber = [self checkSetting:removedSpace];
        /*NSString *data = [@"{" stringByAppendingFormat:@"%@//%@}",mobileNumber, removedSpace];
        NSString *appData = [data stringByAppendingFormat:@",%@", [mPref getProviderInfo]];
        [mPref setProviderInfo:appData];
       // NSLog(@"%@", [mPref getProviderInfo]);*/
    }
    else{
        [mPref setBestSearchProvider:@"NOCONINT"];
        statusNumber=FALSE;
    }
    [mPref setServiceProvider:removedSpace];
    //NSLog(@"vall %@", [mPref getBestSearchProvider]);
    return statusNumber;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"button -- %d", (int)buttonIndex);
    if (buttonIndex == 0) {
        finalStatus = TRUE;
    }
    else{
        finalStatus=FALSE;
    }
}

-(NSString *)checkProvider:(NSString *)number{
    NSString *status=@"";          
    if([number isEqualToString:@"eplus"]){
        status=@"3";
    }
    else if([number isEqualToString:@"o2"]){
        status=@"4";
    }
    else if([number isEqualToString:@"telogic"]){
        status=@"5";
    }
    else if([number isEqualToString:@"tmobile"]){
        status=@"1";
    }
    else if([number isEqualToString:@"vodafone"]){
        status=@"2";
    }
    else{
        status=@"6";
    }     
    return status;
}

-(NSString *)checkProviderName:(NSString *)number{
    NSString *status=@"";
    if([number isEqualToString:@"3"]){
        status=@"eplus";
    }
    else if([number isEqualToString:@"4"]){
        status=@"o2";
    }
    else if([number isEqualToString:@"5"]){
        status=@"telogic";
    }
    else if([number isEqualToString:@"1"]){
        status=@"tmobile";
    }
    else if([number isEqualToString:@"2"]){
        status=@"vodafone";
    }
    else{
        status=@"unknown";
    }
    return status;
}

-(NSString *)checkProvideInDB:(NSString *)number{
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] init];
    NSString *provider = @"";
    provider= [mySqlite getProviderPhone:number] ; // commented by prashant
    //favPhones= [[mySqlite getFavNumbers] retain];
    if([provider isEqualToString:@""]|| provider==nil){
        provider=@"10";
    }
    [mySqlite release];
    return provider;
}

-(NSString *)checkDateTimeProvider:(NSString *)number{
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] init];
    //NSMutableArray *provider =[[NSMutableArray alloc]init];
    NSString *provider= [mySqlite getProviderTime:number] ; // commented by prashant
    //favPhones= [[mySqlite getFavNumbers] retain];
    
    [mySqlite release];    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter stringFromDate:now];
    //NSLog(@"%@",[formatter stringFromDate:now]); //--> 9/9/11 11:54 PM
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    //NSLog(@"%@",[formatter stringFromDate:now]); //-->  9/9/11 3:54 PM
    
    return provider;
}

- (NSComparisonResult)dateTime:(NSString *)datetime
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    //NSRange rangeStr;
    NSRange range = NSMakeRange (0, 10);
    NSString *onlyDate = [datetime substringWithRange:range];
   [df setDateFormat:@"yyyy-MM-dd"];
    //[df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDate *theDate = [df dateFromString:onlyDate];
    //NSLog(@"date: %@", theDate);
    [df release];
   
     NSComparisonResult stt = [self compare:theDate];
    // NSLog(@"BOOL: %d -- %@", stt, onlyDate);
    return stt;
}

- (NSComparisonResult)compare:(NSDate *)anotherDate{
    NSDate *today = [NSDate date];
    NSUInteger dateFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *gregorianCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *selfComponents = [gregorianCalendar components:dateFlags fromDate:today];
    NSDate *selfDateOnly = [gregorianCalendar dateFromComponents:selfComponents];
    
    NSDateComponents *otherCompents = [gregorianCalendar components:dateFlags fromDate:anotherDate];
    NSDate *otherDateOnly = [gregorianCalendar dateFromComponents:otherCompents];
    return [selfDateOnly compare:otherDateOnly];
}

- (BOOL)timeCompare:(NSString *)anotherDate{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"CET"]];    
    NSString *hours = [formatter stringFromDate:now];
    //NSLog(@"now: %@", hours);
    NSRange range = NSMakeRange (9, 3);
    NSString *onlyDate = [hours substringWithRange:range];
    int i=[onlyDate intValue];
    int j=[anotherDate intValue];
    BOOL status = FALSE;
    if(i >=j){
        status = TRUE;
    }
    else{
        status=FALSE;
    }
   
    return status;
}

-(void)updateTheProvider:(NSString *)mobileNumber{
    PreferencesHandler *myPref = [[PreferencesHandler alloc]autorelease];
    NSString *provider = [myPref getServiceProvider];
    NSString *numer = [self checkProvider:provider];
    SQLiteDBHandler *mySqlite = [[SQLiteDBHandler alloc] init];
    [mySqlite updateProvider:mobileNumber :numer] ;
    [mySqlite release];
}

-(BOOL) checkPlusfour:(NSString *)phone{
    BOOL isValidNumber = false;
   // NSString *trimPhoneNumber = @"";
    int strLen = (int)[phone length];
    if(strLen >2){
    NSRange range = NSMakeRange (0, 2);
    NSString *zeroZero = [phone substringWithRange:range];
    
    if([zeroZero isEqualToString:@"49"]){
        NSRange rangeStr=NSMakeRange (2, 2);
        NSString *oneeight = [phone substringWithRange:rangeStr];
        if([oneeight isEqualToString:@"18"])
        isValidNumber=TRUE;
        
    }
    else if([zeroZero isEqualToString:@"18"]){
        isValidNumber = true;        
    }
    else {
        isValidNumber = false;
    }
    }
    else{
        isValidNumber = false;
    }
    //}
    return isValidNumber;
}

-(BOOL)checkDoubleZero:(NSString *)numbers :(NSString *)getPrefix{
    BOOL status=FALSE;
    if([getPrefix isEqualToString:@"+65"]){
        NSArray* inputArray = [NSArray arrayWithObjects:@"001",@"002", @"008", nil];
        
        NSRange prefixRange = NSMakeRange (0, 3);
        NSString *originalPrefix = [numbers substringWithRange:prefixRange];
        
        for (NSString* item in inputArray)
        {
            if ([item rangeOfString:originalPrefix].location != NSNotFound){
                status = TRUE;
                break;
            }
            else
                status = FALSE;
        }
        
    }
    else if([getPrefix isEqualToString:@"+57"]){
        NSArray* inputArray = [NSArray arrayWithObjects:@"005",@"007", @"009", nil];
        
        NSRange prefixRange = NSMakeRange (0, 3);
        NSString *originalPrefix = [numbers substringWithRange:prefixRange];
        
        for (NSString* item in inputArray)
        {
            if ([item rangeOfString:originalPrefix].location != NSNotFound){
                status = TRUE;
                break;
            }
            else
                status = FALSE;
        }
        if(status==FALSE){
            NSRange Range = NSMakeRange (0, 1);
            NSString *singleVale = [numbers substringWithRange:Range];
            if ([singleVale isEqualToString:@"+"]){
                status=TRUE;
            }
            else{
                status=FALSE;
            }
        }
        
    }
    else if([getPrefix isEqualToString:@"+81"]){
        NSString *code = @"001";
        
        NSRange prefixRange = NSMakeRange (0, 3);
        NSString *originalPrefix = [numbers substringWithRange:prefixRange];
        
        if([originalPrefix isEqualToString:code]){
            status=TRUE;            
        }
        
        else if (status==FALSE){
            NSArray* inputArray = [NSArray arrayWithObjects:@"0061", @"0041", nil];            
            NSRange prefixRange = NSMakeRange (0, 4);
            NSString *originalPrefix = [numbers substringWithRange:prefixRange];
            
            for (NSString* item in inputArray)
            {
                if ([item rangeOfString:originalPrefix].location != NSNotFound){
                    status=TRUE;
                    break;
                }
                else{
                    status=FALSE;
                }
            }
            if(status==FALSE){
                NSRange Range = NSMakeRange (0, 1);
                NSString *singleVale = [numbers substringWithRange:Range];
                if ([singleVale isEqualToString:@"+"]){
                    status=TRUE;
                }
                else{
                    status=FALSE;
                }
            }
            
            
        }
        else{
            status=FALSE;
        }
        
    }
    else if([getPrefix isEqualToString:@"+82"]){
        NSArray* inputArray = [NSArray arrayWithObjects:@"001", @"002",@"003", @"005", @"006",@"007", @"008", nil];
        
        NSRange prefixRange = NSMakeRange (0, 3);
        NSString *originalPrefix = [numbers substringWithRange:prefixRange];
        
        for (NSString* item in inputArray)
        {
            
            if ([item rangeOfString:originalPrefix].location != NSNotFound){
                status=TRUE;
                break;
            }
            else{
                status=FALSE;
            }
        }
        if(status==FALSE){
            NSRange Range = NSMakeRange (0, 1);
            NSString *singleVale = [numbers substringWithRange:Range];
            if ([singleVale isEqualToString:@"+"]){
                status=TRUE;
            }
            else{
                status=FALSE;
            }
        }
        
        
        
    }
    else if([getPrefix isEqualToString:@"+61"]){
        NSRange prefixRange = NSMakeRange (0, 4);
        NSString *originalPrefix = [numbers substringWithRange:prefixRange];
        
        if([originalPrefix isEqualToString:@"0011"]){
            status=TRUE;
        }
        if(status==FALSE){
            NSRange Range = NSMakeRange (0, 1);
            NSString *singleVale = [numbers substringWithRange:Range];
            if ([singleVale isEqualToString:@"+"]){
                status=TRUE;
            }
            else{
                status=FALSE;
            }
        }
         
    }
    else if([getPrefix isEqualToString:@"+1"]){
        NSRange prefixRange = NSMakeRange (0, 1);
        NSString *originalPrefix = [numbers substringWithRange:prefixRange];
        
        if([originalPrefix isEqualToString:@"+"]){
            status=TRUE;
        }
        else{
            status=FALSE;
        }
    }
    
    else{
        status=TRUE;
    }
    return status;
}

- (BOOL)checkDatetimeUpdate : (NSString *)number{
    
    return TRUE;
}

- (BOOL)campareDate : (NSString *)number{
    BOOL returnValue = FALSE;
    NSString *f = [self currentDatetime];
    NSString *s = [self getNetValueRefresh:number];
    NSArray *firstTime = [f componentsSeparatedByString:@" "];
    NSString *fDate = [firstTime objectAtIndex:0];
    NSString *fTime = [fDate stringByAppendingString:@" 06:15:00"];
    //NSString *fhours = [firstTime objectAtIndex:1];
    NSString *sDate = @"";
    NSString *sTime = @"";
    NSString *compareValue = @"";
    NSArray *secondTime = [s componentsSeparatedByString:@" "];
    if([secondTime count]>1){
        sDate = [secondTime objectAtIndex:0];
        sTime = [secondTime objectAtIndex:1];
        if([fDate isEqualToString:sDate]){
            compareValue = [self compareTime:s];
        }
    }
    if([compareValue isEqualToString:@"greater"]){
        /*s = [self getNetValueOnly:number :fTime];
        if([s isEqualToString:@"TRUE"])
            returnValue=FALSE;
        else*/
            returnValue=FALSE;
        NSLog(@"Compare %@", compareValue);
    }
    else{
        s = [self getNetValueOnly:number :fTime];
        if([s isEqualToString:@"TRUE"])
            returnValue=FALSE;
        else
            returnValue=TRUE;
    }
    
    
   /* NSString *sDate = @"";
    NSString *sTime = @"";
    NSArray *secondTime = [s componentsSeparatedByString:@" "];
    if([secondTime count]>1){
        sDate = [secondTime objectAtIndex:0];
        sTime = [secondTime objectAtIndex:1];
        if([fDate isEqualToString:sDate]){
            //returnValue=TRUE;
            NSString *compareValue = [self compareTime:s];
            //NSString *stNET = [self getNetValueRefresh:number];
            if([compareValue isEqualToString:@"less"] || [compareValue isEqualToString:@"equal"]){
                s = [self getNetValueOnly:number :fTime];
                if([s isEqualToString:@"TRUE"])
                    returnValue=FALSE;
                else
                    returnValue=TRUE;
            }
            else
                returnValue=FALSE;
        }
        else{
            returnValue=TRUE;
        }
    }
    else{
        returnValue=TRUE;
    }*/
    //NSLog(@"fdsfs %@ - %@ - %@ - %@", fDate, sDate, fTime, sTime);
    return returnValue;
}

-(NSString *)getDateTimeForRefresh : (NSString *)number{
    SQLiteDBHandler *mSqlite = [[SQLiteDBHandler alloc] init];
    NSString *getData = [mSqlite getDateTime:number];
    
    return getData;
}

-(NSString *)getNetValueRefresh : (NSString *)number{
    SQLiteDBHandler *mSqlite = [[SQLiteDBHandler alloc] init];
    NSString *getData = [mSqlite getCallNetValues:number];
    return getData;
}

-(NSString *)getNetValueOnly : (NSString *)number : (NSString *)date{
    SQLiteDBHandler *mSqlite = [[SQLiteDBHandler alloc] init];
    NSString *getData = [mSqlite getCallNetValuesOnly:number :date];
    return getData;
}

-(NSString *) currentDatetime{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *date = [dateFormatter stringFromDate:now];
    [dateFormatter release];
    return date;
}

-(NSString *) compareTime:(NSString *)f{
    NSString *pass = @"";
    NSDate *now = [NSDate date];
    NSString *fd = [NSString stringWithFormat:@"%@", now];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *date = [dateFormatter stringFromDate:now];
    NSArray *sepDate = [fd componentsSeparatedByString:@" "];
    NSString *myDate = [sepDate objectAtIndex:0];
    NSString *fullDate2 = [myDate stringByAppendingFormat:@" 00:00:00"];
    NSString *fullDate = [myDate stringByAppendingFormat:@" 06:14:59"];
    NSDate *date2 = [dateFormatter dateFromString:date];
    //NSDate *fixTime = @"06:15";
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date1 = [dateFormatter dateFromString:fullDate];
    NSDate *date3 = [dateFormatter dateFromString:fullDate2];
    
    NSComparisonResult stt = [date1 compare:date2];
    NSComparisonResult stt1 = [date3 compare:date2];
    NSLog(@"%d", (int)stt);
    /*if(date2 > date1){
        pass=@"less";
    }
    else if (date2<date1){
        pass=@"greater";
    }
    else{
        pass=@"equal";
    }*/
    
    if(stt==NSOrderedAscending && stt1==NSOrderedDescending){
        pass=@"less";
    }
    else if (stt==NSOrderedDescending && stt1==NSOrderedAscending)
        pass=@"greater";
    else
        pass=@"equal";
    [dateFormatter release];
    [dateFormatter1 release];
    return pass;
}

-(BOOL)CheckNetwork   {
    NSError *error = nil;
    BOOL internetStatus = TRUE;
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com"];
    NSURLRequest* request = [NSURLRequest requestWithURL: scriptUrl  cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval:0.5];
    //NSURLRequest *request=[NSURLRequest requestWithURL:scriptUrl];
    
    NSURLResponse* response;
    NSData* myData = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response
                                                       error:&error];
    int vari = (int)[error code];
    //NSLog(@"slow12 %d", vari);
    
    if ( myData != nil  && [error code] == 0 )
        internetStatus = TRUE;
    else if(vari ==-1009 || vari==-1004){
        //NSLog(@"slow %d", [error code]);
        internetStatus = FALSE;
        // mVal=2;
    }
    else
        internetStatus = TRUE;
    return internetStatus;
}

/*- (BOOL)checkRoaming{
    BOOL status = NO;
    PreferencesHandler *mPref = [[PreferencesHandler alloc]init];
    SQLiteDBHandler *mSqlite = [[[SQLiteDBHandler alloc] init]autorelease];
    NSString *dialin = [mPref getDropBox];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    
    
    NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode
                                                value: countryCode];
    NSString *cCode = [mSqlite getCountryPrefix:[countryCode lowercaseString]];
    if(countryCode.length!=0){
        if(![dialin isEqualToString:cCode]){
            [mPref setRoaming:YES];
            status=TRUE;
        }
        else{
            [mPref setRoaming:NO];
            status=FALSE;
        }
    
    }
    NSLog(@"countt %@ - %@ - %@", countryName, countryCode , dialin);
    
    return status;
}*/

// for SIP calling


- (NSString *)checkInternationalNumbers : (NSString *)mobile : (NSString *)getPrefix{
    BOOL statusNumber = FALSE;
    NSString *changedNumber = @"";
    if(![getPrefix isEqualToString:@"+49"]){
        if([getPrefix isEqualToString:@"+1"]){
            NSString *code = @"011";
            NSRange prefixRange = NSMakeRange (0, 3);
            NSString *originalPrefix = [mobile substringWithRange:prefixRange];
            if([originalPrefix isEqualToString:code]){
                statusNumber = TRUE;
                NSRange prefixRange = NSMakeRange (3, [mobile length]-3);
                mobile = [mobile substringWithRange:prefixRange];
                changedNumber=[@"00" stringByAppendingFormat:@"%@",mobile];
            }
            else{
                statusNumber = FALSE;
                changedNumber=mobile;
            }
        }
        else if ([getPrefix isEqualToString:@"+81"]){
            NSString *code = @"010";
            NSRange prefixRange = NSMakeRange (0, 3);
            NSString *originalPrefix = [mobile substringWithRange:prefixRange];
            if([originalPrefix isEqualToString:code]){
                statusNumber = TRUE;
                NSRange prefixRange = NSMakeRange (3, [mobile length]-3);
                mobile = [mobile substringWithRange:prefixRange];
                changedNumber=[@"00" stringByAppendingFormat:@"%@",mobile];
            }
            else{
                statusNumber = FALSE;
                changedNumber=mobile;
            }
        }
        else if ([getPrefix isEqualToString:@"+972"]){
            NSArray* inputArray = [NSArray arrayWithObjects:@"012", @"013", @"014", @"015", @"016", @"017",@"018", @"019", nil];
            
            NSRange prefixRange = NSMakeRange (0, 3);
            NSString *originalPrefix = [mobile substringWithRange:prefixRange];
            
            for (NSString* item in inputArray)
            {
                if ([item rangeOfString:originalPrefix].location != NSNotFound){
                    statusNumber = TRUE;
                    NSRange prefixRange = NSMakeRange (3, [mobile length]-3);
                    mobile = [mobile substringWithRange:prefixRange];
                    changedNumber=[@"00" stringByAppendingFormat:@"%@",mobile];
                    break;
                }
                else{
                    statusNumber = FALSE;
                    changedNumber=mobile;
                }
            }
            
        }
        else if ([getPrefix isEqualToString:@"+65"]){
            NSArray* inputArray = [NSArray arrayWithObjects:@"001",@"002", @"008",@"013", @"018", @"019", nil];
            
            NSRange prefixRange = NSMakeRange (0, 3);
            NSString *originalPrefix = [mobile substringWithRange:prefixRange];
            
            for (NSString* item in inputArray)
            {
                if ([item rangeOfString:originalPrefix].location != NSNotFound){
                    statusNumber = TRUE;
                    NSRange prefixRange = NSMakeRange (3, [mobile length]-3);
                    mobile = [mobile substringWithRange:prefixRange];
                    changedNumber=[@"00" stringByAppendingFormat:@"%@",mobile];
                    break;
                }
                else{
                    statusNumber = FALSE;
                    changedNumber=mobile;
                }
            }
            
        }
        else if([getPrefix isEqualToString:@"+82"]){
            
            NSArray* inputArray = [NSArray arrayWithObjects:@"001", @"002",@"003", @"005", @"006",@"007", @"008", nil];
            
            NSRange prefixRange = NSMakeRange (0, 3);
            NSString *originalPrefix = [mobile substringWithRange:prefixRange];
            
            for (NSString* item in inputArray)
            {
                
                if ([item rangeOfString:originalPrefix].location != NSNotFound){
                    statusNumber=TRUE;
                    break;
                }
            }
            if(statusNumber==TRUE){
                if([originalPrefix isEqualToString:@"003"] || [originalPrefix isEqualToString:@"007"]){
                    NSRange prefixRange = NSMakeRange (3, [mobile length]-3);
                    changedNumber = [mobile substringWithRange:prefixRange];
                    NSRange prefixRange1 = NSMakeRange (5, [mobile length]-5);
                    changedNumber = [mobile substringWithRange:prefixRange1];
                    changedNumber=[@"00" stringByAppendingFormat:@"%@",changedNumber];
                }
                else{
                    NSRange prefixRange = NSMakeRange (3, [mobile length]-3);
                    changedNumber = [mobile substringWithRange:prefixRange];
                    NSRange prefixRange1 = NSMakeRange (3, [mobile length]-3);
                    changedNumber = [mobile substringWithRange:prefixRange1];
                    changedNumber=[@"00" stringByAppendingFormat:@"%@",changedNumber];
                }
                
            }
            else
                changedNumber=mobile;
        
        }
    }
    else
        changedNumber=mobile;
    
    return changedNumber;
    
}

- (BOOL)modifiedNumber : (NSString *)mobile{
    BOOL status = FALSE;
    if([mobile isEqualToString:@"112"] || [mobile isEqualToString:@"0112"] || [mobile isEqualToString:@"110"] || [mobile isEqualToString:@"0110"] || [mobile isEqualToString:@"+49110"] || [mobile isEqualToString:@"0049110"] || [mobile isEqualToString:@"+49112"] || [mobile isEqualToString:@"0049112"] || [mobile isEqualToString:@"19222"] || [mobile isEqualToString:@"019222"] || [mobile isEqualToString:@"+4919222"] || [mobile isEqualToString:@"004919222"] || [mobile isEqualToString:@"4919222"] || [mobile isEqualToString:@"49110"] || [mobile isEqualToString:@"49112"]){
        status=FALSE;
    }
    else if([mobile length]>2){
        NSRange getRange = NSMakeRange (0, 3);
        NSRange getRangeSec = NSMakeRange (0, 2);
        NSString *takeCodeNos = [mobile substringWithRange:getRangeSec];
        NSString *takeNos = [mobile substringWithRange:getRange];
        if([takeCodeNos isEqualToString:@"49"]){
            if([mobile length]>4){
                NSRange getOtherRange = NSMakeRange (2, 3);
                takeCodeNos = [mobile substringWithRange:getOtherRange];
                if([takeCodeNos isEqualToString:@"181"] || [takeCodeNos isEqualToString:@"182"] || [takeCodeNos isEqualToString:@"183"] || [takeCodeNos isEqualToString:@"184"] || [takeCodeNos isEqualToString:@"185"] || [takeCodeNos isEqualToString:@"186"] || [takeCodeNos isEqualToString:@"187"] || [takeCodeNos isEqualToString:@"188"] || [takeCodeNos isEqualToString:@"189"] ){
                    status=FALSE;
                }
            }
        }
        else if(([takeNos isEqualToString:@"181"] || [takeNos isEqualToString:@"182"] || [takeNos isEqualToString:@"183"] || [takeNos isEqualToString:@"184"] || [takeNos isEqualToString:@"185"] || [takeNos isEqualToString:@"186"] || [takeNos isEqualToString:@"187"] || [takeNos isEqualToString:@"188"] || [takeNos isEqualToString:@"189"] || [takeNos isEqualToString:@"018"] || [takeNos isEqualToString:@"180"])){
            status=FALSE;
        }
        else
            status=TRUE;
    }
    else
        status=TRUE;
    
    return status;
}


- (NSString *)convertNumber : (NSString *)mobile{
    PreferencesHandler *mPref = [[[PreferencesHandler alloc]init]autorelease];
    NSString *countryCode = [mPref getDropBox];
    NSString *trimed = @"";
    if([countryCode isEqualToString:@"+49"] && [mobile length]>5){
        BOOL vals = [self modifiedNumber:mobile];
        if(vals){
            BOOL checkZero = [self checkZeroValue:mobile];
            if(checkZero){
                trimed = [self removedZero:mobile];
                trimed = [countryCode stringByAppendingFormat:@"%@", trimed];
            }
            else{
                trimed = [countryCode stringByAppendingFormat:@"%@", mobile];
            }
        }
        else
            trimed=mobile;
    }
    else if([countryCode isEqualToString:@"+91"] && [mobile length]>5){
        BOOL checkZero = [self checkZeroValue:mobile];
        if(checkZero){
            trimed = [self removedZero:mobile];
            trimed = [countryCode stringByAppendingFormat:@"%@", trimed];
        }
        else{
            trimed = [countryCode stringByAppendingFormat:@"%@", mobile];
        }
    }
    else{
        trimed = [self checkInternationalNumbers:mobile :countryCode];
    }
    mobile = trimed;
    return mobile;
}


@end
