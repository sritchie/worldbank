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
}

@property (nonatomic, assign) MKMapView *mapView;
@property (nonatomic, retain) NSMutableSet *annotations;

-(id) initWithAnnotation:(<MKAnnotation>)annotation;
-(id) initWithAnnotations:(NSArray *)annotationArray;

-(void) addAnnotation:(<MKAnnotation>)annotation;
-(void) addAnnotations:(NSArray *)annotationArray;

-(NSInteger) annotationCount;
-(BOOL) containsObject:(<MKAnnotation>)anObject;
-(void) updateCenter;

@end
