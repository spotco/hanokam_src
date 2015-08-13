//
//  BGCharacterPlayer.m
//  hanokam
//
//  Created by spotco on 12/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BGCharacterPlayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Common.h"

@implementation BGCharacterPlayer

+(BGCharacterPlayer*)cons:(GameEngineScene*)g {
	return [BGCharacterPlayer node];
}

-(NSString*)get_dialog_title {
	return @"Hanoka";
}

-(TexRect*)get_head_icon {
	TexRect *rtv = [super get_head_icon];
	[rtv setTex:[Resource get_tex:TEX_UI_DIALOGUE_HEADICONS]];
	[rtv setRect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_HEADICONS idname:@"head_hanoka.png"]];
	return rtv;
}

@end
