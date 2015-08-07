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
    
    //_dialogUI = (DialogUI*)[g.get_ui ui_for_playerstate:PlayerState_InDialogue];
	//[_dialogUI start:g withText:character.dialogueText];
    
    return self;
}

-(void)i_update:(GameEngineScene *)g {
    [g set_zoom:drpt(g.get_zoom,2.5,1/20.0)];
    [g set_camera_height:drpt(g.get_current_camera_center_y,g.player.position.y,1/20.0)];
	/*
    if (_dialogUI.state == DialogState_CanRemove) {
        [g.player pop_state_stack:g];
    }
	*/
}

-(void)on_state_end:(GameEngineScene *)game {
    [_with_character doneSpeaking];
	_dialogUI = NULL;
}

-(PlayerState)get_state {
	return PlayerState_InDialogue;
}

@end


