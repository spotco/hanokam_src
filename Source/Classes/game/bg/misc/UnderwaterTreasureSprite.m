//
//  UnderwaterTreasureSprite.m
//  hanokam
//
//  Created by spotco on 11/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "UnderwaterTreasureSprite.h"
#import "Resource.h" 
#import "FileCache.h"
#import "Common.h"

@implementation UnderwaterTreasureSprite {
	CCSprite *_img;
	NSMutableArray *_lights;
	BOOL _play_anim;
}
+(UnderwaterTreasureSprite*)cons {
	return [[UnderwaterTreasureSprite node] cons];
}
-(UnderwaterTreasureSprite*)cons {
	_img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"underwater_temple_treasure.png"]];
	[self addChild:_img z:1];
	
	_lights = [NSMutableArray array];
	DO_FOR(5,
		CCSprite *itr = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"treasure_light.png"]];
		[itr setAnchorPoint:ccp(0.5,0)];
		[itr setRotation:i*(360.0/5)];
		[self addChild:itr z:0];
		[_lights addObject:itr];
	);
	_play_anim = YES;
	return self;
}
-(void)play_anim:(BOOL)play {
	_play_anim = play;
}
-(void)update:(CCTime)delta {
	if (!self.visible || !_play_anim) return;
	DO_FOR(_lights.count,
		CCSprite *itr = _lights[i];
		itr.rotation = itr.rotation + 1.5 * dt_scale_get();
	);
}
@end
