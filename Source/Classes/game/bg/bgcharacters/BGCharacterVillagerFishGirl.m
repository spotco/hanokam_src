#import "BGCharacterVillagerFishGirl.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Common.h"
#import "DialogEvent.h"
#import "Player.h"

#import "SpriterNode.h"
#import "SpriterJSONParser.h"
#import "SpriterData.h"

@implementation BGCharacterVillagerFishGirl {
	SpriterNode *_img;
}

+(BGCharacterVillagerFishGirl*)cons_pos:(CGPoint)pos {
	return [[BGCharacterVillagerFishGirl node] cons_pos:pos];
}

-(BGCharacterVillagerFishGirl*)cons_pos:(CGPoint)pos {
	[self setPosition:pos];
	
	SpriterData *data = [SpriterData cons_data_from_spritesheetreaders:@[
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_FISHGIRL] file:@"Fishgirl.json"]
	] scml:@"Fishgirl.scml"];
	_img = [SpriterNode nodeFromData:data render_size:ccp(150,400)];
	[_img set_render_placement:ccp(0.5,0.5)];
	[_img p_play_anim:@"Idle Talk" repeat:YES];
	[self addChild:_img];
	
	[self setScale:0.4];
	
	return self;
}

-(NSString*)get_dialog_title {
	return @"Little Girl";
}

-(SPLabelStyle*)get_dialog_default_style {
	SPLabelStyle *rtv = [super get_dialog_default_style];
	[rtv set_fill:ccc4f(221/255.0, 201/255.0, 170/255.0, 1) stroke:ccc4f(114/255.0, 106/255.0, 94/255.0, 1) shadow:ccc4f(0, 0, 0, 1)];
	return rtv;
}

-(SPLabelStyle*)get_dialog_emph_style {
	SPLabelStyle *rtv = [super get_dialog_emph_style];
	[rtv set_fill:ccc4f(220/255.0, 197/255.0, 70/255.0, 1) stroke:ccc4f(120/255.0, 100/255.0, 50/255.0, 1) shadow:ccc4f(0, 0, 0, 1)];
	rtv._amplitude = 7;
	rtv._time_incr = 0.75;
	return rtv;
}

-(NSArray*)get_dialog_list:(GameEngineScene *)g {
	return @[
		[DialogEvent cons_text:@"Oh hey sis, let me guess...\nOff to [emph]save the world@\nagain or something?" speaker:self],
		[DialogEvent cons_text:@"Uh...yeah.\nSomething like that." speaker:g.player.get_player_dialogue_character]
	];
}

-(TexRect*)get_head_icon {
	TexRect *rtv = [super get_head_icon];
	[rtv setTex:[Resource get_tex:TEX_UI_DIALOGUE_HEADICONS]];
	[rtv setRect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_HEADICONS idname:@"head_fishgirl.png"]];
	return rtv;
}

-(CGPoint)get_dialog_icon_offset { return ccp(-10,50); }

-(HitRect)get_hit_rect:(GameEngineScene *)g {
	return hitrect_cons_xy_widhei(self.position.x-20, self.position.y, 40, 40);
}
@end