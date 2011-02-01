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
#import "AnnotationCluster.h"

@implementation WorldBankViewController

@synthesize map;
@synthesize pointParser;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self loadPointParser];
		
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

-(void) loadPointParser;
{
	NSURL *pointsXML = [NSURL URLWithString:@"http://d2eyuetuyqg5j4.cloudfront.net/xml/formapoints.xml"];

	PointParser *parser = [[PointParser alloc] initWithFormaPointXMLURL:pointsXML];
	self.pointParser = parser;
	[parser release];
}

-(void) loadAnnotationsForMapRegion:(MKCoordinateRegion)region;
{	
	MKZoomScale currentZoomScale = self.map.bounds.size.width / self.map.visibleMapRect.size.width;
	NSMutableSet *visiblePoints = [self.pointParser clustersForMapRegion:self.map.region zoomScale:currentZoomScale];
	[self.map addAnnotations:[visiblePoints allObjects]];
}

- (void)mapView:(MKMapView *)map regionDidChangeAnimated:(BOOL)animated;
{	
	MKZoomScale currentZoomScale = self.map.bounds.size.width / self.map.visibleMapRect.size.width;	
	NSMutableSet *sourceClusters = [self.pointParser clustersForMapRegion:self.map.region zoomScale:currentZoomScale];

	//then we want to ADD clusters that aren't in the displayed set!
	NSMutableSet *pointsToShow = [NSMutableSet setWithSet:sourceClusters];
	NSMutableSet *pointsShowing = [NSMutableSet setWithArray:self.map.annotations];
	
	if (!IsEmpty(pointsToShow) || !IsEmpty(pointsShowing)) {
		[pointsToShow minusSet:pointsShowing];
		[self.map addAnnotations:[pointsToShow allObjects]];
		
		//filter the clusters that SHOULD be showing out of this 
		NSMutableSet *pointsToShow = [NSMutableSet setWithSet:sourceClusters];
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

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(AnnotationCluster *) cluster;
{
	MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:cluster reuseIdentifier:@"currentloc"];

	if ([cluster annotationCount] == 1) {
		annView.pinColor = MKPinAnnotationColorGreen;
	}
	else {
		annView.pinColor = MKPinAnnotationColorPurple;
	}
	
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
