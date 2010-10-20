//
//  AudioManger.m
//  ElectricAudio
//
//  Created by Robert McDowell on 08/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "AudioManger.h"
#import "SoundEngine.h"

static AudioManger * g_AudioManger = nil;

@implementation AudioManger

#pragma mark ---------------------------------------------------------
#pragma mark === Properties  ===
#pragma mark ---------------------------------------------------------

// -----------------------------------------------------
// Alter the sound master volume
// -----------------------------------------------------
- (float) soundMasterVolume
{
	return soundEngine->volume();
}
- (void) setSoundMasterVolume:(float)_volume
{
	soundEngine->setVolume(_volume);
}
// -----------------------------------------------------


#pragma mark ---------------------------------------------------------
#pragma mark === End Properties  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

// --------------------------------------
// initialise with the defaults
// --------------------------------------
- (id) init
{
	if ( self = [super init] )
	{
		soundEngine = new SoundEngine();
	}
	return self;
}

// --------------------------------------
// dealloc
// --------------------------------------
- (void) dealloc
{	
	delete( soundEngine );
	
	[super dealloc];
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === Instance Functions  ===
#pragma mark ---------------------------------------------------------

// --------------------------------------
// create the audio manager
// --------------------------------------
+ (void) create
{
	if ( g_AudioManger == nil )
	{
		g_AudioManger = [[super allocWithZone:NULL] init];
	}
}

// --------------------------------------
// destroy the audio manger
// --------------------------------------
+ (void) destroy
{
	if ( g_AudioManger != nil )
	{
		[g_AudioManger release];
		g_AudioManger = nil;
	}
}

// --------------------------------------
// Access the objects instance
// --------------------------------------
+ (AudioManger*) instance
{
	if ( g_AudioManger == nil )
	{
		g_AudioManger = [[super allocWithZone:NULL] init];
	}
	
	return g_AudioManger;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self instance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Instance Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === Public Functions  ===
#pragma mark ---------------------------------------------------------

// -------------------------------------------------------------------
// has sound object
// -------------------------------------------------------------------
- (Boolean) hasSoundWithKey:(NSString*)_key
{
	return soundEngine->hasSound( [_key hash] );
}

// -------------------------------------------------------------------
// create a sound and add it the sound bank
// -------------------------------------------------------------------
- (Boolean) createSoundWithKey:(NSString*)_key withResource:(NSString*)_fileName ofType:(NSString*)_ext isLooping:(Boolean)_loop
{
	// check the bundle for the file
	NSString * path = [[NSBundle mainBundle] pathForResource:_fileName ofType:_ext];
	
	if ( path )
	{
		return soundEngine->create([_key hash], path, _loop);
	}
	else 
	{
		return FALSE;
	}	
}

// -------------------------------------------------------------------
// create a sound and add it the sound bank
// -------------------------------------------------------------------
- (Boolean) createSoundWithKey:(NSString*)_key withFilePath:(NSString*)_filePath isLooping:(Boolean)_loop
{
	return soundEngine->create([_key hash], _filePath, _loop);
}

// -------------------------------------------------------------------
// release the sound with the specified key
// -------------------------------------------------------------------
- (Boolean) releaseSoundWithKey:(NSString*)_key
{
	return soundEngine->release([_key hash]);
}

// -------------------------------------------------------------------
// is Playing Sound with key
// -------------------------------------------------------------------
- (Boolean) isPlayingSoundWithKey:(NSString*)_key
{
	return soundEngine->isPlaying([_key hash]);
}

// -------------------------------------------------------------------
// is Paused Sound with key
// -------------------------------------------------------------------
- (Boolean) isPausedSoundWithKey:(NSString*)_key
{
	return soundEngine->isPaused([_key hash]);
}

// -------------------------------------------------------------------
// play the sound with key
// -------------------------------------------------------------------
- (void) playSoundWithKey:(NSString*)_key
{
	soundEngine->play([_key hash]);
}

// -------------------------------------------------------------------
// stop the sound with key
// -------------------------------------------------------------------
- (void) stopSoundWithKey:(NSString*)_key
{
	soundEngine->stop([_key hash]);
}

// -------------------------------------------------------------------
// pause the sound with key
// -------------------------------------------------------------------
- (void) pauseSoundWithKey:(NSString*)_key
{
	soundEngine->pause([_key hash]);
}

// -------------------------------------------------------------------
// rewind the sound with key
// -------------------------------------------------------------------
- (void) rewindSoundWithKey:(NSString*)_key
{
	soundEngine->rewind([_key hash]);
}

// -------------------------------------------------------------------
// get the volume of the sound
// -------------------------------------------------------------------
- (float) soundVolumeWithKey:(NSString*)_key
{
	return soundEngine->volume([_key hash]);
}

// -------------------------------------------------------------------
// set the sound Volume
// -------------------------------------------------------------------
- (void)  setSoundVolumeWithKey:(NSString*)_key volume:(float)_volume
{
	soundEngine->setVolume([_key hash], _volume);
}

// -------------------------------------------------------------------
// is the sound is looping or not
// -------------------------------------------------------------------
- (Boolean) soundLoopedWithKey:(NSString*)_key
{
	return soundEngine->looped([_key hash]);
}

// -------------------------------------------------------------------
// change the sounds loop state
// -------------------------------------------------------------------
- (void) setSoundLoopedWithKey:(NSString*)_key loop:(Boolean)_loop
{
	soundEngine->setLooped([_key hash], _loop);
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Public Functions  ===
#pragma mark ---------------------------------------------------------

@end
