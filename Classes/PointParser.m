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

@implementation PointParser

@synthesize formaPoints;

static NSInteger zoomScaleToZoomLevel(MKZoomScale scale) {
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0);  // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

-(id) initWithFormaPointXMLURL:(NSURL *)formaURL;
{
	if ((self = [super init])) {
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

@end
