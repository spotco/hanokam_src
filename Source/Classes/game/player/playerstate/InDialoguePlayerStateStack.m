//
//  InDialoguePlayerStateStack.m
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "InDialoguePlayerStateStack.h"
#import "BGCharacterBase.h"

@implementation InDialoguePlayerStateStack {
    BGCharacterBase* _with_character;
}

+(InDialoguePlayerStateStack*)cons:(GameEngineScene *)g withCharacter:(BGCharacterBase *)character {
    return [[[InDialoguePlayerStateStack alloc] init] cons:g withCharacter:character];
}

-(InDialoguePlayerStateStack*)cons:(GameEngineScene*)g withCharacter:(BGCharacterBase *)character {
    g.player.rotation = 0;
    [g.player read_s_pos:g];
    [g.player play_anim:@"idle" repeat:YES];
    
    _with_character = character;
    return self;
}

-(void)i_update:(GameEngineScene *)g {
    [g set_zoom:drp(g.get_zoom,2.5,20)];
    [g set_camera_height:drp(g.get_current_camera_center_y,g.player.position.y,20)];
    if (g.get_control_manager.is_proc_tap) {
        [g.player pop_state_stack:g];
        [_with_character doneSpeaking];
    }
}

@end


