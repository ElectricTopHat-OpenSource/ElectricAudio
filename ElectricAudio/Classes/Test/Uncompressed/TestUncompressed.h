/*
 *  TestUncompressed.h
 *  ElectricAudio
 *
 *  Created by Robert McDowell on 20/10/2010.
 *  Copyright 2010 Electric TopHat Ltd. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "TestUncompressedSound.h"

namespace TestUncompressed 
{
	void AddSection( NSMutableArray * dataset )
	{	
		NSMutableDictionary * data			= [NSMutableDictionary dictionaryWithCapacity:2];
		NSString *			sectiontitle	= @"Uncompressed Sound Tests";
		NSMutableArray *	array			= [NSMutableArray arrayWithCapacity:16];
		
		{
			NSMutableDictionary * testInfo = [NSMutableDictionary dictionary];
			
			[testInfo setObject:@"Basic Test" forKey:@"name"];
			[testInfo setObject:[TestUncompressedSound class] forKey:@"class"];
			[testInfo setObject:@"TestSound" forKey:@"nib"];
			[testInfo setObject:@"TestSound" forKey:@"iPadNib"];
			
			[array addObject:testInfo];
		}
		
		[data setObject:sectiontitle	forKey:@"sectiontitle"];
		[data setObject:array			forKey:@"array"];
		[dataset addObject:data];
	}
};