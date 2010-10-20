//
//  SoundManager.m
//  ElectricAudio
//
//  Created by Robert McDowell on 20/10/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "SoundManager.h"
#import "SoundEngine.h"
#import "Sound.h"

@implementation SoundManager

#pragma mark ---------------------------------------------------------
#pragma mark === Properties  ===
#pragma mark ---------------------------------------------------------

@synthesize soundEngine;

#pragma mark ---------------------------------------------------------
#pragma mark === End Properties  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

// ------------------------------------------
// Initialization
// ------------------------------------------
- (id) init
{
	if ( self = [super init] )
	{
		// create the sound engine instance
		soundEngine = new EA::SoundEngine();
	}
	return self;
}

// ------------------------------------------
// dealloc
// ------------------------------------------
- (void)dealloc 
{
	// destroy the sound engine instance
	SAFE_DELETE( soundEngine );	
    [super dealloc];
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

@end
