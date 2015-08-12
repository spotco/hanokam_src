#import "BGCharacterVillagerFishGirl.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Common.h"

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
	_img = [SpriterNode nodeFromData:data render_size:ccp(300,300)];
	[_img set_render_placement:ccp(0.5,0.5)];
	[_img p_play_anim:@"Idle Talk" repeat:YES];
	[self addChild:_img];
	
	[self setScale:0.5];
	
	return self;
}

-(CGPoint)get_dialog_icon_offset { return ccp(-30,50); }

-(HitRect)get_hit_rect:(GameEngineScene *)g {
	return hitrect_cons_xy_widhei(self.position.x-15, self.position.y, 30, 40);
}
@end