//
//  WorldLightOverlay.h
//  WorldBank
//
//  Created by Samuel Ritchie on 1/8/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "WorldLightOverlay.h"

@implementation WorldLightOverlay

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
	NSUInteger flippedY = abs(y - (pow(2,zoomLevel) - 1));
	
	NSString *tileServer = @"http://b.tile.mapbox.com/1.0.0/world-light/";
	NSString *imagePath = [NSString stringWithFormat:@"%d/%d/%d.png", zoomLevel, x, flippedY];
	return [tileServer stringByAppendingString:imagePath];
}

@end
