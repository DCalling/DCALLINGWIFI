//
//  AddressBookHandler.m
//  DCalling WiFi
//
//  Created by Prashant on 07/02/12.
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

#import "AddressBookHandler.h"
#import "SQLiteDBHandler.h"

@implementation AddressBookHandler

@synthesize _allPhoneNumbers;
@synthesize phoneNumbers, getMatchedPhone, trimMutableArray;
@synthesize trimPhoneNumber;
@synthesize matchPhoneNumber;
@synthesize PhoneBook;
@synthesize dataStr, param, telNumner;
@synthesize getABNames, addMyPhoneBook, getABMobiles, mobileMutable, trimMutableArrayOfArray;


NSArray *addrBookName ;
-(void) setPhoneValues:(NSMutableArray *) allPhoneNumbers{
    self._allPhoneNumbers = allPhoneNumbers;
    
}
-(NSMutableArray *)getPhoneValues{
    return self._allPhoneNumbers;
}

-(void)getAllPhoneFromAB {
    ABAddressBookRef myAddressBook = ABAddressBookCreate();
    NSArray *allPeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(myAddressBook);
    // NSString *str = nil;
    PhoneBook = [[NSMutableString alloc]init];
    NSMutableDictionary *colomnHeading;
    addMyPhoneBook = [[NSMutableArray alloc]init]; ;
    //  NSLog(@"ArrayValue--------%@",allPeople);
    //PhoneBook=@"First Name,Middle Name,Last Name,Mobile No.,Home, Work ,Organization,JobTitle,Dept.,Emails,Birthday\n";
    //PhoneBook = @"";
    [PhoneBook setString:@""];
    colomnHeading = [[NSMutableDictionary alloc]init];
    for (id record in allPeople)
    {
        
        // NSLog(@"---------------------------------------------------");
        if([(NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonFirstNameProperty) length]!=0)
        {
            PhoneBook=[NSMutableString stringWithFormat:@" %@ %@",PhoneBook,(NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonFirstNameProperty)];
            [colomnHeading setObject:(NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonFirstNameProperty) forKey:@"First Name"];
            // NSLog(@"The colomnHeading is -->%@",colomnHeading);
        }
        
        else
        {
            //NSString *firstS = @" ";
            PhoneBook=[NSMutableString stringWithFormat:@"%@ ",PhoneBook];
            
        }
        if([(NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonLastNameProperty) length]!=0)
        {
            
            PhoneBook=[NSMutableString stringWithFormat:@"%@ %@ ",PhoneBook,(NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonLastNameProperty)];
        }
        
        else{
            
            PhoneBook=[NSMutableString stringWithFormat:@"%@ ",PhoneBook];    
        }
        if([(NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonOrganizationProperty) length]!=0)
        {
            
            PhoneBook=[NSMutableString stringWithFormat:@" %@ %@ }",PhoneBook,(NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonOrganizationProperty)];
        }
        
        else{
            //NSString *lastS = @" ";
            PhoneBook=[NSMutableString stringWithFormat:@" %@ } ",PhoneBook];
            
        }
        
        
        
        mobileMutable=[[NSMutableString alloc]init];
        ABMultiValueRef phones =(NSString*)ABRecordCopyValue(record, kABPersonPhoneProperty);
        NSString* mobileLabel;    
        //NSLog(@"\n\n\n\n\n Count is %@",ABMultiValueGetCount(phones));
        //CFIndex i = 0;
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) 
        {
            
            mobileLabel = (NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            
            NSString *Home=[NSString stringWithFormat:@"%@",(NSString*)ABMultiValueCopyValueAtIndex(phones, i)];
            NSString *Work=[NSString stringWithFormat:@"%@",(NSString*)ABMultiValueCopyValueAtIndex(phones, i)];
            NSString *PhoneNumber=[NSString stringWithFormat:@"%@",(NSString*)ABMultiValueCopyValueAtIndex(phones, i)];
            
            if(i>0)
                PhoneNumber = [@"}" stringByAppendingFormat:@"%@",PhoneNumber];
            [mobileMutable appendString:PhoneNumber];
            
            
            Home=nil;
            Work = nil;
            PhoneNumber = nil;
        }
        //NSLog(@"%@ ---- %@", mobileMutable, addMyPhoneBook);
        
        [addMyPhoneBook  addObject:mobileMutable];
        [mobileMutable release];
    }
    
    [self setPhoneValues:addMyPhoneBook];
    
    
    
}

-(void) getAddrBookName {
    getABNames = [[NSArray alloc]init];
    NSString *abName1 = [PhoneBook retain];
    [PhoneBook release];
    
    NSString *abname = [abName1 stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    getABNames = [abname componentsSeparatedByString: @"}"];
    //NSLog(@"NAMES %@", getABNames);
}

-(void) getAddrMobile {
    getABMobiles = [[NSArray alloc]init];
    NSString *abName1 = [mobileMutable retain];
      
    NSString *abname = [abName1 stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    getABMobiles = [abname componentsSeparatedByString: @"}"];
    
    //NSLog(@"mo %@", getABMobiles);
    
}


-(BOOL) getContactCompare:(NSString *) phoneStr{
    BOOL status= false;
    //NSLog(@"Recent Call :- %@", [self getPhoneValues]);
    NSMutableArray *values = [[NSMutableArray alloc]init];
    values = [self.getPhoneValues retain];
    NSMutableArray *myPhoneABNumbers = [[NSMutableArray alloc]init];
    myPhoneABNumbers = [self trimWhiteSpaceMutable:values];
    int count = (int)[myPhoneABNumbers count];
    NSString *trimStr = [self trimWhiteSpace:phoneStr];
    getMatchedPhone = [[NSString alloc]init];
    if(count != 0){
        for(NSString* obj in myPhoneABNumbers){
            NSRange titleResultsRange = [obj rangeOfString:trimStr options:NSCaseInsensitiveSearch];
            if (titleResultsRange.length > 0) 
            {
              //  NSLog(@"object id is :- %@", obj);
                getMatchedPhone = trimStr;
                // NSLog(@"Found Matched String: %@", trimStr);
                status = true;
                break;
            }
            
        }
        
    }
    return status;
    
}

-(BOOL) getCompareWithZero:(NSString *) phoneStr{
    BOOL status = true;    
    trimPhoneNumber = [[NSString alloc]init];
    trimPhoneNumber = [self prefixStr:phoneStr];
    
    NSString *trimmedString = [trimPhoneNumber stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //NSLog(trimmedString);
    trimmedString = [self specialCharactersRemove:trimmedString];
    NSString *removedDashStr = [trimmedString stringByReplacingOccurrencesOfString:@" "
                                                                        withString:@""];
    removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"·"
                                                               withString:@""];
    removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-"
                                                               withString:@""];
    
    NSString *removeBrackets = [removedDashStr stringByReplacingOccurrencesOfString:@"("
                                                                         withString:@""];
    removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@")"
                                                               withString:@""];
        
    return status;    
}

-(void) SetReturnPhoneStr:(NSString *) phoneStr{
    matchPhoneNumber = phoneStr;
}

-(NSString *) returnPhoneStr{
    return matchPhoneNumber;
}

-(NSString *) trimWhiteSpace :(NSString *) myString{
    
    trimPhoneNumber = [[NSString alloc]init];
    
    trimPhoneNumber = [self prefixStr:myString];
    
    NSString *trimmedString = [trimPhoneNumber stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //NSLog(trimmedString);
    trimmedString = [self specialCharactersRemove:trimmedString];
    NSString *removedDashStr = [trimmedString stringByReplacingOccurrencesOfString:@" "
                                                                        withString:@""];
    removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"(0"                                                                       withString:@""];
    //removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-0"                                                                       withString:@""];
    removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"·"
                                                               withString:@""];
    removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-"
                                                               withString:@""];
    
    NSString *removeBrackets = [removedDashStr stringByReplacingOccurrencesOfString:@"("
                                                                         withString:@""];
    removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@")"
                                                               withString:@""];
    removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@"/"
                                                               withString:@""];
    
    return removeBrackets;
}

-(NSString *) trimWhiteSpaceNotZero :(NSString *) myString{
    
    //trimPhoneNumber = [[NSString alloc]init];
    
    //trimPhoneNumber = [self prefixStr:myString];
    
    NSString *trimmedString = [myString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //NSLog(trimmedString);
    trimmedString = [self specialCharactersRemove:trimmedString];
    NSString *removedDashStr = [trimmedString stringByReplacingOccurrencesOfString:@" "
                                                                        withString:@""];
    removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"(0"                                                                       withString:@""];
    //removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-0"                                                                       withString:@""];
    removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"·"
                                                               withString:@""];
    removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-"
                                                               withString:@""];
    
    NSString *removeBrackets = [removedDashStr stringByReplacingOccurrencesOfString:@"("
                                                                         withString:@""];
    removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@")"
                                                               withString:@""];
    removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@"/"
                                                               withString:@""];
    
    return removeBrackets;
}

-(NSMutableArray *) trimWhiteSpaceMutable :(NSMutableArray *) myMutableArray{
    trimMutableArray = [[NSMutableArray alloc]init];
    for(NSString *str in myMutableArray){
        trimPhoneNumber = [[NSString alloc]init];       
        trimPhoneNumber = [self prefixStr:str];
        NSString *trimmedString = [trimPhoneNumber stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(trimmedString);
        trimmedString = [self specialCharactersRemove:trimmedString];
        NSString *removedDashStr = [trimmedString stringByReplacingOccurrencesOfString:@" "
                                                                            withString:@""];
        removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"(0"                                                                       withString:@""];
        //removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-0"                                                                       withString:@""];
        removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"·"
                                                                   withString:@""];
        removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-"
                                                                   withString:@""];
        NSString *removeBrackets = [removedDashStr stringByReplacingOccurrencesOfString:@"("
                                                                             withString:@""];
        removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@")"
                                                                   withString:@""];
        removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@"/"
                                                                   withString:@""];
        
        [trimMutableArray addObject:removeBrackets];
        
    }
    //NSLog(@"tri muta %@", trimMutableArray);
    return trimMutableArray;
    
}

-(NSMutableArray *) trimWhiteSpaceMutableOfMutable :(NSMutableArray *) myMutableArray{
    trimMutableArrayOfArray = [[NSMutableArray alloc]init];
    
    for(NSArray *arrOfArr in myMutableArray){
        NSMutableArray *myaraay;
        myaraay = [[NSMutableArray alloc] init ];
        for( NSString *str in arrOfArr){
            
            trimPhoneNumber = [[NSString alloc]init];       
            trimPhoneNumber = [self prefixStr:str];
            NSString *trimmedString = [trimPhoneNumber stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //NSLog(trimmedString);
            trimmedString = [self specialCharactersRemove:trimmedString];
            NSString *removedDashStr = [trimmedString stringByReplacingOccurrencesOfString:@" "
                                                                            withString:@""];
            removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"(0"                                                                       withString:@""];
            //removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-0"                                                                       withString:@""];
            removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"·"
                                                                       withString:@""];
            removedDashStr = [removedDashStr stringByReplacingOccurrencesOfString:@"-"
                                                                   withString:@""];
            NSString *removeBrackets = [removedDashStr stringByReplacingOccurrencesOfString:@"("
                                                                             withString:@""];
            removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@")"
                                                                   withString:@""];
            removeBrackets = [removeBrackets stringByReplacingOccurrencesOfString:@"/"
                                                                       withString:@""];
            
            [myaraay addObject:removeBrackets];
            
        }
        [trimMutableArrayOfArray addObject:myaraay];
        [myaraay release];
    }
    //NSLog(@"tri muta %@", trimMutableArray);
    return trimMutableArrayOfArray;
    
}


-(NSString *)prefixStr:(NSString *)phone{
   //NSLog(@"sub string %@", phone); 
   trimPhoneNumber = @""; 
   int strLen = (int)[phone length];
    if(strLen >=2){
        NSRange rangeStr;
        NSRange range = NSMakeRange (0, 1);
        NSString *zeroZero = [phone substringWithRange:range];
        
        if([zeroZero isEqualToString:@"+"]){
            rangeStr = NSMakeRange (1, strLen-1);
            trimPhoneNumber = [phone substringWithRange:rangeStr];
        }
        else if([zeroZero isEqualToString:@"0"]){
            rangeStr = NSMakeRange (1, strLen-1);
            trimPhoneNumber = [phone substringWithRange:rangeStr];
            rangeStr = NSMakeRange (0, 1);
            int lenStr = (int)[trimPhoneNumber length];
            NSString *againZero = [trimPhoneNumber substringWithRange:rangeStr];
            if([againZero isEqualToString:@"0"]){
                NSRange rangeStr = NSMakeRange (1, lenStr-1);
                trimPhoneNumber = [trimPhoneNumber substringWithRange:rangeStr];
            }
        }
        else {
            trimPhoneNumber = phone;
        }
    }
    return trimPhoneNumber;
}

-(UIImage *) imageFetchFromAB:(NSString *)phoneStr{
    
    ABAddressBookRef addressbook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressbook);
    CFIndex numPeople = ABAddressBookGetPersonCount(addressbook);
    for (int i=0; i < numPeople; i++) { 
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        ABMutableMultiValueRef phonelist = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex numPhones = ABMultiValueGetCount(phonelist);
        for (int j=0; j < numPhones; j++) {
            CFTypeRef ABphone = ABMultiValueCopyValueAtIndex(phonelist, j);
            NSString *personPhone = (NSString *)ABphone;
            CFRelease(ABphone);
            NSString *triABPhone = [self trimWhiteSpace:personPhone];          
            NSString *trimNumStr = [self trimWhiteSpace:phoneStr];
            
            if([triABPhone isEqualToString:trimNumStr]){
                //NSMutableArray *addImage = [[NSMutableArray alloc]init];
                if(ABPersonHasImageData(person)){
                    CFDataRef imageData = ABPersonCopyImageData(person);
                    image = [UIImage imageWithData:(NSData *)imageData];
                    CFRelease(imageData);
                    break;
                }
                //[addImage addObject:image];
            } 
            
            
        }
        
    }
    
    return image;
}

-(NSString *) namesFromAB:(NSString *)phoneStr{
    NSString *callData=@"" ;
    ABAddressBookRef addressbook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressbook);
    CFIndex numPeople = ABAddressBookGetPersonCount(addressbook);
    
    @try { 
       
    for (int i=0; i < numPeople; i++) { 
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        ABMutableMultiValueRef phonelist = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
        NSString *companyName = (NSString *)ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        
        CFIndex numPhones = ABMultiValueGetCount(phonelist);
        for (int j=0; j < numPhones; j++) {
            CFTypeRef ABphone = ABMultiValueCopyValueAtIndex(phonelist, j);
            NSString *personPhone = (NSString *)ABphone;
            CFRelease(ABphone);
            NSString *triABPhone = [self trimWhiteSpace:personPhone];          
            NSString *trimNumStr = [self trimWhiteSpace:phoneStr];
            NSString *phoneLabel = @" ";
            if([triABPhone isEqualToString:trimNumStr]){
                
                CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phonelist, ABMultiValueGetIndexForIdentifier(phonelist, j));
                phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
                //CFRelease(locLabel);
                //NSLog(@"  - %@",  phoneLabel);
                
                if([phoneLabel length] == 0)
                    phoneLabel =@"mobile";
                
                if([firstName length] ==0){
                    lastName = @"";
                    callData = [companyName stringByAppendingFormat:@" %@",lastName];
                }else{
                    if(lastName.length ==0){
                        lastName =@"";
                    }
                    callData = [firstName stringByAppendingFormat:@" %@",lastName];
                }
                callData = [callData stringByAppendingFormat:@" %@", phoneLabel];
                //NSLog(@"Name %@ %@", firstName, callData);                
                return callData;
            //[addImage addObject:image];
            } 
                        
          
        }
                
    }
    }
    @catch (NSException *exception) {
         NSLog(@"AddressBook Handler - %@", exception);
    }

    
    return callData;
}

-(BOOL) updateCallLogdata{
    BOOL st = false;
    NSMutableArray *arrayNumbers = [[NSMutableArray alloc ]init];
    SQLiteDBHandler *mSQLite = [[SQLiteDBHandler alloc]init];
    arrayNumbers = [mSQLite getCallLogRec];
    ABAddressBookRef addressbook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressbook);
    CFIndex numPeople = ABAddressBookGetPersonCount(addressbook);
    for(int k = 0; k<[arrayNumbers count]; k++){
        NSString *orignal = [arrayNumbers objectAtIndex:k];
        for (int i=0; i < numPeople; i++) { 
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            ABMutableMultiValueRef phonelist = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
            ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
            NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            NSString *lastName = (NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
            NSString *companyName = (NSString *)ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        
            CFIndex numPhones = ABMultiValueGetCount(phonelist);
            for (int j=0; j < numPhones; j++) {
            
                CFTypeRef ABphone = ABMultiValueCopyValueAtIndex(phonelist, j);
                NSString *personPhone = (NSString *)ABphone;
                CFRelease(ABphone);
                NSString *triABPhone = [self trimWhiteSpace:personPhone];          
                NSString *trimNumStr = [self trimWhiteSpace:orignal];
                NSString *phoneLabel = @" ";
                if([triABPhone isEqualToString:trimNumStr]){
                    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phonelist, ABMultiValueGetIndexForIdentifier(phonelist, j));
                    phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
                    CFRelease(locLabel);
                   // NSLog(@"  - %@",  phoneLabel);
                    NSArray *details = [[NSArray alloc] init];
                    NSMutableArray *jh = [[NSMutableArray alloc]init];
                    NSString *fir = [[NSString alloc]init];
                    NSString *sec = [[NSString alloc]init];
                    if(![firstName isEqualToString:@""] && firstName!=nil)
                        [jh addObject:firstName];
                    if (![lastName isEqualToString:@""] && lastName!=nil) {
                        [jh addObject:lastName];
                    }
                    if (![companyName isEqualToString:@""] && companyName!=nil) {
                        [jh addObject:companyName];
                    }
                    if([jh count] == 0){
                        //fir = [jh objectAtIndex:0];
                        details = [NSArray arrayWithObjects: orignal, @" ", orignal, phoneLabel, nil];
                    }
                
                    else if([jh count] == 1){
                        fir = [jh objectAtIndex:0];
                        details = [NSArray arrayWithObjects: fir, @" ", orignal, phoneLabel,nil];
                    }
                    else if([jh count] == 2){
                        fir = [jh objectAtIndex:0];
                        sec = [jh objectAtIndex:1];
                        details = [NSArray arrayWithObjects: fir, sec, orignal, phoneLabel,nil]; 
                    }
                    else {
                        fir = [jh objectAtIndex:0];
                        sec = [jh objectAtIndex:1];
                        details = [NSArray arrayWithObjects: fir, sec, orignal, phoneLabel,nil];                           
                    }
                            
                    st = [self updateCall:details];
                    break;
                } 
            
            
            }
        
        }

    } 
    
    return st;
}

-(BOOL) updateFavLogdata{
    BOOL st = false;
    NSMutableArray *arrayNumbers = [[NSMutableArray alloc ]init];
    SQLiteDBHandler *mSQLite = [[SQLiteDBHandler alloc]init];
    arrayNumbers = [mSQLite getFavNumbers];
    ABAddressBookRef addressbook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressbook);
    CFIndex numPeople = ABAddressBookGetPersonCount(addressbook);
    for(int k = 0; k<[arrayNumbers count]; k++){
        NSString *orignal = [arrayNumbers objectAtIndex:k];
        for (int i=0; i < numPeople; i++) { 
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            ABMutableMultiValueRef phonelist = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
            NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            NSString *lastName = (NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
            NSString *companyName = (NSString *)ABRecordCopyValue(ref, kABPersonOrganizationProperty);
            
            CFIndex numPhones = ABMultiValueGetCount(phonelist);
            for (int j=0; j < numPhones; j++) {
                
                CFTypeRef ABphone = ABMultiValueCopyValueAtIndex(phonelist, j);
                NSString *personPhone = (NSString *)ABphone;
                CFRelease(ABphone);
                NSString *triABPhone = [self trimWhiteSpace:personPhone];          
                NSString *trimNumStr = [self trimWhiteSpace:orignal];
                NSString *phoneLabel = @" ";
                if([triABPhone isEqualToString:trimNumStr]){
                    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phonelist, ABMultiValueGetIndexForIdentifier(phonelist, j));
                    phoneLabel =(NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
                    CFRelease(locLabel);
                    // NSLog(@"  - %@",  phoneLabel);
                    NSArray *details = [[NSArray alloc] init];
                    NSMutableArray *jh = [[NSMutableArray alloc]init];
                    NSString *fir = [[NSString alloc]init];
                    NSString *sec = [[NSString alloc]init];
                    if(![firstName isEqualToString:@""] && firstName!=nil)
                        [jh addObject:firstName];
                    if (![lastName isEqualToString:@""] && lastName!=nil) {
                        [jh addObject:lastName];
                    }
                    if (![companyName isEqualToString:@""] && companyName!=nil) {
                        [jh addObject:companyName];
                    }
                    if([jh count] == 0){
                        //fir = [jh objectAtIndex:0];
                        details = [NSArray arrayWithObjects: orignal, @" ", orignal, phoneLabel, nil];
                    }
                    
                    else if([jh count] == 1){
                        fir = [jh objectAtIndex:0];
                        details = [NSArray arrayWithObjects: fir, @" ", orignal, phoneLabel,nil];
                    }
                    else if([jh count] == 2){
                        fir = [jh objectAtIndex:0];
                        sec = [jh objectAtIndex:1];
                        details = [NSArray arrayWithObjects: fir, sec, orignal, phoneLabel,nil]; 
                    }
                    else {
                        fir = [jh objectAtIndex:0];
                        sec = [jh objectAtIndex:1];
                        details = [NSArray arrayWithObjects: fir, sec, orignal, phoneLabel,nil];                           
                    }
                    
                    st = [self updateFav:details];
                    break;
                } 
                
                
            }
            
        }
        
    } 
    
    return st;
}


-(BOOL) updateCall: (NSArray *) personDetails{
    BOOL status = false ;
    
    SQLiteDBHandler *updateSql = [[SQLiteDBHandler alloc] init];
    status = [updateSql updateCallLog:personDetails];
    [updateSql release];
    
    if(status){
        status = true;
    }
    else{
        status = false;
    }
    
    return status;
}

-(BOOL) updateFav: (NSArray *) personDetails{
    BOOL status = false ;
    
    SQLiteDBHandler *updateSql = [[SQLiteDBHandler alloc] init];
    status = [updateSql updateFavLog:personDetails];
    [updateSql release];
    
    if(status){
        status = true;
    }
    else{
        status = false;
    }
    
    return status;
}

-(NSString *) getDialin:(NSString *)getPrefix{
   
    SQLiteDBHandler *mSqlite = [[SQLiteDBHandler alloc] autorelease];
    NSString *countryID = [mSqlite getCountrCodeID:getPrefix];
    NSString *dialIn = [mSqlite getDefaultDialin:countryID];
    return dialIn;

}

-(NSString *) getCountryID:(NSString *)getPrefix{
    SQLiteDBHandler *mSqlite = [[SQLiteDBHandler alloc] autorelease];
    NSString *countryID = [mSqlite getCountrCodeID:getPrefix];
    NSString *dialIn = [mSqlite getDefaultDialin:countryID];
    return dialIn;
}

-(void) getAlterView:(id) param1 : (NSString *) phonenumber{
    param = param1;
    telNumner = phonenumber;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"ERROR_MSG"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"SELECT_OTHER_COUNTRY"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
   /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NOTIFY_CON"] message:[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"NOTIFY_MSG"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];*/
    [alert show];
    [alert release];

}


-(void) smsController:(id) param1 : (NSString *) number{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        param=param1;
        //controller.body = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"msg3"];
        controller.body = number;
        controller.recipients = [NSArray arrayWithObject:@"+4916090422326"];
        controller.messageComposeDelegate = self;
        [param1 presentModalViewController:controller animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Error");
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[param dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //[self smsController:param :telNumner];
    } 
    else {
        NSLog(@"Cancel");
    }
}

- (NSString *)specialCharactersRemove : (NSString *)myString{
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0){
        NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[myString length]];
        for (int i=0; i < [myString length]; i++) {
            NSString *ichar  = [NSString stringWithFormat:@"%c", [myString characterAtIndex:i]];
            NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"+0123456789()-*#"];
            NSRange numberRange = [ichar rangeOfCharacterFromSet:numberSet];
            if (numberRange.location != NSNotFound) {
                [characters addObject:ichar];
            }
        
        }
        return [characters componentsJoinedByString:@""];
    }
    else
        return myString;
    
}


-(void)dealloc{
    matchPhoneNumber = nil;
    [phoneNumbers release];    
    [image release];   
    [addMyPhoneBook release];
    [param release];
    [super dealloc];
}


@end