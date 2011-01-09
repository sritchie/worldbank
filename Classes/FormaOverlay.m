//
//  FormaOverlay.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/8/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "FormaOverlay.h"

@implementation FormaOverlay

@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>

-(void) applyProjectionTweaks;
{
	boundingMapRect = MKMapRectWorld;
    coordinate = CLLocationCoordinate2DMake(0, 0);
}

-(NSString *) urlForTileWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
{
	NSUInteger flippedY = abs(y - (pow(2, zoomLevel) - 1));

	NSString *tileServer = @"http://d2eyuetuyqg5j4.cloudfront.net/june/";
	NSString *imagePath = [NSString stringWithFormat:@"%d/%d/%d.png", zoomLevel, x, flippedY];
	return [tileServer stringByAppendingString:imagePath];
}

@end
