//
//  InDialoguePlayerStateStack.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BasePlayerStateStack.h"

@class GameEngineScene;
@class BGCharacterBase;

@interface InDialoguePlayerStateStack : BasePlayerStateStack

+(InDialoguePlayerStateStack*)cons:(GameEngineScene*)g with_character:(BGCharacterBase*)character;

@end
