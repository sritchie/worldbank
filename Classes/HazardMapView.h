/*
     File: HazardMapView.h
 Abstract: MKOverlayView subclass that renders a USGS earthquake hazard map represented by the
 HazardMap class.  This class demonstrates how to convert points represented as MKMapRects into
 the local coordinate system and then fill those rectangles to visualize earthquake hazards across
 the continental United States.
  Version: 1.1
 
 */

#import <MapKit/MapKit.h>

@interface HazardMapView : MKOverlayView {
    CGColorRef *colors;
}

@end
