//
//  FormaAnnotation.m
//  WorldBank
//
//  Created by Samuel Ritchie on 1/19/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "FormaAnnotation.h"

@implementation FormaAnnotation

@synthesize coordinate;
@synthesize description;
@synthesize probability;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord;
{
	coordinate = coord;
	NSLog(@"%f,%f", coord.latitude, coord.longitude);
	return self;
}

- (NSString *)subtitle;
{
	return [NSString stringWithFormat:@"Chance: %0.1f%%", (100 * self.probability)];
	
	return @"Sub Title";
}

- (NSString *)title;
{
	return @"Alert!";
}

@end