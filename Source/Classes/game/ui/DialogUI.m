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

CGFloat BG_HORIZONTAL_INSET = 10;
CGFloat BG_VERTICAL_INSET = 10;
CGFloat BG_SCREEN_HEIGHT_PERCENT = 0.33f;

@implementation DialogUI {
    AlphaGradientSprite *_bgBox;
    NSString *_text;
}

+(DialogUI*)cons:(GameEngineScene *)game withText:(NSString *)text {
    return [(DialogUI*)[DialogUI node] cons:game withText:text];
}

-(DialogUI*)cons:(GameEngineScene*)game withText:(NSString *)text {
    [self setAnchorPoint:ccp(0,0)];
    
    CGSize boxSize = CGSizeMake(game_screen().width-2*BG_HORIZONTAL_INSET, game_screen().height*BG_SCREEN_HEIGHT_PERCENT);
    
    _bgBox = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_BLANK]
                                   texrect:cctexture_default_rect([Resource get_tex:TEX_BLANK])
                                      size:boxSize
                               anchorPoint:ccp(0,0)
                                     color:[CCColor blackColor]
                                    alphaX:CGRangeMake(1, 1)
                                    alphaY:CGRangeMake(0.1, 0.4)];
    [_bgBox setPosition:ccp(BG_HORIZONTAL_INSET,BG_VERTICAL_INSET)];
    [_bgBox setOpacity:0];
    [_bgBox setScale:0];
    [self addChild:_bgBox];
    
    _text = text;
    
    return self;
}

-(void)i_update:(GameEngineScene *)game {
    switch (self.state) {
        case DialogState_FadeIn:;
            // Increment opacity and scale. If max is reached, proceed to SHOWING_TEXT state
            CGFloat newOpacity = _bgBox.opacity + 0.1*dt_scale_get();
            if (newOpacity > 1) {
                newOpacity = 1;
                _state = DialogState_ShowingText;
            }
            [_bgBox setOpacity:newOpacity];
            [_bgBox setScale:newOpacity];
            // If player taps dialog, proceed directly to SHOW_COMPLETE state
            if (game.get_control_manager.is_proc_tap) {
                [_bgBox setOpacity:1];
                [_bgBox setScale:1];
                _state = DialogState_ShowComplete;
            }
            break;
        case DialogState_ShowingText:
            // Animate in text
            // For now proceed to SHOW_COMPLETE state
            _state = DialogState_ShowComplete;
            break;
        case DialogState_ShowComplete:
            // If player taps, begin fading out
            if (game.get_control_manager.is_proc_tap) {
                _state = DialogState_FadeOut;
            }
            break;
        case DialogState_FadeOut:
            // Decrement opacity and scale. If min is reached, proceed to CAN_REMOVE state
            newOpacity = _bgBox.opacity - 0.1*dt_scale_get();
            if (newOpacity < 0) {
                newOpacity = 0;
                _state = DialogState_CanRemove;
            }
            [_bgBox setOpacity:newOpacity];
            [_bgBox setScale:newOpacity];
            break;
        default:
            break;
    }
}
@end
