//
//  UIDevice-Extended.m
//  Payday
//
//  Created by Robert McDowell on 28/04/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "UIDevice-Extended.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Hardware)

/*
 Platforms
 iPhone1,1  -> iPhone 1G
 iPhone1,2  -> iPhone 3G 
 iPhone2,1" -> iPhone 3GS 
 iPod1,1    -> iPod touch 1G 
 iPod2,1    -> iPod touch 2G 
 */

- (NSString *) machine
{
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	return platform;
}

- (NSString *) machineString
{
	switch ([self platform])
	{
		case UIDevicePlatform_1GiPhone:			return IPHONE_1G_NAMESTRING;
		case UIDevicePlatform_3GiPhone:			return IPHONE_3G_NAMESTRING;
		case UIDevicePlatform_3GSiPhone:		return IPHONE_3GS_NAMESTRING;	
		case UIDevicePlatform_UnknowniPhone:	return IPHONE_UNKNOWN_NAMESTRING;
			
		case UIDevicePlatform_1GiPod:			return IPOD_1G_NAMESTRING;
		case UIDevicePlatform_2GiPod:			return IPOD_2G_NAMESTRING;
		case UIDevicePlatform_UnknowniPod:		return IPOD_UNKNOWN_NAMESTRING;
			
		case UIDevicePlatform_1GiPad:			return IPAD_1G_NAMESTRING;
		case UIDevicePlatform_3GiPad:			return IPAD_3G_NAMESTRING;
		case UIDevicePlatform_UnknowniPad:		return IPAD_UNKNOWN_NAMESTRING;
			
		default: return nil;
	}
}

- (UIDevicePlatform) platform
{
	NSString *machineIdentifier = [self machine];
	if ([machineIdentifier isEqualToString:@"iPhone1,1"])	return UIDevicePlatform_1GiPhone;
	if ([machineIdentifier isEqualToString:@"iPhone1,2"])	return UIDevicePlatform_3GiPhone;
	if ([machineIdentifier isEqualToString:@"iPhone2,1"])	return UIDevicePlatform_3GSiPhone;
	
	if ([machineIdentifier isEqualToString:@"iPod1,1"])		return UIDevicePlatform_1GiPod;
	if ([machineIdentifier isEqualToString:@"iPod2,1"])		return UIDevicePlatform_2GiPod;
	
	if ([machineIdentifier isEqualToString:@"iPad1,1"])		return UIDevicePlatform_1GiPad;
	if ([machineIdentifier isEqualToString:@"iPad1,2"])		return UIDevicePlatform_3GiPad;
	
	if ([machineIdentifier hasPrefix:@"iPhone"])			return UIDevicePlatform_UnknowniPhone;
	if ([machineIdentifier hasPrefix:@"iPod"])				return UIDevicePlatform_UnknowniPod;
	if ([machineIdentifier hasPrefix:@"iPad"])				return UIDevicePlatform_UnknowniPad;
	return UIDevicePlatform_Unknown;
}

- (UIDeviceType) deviceType
{
	NSString *machineIdentifier = [self machine];
	if ([machineIdentifier hasPrefix:@"iPod"]) return UIDeviceType_iPod;
	if ([machineIdentifier hasPrefix:@"iPhone"]) return UIDeviceType_iPhone;	
	if ([machineIdentifier hasPrefix:@"iPad"]) return UIDeviceType_iPad;
	return UIDeviceType_Unknown;
}

- (int) deviceGeneration
{
	NSString * machineIdentifier = [self machine];
	NSArray * components = [machineIdentifier componentsSeparatedByString:@","];
	NSString * first = ( [components count] > 0 ) ?  [components objectAtIndex:0] : @"";
	NSInteger index = 0;
	if ([first hasPrefix:@"iPod"])
	{
		index = 4;
	}
	else if ([first hasPrefix:@"iPhone"])
	{
		index = 6;
	}
	else if ([first hasPrefix:@"iPad"])
	{
		index = 4;
	}
	
	if ( index > 0 )
	{
		return [[first substringFromIndex:index] intValue];
	}
	else 
	{
		return 0;
	}
}

@end
