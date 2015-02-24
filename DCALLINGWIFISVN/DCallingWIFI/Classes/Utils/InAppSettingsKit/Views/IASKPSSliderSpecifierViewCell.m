//
//  IASKPSSliderSpecifierViewCell.m
//  Created by Prashant on 23/02/12.
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


#import "IASKPSSliderSpecifierViewCell.h"
#import "IASKSlider.h"
#import "IASKSettingsReader.h"

@implementation IASKPSSliderSpecifierViewCell

@synthesize slider=_slider, 
            minImage=_minImage, 
            maxImage=_maxImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Setting only frame data that will not be overwritten by layoutSubviews
        // Slider
        _slider = [[[IASKSlider alloc] initWithFrame:CGRectMake(0, 0, 0, 23)] autorelease];
        _slider.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleWidth;
        _slider.continuous = NO;
        [self.contentView addSubview:_slider];

        // MinImage
        _minImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)] autorelease];
        _minImage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_minImage];

        // MaxImage
        _maxImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)] autorelease];
        _maxImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_maxImage];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	CGRect  sliderBounds    = _slider.bounds;
    CGPoint sliderCenter    = _slider.center;
    const double superViewWidth = _slider.superview.frame.size.width;
    
    sliderCenter.x = superViewWidth / 2;
    sliderCenter.y = self.contentView.center.y;
    sliderBounds.size.width = superViewWidth - kIASKSliderNoImagesPadding * 2;
	_minImage.hidden = YES;
	_maxImage.hidden = YES;

	// Check if there are min and max images. If so, change the layout accordingly.
	if (_minImage.image) {
		// Min image
		_minImage.hidden = NO;
		sliderCenter.x    += (kIASKSliderImagesPadding - kIASKSliderNoImagesPadding) / 2;
		sliderBounds.size.width  -= (kIASKSliderImagesPadding - kIASKSliderNoImagesPadding);
        _minImage.center = CGPointMake(_minImage.frame.size.width / 2 + kIASKPaddingLeft,
                                       self.contentView.center.y);
    }
	if (_maxImage.image) {
		// Max image
		_maxImage.hidden = NO;
		sliderCenter.x    -= (kIASKSliderImagesPadding - kIASKSliderNoImagesPadding) / 2;
		sliderBounds.size.width  -= (kIASKSliderImagesPadding - kIASKSliderNoImagesPadding);
        _maxImage.center = CGPointMake(self.contentView.bounds.size.width - _maxImage.frame.size.width / 2 - kIASKPaddingRight,
                                       self.contentView.center.y);
	}
	
	_slider.bounds = sliderBounds;
    _slider.center = sliderCenter;
}	

- (void)dealloc {
	_minImage.image = nil;
	_maxImage.image = nil;
    [super dealloc];
}

- (void)prepareForReuse {
	_minImage.image = nil;
	_maxImage.image = nil;
}
@end
