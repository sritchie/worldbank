//
//  TileOverlay.h
//  WorldBank
//
//  Created by Samuel Ritchie on 1/8/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TileOverlayProtocol.h"

@interface TileOverlay : NSObject <TileOverlay>;

-(NSString *) urlForTileWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;

-(void) applyProjectionTweaks;

@end
