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
#import "SPAnimatedText.h"
#import "SPAnimatedTextCharacter.h"

CGFloat BG_HORIZONTAL_INSET = 10;
CGFloat BG_VERTICAL_INSET = 10;
CGFloat BG_SCREEN_HEIGHT_PERCENT = 0.33f;

@interface DialogUI()
@property (nonatomic, readwrite) DialogState state;
@end

@implementation DialogUI {
    AlphaGradientSprite *_bgBox;
    SPAnimatedText *_animatedTextLabel;
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
    
    // Create animated text label
    _animatedTextLabel = [SPAnimatedText cons:game withText:text];
    [_bgBox addChild:_animatedTextLabel];
    
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
                // Once max is reached, start animating in text, proceed to SHOWING_TEXT state
                [_bgBox setPosition:ccp(BG_HORIZONTAL_INSET,BG_VERTICAL_INSET)];
                [_bgBox setOpacity:1];
                [_bgBox setScale:1];
                t = 0;
                [_animatedTextLabel beginEntering];
                [_animatedTextLabel i_update:game];
                self.state = DialogState_ShowingText;
            }
            
            // If player taps dialog, proceed directly to SHOW_COMPLETE state
            if (game.get_control_manager.is_proc_tap) {
                [_bgBox setPosition:ccp(BG_HORIZONTAL_INSET,BG_VERTICAL_INSET)];
                [_bgBox setOpacity:1];
                [_bgBox setScale:1];
                self.state = DialogState_ShowComplete;
                
                // Force animated text to proceed directly to SHOWING state
                [_animatedTextLabel forceShowing];
                [_animatedTextLabel i_update:game];
            }
            break;
        case DialogState_ShowingText:
            // Animate text
            [_animatedTextLabel i_update:game];
            
            // Once text is finished animating in, proceed to SHOW_COMPLETE
            if (_animatedTextLabel.state == AnimatedTextState_Showing) {
                self.state = DialogState_ShowComplete;
            }
            
            // If player taps dialog, proceed directly to SHOW_COMPLETE state
            if (game.get_control_manager.is_proc_tap) {
                self.state = DialogState_ShowComplete;
                
                // Force animated text to proceed directly to SHOWING state
                [_animatedTextLabel forceShowing];
            }
            break;
        case DialogState_ShowComplete:
            // Animate text
            [_animatedTextLabel i_update:game];
            
            // If player taps, begin fading out
            if (game.get_control_manager.is_proc_tap) {
                self.state = DialogState_Exiting;
            }
            break;
        case DialogState_Exiting:
            // Decrement opacity and scale. If min is reached, proceed to CAN_REMOVE state
            t += 0.1*dt_scale_get();
            if (t > 1) {
                t = 1;
                self.state = DialogState_CanRemove;
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
