//
//  FormaAnnotation.h
//  WorldBank
//
//  Created by Samuel Ritchie on 1/19/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FormaAnnotation : NSObject <MKAnnotation> {
	NSString *description;
	CGFloat probability;
}

@property (nonatomic, retain) NSString *description;
@property CGFloat probability;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
