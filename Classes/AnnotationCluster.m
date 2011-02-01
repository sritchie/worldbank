//
//  AnnotationCluster.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/31/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#define CLUSTER_WIDTH 60

#import "AnnotationCluster.h"
#import "WorldBankAppDelegate.h"
#import "WorldBankViewController.h"

#import "FormaAnnotation.h"

@implementation AnnotationCluster

@synthesize coordinate;
@synthesize annotations;
@synthesize mapView;

-(id) init;
{
	if ((self = [super init])) {
		self.mapView = [[(WorldBankAppDelegate *)[[UIApplication sharedApplication] delegate] viewController] map];
		NSMutableSet *set = [[NSMutableSet alloc] initWithCapacity:50];
		self.annotations = set;
		[set release];
	}
	return self;
}

-(id) initWithAnnotation:(<MKAnnotation>)annotation;
{
	if ((self = [self init])) {
		[self addAnnotation:annotation];		
	}
	return self;
}

-(id) initWithAnnotations:(NSArray *)annotationArray;
{
	if ((self = [self init])) {
		[self addAnnotations:annotationArray];
	}
	return self;
}

-(void) addAnnotation:(<MKAnnotation>)annotation;
{
	[self.annotations addObject:annotation];
	[self updateCenter];
}

-(void) addAnnotations:(NSArray *)annotationArray;
{
	[self.annotations addObjectsFromArray:annotationArray];
	[self updateCenter];
}

-(NSInteger) annotationCount;
{
	return [self.annotations count];
}

-(BOOL) containsObject:(<MKAnnotation>)anObject;
{
	CGPoint objCoords = [self.mapView convertCoordinate:anObject.coordinate toPointToView:nil];
	CGPoint clusterCoords = [self.mapView convertCoordinate:self.coordinate toPointToView:nil];

	CGFloat objLat = objCoords.x;
	CGFloat objLon = objCoords.y;
	CGFloat clusterLat = clusterCoords.x;
	CGFloat clusterLon = clusterCoords.y;
	
	return ((objLat >= clusterLat - CLUSTER_WIDTH) && (objLat <= clusterLat + CLUSTER_WIDTH) &&
			objLon >= clusterLon - CLUSTER_WIDTH && objLon <= clusterLon + CLUSTER_WIDTH);
}

-(void) updateCenter;
{
	double latSum = 0.0;
	double lonSum = 0.0;
	for (<MKAnnotation> annotation in self.annotations) {
		CLLocationCoordinate2D center = annotation.coordinate;
		latSum += center.latitude;
		lonSum += center.longitude;
	}
	NSInteger count = [self annotationCount];
	
	CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake((latSum / count), (lonSum / count));
	coordinate = newCenter;
}

- (NSString *)subtitle;
{
	if ([self annotationCount] == 1) {
		FormaAnnotation *onlyAnn = [self.annotations anyObject];
		return [onlyAnn subtitle];
	}
	else {
		return [NSString stringWithFormat:@"count: %i", [self annotationCount]];
	}
}

- (NSString *)title;
{
	if ([self annotationCount] == 1) {
		FormaAnnotation *onlyAnn = [self.annotations anyObject];
		return [onlyAnn title];
	}
	else {
		return @"Cluster!";
	}
}

-(void) dealloc;
{
	[annotations release];
	[super dealloc];
}

@end
