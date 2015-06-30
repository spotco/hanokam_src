//
//  DialogUI.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameUI.h"

@class GameEngineScene;

// Dialog states
typedef enum {
    DialogState_Entering,
    DialogState_ShowingText,
    DialogState_ShowComplete,
    DialogState_Exiting,
    DialogState_CanRemove
} DialogState;

/**
 *  @class  DialogUI
 *
 *  Manages the display of conversation dialogs
 */
@interface DialogUI : GameUISubView

@property (nonatomic, readonly) DialogState state;

/**
 *  Returns an instance of DialogUI
 *
 *  @param  game        an object containing information about the current game state
 *  @param  text        the text to display
 */
+(DialogUI*)cons:(GameEngineScene *)game;
-(DialogUI*)start:(GameEngineScene*)game withText:(NSString *)text;


@end
