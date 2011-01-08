//
//  CustomUISlider.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/7/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "CustomUISlider.h"


@implementation CustomUISlider


-(CGFloat) thumbImagePosition;
{
	CGFloat sliderRange = self.frame.size.width - self.currentThumbImage.size.width;
	CGFloat sliderOrigin = self.frame.origin.x + (self.currentThumbImage.size.width / 2.0);
	
	CGFloat sliderValueToPixels = ((self.value / self.maximumValue) * sliderRange) + sliderOrigin;
	
	return sliderValueToPixels;
}



@end
