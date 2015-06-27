//
//  SPAnimatedText.h
//  hanokam
//
//  Created by Kenneth Pu on 6/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@class GameEngineScene;

// Animation states
typedef enum {
    AnimatedTextState_Hidden,
    AnimatedTextState_Entering,
    AnimatedTextState_Showing
} AnimatedTextState;

@interface SPAnimatedText : CCNode

@property (nonatomic, readonly) AnimatedTextState state;

/**
 *  Returns an instance of SPAnimatedText
 *
 *  @param  game        an object containing information about the current game state
 *  @param  text        the text to display
 */
+(SPAnimatedText*)cons:(GameEngineScene*)game withText:(NSString*)text;

/**
 *  Update state, handles interactions with other elements in the game
 *
 *  @param  game        an object containing information about the current game state
 */
-(void)i_update:(GameEngineScene*)game;

/**
 *  Signal to begin showing text
 */
-(void)beginEntering;

/**
 *  Signal to skip any entry animations and immediately show text
 */
-(void)forceShowing;

@end
