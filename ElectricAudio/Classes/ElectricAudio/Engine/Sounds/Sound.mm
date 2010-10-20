//
//  Sound.mm
//  ElectricAudio
//
//  Created by Robert McDowell on 20/10/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "Sound.h"
#import "SoundBuffer.h"
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

namespace EA 
{
	
#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------
	
	// --------------------------------------------------
	// Constructor
	// --------------------------------------------------
	Sound::Sound( SoundBuffer * _buffer, BOOL _looped )
	: m_buffer			( _buffer )
	, m_sourceID		( 0 )	
	, m_referenceCount	( 1 )
	, m_error			( AL_NO_ERROR )
	{		
		if ( m_buffer )
		{
			if ( !m_buffer->isError() )
			{
				// grab a source ID from openAL, this will be the base source ID
				alGenSources(1, &m_sourceID); 
				
				// attach the buffer to the source
				alSourcei(m_sourceID, AL_BUFFER, m_buffer->bufferID());
				
				// set the looping state
				alSourcei(m_sourceID, AL_LOOPING, _looped);
			}
			else
			{
				m_error = -2;
				NSLog(@"Sound : Buffer has an error.");
			}
		}
		else
		{
			m_error = -1;
			NSLog(@"Sound : Buffer is missing.");
		}
	}
	
	// --------------------------------------------------
	// Destructor
	// --------------------------------------------------
	Sound::~Sound()
	{	
		if ( m_buffer )
		{
			ALenum error;
			
#if OpenALStaticBuffer
			// Unqueue the buffer this makes sure 
			// that when we destroy the local buffer
			// the sound thread is not using it.
			NSUInteger bufferID = m_buffer->bufferID();
			alSourceUnqueueBuffers( m_sourceID, 1, &bufferID );
#endif
			
			// delete the source
			alDeleteSources(1, &m_sourceID);
			if ( ( error = alGetError() ) != AL_NO_ERROR )
			{
				NSLog(@"~Sound : error deleting sound: %x\n", error);
			}
		}
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
	BOOL Sound::play()
	{
		//if the base source isn't busy, just use that one...
		alSourcePlay(m_sourceID);
		return ((m_error = alGetError()) != AL_NO_ERROR);
	}
	
	// --------------------------------------------------
	// Pause the sound
	// --------------------------------------------------
	BOOL Sound::pause()
	{
		alSourcePause(m_sourceID);
		return ((m_error = alGetError()) != AL_NO_ERROR);
	}
	
	// --------------------------------------------------
	// Rewind the sound
	// --------------------------------------------------
	BOOL	Sound::rewind()
	{
		alSourceRewind(m_sourceID);
		return ((m_error = alGetError()) != AL_NO_ERROR);
	}
	
	// --------------------------------------------------
	// Stop the sound
	// --------------------------------------------------
	BOOL Sound::stop()
	{
		alSourceStop(m_sourceID);
		return ((m_error = alGetError()) != AL_NO_ERROR);
	}
	
	// --------------------------------------------------
	// Is the sound Playing
	// --------------------------------------------------
	BOOL Sound::isPlaying() const
	{
		ALenum state;	
		alGetSourcei(m_sourceID, AL_SOURCE_STATE, &state);
		return (state == AL_PLAYING);
	}
	
	// --------------------------------------------------
	// Is the sound Paused
	// --------------------------------------------------
	BOOL Sound::isPaused() const
	{
		ALenum state;	
		alGetSourcei(m_sourceID, AL_SOURCE_STATE, &state);
		return (state == AL_PAUSED);
	}
	
	// --------------------------------------------------
	// get if sound so it loops
	// --------------------------------------------------
	BOOL Sound::isLooped() const
	{
		BOOL looped = FALSE;
		alSourcei(m_sourceID, AL_LOOPING, looped);
		return looped;
	}
	
	// --------------------------------------------------
	// set the sound so it loops
	// --------------------------------------------------
	void Sound::setLooped( BOOL _looped )
	{
		alSourcei(m_sourceID, AL_LOOPING, _looped);
	}
	
	// --------------------------------------------------
	// get the Sounds volume
	// --------------------------------------------------
	float Sound::volume() const
	{
		float volume;
		alGetSourcef(m_sourceID, AL_GAIN, &volume);
		return volume;
	}
	
	// --------------------------------------------------
	// get the Sounds volume
	// --------------------------------------------------
	void Sound::getVolume( float & _volume ) const
	{
		alGetSourcef(m_sourceID, AL_GAIN, &_volume);
	}
	
	// --------------------------------------------------
	// set the Sounds volume
	// --------------------------------------------------
	void Sound::setVolume(float _volume )
	{
		float volume = MAX(MIN(_volume, 1.0f), 0.0f); //cap to 0-1
		alSourcef(m_sourceID, AL_GAIN, volume);
	}
	
	// --------------------------------------------------
	// get the sounds pitch
	// --------------------------------------------------
	float Sound::pitch() const
	{
		float pitch;
		alGetSourcef(m_sourceID, AL_PITCH, &pitch);
		return pitch;
	}
	
	// --------------------------------------------------
	// get the sounds pitch
	// --------------------------------------------------
	void Sound::getPitch( float & _pitch ) const
	{
		alGetSourcef(m_sourceID, AL_PITCH, &_pitch);
	}
	
	// --------------------------------------------------
	// set the sounds pitch
	// --------------------------------------------------
	void Sound::setPitch( float _pitch )
	{
		alSourcef(m_sourceID, AL_PITCH, _pitch);
	}
	
	// --------------------------------------------------
	// get the listener position
	// --------------------------------------------------
	Vector3D Sound::position() const
	{
		Vector3D pos;
		alGetSource3f(m_sourceID, AL_POSITION, &pos.x, &pos.y, &pos.z);
		return pos;
	}
	
	// --------------------------------------------------
	// get the listener position
	// --------------------------------------------------
	void Sound::getPosition( Vector3D & _pos ) const
	{
		alGetSource3f(m_sourceID, AL_POSITION, &_pos.x, &_pos.y, &_pos.z);
	}
	
	// --------------------------------------------------
	// set the listener position
	// --------------------------------------------------
	void Sound::setPosition( const Vector3D & _pos )
	{
		alSource3f(m_sourceID, AL_POSITION, _pos.x, _pos.y, _pos.z);
	}
	
	// --------------------------------------------------
	// get the listener velocity
	// --------------------------------------------------
	Vector3D Sound::velocity() const
	{
		Vector3D vel;
		alGetSource3f(m_sourceID, AL_POSITION, &vel.x, &vel.y, &vel.z);
		return vel;
	}
	
	// --------------------------------------------------
	// get the listener velocity
	// --------------------------------------------------
	void Sound::getVelocity( Vector3D & _vel ) const
	{
		alGetSource3f(m_sourceID, AL_VELOCITY, &_vel.x, &_vel.y, &_vel.z);
	}
	
	// --------------------------------------------------
	// set the listener velocity
	// --------------------------------------------------
	void Sound::setVelocity( const Vector3D & _vel )
	{
		alSource3f(m_sourceID, AL_VELOCITY, _vel.x, _vel.y, _vel.z);
	}
	
	// --------------------------------------------------
	// set the listener rotation
	// --------------------------------------------------
	Matrix3x3 Sound::rotation() const
	{
		Matrix3x3 rotation;
		getRotation( rotation );
		return rotation;
	}
	
	// --------------------------------------------------
	// get the listener rotation
	// --------------------------------------------------
	void Sound::getRotation( Matrix3x3 & _rotation ) const
	{
		float vec[6];
		alGetSourcefv(m_sourceID, AL_ORIENTATION, vec);
		
		_rotation.m02 = vec[0]; // at
		_rotation.m12 = vec[1];
		_rotation.m22 = vec[2];
		_rotation.m01 = vec[3]; // up
		_rotation.m11 = vec[4];
		_rotation.m21 = vec[5];
		// cross product to get the right axis
		_rotation.m00 = ( vec[1] * vec[5] - vec[2] * vec[4] );
		_rotation.m10 = ( vec[2] * vec[3] - vec[3] * vec[2] );
		_rotation.m20 = ( vec[0] * vec[4] - vec[4] * vec[0] );
	}
	
	// --------------------------------------------------
	// get the listener rotation
	// --------------------------------------------------
	void Sound::setRotation( const Matrix3x3 & _rotation )
	{
		float vec[6];
		vec[0] = _rotation.m02; // at
		vec[1] = _rotation.m12;
		vec[2] = _rotation.m22;
		vec[3] = _rotation.m01; // up
		vec[4] = _rotation.m11;
		vec[5] = _rotation.m21;
		alSourcefv(m_sourceID, AL_ORIENTATION, vec);
	}
	
	// --------------------------------------------------
	// get the listener transform
	// --------------------------------------------------
	Matrix4x4 Sound::transform() const
	{
		Matrix4x4 transform;
		getTransform( transform );
		return transform;
	}
	
	// --------------------------------------------------
	// get the listener transform
	// --------------------------------------------------
	void Sound::getTransform( Matrix4x4 & _transform ) const
	{
		float vec[6];
		alGetSourcefv(m_sourceID, AL_ORIENTATION, vec);
		alGetSource3f(m_sourceID, AL_POSITION, &_transform.m30, &_transform.m31, &_transform.m32);
		
		_transform.m02 = vec[0]; // at
		_transform.m12 = vec[1];
		_transform.m22 = vec[2];
		_transform.m01 = vec[3]; // up
		_transform.m11 = vec[4];
		_transform.m21 = vec[5];
		// cross product to get the right axis
		_transform.m00 = ( vec[1] * vec[5] - vec[2] * vec[4] );
		_transform.m10 = ( vec[2] * vec[3] - vec[3] * vec[2] );
		_transform.m20 = ( vec[0] * vec[4] - vec[4] * vec[0] );
		_transform.m03 = 0.0f;
		_transform.m13 = 0.0f;
		_transform.m23 = 0.0f;
		_transform.m33 = 1.0f;	
	}
	
	// --------------------------------------------------
	// set the listener transform
	// --------------------------------------------------
	void Sound::setTransform( const Matrix4x4 & _transform )
	{
		float vec[6];
		vec[0] = _transform.m02; // at
		vec[1] = _transform.m12;
		vec[2] = _transform.m22;
		vec[3] = _transform.m01; // up
		vec[4] = _transform.m11;
		vec[5] = _transform.m21;
		alSourcefv(m_sourceID, AL_ORIENTATION, vec);
		alSource3f(m_sourceID, AL_POSITION, _transform.m30, _transform.m31, _transform.m32);
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
			case -2:
				return @"OpenAL Error : Buffer has an error.";
				break;
			case -1:
				return @"OpenAL Error : Buffer does not exist.";
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