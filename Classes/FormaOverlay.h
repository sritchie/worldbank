//
//  FormaOverlay.h
//  WorldBank
//
//  Created by Samuel Ritchie on 1/8/11.
//  Copyright 2011 Threadlock Design. All rights reserved.
//

#import "TileOverlay.h"

@interface FormaOverlay : TileOverlay {
	NSString *tileDir;
}

@property (nonatomic, retain) NSString *tileDir;

-(id) initWithTileDir:(NSString *)dir;

@end
