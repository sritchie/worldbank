//
//  IUCNTileOverlay.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/8/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "IUCNOverlay.h"

@implementation IUCNOverlay

@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>

-(void) applyProjectionTweaks;
{
	boundingMapRect = MKMapRectWorld;
	boundingMapRect.origin.x += 1048600.0;
    boundingMapRect.origin.y += 1048600.0;
    coordinate = CLLocationCoordinate2DMake(0, 0);
}

- (NSString *)urlForTileWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
{
	NSString *tileServer = @"http://184.73.201.235/blue/";
	NSString *imagePath = [NSString stringWithFormat:@"%d/%d/%d", zoomLevel, x, y];
	return [tileServer stringByAppendingString:imagePath];
}
@end
