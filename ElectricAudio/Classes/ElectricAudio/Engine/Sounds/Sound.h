//
//  Sound.h
//  ElectricAudio
//
//  Created by Robert McDowell on 20/10/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#if !defined(__Sound_h__)
#define __Sound_h__

#import "Maths.h"

namespace EA { class SoundEngine; };
namespace EA { class SoundBuffer; };

namespace EA 
{
	class Sound 
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
		Sound( SoundBuffer * buffer, BOOL _looped=FALSE );
		
		// --------------------------------------------------
		// Destructor
		// --------------------------------------------------
		virtual ~Sound();
		
#pragma mark ---------------------------------------------------------
#pragma mark End Constructor / Destructor
#pragma mark ---------------------------------------------------------
		
#pragma mark ---------------------------------------------------------
#pragma mark Public Functions
#pragma mark ---------------------------------------------------------
	public:	// Functions
		
		inline NSUInteger soundID() const { return m_sourceID; };
		
		BOOL play(); 
		BOOL pause();
		BOOL rewind();
		BOOL stop(); 
		
		BOOL isPlaying() const;
		BOOL isPaused() const;
		BOOL isLooped() const;
		
		void setLooped( BOOL _looped );
		
		float volume() const;
		void getVolume( float & _volume ) const;
		void setVolume(float _volume);
		
		float pitch() const;
		void getPitch( float & _pitch ) const;
		void setPitch( float _pitch );
		
		Vector3D position() const;
		void getPosition( Vector3D & _pos ) const;
		void setPosition( const Vector3D & _pos );
		
		Vector3D velocity() const;
		void getVelocity( Vector3D & _vel ) const;
		void setVelocity( const Vector3D & _vel );
		
		Matrix3x3 rotation() const;
		void getRotation( Matrix3x3 & _rotation ) const;
		void setRotation( const Matrix3x3 & _rotation );
		
		Matrix4x4 transform() const;
		void getTransform( Matrix4x4 & _transform ) const;
		void setTransform( const Matrix4x4 & _transform );
		
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
		
		SoundBuffer *	m_buffer;
		NSUInteger		m_sourceID;
		NSUInteger		m_referenceCount;
		NSInteger		m_error;
		
#pragma mark ---------------------------------------------------------
#pragma mark Private Data
#pragma mark ---------------------------------------------------------
	};
	
};

#endif