/*
 *  EAMathTypes.h
 *  ElectricAudio
 *
 *  Created by Robert McDowell on 20/10/2010.
 *  Copyright 2010 Electric TopHat Ltd. All rights reserved.
 *
 */

#if !defined(_EAMathTypes_h__)
#define _EAMathTypes_h__

namespace EA 
{
	
#pragma mark ---------------------------------------------------------
#pragma mark Vector3D typedef
#pragma mark ---------------------------------------------------------
	
	typedef union 
	{ 
		float v[3];
		struct 
		{
			float x;
			float y;
			float z;
		};
	} Vector3D;
	
#pragma mark ---------------------------------------------------------
#pragma mark End Vector3D typedef
#pragma mark ---------------------------------------------------------
	
#pragma mark ---------------------------------------------------------
#pragma mark Matrix3x3 typedef
#pragma mark ---------------------------------------------------------
	
	typedef union 
	{ 
		float m[9];
		struct 
		{
			float m00, m01, m02;
			float m10, m11, m12;
			float m20, m21, m22;
		};
	} Matrix3x3;
	
#pragma mark ---------------------------------------------------------
#pragma mark End Matrix3x3 typedef
#pragma mark ---------------------------------------------------------
	
#pragma mark ---------------------------------------------------------
#pragma mark Matrix3x3 typedef
#pragma mark ---------------------------------------------------------
	
	typedef union 
	{ 
		float m[16];
		struct 
		{
			float m00, m01, m02, m03;
			float m10, m11, m12, m13;
			float m20, m21, m22, m23;
			float m30, m31, m32, m33;
		};
	} Matrix4x4;
	
#pragma mark ---------------------------------------------------------
#pragma mark End Matrix3x3 typedef
#pragma mark ---------------------------------------------------------
	
};

#endif