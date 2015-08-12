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
#import "DialogEvent.h"

@implementation InDialoguePlayerStateStack {
    BGCharacterBase* _with_character;
    DialogUI *_dialog_ui;
	
	NSArray *_dialog_events;
	int _i_dialog_events;
}

+(InDialoguePlayerStateStack*)cons:(GameEngineScene *)g with_character:(BGCharacterBase *)character {
    return [[[InDialoguePlayerStateStack alloc] init] cons:g with_character:character];
}

-(InDialoguePlayerStateStack*)cons:(GameEngineScene*)g with_character:(BGCharacterBase *)character {
    g.player.rotation = 0;
    [g.player read_s_pos:g];
    [g.player play_anim:@"Idle" repeat:YES];
    
    _with_character = character;
	
    _dialog_ui = (DialogUI*)[g.get_ui ui_for_playerstate:PlayerState_InDialogue];
	
	_dialog_events = [_with_character get_dialog_list];
	_i_dialog_events = 0;
	[self run_current_dialog_event:g];
    return self;
}

-(void)run_current_dialog_event:(GameEngineScene*)g {
	DialogEvent *evt = [_dialog_events objectAtIndex:_i_dialog_events];
	[_dialog_ui show_message:evt.get_text from_character:_with_character g:g];
}

-(void)i_update:(GameEngineScene *)g {
    [g set_zoom:drpt(g.get_zoom,2.5,1/20.0)];
    [g set_camera_height:drpt(g.get_current_camera_center_y,g.player.position.y,1/20.0)];
	if (g.get_control_manager.is_proc_tap) {
		if ([_dialog_ui is_ready_for_next_message]) {
			_i_dialog_events++;
			if (_i_dialog_events < _dialog_events.count) {
				[self run_current_dialog_event:g];
				
			} else {
				[g.player pop_state_stack:g];
			}
			
		} else {
			[_dialog_ui fast_forward_message_to_end];
		}
	}

}

-(void)on_state_end:(GameEngineScene *)game {
	_dialog_ui = NULL;
	_with_character = NULL;
	_dialog_events = NULL;
}

-(PlayerState)get_state {
	return PlayerState_InDialogue;
}

@end


