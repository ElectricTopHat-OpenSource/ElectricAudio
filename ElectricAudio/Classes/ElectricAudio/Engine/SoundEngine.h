//
//  SoundEngine.h
//  ElectricAudio
//
//  Created by Robert McDowell on 08/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#if !defined(__SoundEngine_h__)
#define __SoundEngine_h__

#import "SoundListener.h"
#import <map>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

namespace EA { class Sound; }
namespace EA { class SoundBuffer; }

namespace EA 
{
	
	typedef std::map<NSUInteger,EA::Sound*>			SoundsMap;
	typedef std::map<NSUInteger,EA::SoundBuffer*>	SoundBuffersMap;
	
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
		
		// access the sound engines listener
		inline SoundListener &		 listener()			{ return m_listener; };
		inline const SoundListener & listener() const	{ return m_listener; };
		
		// check to se if a sound is loaded
		BOOL isLoaded( const NSString * _name, const NSString * _ext, NSBundle * _bundle = nil );
		BOOL isLoaded( const NSString * _filePath );
		
		// load a sound into the bank
		Sound * load( const NSString * _name, const NSString * _ext, NSBundle * _bundle = nil );
		Sound * load( const NSString * _filePath );
		
		// release the sound
		void release( Sound * _sound );
		
		// clear the entire sound bank
		void clear();
		
#pragma mark ---------------------------------------------------------
#pragma mark End Public Functions
#pragma mark ---------------------------------------------------------
		
#pragma mark ---------------------------------------------------------
#pragma mark Private Functions
#pragma mark ---------------------------------------------------------
	private: // Functions
		
		void release( SoundBuffer * _buffer );
		
#pragma mark ---------------------------------------------------------
#pragma mark End Private Functions
#pragma mark ---------------------------------------------------------
		
#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
	private: // Data
		
		ALCcontext *	m_context; // stores the context (the 'air')
		ALCdevice *		m_device; // stores the device
		
		SoundListener	m_listener;
		SoundsMap		m_sounds;
		SoundBuffersMap	m_buffers;
		
#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
	};
	
};

#endif // __SoundEngine_h__