//
//  PointParser.h
//  WorldBank
//
//  Created by Samuel Ritchie on 1/19/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import <MapKit/MapKit.h>

@class TBXML;

@interface PointParser : NSObject {
	NSInteger zoomLevel;
	NSSet *formaPoints;
	NSMutableSet *clusters;
}

@property NSInteger zoomLevel;
@property (nonatomic, retain) NSSet *formaPoints;
@property (nonatomic, retain) NSMutableSet *clusters;

-(id) initWithFormaPointXMLURL:(NSURL *)formaURL;
-(id) initWithFormaPointXMLFileNamed:(NSString *)fileName;

-(NSSet *) loadFormaPointsFromTBXML:(TBXML *)tbxml;

-(NSMutableSet *) clustersForMapRegion:(MKCoordinateRegion)region zoomScale:(MKZoomScale)zoomScale;
-(NSMutableSet *) clustersShowingInRegion:(MKCoordinateRegion)region;

-(NSMutableSet *) formaPointsForMapRegion:(MKCoordinateRegion)region zoomScale:(MKZoomScale)zoomScale;

@end
