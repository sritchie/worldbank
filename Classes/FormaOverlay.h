#import <MapKit/MapKit.h>
#import "TileOverlayProtocol.h"

/**
 * Tile layer that uses tiles from the OpenStreetMap project.
 */
@interface FormaOverlay : NSObject <TileOverlay> {
    CGFloat defaultAlpha;
}
@end
