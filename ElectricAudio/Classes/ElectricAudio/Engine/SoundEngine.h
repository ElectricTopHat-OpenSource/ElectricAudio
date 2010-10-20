//
//  SoundEngine.h
//  ElectricAudio
//
//  Created by Robert McDowell on 08/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#if !defined(__SoundEngine_h__)
#define __SoundEngine_h__

#import <Foundation/Foundation.h>
#import <map>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

class Sound;
typedef std::map<NSUInteger,Sound*> SoundsMap;

class SoundEngine
{
#pragma mark ---------------------------------------------------------
#pragma mark Constructor / Destructor
#pragma mark ---------------------------------------------------------
public: // Functions
	
	// --------------------------------------------------
	// Constructor
	// --------------------------------------------------
	SoundEngine();
	
	// --------------------------------------------------
	// Destructor
	// --------------------------------------------------
	~SoundEngine();
	
#pragma mark ---------------------------------------------------------
#pragma mark End Constructor / Destructor
#pragma mark ---------------------------------------------------------
	
#pragma mark ---------------------------------------------------------
#pragma mark Public Functions
#pragma mark ---------------------------------------------------------
public:	// Functions
	
	float volume() const;
	void setVolume( float _volume );
	
	Boolean	hasSound( NSUInteger _key );
	Sound * getSound( NSUInteger _key );
	
	Boolean create( NSUInteger _key, NSString * _filePath, Boolean _loops=FALSE );
	
	Boolean release( NSUInteger _key );
	Boolean release( Sound ** _sound );
	
	Boolean isPlaying( NSUInteger _key);
	Boolean isPaused( NSUInteger _key );
	
	void	play( NSUInteger _key ); 
	void	pause( NSUInteger _key ); 
	void	stop( NSUInteger _key ); 
	void	rewind( NSUInteger _key );
	
	float	volume( NSUInteger _key );
	void	setVolume( NSUInteger _key, float _volume );
	
	Boolean looped( NSUInteger _key );
	void	setLooped( NSUInteger _key, Boolean _looped );
	
#pragma mark ---------------------------------------------------------
#pragma mark End Public Functions
#pragma mark ---------------------------------------------------------
	
#pragma mark ---------------------------------------------------------
#pragma mark Private Functions
#pragma mark ---------------------------------------------------------
private: // Functions
	
#pragma mark ---------------------------------------------------------
#pragma mark End Private Functions
#pragma mark ---------------------------------------------------------
	
#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
private: // Data
	
	ALCcontext *	m_context; // stores the context (the 'air')
	ALCdevice *		m_device; // stores the device
	
	SoundsMap		m_map;
	
#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
};

#endif // __SoundEngine_h__