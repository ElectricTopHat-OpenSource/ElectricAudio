//
//  SoundEngine.m
//  ElectricAudio
//
//  Created by Robert McDowell on 08/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "SoundEngine.h"
#import <AudioToolbox/AudioToolbox.h>

#import "Sound.h"
#import "AppleOpenALSupport.h"



#define SafeDelete( obj ) { delete(obj); obj=nil; }

#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

// --------------------------------------------------
// Constructor
// --------------------------------------------------
SoundEngine::SoundEngine()
: m_context ( NULL )
{		
	m_device = alcOpenDevice(NULL); // select the "preferred device"
	if ( m_device ) 
	{
		// use the device to make a context
		m_context = alcCreateContext(m_device,NULL);
		
		if ( m_context )
		{
			// set my context to the currently active one
			alcMakeContextCurrent(m_context);
		}
		else 
		{
			// close the device
			alcCloseDevice(m_device);
			m_device = nil;
			
			NSLog(@"SoundEngine : Failed to create Audio Context.");
		}
	}
	else 
	{
		NSLog(@"SoundEngine : Failed to create Audio Device.");
	}
}

// --------------------------------------------------
// Destructor
// --------------------------------------------------
SoundEngine::~SoundEngine()
{
	// delete all the sound objects
	SoundsMap::iterator obj;
    for (obj = m_map.begin(); obj != m_map.end(); ++obj) 
	{
		Sound * sound = obj->second;
		delete( sound );
    }
	// remove all the dead pointers
	m_map.clear();
	
	if ( m_context )
	{
		// destroy the context
		alcDestroyContext(m_context);
	}
	
	if ( m_device )
	{
		// close the device
		alcCloseDevice(m_device);
	}
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === Public Functions  ===
#pragma mark ---------------------------------------------------------

// --------------------------------------------------
// get the master volume
// --------------------------------------------------
float SoundEngine::volume() const
{
	float volume;
	alGetListenerf(AL_GAIN, &volume);
	return volume;
}

// --------------------------------------------------
// set the master volume
// --------------------------------------------------
void SoundEngine::setVolume(float _volume )
{
	float volume = MAX(MIN(_volume, 1.0f), 0.0f); //cap to 0-1
	alListenerf(AL_GAIN, volume);
}

// --------------------------------------------------
// has the sound been loaded
// --------------------------------------------------
Boolean SoundEngine::hasSound( NSUInteger _key )
{	
	SoundsMap::iterator lb = m_map.lower_bound(_key);
	
	return (lb != m_map.end() && !(m_map.key_comp()(_key, lb->first)));
}

// --------------------------------------------------
// get the sound
// --------------------------------------------------
Sound * SoundEngine::getSound( NSUInteger _key )
{
	SoundsMap::iterator lb = m_map.lower_bound(_key);
	
	if (lb != m_map.end() && !(m_map.key_comp()(_key, lb->first)))
	{
		return lb->second;
	}
	return nil;
}

// --------------------------------------------------
// create the sound object
// --------------------------------------------------
Boolean SoundEngine::create( NSUInteger _key, NSString * _filePath, Boolean _loops )
{	
	if ( !hasSound(_key) )
	{
		// create the new sound object and store it in the map
		Sound * sound = new Sound( _key, _filePath, _loops );
		if ( !sound->isError() )
		{
			m_map[_key] = sound;
			
			return TRUE;
		}
		else 
		{
			NSLog(@"Create Sound : Failed to load new sound due %@.", sound->error() );
			delete( sound );
			return FALSE;
		}
	}
	else 
	{
		NSLog(@"Create Sound : Failed to load new sound as key is in use." );
		return FALSE;
	}
}

// --------------------------------------------------
// release the Sound Object
// --------------------------------------------------
Boolean SoundEngine::release( NSUInteger _key )
{
	SoundsMap::iterator lb = m_map.lower_bound(_key);
	
	if (lb != m_map.end() && !(m_map.key_comp()(_key, lb->first)))
	{
		Sound * obj = lb->second;
		delete( obj );
		
		m_map.erase( lb );
		return TRUE;
	}
	else 
	{
		return FALSE;
	}
}

// --------------------------------------------------
// release the sound object
// --------------------------------------------------
Boolean SoundEngine::release( Sound ** _sound )
{
	Sound * sound = *_sound;
	NSUInteger hashkey = sound->key();
	SoundsMap::iterator lb = m_map.lower_bound(hashkey);
	
	if (lb != m_map.end() && !(m_map.key_comp()(hashkey, lb->first)))
	{
		Sound * obj = lb->second;
		delete( obj );
		
		m_map.erase( lb );
		
		*_sound = nil;
		return TRUE;
	}
	else 
	{
		return FALSE;
	}
}

// --------------------------------------------------
// is the sound playing
// --------------------------------------------------
Boolean SoundEngine::isPlaying( NSUInteger _key)
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		return sound->isPlaying();
	}
	return FALSE;
}

// --------------------------------------------------
// is the sound playing
// --------------------------------------------------
Boolean SoundEngine::isPaused( NSUInteger _key )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		return sound->isPaused();
	}
	return FALSE;
}

// --------------------------------------------------
// play the sound
// --------------------------------------------------
void SoundEngine::play( NSUInteger _key )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		sound->play();
	}
}

// --------------------------------------------------
// pause the sound
// --------------------------------------------------
void SoundEngine::pause( NSUInteger _key )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		sound->pause();
	}
}

// --------------------------------------------------
// stop the sound
// --------------------------------------------------
void SoundEngine::stop( NSUInteger _key )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		sound->stop();
	}
}

// --------------------------------------------------
// rewind the sound
// --------------------------------------------------
void SoundEngine::rewind( NSUInteger _key )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		sound->rewind();
	}
}

// --------------------------------------------------
// get the volume for an individual sound
// --------------------------------------------------
float SoundEngine::volume( NSUInteger _key )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		return sound->volume();
	}
	return 1.0f;
}

// --------------------------------------------------
// set the volume for an individual sound
// --------------------------------------------------
void SoundEngine::setVolume( NSUInteger _key, float _volume )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		return sound->setVolume( _volume );
	}
}

// --------------------------------------------------
// is the sound looped
// --------------------------------------------------
Boolean SoundEngine::looped( NSUInteger _key )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		return sound->looped();
	}
	return FALSE;
}

// --------------------------------------------------
// set the sounds loop state
// --------------------------------------------------
void SoundEngine::setLooped( NSUInteger _key, Boolean _looped )
{
	Sound * sound = getSound( _key );
	if ( sound )
	{
		return sound->setLooped(_looped);
	}
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Public Functions  ===
#pragma mark ---------------------------------------------------------
