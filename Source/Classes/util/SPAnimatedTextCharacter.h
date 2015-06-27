//
//  SPAnimatedTextCharacter.h
//  hanokam
//
//  Created by Kenneth Pu on 6/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@class GameEngineScene;

// Animation states
typedef enum {
    AnimatedTextCharacterState_Hidden,
    AnimatedTextCharacterState_Entering,
    AnimatedTextCharacterState_Showing,
    AnimatedTextCharacterState_Exiting,
    AnimatedTextCharacterState_CanRemove
} AnimatedTextCharacterState;

/**
 *  @class  SPAnimatedTextCharacter
 *
 *  Manages the display and animation of a single letter
 */
@interface SPAnimatedTextCharacter : CCNode

@property (nonatomic, readonly) AnimatedTextCharacterState state;

/**
 *  Returns an instance of SPAnimatedTextCharacter
 *
 *  @param  game        an object containing information about the current game state
 *  @param  character   the character to display
 *  @param  color       the color of the character
 *  @param  amplitude   the amplitude of oscillation
 */
+(SPAnimatedTextCharacter*)cons:(GameEngineScene*)game
                  withCharacter:(NSString*)character
                          color:(CCColor*)color
                      amplitude:(CGFloat)amplitude;

/**
 *  Update state, handles interactions with other elements in the game
 *
 *  @param  game        an object containing information about the current game state
 */
-(void)i_update:(GameEngineScene*)game
             ts:(CGFloat)ts;

/**
 *  Signal to begin showing character
 */
-(void)beginEntering;

/**
 *  Signal to skip any entry animations and immediately show character
 */
-(void)forceShowing;

/**
 *  Signal to begin hiding character
 */
-(void)beginExiting;

@end
