//
//  FormaOverlay.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/8/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "FormaOverlay.h"

@implementation FormaOverlay

@synthesize tileDir;
@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>

-(id) initWithTileDir:(NSString *)dir;
{
	if ((self = [super init])) {
		self.tileDir = dir;
	}
	return self;
}

-(void) applyProjectionTweaks;
{
	boundingMapRect = MKMapRectWorld;
    coordinate = CLLocationCoordinate2DMake(0, 0);
}

-(NSString *) urlForTileWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
{
	NSUInteger flippedY = abs(y - (pow(2, zoomLevel) - 1));

	NSString *tileServer = @"http://d2eyuetuyqg5j4.cloudfront.net/";
	NSString *imagePath = [NSString stringWithFormat:@"%@/%d/%d/%d.png", self.tileDir, zoomLevel, x, flippedY];
	return [tileServer stringByAppendingString:imagePath];
}

-(void) dealloc;
{
	[tileDir release];
	[super dealloc];
}

@end
