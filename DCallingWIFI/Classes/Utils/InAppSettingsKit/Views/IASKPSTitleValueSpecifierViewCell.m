//
//  IASKPSTitleValueSpecifierViewCell.m
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

#import "IASKPSTitleValueSpecifierViewCell.h"
#import "IASKSettingsReader.h"


@implementation IASKPSTitleValueSpecifierViewCell

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGSize viewSize =  [self.textLabel superview].frame.size;

	// if there's an image, make room for it
	CGFloat imageOffset = floor(self.imageView.image ? self.imageView.bounds.size.width + self.imageView.frame.origin.x : 0);
  
	// set the left title label frame
	CGFloat labelWidth = [self.textLabel sizeThatFits:CGSizeZero].width;
	CGFloat minValueWidth = (self.detailTextLabel.text.length) ? kIASKMinValueWidth + kIASKSpacing : 0;
	labelWidth = MIN(labelWidth, viewSize.width - minValueWidth - kIASKPaddingLeft -kIASKPaddingRight - imageOffset);
	CGRect labelFrame = CGRectMake(kIASKPaddingLeft + imageOffset, 0, labelWidth, viewSize.height);
	if (!self.detailTextLabel.text.length) {
		labelFrame = CGRectMake(kIASKPaddingLeft + imageOffset, 0, viewSize.width - kIASKPaddingLeft - kIASKPaddingRight - imageOffset, viewSize.height);
	}
	self.textLabel.frame = labelFrame;
	
	// set the right value label frame
	if (!self.textLabel.text.length) {
		viewSize =  [self.detailTextLabel superview].frame.size;
		self.detailTextLabel.frame = CGRectMake(kIASKPaddingLeft + imageOffset, 0, viewSize.width - kIASKPaddingLeft - kIASKPaddingRight - imageOffset, viewSize.height);
	} else if (self.detailTextLabel.textAlignment == NSTextAlignmentLeft) {
		CGRect valueFrame = self.detailTextLabel.frame;
		valueFrame.origin.x = labelFrame.origin.x + MAX(kIASKMinLabelWidth - imageOffset, labelWidth) + kIASKSpacing;
		valueFrame.size.width = self.detailTextLabel.superview.frame.size.width - valueFrame.origin.x - kIASKPaddingRight;
		self.detailTextLabel.frame = valueFrame;
	}
}

@end
