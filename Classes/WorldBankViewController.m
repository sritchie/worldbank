//
//  WorldBankViewController.m
//  WorldBank
//
//  Created by Samuel Ritchie on 10/31/10.
//  Copyright 2010 Threadlock Design. All rights reserved.
//

#import "WorldBankViewController.h"

#import "CommonMacros.h"
#import "WorldLightOverlay.h"
#import "IUCNOverlay.h"
#import "TileOverlayView.h"
#import "FormaOverlay.h"

#import "PointParser.h"

@implementation WorldBankViewController

@synthesize map;
@synthesize pointParser;


- (void)viewDidLoad
{
    [super viewDidLoad];
	PointParser *parser = [[PointParser alloc] initWithFormaPointXMLFileNamed:FORMA_XML_FILENAME];
	self.pointParser = parser;
	[parser release];
		
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
		
	[self.map setVisibleMapRect:visibleRect animated:YES];
	[self loadAnnotationsForMapRegion:self.map.region];

    [overlay release];
}

-(void) loadAnnotationsForMapRegion:(MKCoordinateRegion)region;
{	
	MKZoomScale currentZoomScale = self.map.bounds.size.width / self.map.visibleMapRect.size.width;
	NSMutableSet *visiblePoints = [self.pointParser formaPointsForMapRegion:self.map.region zoomScale:currentZoomScale];
	[self.map addAnnotations:[visiblePoints allObjects]];
}

- (void)mapView:(MKMapView *)map regionDidChangeAnimated:(BOOL)animated;
{	
	MKZoomScale currentZoomScale = self.map.bounds.size.width / self.map.visibleMapRect.size.width;

	//then we want to ADD annotations that aren't in the displayed set!
	NSMutableSet *pointsShowing = [NSMutableSet setWithArray:self.map.annotations];
	NSMutableSet *pointsToShow = [self.pointParser formaPointsForMapRegion:self.map.region zoomScale:currentZoomScale];
	
	if (!IsEmpty(pointsToShow) || !IsEmpty(pointsShowing)) {
		[pointsToShow minusSet:pointsShowing];
		[self.map addAnnotations:[pointsToShow allObjects]];
		
		//filter the points that SHOULD be showing out of this 
		pointsToShow = [self.pointParser formaPointsForMapRegion:self.map.region zoomScale:currentZoomScale];
		pointsShowing = [NSMutableSet setWithArray:self.map.annotations];
		[pointsShowing minusSet:pointsToShow];
		[self.map removeAnnotations:[pointsShowing allObjects]];
	}
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay;
{
	TileOverlayView *overlayView = [[[TileOverlayView alloc] initWithOverlay:overlay] autorelease];
    return overlayView;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation;
{
    MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorGreen;
    annView.animatesDrop = FALSE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
	
//	MKAnnotationView *annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
//    annView.canShowCallout = YES;
//	annView.image = [UIImage imageNamed:@"bullseye.png"];
//	return annView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

-(void) dealloc;
{
	[map release];
	[pointParser release];
	[super dealloc];
}

@end
