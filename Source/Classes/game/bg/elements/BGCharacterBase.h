//
//  BGCharacterBase.h
//  hanokam
//
//  Created by Kenneth Pu on 6/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@class GameEngineScene;
@class SpriterNode;

// States for background characters
typedef enum {
    BGCharacter_Idle,
    BGCharacter_CanSpeak,
    BGCharacter_Speaking
} BGCharacterState;

/**
 *  @class  BGCharacterBase
 *
 *  Base CCSprite for background characters. Should never be instantiated
 */
@interface BGCharacterBase : CCSprite

// States for background characters
@property (nonatomic, readonly) BGCharacterState state;

// Offset position for dialogue bubble
-(CGPoint)dialogueOffset;

/**
 *  Update state, handles interactions with other elements in the game
 *
 *  @param  g       an object containing information about the current game state
 */
-(void)i_update:(GameEngineScene*)g;

/**
 *  Signal to character to exit from SPEAKING state
 */
-(void)doneSpeaking;

@end
