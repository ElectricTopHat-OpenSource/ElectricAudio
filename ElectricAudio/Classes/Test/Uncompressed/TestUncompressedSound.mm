//
//  TestUncompressedSound.m
//  ElectricAudio
//
//  Created by Robert McDowell on 09/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "TestUncompressedSound.h"
#import "ElectricAudio.h"

NSString * defaultSoundName = @"FanFare";
NSString * defaultSoundType = @"wav";

@implementation TestUncompressedSound

#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )
	{
		
	}
	return self;
}

- (void) dealloc
{
	[soundVolume release];
	[loopSound release];
	
	[super dealloc];
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === View Functions  ===
#pragma mark ---------------------------------------------------------

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	engine = new EA::SoundEngine();
	sound  = nil;
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	delete( engine );
}

#pragma mark ---------------------------------------------------------
#pragma mark === End View Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === Public Functions  ===
#pragma mark ---------------------------------------------------------

- (IBAction) createSoundObject:(id)_sender
{
	if ( sound == nil )
	{
		sound = engine->load( defaultSoundName, defaultSoundType );
		if ( sound )
		{
			sound->setVolume( [soundVolume value] );
			sound->setLooped( [loopSound isOn] );
		}
	}
}

- (IBAction) releaseSoundObject:(id)_sender
{
	engine->release( sound );
	sound = nil;
}

- (IBAction) playSoundObject:(id)_sender
{
	if ( sound )
	{
		sound->play();
	}
}

- (IBAction) pauseSoundObject:(id)_sender
{
	if ( sound )
	{
		sound->pause();
	}
}

- (IBAction) stopSoundObject:(id)_sender
{
	if ( sound )
	{
		sound->stop();
	}
}

- (IBAction) rewindSoundObject:(id)_sender
{
	if ( sound )
	{
		sound->rewind();
	}
}

- (IBAction) volumeChanged:(id)_sender
{
	if ( [_sender isKindOfClass:[UISlider class]] )
	{
		UISlider * slider = _sender;
		float volume = [slider value];
		if ( sound )
		{
			sound->setVolume( volume );
		}
	}
}

- (IBAction) loopChanged:(id)_sender
{
	if ( [_sender isKindOfClass:[UISwitch class]] )
	{
		UISwitch * sw = _sender;
		if ( sound )
		{
			sound->setLooped( [sw isOn] );
		}
	}
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Public Functions  ===
#pragma mark ---------------------------------------------------------

@end
