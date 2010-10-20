//
//  TestUncompressedSound.h
//  ElectricAudio
//
//  Created by Robert McDowell on 09/06/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestUncompressedSound : UIViewController 
{
@private

	IBOutlet UISlider *		soundVolume;
	IBOutlet UISwitch *		loopSound;
}

- (IBAction) createSoundObject:(id)_sender;
- (IBAction) releaseSoundObject:(id)_sender;

- (IBAction) playSoundObject:(id)_sender;
- (IBAction) pauseSoundObject:(id)_sender;
- (IBAction) stopSoundObject:(id)_sender;
- (IBAction) rewindSoundObject:(id)_sender;

- (IBAction) volumeChanged:(id)_sender;
- (IBAction) loopChanged:(id)_sender;

@end
