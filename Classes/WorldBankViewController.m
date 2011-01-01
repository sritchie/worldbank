//
//  WorldBankViewController.m
//  WorldBank
//
//  Created by Samuel Ritchie on 10/31/10.
//  Copyright 2010 Threadlock Design. All rights reserved.
//

#import "WorldBankViewController.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"

@implementation WorldBankViewController

@synthesize map;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	TileOverlay *overlay;
	
	NSArray *tileNames = [[NSArray alloc] initWithObjects:@"TilesOne", @"TilesTwo", nil];
	for (NSString *name in tileNames) {
		NSString *tileDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
		overlay = [[TileOverlay alloc] initWithTileDirectory:tileDirectory];
		[self.map addOverlay:overlay];
	}

	// zoom in by a factor of two from the rect that contains the bounds
    // because MapKit always backs up to get to an integral zoom level so
    // we need to go in one so that we don't end up backed out beyond the
    // range of the TileOverlay.
    MKMapRect visibleRect = [map mapRectThatFits:overlay.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
    map.visibleMapRect = visibleRect;
    
    [overlay release]; // map is now keeping track of overlay
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:overlay];
    view.tileAlpha = 0.7;
	NSLog(@"View Called!");
    return [view autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void) dealloc;
{
	[map release];
	[super dealloc];
}

@end
