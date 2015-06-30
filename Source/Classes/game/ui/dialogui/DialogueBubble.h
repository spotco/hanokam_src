//
//  DialogueBubble.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
@class GameEngineScene;
/**
 *  @class  DialogueBubble
 *
 *  Dialogue bubble to indicate that a character can be spoken to
 */
@interface DialogueBubble : CCNode

/**
 *  Constructs and returns an instance of DialogueBubble
 */
+(DialogueBubble*)cons;

/**
 *  Update the state of the dialogue bubble
 *
 *  @param  shouldShow      whether or not the bubble should be showing
 */
-(void)i_update:(GameEngineScene*)g shouldShow:(BOOL)shouldShow;

@end
