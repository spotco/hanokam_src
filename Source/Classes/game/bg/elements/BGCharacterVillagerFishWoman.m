#import "BGCharacterVillagerFishWoman.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Common.h"

#import "SpriterNode.h"
#import "SpriterJSONParser.h"
#import "SpriterData.h"

@implementation BGCharacterVillagerFishWoman {
	SpriterNode *_img;
	NSString *_current_playing;
	NSString *_on_finish_play_anim;
}

+(BGCharacterVillagerFishWoman*)cons_pos:(CGPoint)pos {
	return [[BGCharacterVillagerFishWoman node] cons_pos:pos];
}

-(BGCharacterVillagerFishWoman*)cons_pos:(CGPoint)pos {
	[self setPosition:pos];
	
	
	SpriterData *data = [SpriterData cons_data_from_spritesheetreaders:@[
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_FISHGIRL] file:@"Fishgirl.json"]
	] scml:@"Fishgirl.scml"];
	_img = [SpriterNode nodeFromData:data render_size:ccp(150,300)];
	[_img playAnim:@"Idle" repeat:YES];
	[_img set_render_placement:ccp(0.5,0.1)];
	
	[self setScale:0.8];
	
	[self addChild:_img];
	
	return self;
}

-(CGPoint)dialogueOffset { return ccp(-50,50); }

-(NSString*)dialogueText { return @"ayyy lmao"; }

-(void)play_anim:(NSString*)anim repeat:(BOOL)repeat {
	_on_finish_play_anim = NULL;
	if(_current_playing != anim) {
		_current_playing = anim;
		[_img playAnim:anim repeat:repeat];
	}
}
@end
