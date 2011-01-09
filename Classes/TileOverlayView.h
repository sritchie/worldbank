#import <MapKit/MapKit.h>

/**
 * The "view" for the tile layer.
 *
 * Essentially handles all of the heavy lifting: reprojection / data
 * loading / processing / rendering.
 */
@interface TileOverlayView : MKOverlayView {
}

-(void) performTileRequestWithURLString:(NSString *)urlString mapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale;


- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale;

@end
