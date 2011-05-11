//
//  AnnotationClusterView.h
//  WorldBank
//
//  Created by Samuel Ritchie on 1/31/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface AnnotationClusterView : MKAnnotationView {
	UILabel *clusterCount;
}

@property (nonatomic, retain) UILabel *clusterCount;

@end
