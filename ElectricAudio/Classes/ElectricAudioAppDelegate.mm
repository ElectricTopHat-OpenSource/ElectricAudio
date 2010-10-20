//
//  ElectricAudioAppDelegate.m
//  ElectricAudio
//
//  Created by Robert McDowell on 07/06/2010.
//  Copyright Electric TopHat Ltd. 2010. All rights reserved.
//

#import "ElectricAudioAppDelegate.h"
#import "ElectricAudioViewController.h"
#import "AudioManger.h"

@implementation ElectricAudioAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[AudioManger create];
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
	
	[AudioManger destroy];
    [super dealloc];
}


@end
