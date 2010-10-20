//
//  SoundBuffer.m
//  ElectricAudio
//
//  Created by Robert McDowell on 20/10/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "SoundBuffer.h"

#import "AppleOpenALSupport.h"

namespace EA 
{
	
#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------
	
	// --------------------------------------------------
	// Constructor
	// --------------------------------------------------
	SoundBuffer::SoundBuffer( NSString * _filePath )
	: m_filePath		( [_filePath copy] )
	, m_error			( AL_NO_ERROR )
	, m_bufferData		( nil )
	, m_bufferSize		( 0 )
	, m_frequecy		( 0 )
	, m_format			( 0 )
	, m_duration		( 0.0f )
	, m_referenceCount	( 1 )
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
		}
	}
	
	// --------------------------------------------------
	// Destructor
	// --------------------------------------------------
	SoundBuffer::~SoundBuffer()
	{	
		ALenum error;
		
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
	// is there an error
	// --------------------------------------------------
	Boolean SoundBuffer::isError() const 
	{ 
		return m_error != AL_NO_ERROR; 
	}
	
	// --------------------------------------------------
	// return the error string
	// --------------------------------------------------
	NSString * SoundBuffer::error() const
	{
		switch (m_error) 
		{
			case -1:
				return @"OpenAL Error : File does not exist.";
				break;
			case AL_NO_ERROR:
				return @"OpenAL Error : NO ERROR";
				break;
			case AL_INVALID_NAME:
				return @"OpenAL Error : Invalid Name paramater passed to AL call.";
				break;
			case AL_INVALID_ENUM:
				return @"OpenAL Error : Invalid parameter passed to AL call.";
				break;
			case AL_INVALID_VALUE:
				return @"OpenAL Error : Invalid enum parameter value.";
				break;
			case  AL_INVALID_OPERATION:
				return @"OpenAL Error : Illegal call.";
				break;
			case AL_OUT_OF_MEMORY:
				return @"OpenAL Error : Out of Memory.";
				break;
			default:
				return [NSString stringWithFormat:@"Unknown Error with code %x", m_error];
				break;
		}
	}
	
#pragma mark ---------------------------------------------------------
#pragma mark End Public Functions
#pragma mark ---------------------------------------------------------
	
};