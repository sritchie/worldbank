//
//  WorldBankViewController.m
//  WorldBank
//
//  Created by Samuel Ritchie on 10/31/10.
//  Copyright 2010 Threadlock Design. All rights reserved.
//

#import "WorldBankViewController.h"

#import "WorldLightOverlay.h"
#import "IUCNOverlay.h"
#import "TileOverlayView.h"
#import "FormaOverlay.h"

@implementation WorldBankViewController

@synthesize map;

- (void)viewDidLoad
{
    [super viewDidLoad];
		
	WorldLightOverlay *overlay = [[WorldLightOverlay alloc] init];
    [self.map addOverlay:overlay];
	
	IUCNOverlay *firstOverlay = [[IUCNOverlay alloc] init];
    [self.map addOverlay:firstOverlay];
    [firstOverlay release];
	
	FormaOverlay *secondOverlay = [[FormaOverlay alloc] init];
    [self.map addOverlay:secondOverlay];
    [secondOverlay release];

	// zoom in by a factor of two from the rect that contains the bounds
    // because MapKit always backs up to get to an integral zoom level so
    // we need to go in one so that we don't end up backed out beyond the
    // range of the TileOverlay.
    MKMapRect visibleRect = [map mapRectThatFits:overlay.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
	
	[self.map setVisibleMapRect:visibleRect];
    
    [overlay release];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay;
{
	TileOverlayView *overlayView = [[[TileOverlayView alloc] initWithOverlay:overlay] autorelease];
    return overlayView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

-(void) dealloc;
{
	[map release];
	[super dealloc];
}

@end
