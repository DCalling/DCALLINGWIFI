//
//  IASKPSTextFieldSpecifierViewCell.m
//  Created by Prashant on 23/02/12.
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


#import "IASKPSTextFieldSpecifierViewCell.h"
#import "IASKTextField.h"
#import "IASKSettingsReader.h"

@implementation IASKPSTextFieldSpecifierViewCell

@synthesize textField=_textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;

        // TextField
        _textField = [[[IASKTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 21)] autorelease];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin;
        _textField.font = [UIFont systemFontOfSize:17.0f];
		_textField.minimumFontSize = kIASKMinimumFontSize;
        _textField.textColor = [UIColor colorWithRed:0.275 green:0.376 blue:0.522 alpha:1.000];
        [self.contentView addSubview:_textField];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Label
	CGFloat imageOffset = self.imageView.image ? self.imageView.bounds.size.width + kIASKPaddingLeft : 0;
    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
	labelSize.width = MAX(labelSize.width, kIASKMinLabelWidth - imageOffset);
    self.textLabel.frame = (CGRect){self.textLabel.frame.origin, {MIN(kIASKMaxLabelWidth, labelSize.width), self.textLabel.frame.size.height}} ;

    // TextField
    _textField.center = CGPointMake(_textField.center.x, self.contentView.center.y);
	CGRect textFieldFrame = _textField.frame;
	textFieldFrame.origin.x = self.textLabel.frame.origin.x + MAX(kIASKMinLabelWidth - imageOffset, self.textLabel.frame.size.width) + kIASKSpacing;
	textFieldFrame.size.width = _textField.superview.frame.size.width - textFieldFrame.origin.x - kIASKPaddingRight;
	
	if (!self.textLabel.text.length) {
		textFieldFrame.origin.x = kIASKPaddingLeft + imageOffset;
		textFieldFrame.size.width = self.contentView.bounds.size.width - 2* kIASKPaddingLeft - imageOffset;
	} else if (_textField.textAlignment == UITextAlignmentRight) {
		textFieldFrame.origin.x = self.textLabel.frame.origin.x + labelSize.width + kIASKSpacing;
		textFieldFrame.size.width = _textField.superview.frame.size.width - textFieldFrame.origin.x - kIASKPaddingRight;
	}
	_textField.frame = textFieldFrame;
}


- (void)dealloc {
    [super dealloc];
}


@end
