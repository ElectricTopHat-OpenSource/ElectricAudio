//
//  SoundManager.h
//  ElectricAudio
//
//  Created by Robert McDowell on 20/10/2010.
//  Copyright 2010 Electric TopHat Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

namespace EA { class SoundEngine; }
namespace EA { class Sound; }

@interface SoundManager : NSObject 
{
@private
	EA::SoundEngine * soundEngine;
}

@property (nonatomic,readonly) EA::SoundEngine * soundEngine;


@end
