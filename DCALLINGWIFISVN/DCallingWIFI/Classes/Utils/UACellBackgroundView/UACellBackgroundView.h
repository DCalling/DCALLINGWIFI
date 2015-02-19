//
//  UACellBackgroundView.h
//  Ambiance
//
//  Created by Prashant Kumar on 10/06/14.
//  Copyright 2014 Dcalling Apps . All rights reserved.
//
//  Modified by Prashant Kumar on 10/06/14

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef enum  {
    UACellBackgroundViewPositionSingle = 0,
    UACellBackgroundViewPositionTop, 
    UACellBackgroundViewPositionBottom,
    UACellBackgroundViewPositionMiddle
} UACellBackgroundViewPosition;

@interface UACellBackgroundView : UIView {
}

@property(nonatomic) UACellBackgroundViewPosition position;
@property(nonatomic, copy) UIColor *backgroundColor;
@property(nonatomic, copy) UIColor *borderColor;
@property(assign) BOOL automaticPositioning;

@end
