//
//  InDialoguePlayerStateStack.m
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "InDialoguePlayerStateStack.h"
#import "BGCharacterBase.h"
#import "DialogUI.h"

@implementation InDialoguePlayerStateStack {
    BGCharacterBase* _with_character;
    DialogUI *_dialogUI;
}

+(InDialoguePlayerStateStack*)cons:(GameEngineScene *)g withCharacter:(BGCharacterBase *)character {
    return [[[InDialoguePlayerStateStack alloc] init] cons:g withCharacter:character];
}

-(InDialoguePlayerStateStack*)cons:(GameEngineScene*)g withCharacter:(BGCharacterBase *)character {
    g.player.rotation = 0;
    [g.player read_s_pos:g];
    [g.player play_anim:@"Idle" repeat:YES];
    
    _with_character = character;
    
    _dialogUI = [DialogUI cons:g withText:@"test"];
    [g.get_ui addChild:_dialogUI];
    
    return self;
}

-(void)i_update:(GameEngineScene *)g {
    [g set_zoom:drp(g.get_zoom,2.5,20)];
    [g set_camera_height:drp(g.get_current_camera_center_y,g.player.position.y,20)];
    
    [_dialogUI i_update:g];
    
    if (_dialogUI.state == DialogState_CanRemove) {
        [g.player pop_state_stack:g];
    }
}

-(void)on_state_end:(GameEngineScene *)game {
    [_with_character doneSpeaking];
    [game.get_ui removeChild:_dialogUI];
}

@end


