#import "TileOverlayView.h"
#import "TileOverlay.h"
#import "Three20Network/Three20Network.h"

#import "CommonMacros.h"

#pragma mark Private methods
@interface TileOverlayView()
- (NSUInteger)worldTileWidthForZoomLevel:(NSUInteger)zoomLevel;
- (CGPoint)mercatorTileOriginForMapRect:(MKMapRect)mapRect;
@end

#pragma mark -
#pragma mark Implementation

@implementation TileOverlayView

#pragma mark Private utility methods

// Convert an MKZoomScale to a zoom level where level 0 contains 4 256px square tiles,
// which is the convention used by gdal2tiles.py.
static NSInteger zoomScaleToZoomLevel(MKZoomScale scale) {
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0);  // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

/**
 * Shortcut to determine the number of tiles wide *or tall* the
 * world is, at the given zoomLevel. (In the Spherical Mercator
 * projection, the poles are cut off so that the resulting 2D
 * map is "square".)
 */
- (NSUInteger)worldTileWidthForZoomLevel:(NSUInteger)zoomLevel;
{
    return (NSUInteger)pow(2, zoomLevel);
}

/**
 * Given a MKMapRect, this reprojects the center of the mapRect
 * into the Mercator projection and calculates the rect's top-left point
 * (so that we can later figure out the tile coordinate).
 *
 * See http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Derivation_of_tile_names
 */
- (CGPoint)mercatorTileOriginForMapRect:(MKMapRect)mapRect;
{
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    // Convert lat/lon to radians
    CGFloat x = (region.center.longitude) * (M_PI/180.0); // Convert lon to radians
    CGFloat y = (region.center.latitude) * (M_PI/180.0); // Convert lat to radians
    y = log(tan(y) + 1.0 / cos(y));
    
    // X and Y should actually be the top-left of the rect (the values above represent
    // the center of the rect)
    x = (1.0 + (x / M_PI)) / 2.0;
    y = (1.0 - (y / M_PI)) / 2.0;

    return CGPointMake(x, y);
}
#pragma mark MKOverlayView methods

- (NSArray *)tileURLsForMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale
{        	
    NSInteger minX = floor((MKMapRectGetMinX(rect) * scale) / TILE_SIZE);
    NSInteger maxX = floor((MKMapRectGetMaxX(rect) * scale) / TILE_SIZE);
    NSInteger minY = floor((MKMapRectGetMinY(rect) * scale) / TILE_SIZE);
    NSInteger maxY = floor((MKMapRectGetMaxY(rect) * scale) / TILE_SIZE);
    
	NSUInteger zoomLevel = zoomScaleToZoomLevel(scale);

	NSMutableArray *tiles = [NSMutableArray array];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {	
			NSString *url = [(TileOverlay *)self.overlay urlForTileWithX:x andY:y andZoomLevel:zoomLevel];
			[tiles addObject:url];
		}
	}
    
    return tiles;
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale;
{	
	if ((zoomScaleToZoomLevel(zoomScale) > kMaxFormaZoomLevel) || IsEmpty(self.superview)) 
		return NO;

	TTURLCache *cache = [TTURLCache sharedCache];
	BOOL canDraw = NO;

	NSArray *tilesInRect = [self tileURLsForMapRect:mapRect zoomScale:zoomScale];
	for (NSString *url in tilesInRect) {
		if ([cache hasDataForURL:url]) {
			canDraw = YES;
		}
		else {
			[self performTileRequestWithURLString:url mapRect:mapRect zoomScale:zoomScale];
		}
	}
	
	return canDraw;
}

-(void) performTileRequestWithURLString:(NSString *)urlString mapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
	// Perform a background HTTP request for this map tile.
	// (The delegate's didFinishLoad method will call setNeedsDisplayInMapRect,
	// which notifies MapKit that it should check this (and try to render
	// the tile) once again
	TTURLRequest *request = [TTURLRequest requestWithURL:urlString delegate:self];
	
	// Store some metadata in the request so that the delegate
	// can later figure out what mapRect and what zoomScale were originally
	// requested for this tile. (Required so we know what to tell MapKit when
	// it needs to render the tile after we've downloaded it.)
	NSDictionary *metaData = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithDouble:mapRect.origin.x], @"mr_origin_x",
							  [NSNumber numberWithDouble:mapRect.origin.y], @"mr_origin_y",
							  [NSNumber numberWithDouble:mapRect.size.width], @"mr_size_w",
							  [NSNumber numberWithDouble:mapRect.size.height], @"mr_size_h",
							  [NSNumber numberWithFloat:zoomScale], @"zoomScale",
							  nil];
	request.userInfo = metaData;
	
	TTURLDataResponse* response = [[TTURLDataResponse alloc] init];
	request.response = response;
	TT_RELEASE_SAFELY(response);
	
	request.cachePolicy = TTURLRequestCachePolicyLocal;
	
	[request performSelectorOnMainThread:@selector(send) withObject:nil waitUntilDone:NO];
}

/**
 * If the above method returns YES, this method performs the actual screen render
 * of a particular tile.
 *
 * You should never perform long processing (HTTP requests, etc.) from this method
 * or else your application UI will become blocked. You should make sure that
 * canDrawMapRect ONLY EVER returns YES if you are positive the tile is ready
 * to be rendered.
 */
- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context;
{
	TileOverlay *tileOverlay = (TileOverlay *)self.overlay;
	NSUInteger zoomLevel = zoomScaleToZoomLevel(zoomScale);
    CGPoint mercatorPoint = [self mercatorTileOriginForMapRect:mapRect];
    
    NSUInteger tilex = floor(mercatorPoint.x * [self worldTileWidthForZoomLevel:zoomLevel]);
    NSUInteger tiley = floor(mercatorPoint.y * [self worldTileWidthForZoomLevel:zoomLevel]);

    NSString *url = [tileOverlay urlForTileWithX:tilex andY:tiley andZoomLevel:zoomLevel];
    
    // Load the image from cache.
    TTURLCache *cache = [TTURLCache sharedCache];
    NSData *imageData = [cache dataForURL:url];
    if (imageData != nil) {
        UIImage *image = [[UIImage imageWithData:imageData] retain];
		
		//from Apple's Tilemap demo code, slightly modified.
		CGRect rect = [self rectForMapRect:mapRect];
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, 1 / zoomScale, 1 / zoomScale);
        CGContextTranslateCTM(context, 0, image.size.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
        CGContextRestoreGState(context);
        
        [image release];
    }
}

#pragma mark TTURLRequestDelegate methods
/**
 * Gets called if a HTTP request to a tile was successful.
 *
 * Simply calls setNeedsDisplay for the tile, so that MapKit attempts to draw
 * the tile again.
 */
-(void)requestDidFinishLoad:(TTURLRequest *)request {
    // Pull out the metadata that we stored.
    NSNumber *mr_origin_x = [(NSDictionary *)[request userInfo] objectForKey:@"mr_origin_x"];
    NSNumber *mr_origin_y = [(NSDictionary *)[request userInfo] objectForKey:@"mr_origin_y"];
    NSNumber *mr_size_w = [(NSDictionary *)[request userInfo] objectForKey:@"mr_size_w"];
    NSNumber *mr_size_h = [(NSDictionary *)[request userInfo] objectForKey:@"mr_size_h"];

    MKMapRect mapRect = MKMapRectMake(
                                    [mr_origin_x doubleValue],
                                    [mr_origin_y doubleValue],
                                    [mr_size_w doubleValue],
                                    [mr_size_h doubleValue]);
    
    NSNumber *zoomScaleNumber = [(NSDictionary *)[request userInfo] objectForKey:@"zoomScale"];
    MKZoomScale zoomScale = [zoomScaleNumber floatValue];
    
    // "Invalidate" the image at the mapRect -- causes MapKit to attempt another
    // load for this tile.
    [self setNeedsDisplayInMapRect:mapRect zoomScale:zoomScale];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc;
{
    [[TTURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
    
    [super dealloc];
}

@end
