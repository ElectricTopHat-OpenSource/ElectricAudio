//
//  Sound.h
//  ElectricAudio
//
//  Created by Robert McDowell on 08/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#if !defined(__Sound_h__)
#define __Sound_h__

#if !defined(OpenALStaticBuffer)
#define OpenALStaticBuffer 1
#endif

class Sound 
{
#pragma mark ---------------------------------------------------------
#pragma mark Constructor / Destructor
#pragma mark ---------------------------------------------------------
public: // Functions
	
	// --------------------------------------------------
	// Constructor
	// --------------------------------------------------
	Sound( NSUInteger _key, NSString * _filePath, Boolean _looped=FALSE );
	
	// --------------------------------------------------
	// Destructor
	// --------------------------------------------------
	~Sound();
	
#pragma mark ---------------------------------------------------------
#pragma mark End Constructor / Destructor
#pragma mark ---------------------------------------------------------
	
#pragma mark ---------------------------------------------------------
#pragma mark Public Functions
#pragma mark ---------------------------------------------------------
public:	// Functions
	
	Boolean	play(); 
	Boolean	pause();
	Boolean	rewind();
	Boolean	stop(); 
	
	Boolean isPlaying() const;
	Boolean isPaused() const;
	
	Boolean		isError() const;
	NSString *	error() const;
	
	inline NSUInteger	key() const { return m_key; };
	
	inline NSUInteger	size() const { return m_bufferSize; };
	inline NSInteger	format() const { return m_format; };
	inline NSInteger	frequency() const { return m_frequecy; };
	inline double		duration() const { return m_duration; };
	
	inline float volume() const { return m_volume; }
	void setVolume(float _volume);
	
	inline float pitch() const { return m_pitch; }
	void setPitch( float _pitch );
	
	inline Boolean looped() const { return m_looped; };
	void setLooped( Boolean _looped );
	
#pragma mark ---------------------------------------------------------
#pragma mark End Public Functions
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
private: // Data
	
	NSUInteger  m_key;
	
	NSUInteger  m_sourceID;
	NSUInteger	m_bufferID;
	
	int			m_error;
	
#if OpenALStaticBuffer
	void *		m_bufferData; // buffer 
#endif
	NSUInteger	m_bufferSize; // buffer size
	
	NSInteger	m_format;	// format
	NSInteger	m_frequecy; // frequency
	double		m_duration;	// duration in seconds
	
	float		m_volume;	// volume [0 - 1]
	float		m_pitch;	// speed
	
	Boolean		m_looped;
	
#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
};

#endif // __Sound_h__
