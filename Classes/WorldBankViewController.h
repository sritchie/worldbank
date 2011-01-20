//
//  WorldBankViewController.h
//  WorldBank
//
//  Created by Samuel Ritchie on 10/31/10.
//  Copyright 2010 Threadlock Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define FORMA_XML_FILENAME @"formapoints.xml"

@class PointParser;

@interface WorldBankViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *map;
	PointParser *pointParser;
}

@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) PointParser *pointParser;

-(void) loadAnnotationsForMapRegion:(MKCoordinateRegion)region;

@end

