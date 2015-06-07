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

/**
 *  @class  InDialoguePlayerStateStack
 *
 *  Helper class to handle game behavior when player is in a dialogue
 */
@interface InDialoguePlayerStateStack : BasePlayerStateStack

/*
 * Returns an instance of InDialoguePlayerStateStack
 *
 *  @param  g           an object containing information about the current game state
 *  @param  character   character with whom we are currently speaking to
 */
+(InDialoguePlayerStateStack*)cons:(GameEngineScene*)g withCharacter:(BGCharacterBase*)character;

@end
