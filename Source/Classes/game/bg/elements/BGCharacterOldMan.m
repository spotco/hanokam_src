#import "BGCharacterOldMan.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Common.h"

#import "SpriterNode.h"
#import "SpriterJSONParser.h"
#import "SpriterData.h"

@implementation BGCharacterOldMan {
	SpriterNode *_img;
	NSString *_current_playing;
	NSString *_on_finish_play_anim;
}

+(BGCharacterOldMan*)cons_pos:(CGPoint)pos {
	return [[BGCharacterOldMan node] cons_pos:pos];
}

-(BGCharacterOldMan*)cons_pos:(CGPoint)pos {
	[self setPosition:pos];
	
	[self setScaleX:self.scale*-1];
	
	SpriterData *data = [SpriterData cons_data_from_spritesheetreaders:@[
		[SpriterJSONParser cons_texture:[Resource get_tex:TEX_SPRITER_CHAR_OLDMAN] file:@"oldman_ss.json"]
	] scml:@"oldman.scml"];
	_img = [SpriterNode nodeFromData:data render_size:ccp(300,300)];
	[_img set_render_placement:ccp(0.5,0.1)];
	[_img playAnim:@"idle" repeat:YES];
	[self addChild:_img];
	
	/*
	_img = [SpriterNode nodeFromData:[FileCache spriter_scml_data_from_file:@"oldman.scml" json:@"oldman_ss.json" texture:[Resource get_tex:TEX_SPRITER_CHAR_OLDMAN]]];
	[self play_anim:@"idle" repeat:YES];
	[self addChild:_img];
    */
	return self;
}

-(CGPoint)dialogueOffset { return ccp(-30,50); }

-(void)play_anim:(NSString*)anim repeat:(BOOL)repeat {
	_on_finish_play_anim = NULL;
	if(_current_playing != anim) {
		_current_playing = anim;
		[_img playAnim:anim repeat:repeat];
	}
}

-(void)play_anim:(NSString*)anim1 on_finish_anim:(NSString*)anim2 {
	_current_playing = anim1;
	[_img playAnim:anim1 repeat:NO];
	_on_finish_play_anim = anim2;
}

@end
