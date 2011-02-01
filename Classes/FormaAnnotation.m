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
	if ((self = [super init])) {
		coordinate = coord;
	}
	return self;
}

- (NSString *)subtitle;
{
	return [NSString stringWithFormat:@"Chance: %0.1f%%", (100 * self.probability)];
}

- (NSString *)title;
{
	return @"Alert!";
}

@end