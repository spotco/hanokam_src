//
//  BGCharacterBase.m
//  hanokam
//
//  Created by Kenneth Pu on 6/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BGCharacterBase.h"
#import "GameEngineScene.h"
#import "Resource.h"
#import "FileCache.h"
#import "Player.h"
#import "ControlManager.h"
#import "Common.h"
#import "PlayerLandParams.h"
#import "BasePlayerStateStack.h"

// Range to enable dialogue
static NSUInteger const DIALOGUE_RANGE = 25;
static CGFloat const TAP_RANGE = 50;

@implementation BGCharacterBase

@synthesize dialogueOffset = _dialogueOffset;

-(void)i_update:(GameEngineScene*)g {
    // Only handle state transitions if player is currently on the dock
    if (g.get_player_state == PlayerState_OnGround && [g.player.get_top_state on_land:g]) {
        switch (self.state) {
            case BGCharacter_Idle:;
                // Proceed to CAN_SPEAK state if player is within range
                CGFloat x1 = [g.player convertToWorldSpace:CGPointZero].x;
                CGFloat x2 = [self convertToWorldSpace:CGPointZero].x;
                if (abs(x1 - x2) < DIALOGUE_RANGE) {
                    _state = BGCharacter_CanSpeak;
                }
                break;
            case BGCharacter_CanSpeak:
                // If tapped, proceed to SPEAKING state
                if (g.get_control_manager.is_proc_tap) {
                    CGPoint p1 = g.get_control_manager.get_proc_tap;
                    CGPoint p2 = [self convertToWorldSpace:CGPointZero];
                    if (CGPointDist(p1, p2) < TAP_RANGE) {
                        _state = BGCharacter_Speaking;
                        break;
                    }
                }
                // If player leaves range move to IDLE state
                x1 = [g.player convertToWorldSpace:CGPointZero].x;
                x2 = [self convertToWorldSpace:CGPointZero].x;
                if (abs(x1 - x2) > DIALOGUE_RANGE) {
                    _state = BGCharacter_Idle;
                }
                break;
            case BGCharacter_Speaking:
                NSLog(@"SUP BRO");
                // Once dialogue dismissed, move to CAN_SPEAK state,
                if (g.get_control_manager.is_proc_tap) {
                    _state = BGCharacter_CanSpeak;
                }
                [g set_zoom:drp(g.get_zoom,2.5,20)];
                [g set_camera_height:drp(g.get_current_camera_center_y,g.player.position.y,20)];
                break;
            default:
                break;
        }
    } else {
        // Otherwise stay in IDLE state
        _state = BGCharacter_Idle;
    }
}

@end
