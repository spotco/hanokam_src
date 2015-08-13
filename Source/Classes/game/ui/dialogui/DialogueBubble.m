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

@implementation DialogueBubble {
    CCSprite *_sprite;
}

+(DialogueBubble*)cons {
    return [[DialogueBubble node] cons];
}

-(DialogueBubble*)cons {
    _sprite = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"thought_cloud_0.png"]];
    [_sprite runAction:animaction_cons(@[@"thought_cloud_0.png",@"thought_cloud_1.png"], 0.5, TEX_HUD_SPRITESHEET)];
    [_sprite setScale:0.15];
    [_sprite setOpacity:0.8];
	
    [self addChild:_sprite];
    
    return self;
}

-(void)i_update:(GameEngineScene *)g shouldShow:(BOOL)shouldShow {
	[self setScale:g.get_zoom];
}

@end
