//
//  WorldBankViewController.h
//  WorldBank
//
//  Created by Samuel Ritchie on 10/31/10.
//  Copyright 2010 Threadlock Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface WorldBankViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *map;
}

@property (nonatomic, retain) MKMapView *map;

@end

