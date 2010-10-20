//
//  Sound.mm
//  ElectricAudio
//
//  Created by Robert McDowell on 08/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "Sound.h"
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

#import "AppleOpenALSupport.h"

#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

// --------------------------------------------------
// Constructor
// --------------------------------------------------
Sound::Sound( NSUInteger _key, NSString * _filePath, Boolean _looped )
: m_key ( _key )
, m_volume ( 1.0 )
, m_pitch ( 1.0 )	
, m_looped ( _looped )
, m_error ( AL_NO_ERROR )
, m_bufferData ( nil )
, m_bufferSize ( 0 )
, m_frequecy ( 0 )
, m_format ( 0 )
, m_duration ( 0.0 )
{
	// get some audio data from a wave file
	CFURLRef fileURL = (CFURLRef)[NSURL fileURLWithPath:_filePath];
	
	if (fileURL)
	{
		ALFileInfo  info;
#if OpenALStaticBuffer
		m_bufferData = MyGetOpenALAudioData(fileURL, &info);
#else
		void * bufferData = MyGetOpenALAudioData(fileURL, &info);
#endif
		
		if((m_error = alGetError()) != AL_NO_ERROR) 
		{
			NSLog(@"Sound : error loading sound: %x\n", m_error);
		}
		else 
		{
			// grab a buffer ID from openAL
			alGenBuffers(1, &m_bufferID);
			
#if OpenALStaticBuffer
			// load the awaiting data blob into the openAL buffer.
			// http://developer.apple.com/iphone/library/technotes/tn2008/tn2199.html
			// Use the alBufferDataStatic API, found in the oalStaticBufferExtension.h 
			// header file, instead of the standard alBufferData function. This 
			// eliminates extra buffer copies by allowing your application to own
			// the audio data memory used by the buffer objects.
			alBufferDataStaticProc(m_bufferID, info.format, m_bufferData, info.size, info.sampleRate);	
#else
			// copy the buffer into the OpenAL controlled buffer.
			alBufferData(m_bufferID, info.format, bufferData, info.size, info.sampleRate);
			
			// clean up the local buffer
			free( bufferData );
			bufferData = nil;
#endif
			if((m_error = alGetError()) != AL_NO_ERROR) 
			{
				NSLog(@"Sound : Error attaching audio to buffer: %x\n", m_error);
			}
			else 
			{
				// grab a source ID from openAL, this will be the base source ID
				alGenSources(1, &m_sourceID); 
				
				// attach the buffer to the source
				alSourcei(m_sourceID, AL_BUFFER, m_bufferID);
				
				// set the looping state
				alSourcei(m_sourceID, AL_LOOPING, m_looped);
				
				// store the reset of the 
				// state information
				m_bufferSize = info.size;
				m_format	 = info.format;
				m_frequecy	 = info.sampleRate;
				m_duration	 = info.duration;
			}
		}
	}
	else
	{
		m_error = -1;
		NSLog(@"Sound : File not found.");
		return;
	}
}

// --------------------------------------------------
// Destructor
// --------------------------------------------------
Sound::~Sound()
{	
	ALenum error;
	
#if OpenALStaticBuffer
	// Unqueue the buffer this makes sure 
	// that when we destroy the local buffer
	// the sound thread is not using it.
	alSourceUnqueueBuffers( m_sourceID, 1, &m_bufferID );
#endif
	
	// delete the source
	alDeleteSources(1, &m_sourceID);
	if ( ( error = alGetError() ) != AL_NO_ERROR )
	{
		NSLog(@"~Sound : error deleting sound: %x\n", error);
	}
	
	// delete the buffer
	alDeleteBuffers(1, &m_bufferID);
	if ( ( error = alGetError() ) != AL_NO_ERROR )
	{
		NSLog(@"~Sound : error deleting buffer: %x\n", error);
	}
	
#if OpenALStaticBuffer	
	if ( !alIsBuffer( m_bufferID ) )
	{
		if( m_bufferData )
		{
			free( m_bufferData );
			m_bufferData = nil;
		}
	}
#endif
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark Public Functions
#pragma mark ---------------------------------------------------------

// --------------------------------------------------
// Play the sound
// --------------------------------------------------
Boolean Sound::play()
{
	//if the base source isn't busy, just use that one...
	alSourcePlay(m_sourceID);
	return ((m_error = alGetError()) != AL_NO_ERROR);
}

// --------------------------------------------------
// Pause the sound
// --------------------------------------------------
Boolean Sound::pause()
{
	alSourcePause(m_sourceID);
	return ((m_error = alGetError()) != AL_NO_ERROR);
}

// --------------------------------------------------
// Rewind the sound
// --------------------------------------------------
Boolean	Sound::rewind()
{
	alSourceRewind(m_sourceID);
	return ((m_error = alGetError()) != AL_NO_ERROR);
}

// --------------------------------------------------
// Stop the sound
// --------------------------------------------------
Boolean Sound::stop()
{
	alSourceStop(m_sourceID);
	return ((m_error = alGetError()) != AL_NO_ERROR);
}

// --------------------------------------------------
// Is the sound Playing
// --------------------------------------------------
Boolean Sound::isPlaying() const
{
	ALenum state;	
    alGetSourcei(m_sourceID, AL_SOURCE_STATE, &state);
    return (state == AL_PLAYING);
}

// --------------------------------------------------
// Is the sound Paused
// --------------------------------------------------
Boolean Sound::isPaused() const
{
	ALenum state;	
    alGetSourcei(m_sourceID, AL_SOURCE_STATE, &state);
    return (state == AL_PAUSED);
}

// --------------------------------------------------
// is there an error
// --------------------------------------------------
Boolean Sound::isError() const 
{ 
	return m_error != AL_NO_ERROR; 
}

// --------------------------------------------------
// return the error string
// --------------------------------------------------
NSString * Sound::error() const
{
	switch (m_error) 
	{
		case -1:
			return @"File does not exist.";
			break;
		case AL_NO_ERROR:
			return @"No Error";
			break;
		default:
			return [NSString stringWithFormat:@"Unknow Error with code %x", m_error];
			break;
	}
}

// --------------------------------------------------
// set the Sounds Volume
// --------------------------------------------------
void Sound::setVolume(float _volume)
{
	m_volume = MAX(MIN(_volume, 1.0f), 0.0f); //cap to 0-1
	alSourcef(m_sourceID, AL_GAIN, m_volume);	
	m_error = alGetError();
}

// --------------------------------------------------
// set the sounds pitch
// --------------------------------------------------
void Sound::setPitch( float _pitch )
{
	m_pitch = _pitch;
	alSourcef(m_sourceID, AL_PITCH, m_pitch);
	m_error = alGetError();
}

// --------------------------------------------------
// set the sound so it loops
// --------------------------------------------------
void Sound::setLooped( Boolean _looped )
{
	m_looped = _looped;
	alSourcei(m_sourceID, AL_LOOPING, m_looped);
	m_error = alGetError();
}

#pragma mark ---------------------------------------------------------
#pragma mark End Public Functions
#pragma mark ---------------------------------------------------------
