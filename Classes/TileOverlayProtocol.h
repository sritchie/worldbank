//
//  TileOverlay.h
//  WorldBank
//
//  Created by Samuel Ritchie on 1/8/11.
//  Big thanks to Mike Tigas (https://github.com/mtigas/iOS-MapLayerDemo) for his work on tilemaps.
//

@protocol TileOverlay <MKOverlay>
@property (nonatomic) CGFloat defaultAlpha;
-(NSString *) urlForTileWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel;
@end
