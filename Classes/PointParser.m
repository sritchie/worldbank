//
//  PointParser.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/19/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#define MIN_ZOOM_LEVEL 4

#import "PointParser.h"
#import "CommonMacros.h"
#import "TBXML.h"

#import "FormaAnnotation.h"
#import "AnnotationCluster.h"

@implementation PointParser

@synthesize formaPoints, clusters;
@synthesize zoomLevel;

static NSInteger zoomScaleToZoomLevel(MKZoomScale scale)
{
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0);  // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

#pragma mark -
#pragma mark Constructors

-(id) initWithFormaPointXMLURL:(NSURL *)formaURL;
{
	if ((self = [super init])) {
		self.zoomLevel = -1;
		
		TBXML *tbxml = [[TBXML alloc] initWithURL:formaURL];
		self.formaPoints = [self loadFormaPointsFromTBXML:tbxml];
		[tbxml release];
	}

	return self;
}

-(id) initWithFormaPointXMLFileNamed:(NSString *)fileName;
{
	if ((self = [super init])) {
		TBXML *tbxml = [[TBXML alloc] initWithXMLFile:fileName];
		self.formaPoints = [self loadFormaPointsFromTBXML:tbxml];
		[tbxml release];
	}
	
	return self;
}

-(NSSet *) loadFormaPointsFromTBXML:(TBXML *)tbxml;
{	
	NSMutableSet *points = [[NSMutableArray alloc] initWithCapacity:200];

	TBXMLElement *root = tbxml.rootXMLElement;
	
	if (root) {
		TBXMLElement *point = [TBXML childElementNamed:@"point" parentElement:root];
		
		while (point != nil) {
			double lat = [[TBXML valueOfAttributeNamed:@"latitude" forElement:point] doubleValue];
			double lon = [[TBXML valueOfAttributeNamed:@"longitude" forElement:point] doubleValue];
			CGFloat prob = [[TBXML valueOfAttributeNamed:@"prob" forElement:point] floatValue];

			CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
			
			FormaAnnotation *formaPoint = [[FormaAnnotation alloc] initWithCoordinate:coord];
			[formaPoint setProbability:prob];
			
			TBXMLElement * desc = [TBXML childElementNamed:@"description" parentElement:point];
			[formaPoint setDescription:[TBXML textForElement:desc]];

			[points addObject:formaPoint];
			[formaPoint release];
			
			point = [TBXML nextSiblingNamed:@"point" searchFromElement:point];
		}
	}
		
	NSAssert(!IsEmpty(points), @"The FORMA points array was empty!");
	return points;	
}

#pragma mark -
#pragma mark Set Return Methods

-(NSMutableSet *) clustersForMapRegion:(MKCoordinateRegion)region zoomScale:(MKZoomScale)zoomScale;
{	
	NSInteger currentZoomLevel = zoomScaleToZoomLevel(zoomScale);
	if (currentZoomLevel != self.zoomLevel) {
		self.zoomLevel = currentZoomLevel;

		NSMutableSet *newClusters = [[NSMutableSet alloc] initWithCapacity:50];
		NSInteger total = [self.formaPoints count];
		
		for (FormaAnnotation *annotation in self.formaPoints) {
			BOOL withinCluster = NO;
			
			for (AnnotationCluster *cluster in newClusters) {
				if ([cluster containsObject:annotation]) {
					withinCluster = YES;
					[cluster addAnnotation:annotation];
					break;
				}
			}
			
			if (!withinCluster) {
				AnnotationCluster *newCluster = [[AnnotationCluster alloc] initWithAnnotation:annotation totalMarkers:total];
				[newClusters addObject:newCluster];
				[newCluster release];
			}
		}
		
		self.clusters = newClusters;
		[newClusters release];
	}
	
	return [self clustersShowingInRegion:region];
	return [NSMutableSet setWithSet:self.clusters];
}

-(NSMutableSet *) clustersShowingInRegion:(MKCoordinateRegion)region;
{
	CLLocationDegrees latStart = region.center.latitude - region.span.latitudeDelta/2.0;
	CLLocationDegrees latStop = region.center.latitude + region.span.latitudeDelta/2.0;
	CLLocationDegrees lonStart = region.center.longitude - region.span.longitudeDelta/2.0;
	CLLocationDegrees lonStop = region.center.longitude + region.span.longitudeDelta/2.0;
	
	NSMutableSet *toReturn = [NSMutableSet setWithCapacity:[self.clusters count]];
	
	for (AnnotationCluster *cluster in self.clusters) {
		CLLocationDegrees lat = cluster.coordinate.latitude;
		CLLocationDegrees lon = cluster.coordinate.longitude;
		
		if ((lat > latStart && lat < latStop) && (lon > lonStart && lon < lonStop)) {
			[toReturn addObject:cluster];			
		}
	}
	
	return toReturn;
}

-(NSMutableSet *) formaPointsForMapRegion:(MKCoordinateRegion)region zoomScale:(MKZoomScale)zoomScale;
{
	NSMutableSet *selectedPoints = [NSMutableSet setWithCapacity:50];
	
	if (zoomScaleToZoomLevel(zoomScale) > MIN_ZOOM_LEVEL) {
		CLLocationDegrees latStart = region.center.latitude - region.span.latitudeDelta/2.0;
		CLLocationDegrees latStop = region.center.latitude + region.span.latitudeDelta/2.0;
		CLLocationDegrees lonStart = region.center.longitude - region.span.longitudeDelta/2.0;
		CLLocationDegrees lonStop = region.center.longitude + region.span.longitudeDelta/2.0;
		
		
		for (FormaAnnotation *annotation in formaPoints) {
			CLLocationDegrees lat = annotation.coordinate.latitude;
			CLLocationDegrees lon = annotation.coordinate.longitude;
			
			if ((lat > latStart && lat < latStop) && (lon > lonStart && lon < lonStop)) {
				[selectedPoints addObject:annotation];			
			}
		}
	}
	
	return selectedPoints;
}

@end
