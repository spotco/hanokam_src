//
//  DialogueBubble.m
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DialogueBubble.h"
#import "Resource.h"
#import "FileCache.h"
#import "Common.h"
#import "GameEngineScene.h"

typedef enum {
    DialogueBubbleState_Hidden,
    DialogueBubbleState_FadeIn,
    DialogueBubbleState_Showing,
    DialogueBubbleState_FadeOut
} DialogueBubbleState;

@implementation DialogueBubble {
    CCSprite *_sprite;
    CCLabelTTF *_label;
    DialogueBubbleState _state;
    
    float _fade_t;
}

+(DialogueBubble*)cons {
    return [[DialogueBubble node] cons];
}

-(DialogueBubble*)cons {
    _sprite = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"thought_cloud_0.png"]];
    [_sprite runAction:animaction_cons(@[@"thought_cloud_0.png",@"thought_cloud_1.png"], 0.5, TEX_HUD_SPRITESHEET)];
    [_sprite setScale:0];
    _label = label_cons(ccp(175,100), ccc3(0, 0, 0), 20, @". . .");
    [_label setOpacity:0];
    [_sprite addChild:_label];
    [_sprite setOpacity:0];
    [self addChild:_sprite];
    return self;
}

-(void)i_update:(BOOL)shouldShow {
    switch (_state) {
        case DialogueBubbleState_Hidden:
            if (shouldShow) {
                _state = DialogueBubbleState_FadeIn;
            }
            break;
        case DialogueBubbleState_FadeIn:
            if (!shouldShow) {
                _state = DialogueBubbleState_FadeOut;
            }
            CGFloat newOpacity = _sprite.opacity + 0.1*dt_scale_get();
            if (newOpacity > 1) {
                newOpacity = 1;
                _state = DialogueBubbleState_Showing;
            }
            [_sprite setOpacity:newOpacity];
            [_label setOpacity:newOpacity];
            [_sprite setScale:newOpacity/5.];
            break;
        case DialogueBubbleState_Showing:
            if (!shouldShow) {
                _state = DialogueBubbleState_FadeOut;
            }
            break;
        case DialogueBubbleState_FadeOut:
            if (shouldShow) {
                _state = DialogueBubbleState_FadeIn;
            }
            newOpacity = _sprite.opacity - 0.1*dt_scale_get();
            if (newOpacity < 0) {
                newOpacity = 0;
                _state = DialogueBubbleState_Hidden;
            }
            [_sprite setOpacity:newOpacity];
            [_label setOpacity:newOpacity];
            [_sprite setScale:newOpacity/5.];
            break;
        default:
            break;
    }
}

@end
