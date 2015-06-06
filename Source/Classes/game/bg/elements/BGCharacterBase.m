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

// Range to enable dialogue
static NSUInteger const DIALOGUE_RANGE = 20;
static CGFloat const TAP_RANGE = 50;

@implementation BGCharacterBase

@synthesize dialogueOffset = _dialogueOffset;

-(void)i_update:(GameEngineScene*)g {
    // Only handle state transitions if player is currently on the dock
    if (g.get_player_state == PlayerState_OnGround && g.player.getLandParams._current_mode == PlayerLandMode_OnDock) {
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
                // If tapped, proceed to SPEAKING state, move player to IN_DIALOGUE state
                if (g.get_control_manager.is_proc_tap) {
                    CGPoint p1 = g.get_control_manager.get_proc_tap;
                    CGPoint p2 = [self convertToWorldSpace:CGPointZero];
                    if (CGPointDist(p1, p2) < TAP_RANGE) {
                        _state = BGCharacter_Speaking;
    //                    g._player_state = PlayerState_InDialogue;
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
                // Once dialogue dismissed, move to CAN_SPEAK state, move player back to ON_GROUND state
                _state = BGCharacter_CanSpeak;
    //            g._player_state = PlayerState_OnGround;
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
