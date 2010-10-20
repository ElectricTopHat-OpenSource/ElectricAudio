//
//  SoundListener.m
//  ElectricAudio
//
//  Created by Robert McDowell on 20/10/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "SoundListener.h"
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
	SoundListener::SoundListener()
	{
	}
	
	// --------------------------------------------------
	// Destructor
	// --------------------------------------------------
	SoundListener::~SoundListener()
	{	
	}
	
#pragma mark ---------------------------------------------------------
#pragma mark === End Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------
	
#pragma mark ---------------------------------------------------------
#pragma mark === Public Functions  ===
#pragma mark ---------------------------------------------------------
	
	// --------------------------------------------------
	// get the listener volume
	// --------------------------------------------------
	float SoundListener::volume() const
	{
		float volume;
		alGetListenerf(AL_GAIN, &volume);
		return volume;
	}
	
	// --------------------------------------------------
	// get the listener volume
	// --------------------------------------------------
	void SoundListener::getVolume( float & _volume ) const
	{
		alGetListenerf(AL_GAIN, &_volume);
	}
	
	// --------------------------------------------------
	// set the listener volume
	// --------------------------------------------------
	void SoundListener::setVolume(float _volume )
	{
		float volume = MAX(MIN(_volume, 1.0f), 0.0f); //cap to 0-1
		alListenerf(AL_GAIN, volume);
	}
	
	// --------------------------------------------------
	// get the listener position
	// --------------------------------------------------
	Vector3D SoundListener::position() const
	{
		Vector3D pos;
		alGetListener3f(AL_POSITION, &pos.x, &pos.y, &pos.z);
		return pos;
	}
	
	// --------------------------------------------------
	// get the listener position
	// --------------------------------------------------
	void SoundListener::getPosition( Vector3D & _pos ) const
	{
		alGetListener3f(AL_POSITION, &_pos.x, &_pos.y, &_pos.z);
	}
	
	// --------------------------------------------------
	// set the listener position
	// --------------------------------------------------
	void SoundListener::setPosition( const Vector3D & _pos )
	{
		alListener3f(AL_POSITION, _pos.x, _pos.y, _pos.z);
	}
	
	// --------------------------------------------------
	// get the listener velocity
	// --------------------------------------------------
	Vector3D SoundListener::velocity() const
	{
		Vector3D vel;
		alGetListener3f(AL_POSITION, &vel.x, &vel.y, &vel.z);
		return vel;
	}
	
	// --------------------------------------------------
	// get the listener velocity
	// --------------------------------------------------
	void SoundListener::getVelocity( Vector3D & _vel ) const
	{
		alGetListener3f(AL_VELOCITY, &_vel.x, &_vel.y, &_vel.z);
	}
	
	// --------------------------------------------------
	// set the listener velocity
	// --------------------------------------------------
	void SoundListener::setVelocity( const Vector3D & _vel )
	{
		alListener3f(AL_VELOCITY, _vel.x, _vel.y, _vel.z);
	}
	
	// --------------------------------------------------
	// set the listener rotation
	// --------------------------------------------------
	Matrix3x3 SoundListener::rotation() const
	{
		Matrix3x3 rotation;
		getRotation( rotation );
		return rotation;
	}
	
	// --------------------------------------------------
	// get the listener rotation
	// --------------------------------------------------
	void SoundListener::getRotation( Matrix3x3 & _rotation ) const
	{
		float vec[6];
		alGetListenerfv(AL_ORIENTATION, vec);
		
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
	void SoundListener::setRotation( const Matrix3x3 & _rotation )
	{
		float vec[6];
		vec[0] = _rotation.m02; // at
		vec[1] = _rotation.m12;
		vec[2] = _rotation.m22;
		vec[3] = _rotation.m01; // up
		vec[4] = _rotation.m11;
		vec[5] = _rotation.m21;
		alListenerfv(AL_ORIENTATION, vec);
	}
	
	// --------------------------------------------------
	// get the listener transform
	// --------------------------------------------------
	Matrix4x4 SoundListener::transform() const
	{
		Matrix4x4 transform;
		getTransform( transform );
		return transform;
	}
	
	// --------------------------------------------------
	// get the listener transform
	// --------------------------------------------------
	void SoundListener::getTransform( Matrix4x4 & _transform ) const
	{
		float vec[6];
		alGetListenerfv(AL_ORIENTATION, vec);
		alGetListener3f(AL_POSITION, &_transform.m30, &_transform.m31, &_transform.m32);
		
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
	void SoundListener::setTransform( const Matrix4x4 & _transform )
	{
		float vec[6];
		vec[0] = _transform.m02; // at
		vec[1] = _transform.m12;
		vec[2] = _transform.m22;
		vec[3] = _transform.m01; // up
		vec[4] = _transform.m11;
		vec[5] = _transform.m21;
		alListenerfv(AL_ORIENTATION, vec);
		alListener3f(AL_POSITION, _transform.m30, _transform.m31, _transform.m32);
	}
	
#pragma mark ---------------------------------------------------------
#pragma mark === End Public Functions  ===
#pragma mark ---------------------------------------------------------
};