//     File: TileOverlayView.h
// Abstract: 
//     MKOverlayView subclass to display a raster tiled map overlay.
//   
//  Version: 1.0
// 
// Copyright (C) 2010 Apple Inc. All Rights Reserved.
// 


#import <MapKit/MapKit.h>


@interface TileOverlayView : MKOverlayView {
    CGFloat tileAlpha;
}

@property (nonatomic, assign) CGFloat tileAlpha;

@end
