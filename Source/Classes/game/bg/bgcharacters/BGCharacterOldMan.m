#import "BGCharacterOldMan.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Common.h"
#import "DialogEvent.h"
#import "Player.h"

#import "SpriterNode.h"
#import "SpriterJSONParser.h"
#import "SpriterData.h"

@implementation BGCharacterOldMan {
	SpriterNode *_img;
}

+(BGCharacterOldMan*)cons_pos:(CGPoint)pos {
	return [[BGCharacterOldMan node] cons_pos:pos];
}

-(BGCharacterOldMan*)cons_pos:(CGPoint)pos {
	[self setPosition:pos];
	
	SpriterData *data = [SpriterData cons_data_from_spritesheetreaders:@[
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_OLDMAN] file:@"Oldman.json"]
	] scml:@"Oldman.scml"];
	_img = [SpriterNode nodeFromData:data render_size:ccp(300,350)];
	[_img set_render_placement:ccp(0.5,0.5)];
	[_img p_play_anim:@"Sleeping" repeat:YES];
	[self addChild:_img];
	
	[self setScale:0.5];
	
	return self;
}

-(SPLabelStyle*)get_dialog_default_style {
	SPLabelStyle *rtv = [super get_dialog_default_style];
	[rtv set_fill:ccc4f(0.74, 0.7, 0.7, 1) stroke:ccc4f(0.24, 0.2, 0.2, 1) shadow:ccc4f(0, 0, 0, 1)];
	rtv._amplitude = 7;
	rtv._time_incr = 0.75;
	return rtv;
}

-(SPLabelStyle*)get_dialog_emph_style {
	SPLabelStyle *rtv = [super get_dialog_emph_style];
	[rtv set_fill:ccc4f(0.94, 0.9, 0.9, 1) stroke:ccc4f(0.64, 0.6, 0.6, 1) shadow:ccc4f(0, 0, 0, 1)];
	rtv._amplitude = 7;
	rtv._time_incr = 0.75;
	return rtv;
}

-(NSArray*)get_dialog_list:(GameEngineScene *)g {
	return @[
		[DialogEvent cons_text:@"Zzzz..." speaker:self],
		[DialogEvent cons_text:@"I guess I'll let him sleep\n...[emph]for now.@" speaker:g.player.get_player_dialogue_character],
		[DialogEvent cons_text:@"Zzz...[emph]Heeheehee@...Zzz..." speaker:self]
	];
}

-(NSString*)get_dialog_title {
	return @"Old Man";
}

-(TexRect*)get_head_icon {
	TexRect *rtv = [super get_head_icon];
	[rtv setTex:[Resource get_tex:TEX_UI_DIALOGUE_HEADICONS]];
	[rtv setRect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_HEADICONS idname:@"head_oldman.png"]];
	return rtv;
}

-(CGPoint)get_dialog_icon_offset { return ccp(0,50); }

-(HitRect)get_hit_rect:(GameEngineScene *)g {
	return hitrect_cons_xy_widhei(self.position.x-20, self.position.y, 40, 40);
}

@end
