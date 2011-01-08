#import <MapKit/MapKit.h>
#import "TileOverlayProtocol.h"

/**
 * Tile layer that uses tiles from the OpenStreetMap project.
 */
@interface IUCNOverlay : NSObject <TileOverlay> {
    CGFloat defaultAlpha;
}
@end
