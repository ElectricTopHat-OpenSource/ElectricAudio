//
//  AudioManger.h
//  ElectricAudio
//
//  Created by Robert McDowell on 08/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

class SoundEngine;

@interface AudioManger : NSObject 
{
@private

	SoundEngine * soundEngine; 
}

@property (nonatomic) float soundMasterVolume; // Sound Master Volume

+ (void) create;	// construct the audio manager, can be used to create the manager at point before the instance is accessed
+ (void) destroy;	// tear down the audio manager.

+ (AudioManger*) instance;

- (Boolean) hasSoundWithKey:(NSString*)_key;

- (Boolean) createSoundWithKey:(NSString*)_key withResource:(NSString*)_resource ofType:(NSString*)_ext isLooping:(Boolean)_loop;
- (Boolean) createSoundWithKey:(NSString*)_key withFilePath:(NSString*)_filePath isLooping:(Boolean)_loop;

- (Boolean) releaseSoundWithKey:(NSString*)_key;

- (Boolean) isPlayingSoundWithKey:(NSString*)_key;
- (Boolean) isPausedSoundWithKey:(NSString*)_key;

- (void) playSoundWithKey:(NSString*)_key;
- (void) stopSoundWithKey:(NSString*)_key;
- (void) pauseSoundWithKey:(NSString*)_key;
- (void) rewindSoundWithKey:(NSString*)_key;

- (float) soundVolumeWithKey:(NSString*)_key;
- (void)  setSoundVolumeWithKey:(NSString*)_key volume:(float)_volume;

- (Boolean) soundLoopedWithKey:(NSString*)_key;
- (void)	setSoundLoopedWithKey:(NSString*)_key loop:(Boolean)_loop;

@end
