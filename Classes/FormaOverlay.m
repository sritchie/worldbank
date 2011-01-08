#import "FormaOverlay.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation FormaOverlay
@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>
@synthesize defaultAlpha;

-(id) init {
    self = [super init];
    
    defaultAlpha = 1;
    
    // I am still not well-versed in map projections, but the Google Mercator projection
    // is slightly off from the "standard" Mercator projection, used by MapKit. (GMerc is used
    // by the demo tileserver to serve to the Google Maps API script in a user's
    // browser.)
    //
    // My understanding is that this is due to Google Maps' use of a Spherical Mercator
    // projection, where the poles are cut off -- the effective map ending at approx. +/- 85º.
    // MapKit does not(?), therefore, our origin point (top-left) must be moved accordingly.
    
    boundingMapRect = MKMapRectWorld;
//    boundingMapRect.origin.x += 1048600.0;
//    boundingMapRect.origin.y += 1048600.0;
    
    coordinate = CLLocationCoordinate2DMake(0, 0);
    
    return self;
}

- (NSString *)urlForPointWithX:(NSUInteger)x andY:(NSUInteger)y andZoomLevel:(NSUInteger)zoomLevel {
	NSUInteger newY = abs(y - (pow(2,zoomLevel) - 1));

	NSString *logString = [NSString stringWithFormat:@"http://d2eyuetuyqg5j4.cloudfront.net/june/%d/%d/%d.png", zoomLevel, x, newY];
	NSLog(@"%@", logString);
	return logString;
}
@end
