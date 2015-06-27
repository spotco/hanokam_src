//
//  TestScene.m
//  hanokam
//
//  Created by spotco on 27/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TestScene.h"
#import "Resource.h" 
#import "FileCache.h" 
#import "SpriterNode.h"
#import "SpriterData.h"
#import "SpriterJSONParser.h"
#import "Common.h"

@implementation TestScene

+(TestScene*)cons {
	return [[TestScene node] cons];
}

-(TestScene*)cons {
	
	/*
	SpriterData *data = [SpriterData cons_data_from_spritesheetreaders:@[
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_TEST] file:@"spriter_test.json"]
	] scml:@"spriter_test.scml"];
	SpriterNode *_img = [SpriterNode nodeFromData:data];
	[_img playAnim:@"Test2" repeat:YES];
	[_img setPosition:game_screen_pct(0.5, 0.5)];
	[_img setScale:0.25];
	[self addChild:_img];
	*/

	/*
	SpriterData *data = [SpriterData cons_data_from_spritesheetreaders:@[
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_OLDMAN] file:@"oldman_ss.json"]
	] scml:@"oldman.scml"];
	SpriterNode *_img = [SpriterNode nodeFromData:data];
	[_img playAnim:@"idle" repeat:YES];
	[_img setPosition:game_screen_pct(0.5, 0.5)];
	[_img set_render_placement:ccp(0.5,0.1)];
	[self addChild:_img];
	*/
	
	SpriterData *data = [SpriterData cons_data_from_spritesheetreaders:@[
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_PLAYER] file:@"hanoka_player.json"],
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_BOW] file:@"hanoka_bow.json"],
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_SWORD] file:@"hanoka_sword.json"],
	] scml:@"hanoka_player.scml"];
	SpriterNode *_img = [SpriterNode nodeFromData:data render_size:ccp(100,250)];
	[_img playAnim:@"Idle" repeat:YES];
	[_img setPosition:game_screen_pct(0.5, 0.5)];
	[self addChild:_img];

	/*
	CCSprite *test = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BLANK]];
	[test setScale:20];
	[test setPosition:game_screen_pct(0.5, 0.5)];
	[self addChild:test z:999];
	*/
	return self;
}

@end
