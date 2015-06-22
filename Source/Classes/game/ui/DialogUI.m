//
//  DialogUI.m
//
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DialogUI.h"
#import "GameEngineScene.h"
#import "Player.h"
#import "Resource.h"
#import "FileCache.h"
#import "AlphaGradientSprite.h"
#import "ControlManager.h"
#import "SPAnimatedTextCharacter.h"

CGFloat BG_HORIZONTAL_INSET = 10;
CGFloat BG_VERTICAL_INSET = 10;
CGFloat BG_SCREEN_HEIGHT_PERCENT = 0.33f;
CGFloat CHAR_WIDTH = 9;
CGFloat SPACE_WIDTH = 6;

@interface DialogUI()
@property (nonatomic, readwrite) DialogState state;
@end

@implementation DialogUI {
    AlphaGradientSprite *_bgBox;
    NSArray *_charLabels;
    CGFloat t;
}

#pragma mark - Constructors

+(DialogUI*)cons:(GameEngineScene *)game withText:(NSString *)text {
    return [(DialogUI*)[DialogUI node] cons:game withText:text];
}

-(DialogUI*)cons:(GameEngineScene*)game withText:(NSString *)text {
    [self setAnchorPoint:ccp(0,0)];
    
    // Create background box for dialog
    CGSize boxSize = CGSizeMake(game_screen().width-2*BG_HORIZONTAL_INSET, game_screen().height*BG_SCREEN_HEIGHT_PERCENT);
    _bgBox = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_BLANK]
                                   texrect:cctexture_default_rect([Resource get_tex:TEX_BLANK])
                                      size:boxSize
                               anchorPoint:ccp(0,0)
                                     color:[CCColor blackColor]
                                    alphaX:CGRangeMake(1, 1)
                                    alphaY:CGRangeMake(0.1, 0.4)];
    [_bgBox setPosition:ccp(game_screen().width/2,BG_VERTICAL_INSET)];
    [_bgBox setOpacity:0];
    [_bgBox setScale:0];
    [self addChild:_bgBox];
    
    // Create array of character labels to display text
    NSMutableArray *labelsArray = [NSMutableArray array];
    CGFloat xPos = CHAR_WIDTH;
    for (int i=0; i< text.length; i++) {
        NSString *textCharacter = [text substringWithRange:NSMakeRange(i,1)];
        if (![textCharacter isEqualToString:@" "]) {
            // If current character is not a space, initialize an instance of SPAnimatedTextCharacter, increment xPos accordingly
            SPAnimatedTextCharacter *charLabel = [SPAnimatedTextCharacter cons:game
                                                                 withCharacter:[text substringWithRange:NSMakeRange(i,1)]
                                                                         color:[CCColor whiteColor]
                                                                     amplitude:3];
            charLabel.scale = 0.4f;
            [charLabel setPosition:ccp(xPos,0)];
            [charLabel setOpacity:0];
            [labelsArray addObject:charLabel];
            [_bgBox addChild:charLabel];
            xPos += CHAR_WIDTH;
        } else {
            // Otherwise simply incrment xPos
            xPos += SPACE_WIDTH;
        }
    }
    _charLabels = [NSArray arrayWithArray:labelsArray];
    
    // Initialize time variables
    t = 0;
    
    return self;
}

#pragma mark - State Machine

-(void)i_update:(GameEngineScene *)game {
    switch (self.state) {
        case DialogState_Entering:;
            t += 0.1*dt_scale_get();
            if (t < 1) {
                // Animate in dialog box
                CGFloat xPos = BG_HORIZONTAL_INSET+(1-t)*(game_screen().width/2-BG_HORIZONTAL_INSET);
                [_bgBox setPosition:ccp(xPos,BG_VERTICAL_INSET)];
                [_bgBox setOpacity:t];
                [_bgBox setScale:t];
            } else {
                // Once max is reached, proceed to SHOWING state
                [_bgBox setPosition:ccp(BG_HORIZONTAL_INSET,BG_VERTICAL_INSET)];
                [_bgBox setOpacity:1];
                [_bgBox setScale:1];
                t = 0;
                self.state = DialogState_ShowingText;
            }
            
            // If player taps dialog, proceed directly to SHOW_COMPLETE state
            if (game.get_control_manager.is_proc_tap) {
                [_bgBox setPosition:ccp(BG_HORIZONTAL_INSET,BG_VERTICAL_INSET)];
                [_bgBox setOpacity:1];
                [_bgBox setScale:1];
                self.state = DialogState_ShowComplete;
                
                // Force character labels to proceed directly to SHOWING state
                for (SPAnimatedTextCharacter *tc in _charLabels) {
                    [tc forceShowing];
                }
            }
            break;
        case DialogState_ShowingText:
            // Animate in text
            t += 0.2*dt_scale_get();
            if (t < _charLabels.count) {
                // Characters should begin appearing one after another
                int i = floor(t);
                [(SPAnimatedTextCharacter *)[_charLabels objectAtIndex:i] beginEntering];
                for (int j=0; j<=i; j++) {
                    // All characters that have appeared need to continue updating
                    [(SPAnimatedTextCharacter *)[_charLabels objectAtIndex:j] i_update:game ts:fmod((t-j),2*M_PI)];
                }
            } else {
                // Once all characters have appeared proceed to SHOW_COMPLETE state
                self.state = DialogState_ShowComplete;
                for (int i=0; i<_charLabels.count; i++) {
                    [(SPAnimatedTextCharacter *)[_charLabels objectAtIndex:i] i_update:game
                                                                                    ts:fmod((t-i),2*M_PI)];
                }
            }
            
            // If player taps dialog, proceed directly to SHOW_COMPLETE state
            if (game.get_control_manager.is_proc_tap) {
                self.state = DialogState_ShowComplete;
                // Force character labels to SHOWING state
                for (SPAnimatedTextCharacter *tc in _charLabels) {
                    [tc forceShowing];
                }
            }
            break;
        case DialogState_ShowComplete:
            // Keep t between 0 and 2PI
            t += 0.2*dt_scale_get();
            if (t >= 2*M_PI) {
                t -= 2*M_PI;
            }
            
            // Animate characters in wave pattern
            for (int i=0; i<_charLabels.count; i++) {
                [(SPAnimatedTextCharacter *)[_charLabels objectAtIndex:i] i_update:game
                                                                                ts:fmod((t-i),2*M_PI)+2*M_PI];
            }
            
            // If player taps, begin fading out
            if (game.get_control_manager.is_proc_tap) {
                self.state = DialogState_Exiting;
                t = 0;
                // Have character labels proceed to EXITING state
                for (SPAnimatedTextCharacter *tc in _charLabels) {
                    [tc beginExiting];
                    [tc i_update:game ts:t];
                }
            }
            break;
        case DialogState_Exiting:
            // Decrement opacity and scale. If min is reached, proceed to CAN_REMOVE state
            t += 0.1*dt_scale_get();
            if (t > 1) {
                t = 1;
                self.state = DialogState_CanRemove;
            }
            
            // Fade out character labels
            for (SPAnimatedTextCharacter *tc in _charLabels) {
                [tc i_update:game ts:t];
            }
            
            // Animate out dialog box
            CGFloat xPos = BG_HORIZONTAL_INSET+t*(game_screen().width/2-BG_HORIZONTAL_INSET);
            [_bgBox setPosition:ccp(xPos,_bgBox.position.y)];
            [_bgBox setOpacity:(1-t)];
            [_bgBox setScale:(1-t)];
            break;
        case DialogState_CanRemove:
            // Wait here to be removed
            break;
        default:
            break;
    }
}
@end
