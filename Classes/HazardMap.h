/*
     File: HazardMap.h
 Abstract: MKOverlay model object representing a USGS earthquake hazard map.
 See http://earthquake.usgs.gov/hazards/products/conterminous/2008/data/. 
 This class demonstrates how to project latitude and longitude coordinates representing the corners
 of a square into an MKMapRect.
  Version: 1.1
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <MapKit/MapKit.h>

@interface HazardMap : NSObject <MKOverlay> {
    CLLocationCoordinate2D origin; // position of upper left hazard
    CLLocationDegrees gridSize; // delta degrees for each square in the grid
    
    NSInteger gridWidth;  // number of squares in the grid in the x direction
    NSInteger gridHeight; // "" y direction
    
    CGFloat *grid; // actual hazard values in row-major order
}

// path points to a USGS earthquake hazard map grid file converted to binary
// format by the compactgrid utility.
- (id)initWithHazardMapFile:(NSString *)path;

- (MKMapRect)boundingMapRect;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Sample the hazard values within rect into values.  Boundaries will contain
// the bounding map rects for each respective value in values.  Caller is
// responsible for freeing both values and boundaries.
- (void)hazardsInMapRect:(MKMapRect)rect
                 atScale:(MKZoomScale)scale
                  values:(CGFloat **)values
              boundaries:(MKMapRect **)boundaries
                   count:(int *)count;

@end
