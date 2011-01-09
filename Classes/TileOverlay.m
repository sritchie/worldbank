//
//  TileOverlay.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/8/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "TileOverlay.h"

@implementation TileOverlay

@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>
@synthesize defaultAlpha;

-(id) initWithAlpha:(CGFloat)alpha;
{
	if ((self = [super init])) {
		self.defaultAlpha = alpha;
		[self applyProjectionTweaks];
	}
    return self;
}

-(id) init;
{
	return [self initWithAlpha:1.0];
}

-(void) applyProjectionTweaks;
{
	NSAssert(FALSE, @"Please subclass applyProjectionTweaks.");
}

-(NSString *) urlForTileWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
{
	NSAssert(FALSE, @"Please subclass urlForTileWithX.");
	return nil;
}

@end
