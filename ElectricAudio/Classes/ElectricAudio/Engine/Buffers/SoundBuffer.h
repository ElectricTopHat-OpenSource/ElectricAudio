//
//  SoundBuffer.h
//  ElectricAudio
//
//  Created by Robert McDowell on 20/10/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#if !defined(__SoundBuffer_h__)
#define __SoundBuffer_h__

#if !defined(OpenALStaticBuffer)
#define OpenALStaticBuffer 1
#endif

namespace EA { class SoundEngine; };

namespace EA 
{
	class SoundBuffer 
	{
#pragma mark ---------------------------------------------------------
#pragma mark friend classes
#pragma mark ---------------------------------------------------------
		
		friend class SoundEngine;
		
#pragma mark ---------------------------------------------------------
#pragma mark End friend classes
#pragma mark ---------------------------------------------------------
		
#pragma mark ---------------------------------------------------------
#pragma mark Constructor / Destructor
#pragma mark ---------------------------------------------------------
	private: // Functions
		
		// --------------------------------------------------
		// Constructor
		// --------------------------------------------------
		SoundBuffer( NSString * _filePath );
		
		// --------------------------------------------------
		// Destructor
		// --------------------------------------------------
		virtual ~SoundBuffer();
		
#pragma mark ---------------------------------------------------------
#pragma mark End Constructor / Destructor
#pragma mark ---------------------------------------------------------
		
#pragma mark ---------------------------------------------------------
#pragma mark Public Functions
#pragma mark ---------------------------------------------------------
	public:	// Functions
		
		inline NSString *	name() const		{ return [m_filePath lastPathComponent]; };
		inline NSString *	filePath() const	{ return m_filePath; };
		inline NSUInteger	hash() const		{ return [m_filePath hash]; };
		
		inline NSUInteger	bufferID()	const { return m_bufferID; };
		inline NSUInteger	size()		const { return m_bufferSize; };
		inline NSInteger	format()	const { return m_format; };
		inline NSInteger	frequency() const { return m_frequecy; };
		inline double		duration()	const { return m_duration; };
		
		Boolean		isError() const;
		NSString *	error() const;
		
#pragma mark ---------------------------------------------------------
#pragma mark End Public Functions
#pragma mark ---------------------------------------------------------
		
#pragma mark ---------------------------------------------------------
#pragma mark Private Functions
#pragma mark ---------------------------------------------------------
	private: // Functions
		
		inline NSInteger referenceCount() const { return m_referenceCount; };
		inline void incrementReferenceCount() { m_referenceCount++; };
		inline void decrementReferenceCount() { m_referenceCount--; };
		
#pragma mark ---------------------------------------------------------
#pragma mark End Private Functions
#pragma mark ---------------------------------------------------------
		
#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
	private: // Data
		
		NSString *	m_filePath;
		
		NSUInteger	m_referenceCount;
		NSUInteger	m_bufferID;
		
		NSInteger	m_error;
		
#if OpenALStaticBuffer
		void *		m_bufferData; // buffer 
#endif
		NSUInteger	m_bufferSize; // buffer size
		NSInteger	m_format;	// format
		NSInteger	m_frequecy; // frequency
		float		m_duration;	// duration in seconds
		
#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
	};
}

#endif
