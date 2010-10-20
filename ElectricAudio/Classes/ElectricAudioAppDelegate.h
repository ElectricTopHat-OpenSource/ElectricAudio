//
//  ElectricAudioAppDelegate.h
//  ElectricAudio
//
//  Created by Robert McDowell on 07/06/2010.
//  Copyright Electric TopHat Ltd. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricAudioAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    UINavigationController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *viewController;

@end

