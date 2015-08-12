//
//  BGSky.m
//  hobobob
//
//  Created by spotco on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BGVillage.h"
#import "Common.h"
#import "Resource.h"
#import "CCTexture_Private.h"
#import "BGReflection.h"
#import "Player.h"
#import "ShaderManager.h"
#import "FileCache.h"

#import "BGCharacterOldMan.h"
#import "BGCharacterVillagerFishGirl.h"
#import "BGCharacterVillagerFishWoman.h"

#import "BGCharacterTest.h"

@implementation BGVillage {
	CCSprite *_sky_bg;
	CCSprite *_docks,*_bldg_1, *_bldg_2, *_bldg_3, *_bldg_4;
	
    NSMutableArray *_villagers;
	BGCharacterOldMan *_old_man;
	BGCharacterVillagerFishGirl *_fish_girl;
	//BGCharacterVillagerFishWoman *_fish_woman;
	BGCharacterTest *_test_character;
	
	CCNode *_docks_bottom_anchor, *_left_building_anchor;
	
	NSMutableArray *_above_water_elements, *_below_water_elements;
}
+(BGVillage*)cons:(GameEngineScene *)g {
	return [[[BGVillage alloc] init] cons:g];
}

-(BGVillage*)cons:(GameEngineScene *)g {
	_above_water_elements = [NSMutableArray array];
	_below_water_elements = [NSMutableArray array];
    _villagers = [NSMutableArray array];
	
	_sky_bg = [CCSprite node];
	[[g get_anchor] addChild:_sky_bg z:GameAnchorZ_BGSky_RepeatBG];
	[_above_water_elements addObject:_sky_bg];
	[_sky_bg setTexture:[Resource get_tex:TEX_TEST_BG_TILE_SKY]];
	[_sky_bg set_anchor_pt:ccp(0,0)];
	ccTexParams par = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
	[_sky_bg.texture setTexParameters:&par];
	
	_bldg_4 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"bg_4.png"]];
	[[g get_anchor] addChild:_bldg_4 z:GameAnchorZ_BGSky_BackgroundElements];
	[_above_water_elements addObject:_bldg_4];
	[_bldg_4 set_scale:0.5];
	scale_to_fit_screen_x(_bldg_4);
	[_bldg_4 set_pos:ccp(game_screen().width,0)];
	[_bldg_4 set_anchor_pt:ccp(1,0)];
	
	_bldg_3 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"bg_3.png"]];
	[[g get_anchor] addChild:_bldg_3 z:GameAnchorZ_BGSky_BackgroundElements];
	[_above_water_elements addObject:_bldg_3];
	[_bldg_3 set_scale:0.5];
	[_bldg_3 set_pos:ccp(game_screen().width,0)];
	[_bldg_3 set_anchor_pt:ccp(1,0)];
	
	_bldg_2 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"bg_2.png"]];
	[[g get_anchor] addChild:_bldg_2 z:GameAnchorZ_BGSky_Elements];
	[_above_water_elements addObject:_bldg_2];
	[_bldg_2 set_scale:0.5];
	[_bldg_2 set_pos:ccp(game_screen().width,0)];
	[_bldg_2 set_anchor_pt:ccp(1,0)];
	
	_bldg_1 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"bg_1.png"]];
	[[g get_anchor] addChild:_bldg_1 z:GameAnchorZ_BGSky_Elements];
	[_above_water_elements addObject:_bldg_1];
	[_bldg_1 setScale:0.5];
	[_bldg_1 set_pos:ccp(0,0)];
	[_bldg_1 set_anchor_pt:ccp(0,0)];
	
	_left_building_anchor = [CCNode node];
	[_left_building_anchor setPosition:pct_of_obj(_bldg_1, 0.8, 0.41)];
	[_bldg_1 addChild:_left_building_anchor];
	
	_old_man = [BGCharacterOldMan cons_pos:CGPointZero];
	[_old_man set_anchor_object:_left_building_anchor];
	[_old_man set_anchor_relative_position:CGPointZero g:g];
    [_villagers addObject:_old_man];
    [g.get_anchor addChild:_old_man z:GameAnchorZ_BGVillage_Character];
	
	
	_docks = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"pier_top.png"]];
	[[g get_anchor] addChild:_docks z:GameAnchorZ_BGSky_Docks];
	[_above_water_elements addObject:_docks];
	scale_to_fit_screen_x(_docks);
	_docks.scaleY = _docks.scaleX;
	[_docks set_pos:ccp(0,0)];
	[_docks set_anchor_pt:ccp(0,0)];
	
	_docks_bottom_anchor = [CCNode node];
	[_docks_bottom_anchor setPosition:pct_of_obj(_docks, 0, 0.6)];
	[_docks addChild:_docks_bottom_anchor];
	
	_fish_girl = [BGCharacterVillagerFishGirl cons_pos:CGPointZero];
	[_fish_girl set_anchor_object:_docks_bottom_anchor];
	[_fish_girl set_anchor_relative_position:ccp(game_screen().width*0.75,0) g:g];
	[_villagers addObject:_fish_girl];
	[g.get_anchor addChild:_fish_girl z:GameAnchorZ_BGVillage_Character];
	
	
	CCSprite *docks_front = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SPRITESHEET_1] rect:[FileCache get_cgrect_from_plist:TEX_BG_SPRITESHEET_1 idname:@"pier_top_front_pillars.png"]];
	[[g get_anchor] addChild:docks_front z:GameAnchorZ_BGSky_Docks_Pillars_Front];
	[_above_water_elements addObject:docks_front];
	scale_to_fit_screen_x(docks_front);
	docks_front.scaleY = docks_front.scaleX;
	[docks_front set_pos:ccp(0,0)];
	[docks_front set_anchor_pt:ccp(0,0)];
	
	return self;
}

-(void)render_reflection:(GameEngineScene*)game offset:(CGPoint)offset {
	float y;
	
	y = _bldg_4.position.y;
	_bldg_4.position = ccp(_bldg_4.position.x,80);
	[_bldg_4 visit];
	_bldg_4.position = ccp(_bldg_4.position.x,y);
	
	y = _bldg_3.position.y;
	_bldg_3.position = ccp(_bldg_3.position.x,80);
	[_bldg_3 visit];
	_bldg_3.position = ccp(_bldg_3.position.x,y);
	
	
	[BGReflection bgobj_reflection_render:_bldg_2 offset:ccp(0,offset.y) g:game];
	[BGReflection bgobj_reflection_render:_bldg_1 offset:ccp(0,offset.y) g:game];
	[BGReflection reflection_render:_docks offset:ccp(0,game.HORIZON_HEIGHT/2 - offset.y) g:game];
}

-(void)render_underwater_reflection {
	[self above_water_root_set_visible:YES];
	[BGReflection above_water_below_render:_sky_bg];
	[BGReflection above_water_below_render:_bldg_4];
	[BGReflection above_water_below_render:_bldg_3];
	[BGReflection above_water_below_render:_bldg_2];
	[BGReflection above_water_below_render:_bldg_1];
	[BGReflection above_water_below_render:_docks];
	[self above_water_root_set_visible:NO];
	[self below_water_root_set_visible:YES];
}

-(void)set_bgobj_positions:(GameEngineScene*)game {
	float camera_y = game.get_current_camera_center_y;
	_bldg_1.position = ccp(_bldg_1.position.x,clampf(camera_y*.1, 0, game.HORIZON_HEIGHT));
	_bldg_2.position = ccp(_bldg_2.position.x,clampf(camera_y*.2, 0, game.HORIZON_HEIGHT));
	_bldg_3.position = ccp(_bldg_3.position.x,camera_y*.25);
	_bldg_4.position = ccp(_bldg_4.position.x,camera_y*.45);
}

-(void)above_water_root_set_visible:(BOOL)tar {
	for(CCNode *itr in _above_water_elements) [itr setVisible:tar];
 }
-(void)below_water_root_set_visible:(BOOL)tar { for(CCNode *itr in _below_water_elements) [itr setVisible:tar]; }

-(void)i_update:(GameEngineScene*)g {	
	if ([g.player is_underwater:g] && g.get_current_camera_center_y > -game_screen().height) {
		[self above_water_root_set_visible:NO];
		[self below_water_root_set_visible:YES];
		
	} else {
		[self above_water_root_set_visible:YES];
		[self below_water_root_set_visible:NO];
	}
	
	for (BGCharacterBase *itr in _villagers) {
		[itr i_update:g];
	}
	
	[_sky_bg setTextureRect:CGRectMake(
		0,
		MAX(0, [g get_viewbox].y1),
		game_screen().width,
		MAX(0, [g get_viewbox].y2 + game_screen().height)
	)];
	[self set_bgobj_positions:g];
}

-(NSArray*)get_villagers {
    return _villagers;
}

@end