//
//  AnnotationCluster.h
//  WorldBank
//
//  Created by Samuel Ritchie on 1/31/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface AnnotationCluster : NSObject <MKAnnotation> {
	NSMutableSet *annotations;
	MKMapView *mapView;
	NSInteger allMarkerCount;
}

@property (nonatomic, assign) MKMapView *mapView;
@property (nonatomic, retain) NSMutableSet *annotations;
@property NSInteger allMarkerCount;

-(id) initWithAnnotation:(<MKAnnotation>)annotation totalMarkers:(NSInteger)count;
-(id) initWithAnnotations:(NSArray *)annotationArray totalMarkers:(NSInteger)count;

-(void) addAnnotation:(<MKAnnotation>)annotation;
-(void) addAnnotations:(NSArray *)annotationArray;

-(NSInteger) annotationCount;
-(NSInteger) quintile;
-(BOOL) containsObject:(<MKAnnotation>)anObject;
-(void) updateCenter;

@end
