//
//  UIDevice-Extended.h
//  Payday
//
//  Created by Robert McDowell on 28/04/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IPHONE_1G_NAMESTRING		@"iPhone 1G"
#define IPHONE_3G_NAMESTRING		@"iPhone 3G"
#define IPHONE_3GS_NAMESTRING		@"iPhone 3GS"
#define IPHONE_UNKNOWN_NAMESTRING	@"Unknown iPhone"

#define IPOD_1G_NAMESTRING			@"iPod touch 1G"
#define IPOD_2G_NAMESTRING			@"iPod touch 2G"
#define IPOD_UNKNOWN_NAMESTRING		@"Unknown iPod"

#define IPAD_1G_NAMESTRING			@"iPad 1G"
#define IPAD_3G_NAMESTRING			@"iPad 3G"
#define IPAD_UNKNOWN_NAMESTRING		@"Unknown iPad"

typedef enum 
{
	UIDevicePlatform_Unknown = 0,
	UIDevicePlatform_1GiPhone,
	UIDevicePlatform_1GiPod,
	
	UIDevicePlatform_3GiPhone,
	UIDevicePlatform_2GiPod,
	UIDevicePlatform_3GSiPhone,
	
	UIDevicePlatform_1GiPad,
	UIDevicePlatform_3GiPad,
	
	UIDevicePlatform_UnknowniPhone,
	UIDevicePlatform_UnknowniPod,
	UIDevicePlatform_UnknowniPad
} UIDevicePlatform;

typedef enum
{
	UIDeviceType_iPod = 0,
	UIDeviceType_iPhone,
	UIDeviceType_iPad,
	UIDeviceType_Unknown,
} UIDeviceType;

@interface UIDevice (Hardware)

- (NSString *) machine;
- (NSString *) machineString;

- (UIDevicePlatform)	platform;
- (UIDeviceType)		deviceType;
- (int)					deviceGeneration;

@end
