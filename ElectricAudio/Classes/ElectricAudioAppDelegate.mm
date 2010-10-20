//
//  ElectricAudioAppDelegate.m
//  ElectricAudio
//
//  Created by Robert McDowell on 07/06/2010.
//  Copyright Electric TopHat Ltd. 2010. All rights reserved.
//

#import "ElectricAudioAppDelegate.h"
#import "ElectricAudioViewController.h"

@implementation ElectricAudioAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
