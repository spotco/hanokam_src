//
//  DialogUI.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@class GameEngineScene;

// Dialog states
typedef enum {
    DialogState_FadeIn,
    DialogState_ShowingText,
    DialogState_ShowComplete,
    DialogState_FadeOut,
    DialogState_CanRemove
} DialogState;

/**
 *  @class  DialogUI
 *
 *  Manages the display of conversation dialogs
 */
@interface DialogUI : CCNode

@property (nonatomic, readonly) DialogState state;

/**
 *  Returns an instance of DialogUI
 *
 *  @param  game        an object containing information about the current game state
 *  @param  text        the text to display
 */
+(DialogUI*)cons:(GameEngineScene*)game withText:(NSString*)text;

/**
 *  Update state, handles interactions with other elements in the game
 *
 *  @param  game        an object containing information about the current game state
 */
-(void)i_update:(GameEngineScene*)game;


@end
