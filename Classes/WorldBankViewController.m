//
//  WorldBankViewController.m
//  WorldBank
//
//  Created by Samuel Ritchie on 10/31/10.
//  Copyright 2010 Threadlock Design. All rights reserved.
//

#import "WorldBankViewController.h"

#import "HazardMap.h"
#import "HazardMapView.h"

@implementation WorldBankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[map setDelegate:self];
	
    // Find and load the earthquake hazard grid from the application's bundle
    NSString *hazardPath = [[NSBundle mainBundle] pathForResource:@"raster"
                                                           ofType:@"bin"];
    HazardMap *hazards = [[HazardMap alloc] initWithHazardMapFile:hazardPath];
    
    // Position and zoom the map to just fit the grid loaded on screen
    [map setVisibleMapRect:[hazards boundingMapRect]];
    
    // Add the earthquake hazard map to the map view
    [map addOverlay:hazards];
    
    // Let the map view own the hazards model object now
    [hazards release];
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
	int x = 5;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
	int x = 5;

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    HazardMapView *view = [[HazardMapView alloc] initWithOverlay:overlay];
    return [view autorelease];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
