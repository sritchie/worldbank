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
	NSSet *formaPoints;
}

@property (nonatomic, retain) NSSet *formaPoints;

-(id) initWithFormaPointXMLURL:(NSURL *)formaURL;
-(id) initWithFormaPointXMLFileNamed:(NSString *)fileName;

-(NSSet *) loadFormaPointsFromTBXML:(TBXML *)tbxml;

-(NSMutableSet *) formaPointsForMapRegion:(MKCoordinateRegion)region zoomScale:(MKZoomScale)zoomScale;

@end
