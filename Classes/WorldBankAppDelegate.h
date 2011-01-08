//
//  WorldBankAppDelegate.h
//  WorldBank
//
//  Created by Samuel Ritchie on 10/31/10.
//  Copyright 2010 Threadlock Design. All rights reserved.
//

@class WorldBankViewController;

@interface WorldBankAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WorldBankViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WorldBankViewController *viewController;

-(void) prepareTileCache;

@end

