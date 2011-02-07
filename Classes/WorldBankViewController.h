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
#define HOVER_IMAGE @"smiley.png"
#define FADE_DURATION 0.2

@class PointParser;

@interface WorldBankViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *map;
	IBOutlet UISlider *slider; 
	UIImageView *hoverImage;

	PointParser *pointParser;
	NSArray *formaLayers;
	NSInteger currentLayer;
	
}

@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UIImageView *hoverImage;
@property (nonatomic, retain) PointParser *pointParser;
@property (nonatomic, retain) NSArray *formaLayers;
@property NSInteger currentLayer;

-(IBAction) startedSliding:(id)sender;
-(IBAction) finishedSliding:(id)sender;
-(IBAction) showSliderPosition:(id)sender;
-(CGFloat) thumbImagePosition;

-(IBAction) toggleLayers:(id)sender;
-(void) loadFormaOverlaysWithDirs:(NSArray *)extensions;
-(void) loadPointParser;
-(void) loadAnnotationsForMapRegion:(MKCoordinateRegion)region;

@end

