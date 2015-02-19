//
//  CountryPrefixHandler.h
//  DCalling WiFi
//
//  Created by Prashant Kumar on 29/02/12.
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

#import <Foundation/Foundation.h>

@interface CountryPrefixHandler : NSObject{
    NSString *countryName;
}
@property(nonatomic, retain) NSMutableArray *countryPrefix;
@property(nonatomic, copy) NSString *countryName;
-(NSString *) getCountryPrefix: (NSString *)cName;

-(NSMutableArray *) getCountryPrefixCode;

-(void) getCountryName;

-(NSMutableArray *) getMCCCode;

-(NSString *) getPreMCCCode:(NSInteger) mcc;

-(BOOL) staticDialinNumbers:(NSString *) prefixed;

-(void) getCountryNameEN;

-(NSString *) getCountryPrefixEN:(NSString *)cName;

-(NSString *) getCountryPrefixTr:(NSString *)cName;

-(NSMutableArray *) getCountryPrefixCodeEN;

-(NSMutableArray *) getCountryPrefixCodeTr;

-(void) getCountryNameTr;

-(NSString *) getCountryNamePrefix:(NSString *)cName;
-(NSString *) getCountryNamePrefixEN:(NSString *)cName;
-(NSString *) getCountryNamePrefixTr:(NSString *)cName;

@end
