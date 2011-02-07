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
@synthesize slider;
@synthesize pointParser;
@synthesize formaLayers;
@synthesize currentLayer;
@synthesize hoverImage;

-(IBAction) toggleLayers:(id)sender;
{	
	NSInteger nextLayer = self.currentLayer + 1;

	if (nextLayer == [self.formaLayers count]) {
		nextLayer = 0;
	}
	
	[self.map removeOverlay:[self.formaLayers objectAtIndex:self.currentLayer]];
	[self.map addOverlay:[self.formaLayers objectAtIndex:nextLayer]];
	
	self.currentLayer = nextLayer;
}

-(IBAction) startedSliding:(id)sender;
{
	[self fadeIn:self.hoverImage withDuration:FADE_DURATION];
}

-(IBAction) finishedSliding:(id)sender;
{
	[self fadeOut:self.hoverImage withDuration:FADE_DURATION];
}

-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration;
{
	[UIView beginAnimations: @"Fade Out" context:nil];
	[UIView setAnimationDuration:duration];
	viewToDissolve.alpha = 0.0;
	[UIView commitAnimations];
}

-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration;
{
	[UIView beginAnimations: @"Fade In" context:nil];
	[UIView setAnimationDuration:duration];
	viewToFadeIn.alpha = 1;
	[UIView commitAnimations];
}

-(IBAction) showSliderPosition:(id)sender;
{
	CGPoint imageCenter = self.hoverImage.center;
	CGFloat sliderXPos = [self thumbImagePosition];
	
	self.hoverImage.center = CGPointMake(sliderXPos, imageCenter.y);
}

-(CGFloat) thumbImagePosition;
{
	CGFloat sliderRange = self.slider.frame.size.width - self.slider.currentThumbImage.size.width;
	CGFloat sliderOrigin = self.slider.frame.origin.x + (self.slider.currentThumbImage.size.width / 2.0);
	CGFloat sliderValueToPixels = ((self.slider.value / self.slider.maximumValue) * sliderRange) + sliderOrigin;	
	
	NSLog(@"Slider range: %f!. Origin: %f. pix: %f", sliderRange, sliderOrigin, sliderValueToPixels);
	
	return sliderValueToPixels;
}

-(void) loadSliderHover; 
{
	UIImageView *hover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:HOVER_IMAGE]];
	self.hoverImage = hover;
	[hover release];

	CGRect bounds = [[UIScreen mainScreen] bounds];
	
	CGFloat x = [self thumbImagePosition];
	CGFloat y = bounds.size.height - self.slider.center.y - 70.0;
	self.hoverImage.center = CGPointMake(x, y);
	self.hoverImage.alpha = 0;
	[self.view addSubview:self.hoverImage];
}

-(void) viewDidLoad;
{
    [super viewDidLoad];
	
	[self loadPointParser];
	
	WorldLightOverlay *overlay = [[WorldLightOverlay alloc] init];
    [self.map addOverlay:overlay];
	
	IUCNOverlay *firstOverlay = [[IUCNOverlay alloc] init];
    [self.map addOverlay:firstOverlay];
    [firstOverlay release];
	
	NSArray *extensions = [[NSArray alloc] initWithObjects:@"tiles/map130", @"june", nil];
	[self loadFormaOverlaysWithDirs:extensions];
	[extensions release];
	
	self.currentLayer = 0;
	FormaOverlay *layer = [self.formaLayers objectAtIndex:self.currentLayer];
	[self.map addOverlay:layer];
	
	// zoom in by a factor of two from the rect that contains the bounds
    // because MapKit always backs up to get to an integral zoom level so
    // we need to go in one so that we don't end up backed out beyond the
    // range of the TileOverlay.
    MKMapRect visibleRect = [map mapRectThatFits:layer.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
		
	[self.map setVisibleMapRect:visibleRect animated:YES];
	[self loadAnnotationsForMapRegion:self.map.region];

    [overlay release];
	
	[self loadSliderHover];

}

-(void) loadFormaOverlaysWithDirs:(NSArray *)extensions;
{
	NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity:12];	
	for (NSString *ext in extensions) {
		FormaOverlay *overlay = [[FormaOverlay alloc] initWithTileDir:ext];
		[accum addObject:overlay];
		[overlay release];
	}		
	self.formaLayers = [[NSArray alloc] initWithArray:accum];
	[accum release];
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
	[slider release];
	[hoverImage release];
	[pointParser release];
	[super dealloc];
}

@end
