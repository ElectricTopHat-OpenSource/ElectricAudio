//
//  TestUncompressedSound.m
//  ElectricAudio
//
//  Created by Robert McDowell on 09/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "TestUncompressedSound.h"
#import "AudioManger.h"

NSString * defaultSoundKey	= @"MySoundReferenceKey";
NSString * defaultSoundName = @"FanFare";
NSString * defaultSoundType = @"wav";

@implementation TestUncompressedSound

#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

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
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	// allways release the sound when the view disappers
	[[AudioManger instance] releaseSoundWithKey:defaultSoundKey];
}

#pragma mark ---------------------------------------------------------
#pragma mark === End View Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === Public Functions  ===
#pragma mark ---------------------------------------------------------

- (IBAction) createSoundObject:(id)_sender
{
	Boolean loop = [loopSound isOn];
	if ( [[AudioManger instance] createSoundWithKey:defaultSoundKey withResource:defaultSoundName ofType:defaultSoundType isLooping:loop] )
	{
		float volume = [soundVolume value];
		[[AudioManger instance] setSoundVolumeWithKey:defaultSoundKey volume:volume];
	}
}

- (IBAction) releaseSoundObject:(id)_sender
{
	[[AudioManger instance] releaseSoundWithKey:defaultSoundKey];
}

- (IBAction) playSoundObject:(id)_sender
{
	[[AudioManger instance] playSoundWithKey:defaultSoundKey];
}

- (IBAction) pauseSoundObject:(id)_sender
{
	[[AudioManger instance] pauseSoundWithKey:defaultSoundKey];
}

- (IBAction) stopSoundObject:(id)_sender
{
	[[AudioManger instance] stopSoundWithKey:defaultSoundKey];
}

- (IBAction) rewindSoundObject:(id)_sender
{
	[[AudioManger instance] rewindSoundWithKey:defaultSoundKey];
}

- (IBAction) volumeChanged:(id)_sender
{
	if ( [_sender isKindOfClass:[UISlider class]] )
	{
		UISlider * slider = _sender;
		float volume = [slider value];
		[[AudioManger instance] setSoundVolumeWithKey:defaultSoundKey volume:volume];
	}
}

- (IBAction) loopChanged:(id)_sender
{
	if ( [_sender isKindOfClass:[UISwitch class]] )
	{
		UISwitch * sw = _sender;
		Boolean loop = [sw isOn];
		[[AudioManger instance] setSoundLoopedWithKey:defaultSoundKey loop:loop];
	}
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Public Functions  ===
#pragma mark ---------------------------------------------------------

@end
