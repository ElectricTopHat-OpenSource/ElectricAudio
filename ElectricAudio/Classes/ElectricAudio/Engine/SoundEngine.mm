//
//  SoundEngine.m
//  ElectricAudio
//
//  Created by Robert McDowell on 08/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import "SoundEngine.h"

#import "Sound.h"
#import "SoundBuffer.h"

namespace EA 
{
	
#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------
	
	// --------------------------------------------------
	// Constructor
	// --------------------------------------------------
	SoundEngine::SoundEngine()
	: m_context ( NULL )
	{		
		m_device = alcOpenDevice(NULL); // select the "preferred device"
		if ( m_device ) 
		{
			// use the device to make a context
			m_context = alcCreateContext(m_device,NULL);
			
			if ( m_context )
			{
				// set my context to the currently active one
				alcMakeContextCurrent(m_context);
			}
			else 
			{
				// close the device
				alcCloseDevice(m_device);
				m_device = nil;
				
				NSLog(@"SoundEngine : Failed to create Audio Context.");
			}
		}
		else 
		{
			NSLog(@"SoundEngine : Failed to create Audio Device.");
		}
	}
	
	// --------------------------------------------------
	// Destructor
	// --------------------------------------------------
	SoundEngine::~SoundEngine()
	{
		// -------------------------------
		// clean up all the sound objects
		// -------------------------------
		clear();
		// -------------------------------
		
		if ( m_context )
		{
			// destroy the context
			alcDestroyContext(m_context);
		}
		
		if ( m_device )
		{
			// close the device
			alcCloseDevice(m_device);
		}
	}
	
#pragma mark ---------------------------------------------------------
#pragma mark === End Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------
	
#pragma mark ---------------------------------------------------------
#pragma mark === Public Functions  ===
#pragma mark ---------------------------------------------------------
	
	// --------------------------------------------------
	// is the sound loaded
	// --------------------------------------------------
	BOOL SoundEngine::isLoaded( const NSString * _name, const NSString * _ext, NSBundle * _bundle )
	{
		NSBundle * bundle	= ( _bundle ) ? _bundle : [NSBundle mainBundle];
		NSString * path		= [bundle pathForResource:_name ofType:_ext];
		if ( path )
		{
			return isLoaded( path );
		}
		return nil;
	}
	
	// --------------------------------------------------
	// is the sound loaded
	// --------------------------------------------------
	BOOL SoundEngine::isLoaded( const NSString * _filePath )
	{
		SoundBuffersMap::iterator lb = m_buffers.lower_bound(_filePath.hash);
		if (lb != m_buffers.end() && !(m_buffers.key_comp()(_filePath.hash, lb->first)))
		{
			return true;
		}
		return false;
	}
	
	// --------------------------------------------------
	// load a sound
	// --------------------------------------------------
	Sound * SoundEngine::load( const NSString * _name, const NSString * _ext, NSBundle * _bundle )
	{
		NSBundle * bundle	= ( _bundle ) ? _bundle : [NSBundle mainBundle];
		NSString * path		= [bundle pathForResource:_name ofType:_ext];
		if ( path )
		{
			return load( path );
		}
		return nil;
	}
	
	// --------------------------------------------------
	// load a sound
	// --------------------------------------------------
	Sound * SoundEngine::load( const NSString * _filePath )
	{
		SoundBuffer * buffer = nil;
		SoundBuffersMap::iterator lb = m_buffers.lower_bound(_filePath.hash);
		if (lb != m_buffers.end() && !(m_buffers.key_comp()(_filePath.hash, lb->first)))
		{
			buffer  = lb->second;
			buffer->incrementReferenceCount();
		}
		else // Load the buffer and convert it.
		{
			buffer = new SoundBuffer( _filePath );
			
			if ( buffer && buffer->isError() )
			{
				delete( buffer );
				buffer = nil;
			}
			else 
			{
				m_buffers[buffer->hash()] = buffer;
			}
		}
		
		Sound * sound = nil;
		if ( buffer )
		{
			sound = new Sound( buffer );
			if ( sound->isError() )
			{
				delete(sound);
				sound = nil;
				
				// may need to clean up the buffer
				release( buffer );
			}
			else 
			{
				m_sounds[sound->soundID()] = sound;
			}
		}
		
		return sound;
	}
	
	// --------------------------------------------------
	// release a sound
	// --------------------------------------------------
	void SoundEngine::release( Sound * _sound )
	{
		if ( _sound )
		{
			NSUInteger key = _sound->soundID();
			SoundsMap::iterator lb = m_sounds.lower_bound(key);
			if (lb != m_sounds.end() && !(m_sounds.key_comp()(key, lb->first)))
			{
				Sound * sound = lb->second;
				sound->decrementReferenceCount();
				
				if ( sound->referenceCount() <= 0 )
				{	
					// grab the refrenced sound buffer
					release( sound->m_buffer );
					
					// remove the object reference
					// from the map
					m_sounds.erase( lb );			

					// delete the object
					delete( sound );
				}
			}
		}
	}
	
	// --------------------------------------------------
	// clear the entire sound bank
	// --------------------------------------------------
	void SoundEngine::clear()
	{
		// -------------------------------------
		// delete all the sound objects
		// -------------------------------------
		SoundsMap::iterator objs;
		for (objs = m_sounds.begin(); objs != m_sounds.end(); ++objs) 
		{
			Sound * sound = objs->second;
			delete( sound );
		}
		m_sounds.clear();
		// -------------------------------------
		
		// -------------------------------------
		// delete all the sound buffers
		// -------------------------------------
		SoundBuffersMap::iterator objb;
		for (objb = m_buffers.begin(); objb != m_buffers.end(); ++objb) 
		{
			SoundBuffer * buffer = objb->second;
			delete( buffer );
		}
		m_buffers.clear();
		// -------------------------------------
	}
	
#pragma mark ---------------------------------------------------------
#pragma mark === End Public Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === Private Functions  ===
#pragma mark ---------------------------------------------------------
	
	// --------------------------------------------------
	// release a sound buffer
	// --------------------------------------------------
	void SoundEngine::release( SoundBuffer * _buffer )
	{
		if ( _buffer )
		{
			NSUInteger key = _buffer->hash();
			SoundBuffersMap::iterator lb = m_buffers.lower_bound(key);
			if (lb != m_buffers.end() && !(m_buffers.key_comp()(key, lb->first)))
			{
				SoundBuffer * buffer = lb->second;
				buffer->decrementReferenceCount();
				
				if ( buffer->referenceCount() <= 0 )
				{						
					// remove the object reference
					// from the map
					m_buffers.erase( lb );			
					
					// delete the object
					delete( buffer );
				}
			}
		}
	}
	
#pragma mark ---------------------------------------------------------
#pragma mark === End Private Functions  ===
#pragma mark ---------------------------------------------------------
};