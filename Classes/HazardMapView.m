/*
     File: HazardMapView.m 
 Abstract: MKOverlayView subclass that renders a USGS earthquake hazard map represented by the
 HazardMap class.  This class demonstrates how to convert points represented as MKMapRects into
 the local coordinate system and then fill those rectangles to visualize earthquake hazards across
 the continental United States. 
  Version: 1.1 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "HazardMapView.h"
#import "HazardMap.h"

#import <CoreGraphics/CoreGraphics.h>

#define NUM_COLORS 14

@implementation HazardMapView

// Create a table of possible colors to draw a grid cell with
- (void)initColors
{
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    colors = malloc(sizeof(CGColorRef) * NUM_COLORS);
    int i = 0;
    colors[i++] =	CGColorCreate(rgb, (CGFloat[]){ 68.0/255.0, 184.0/255.0, 149.0/255.0, 1 }); // 1.0
    colors[i++] =	CGColorCreate(rgb, (CGFloat[]){ 152.0/255.0, 210.0/255.0, 92.0/255.0, 1 }); // 0.8
    colors[i++] =	CGColorCreate(rgb, (CGFloat[]){ 235.0/255.0, 235.0/255.0, 35.0/255.0, 1 }); // 0.6
    colors[i++] =	CGColorCreate(rgb, (CGFloat[]){ 235.0/255.0, 144.0/255.0, 35.0/255.0, 1 }); // 0.4
    colors[i] =		CGColorCreate(rgb, (CGFloat[]){ 235.0/255.0, 52.0/255.0, 35.0/255.0, 1 }); // 0.2
    CGColorSpaceRelease(rgb);
}

// Look up a color in the table of colors for a peak ground acceleration
- (CGColorRef)colorForAcceleration:(CGFloat)value
{	
    if (value > 0.8) return colors[4];
    if (value > 0.6) return colors[3];
    if (value > 0.4) return colors[2];
    if (value > 0.2) return colors[1];
    if (value > 0.0) return colors[0];

    return NULL;
}

- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    if (self = [super initWithOverlay:overlay]) {
        [self initColors];
    }
    return self;
}

- (void)dealloc
{
    int i;
    for (i = 0; i < NUM_COLORS; i++) {
        CGColorRelease(colors[i]);
    }
    free(colors);
    [super dealloc];
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect
             zoomScale:(MKZoomScale)zoomScale {
	return YES;
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    HazardMap *hazards = (HazardMap *)self.overlay;
    
    float *values = NULL;
    MKMapRect *boundaries = NULL;
    int count = 0;
    
    // Fetch the grid values out of the model for this mapRect and zoomScale.
    [hazards hazardsInMapRect:mapRect
                      atScale:zoomScale
                       values:&values
                   boundaries:&boundaries
                        count:&count];
    
    CGContextSetAlpha(ctx, 0.5);
    
    // For each grid value that is colorable, color in its corresponding
    // boundary MKMapRect with the appropriate color.
    int i;
    for (i = 0; i < count; i++) {
        float value = values[i];
		
        MKMapRect boundary = boundaries[i];
        
        CGColorRef color = [self colorForAcceleration:value];
        if (color) {          
            CGContextSetFillColorWithColor(ctx, color);
            
            // Convert the MKMapRect (absolute points on the map proportional to screen points) to
            // a CGRect (points relative to the origin of this view) that can be drawn.
            CGRect boundaryCGRect = [self rectForMapRect:boundary];
            
            CGContextFillRect(ctx, boundaryCGRect);
        }
    }
    
    free(values);
    free(boundaries);
}

@end
