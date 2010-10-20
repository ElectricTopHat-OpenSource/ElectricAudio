//
//  SoundListener.h
//  ElectricAudio
//
//  Created by Robert McDowell on 20/10/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#if !defined(__SoundListener_h__)
#define __SoundListener_h__

#import "Maths.h"

namespace EA 
{
	class SoundListener
	{
#pragma mark ---------------------------------------------------------
#pragma mark Constructor / Destructor
#pragma mark ---------------------------------------------------------
	public: // Functions
		
		// --------------------------------------------------
		// Constructor
		// --------------------------------------------------
		SoundListener();
		
		// --------------------------------------------------
		// Destructor
		// --------------------------------------------------
		virtual ~SoundListener();
		
#pragma mark ---------------------------------------------------------
#pragma mark End Constructor / Destructor
#pragma mark ---------------------------------------------------------	
		
#pragma mark ---------------------------------------------------------
#pragma mark Public Functions
#pragma mark ---------------------------------------------------------
	public:	// Functions
		
		float volume() const;
		void getVolume( float & _volume ) const;
		void setVolume( float _volume );
		
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
		
#pragma mark ---------------------------------------------------------
#pragma mark End Public Functions
#pragma mark ---------------------------------------------------------
	};
};

#endif