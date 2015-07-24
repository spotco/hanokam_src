#import "PlayerUIHealthIndicator.h"

#import "cocos2d.h" 

#import "Resource.h"
#import "FileCache.h" 
#import "GameEngineScene.h" 
#import "Player.h"

@interface UIHealthHeart : CCSprite
@property(readwrite,strong) CCSprite *_h0, *_h1, *_h2, *_h3;
@end
@implementation UIHealthHeart
@synthesize _h0, _h1, _h2, _h3;
@end

@implementation PlayerUIHealthIndicator {
	NSMutableArray *_fill_spr;
	float _anim_theta;
	float _pulse_add_scale;
	CCNode *_background;
}

+(PlayerUIHealthIndicator*)cons:(GameEngineScene*)g {
	return [[PlayerUIHealthIndicator node] cons:g];
}

-(PlayerUIHealthIndicator*)cons:(GameEngineScene*)g {
	_fill_spr = [NSMutableArray array];
	[self setScale:0.75];
	_pulse_add_scale = 0;
	
	_background = [[[CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET]
	rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI-Heart-Container.png"]]
	set_anchor_pt:ccp(0,1)] set_scale:0.6];
	[self addChild:_background];
	
	[self make_image:g];
	[self update_health:g];
	
	return self;
}

void calc_r_i_pos(CGRect r_full, CGRect *r_i) {
	r_i[0] = CGRectMake(r_full.origin.x, r_full.origin.y, r_full.size.width*0.5, r_full.size.height*0.5);
	r_i[1] = CGRectMake(r_full.origin.x, r_full.origin.y + r_full.size.height*0.5, r_full.size.width*0.5, r_full.size.height*0.5);
	r_i[2] = CGRectMake(r_full.origin.x + r_full.size.width*0.5, r_full.origin.y + r_full.size.height*0.5, r_full.size.width*0.5, r_full.size.height*0.5);
	r_i[3] = CGRectMake(r_full.origin.x + r_full.size.width*0.5, r_full.origin.y, r_full.size.width*0.5, r_full.size.height*0.5);
}

-(float)imgscale {
	return 0.15;
}

-(void)make_image:(GameEngineScene*)g {
	for (UIHealthHeart *itr in _fill_spr) [self removeChild:itr];
	[_fill_spr removeAllObjects];
	
	CGRect img_rect = [FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI-Heart-BG.png"];
	
	CGRect r_full = [FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI-Heart.png"];
	CGRect r_i[4];
	calc_r_i_pos(r_full, r_i);
	
	float imgscale = [self imgscale];
	float offset_factor = (img_rect.size.width+2) * imgscale - 4;
	CGPoint fill_offset = ccp(20,20);
	CGPoint positioning_offset = ccp(15,-12);
	
	for (int i = 0; i < g.player.shared_params.get_max_health; i++) {
		if (i!=0 && i%8 == 0) {
			positioning_offset = CGPointAdd(positioning_offset, ccp(4,-12));
		}
	
		UIHealthHeart *itr_backfill_spr = [UIHealthHeart spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:img_rect];
		[itr_backfill_spr setPosition:CGPointAdd(positioning_offset,ccp((i%8)*offset_factor,0))];
		[self addChild:itr_backfill_spr];
		[itr_backfill_spr setScale:imgscale];
		[_fill_spr addObject:itr_backfill_spr];
		
		itr_backfill_spr._h0 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:r_i[0]];
		itr_backfill_spr._h0.anchorPoint = ccp(0,0);
		[itr_backfill_spr._h0 setPosition:CGPointAdd(fill_offset,ccp(0,r_full.size.height*0.5))];
		[itr_backfill_spr addChild:itr_backfill_spr._h0];
		
		itr_backfill_spr._h1 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:r_i[1]];
		itr_backfill_spr._h1.anchorPoint = ccp(0,0);
		[itr_backfill_spr._h1 setPosition:fill_offset];
		[itr_backfill_spr addChild:itr_backfill_spr._h1];
		
		itr_backfill_spr._h2 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:r_i[2]];
		itr_backfill_spr._h2.anchorPoint = ccp(0,0);
		[itr_backfill_spr._h2 setPosition:CGPointAdd(fill_offset,ccp(r_full.size.width*0.5,0))];
		[itr_backfill_spr addChild:itr_backfill_spr._h2];
		
		itr_backfill_spr._h3 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:r_i[3]];
		itr_backfill_spr._h3.anchorPoint = ccp(0,0);
		[itr_backfill_spr._h3 setPosition:CGPointAdd(fill_offset,ccp(r_full.size.width*0.5,r_full.size.height*0.5))];
		[itr_backfill_spr addChild:itr_backfill_spr._h3];
	}
}

-(UIHealthHeart*)update_health:(GameEngineScene*)g {
	CGRect r_full = [FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"UI-Heart.png"];
	CGRect r_i[4];
	calc_r_i_pos(r_full, r_i);
	
	float cur_health = g.player.shared_params.get_current_health;
	if (cur_health <= 0) {
		[_background setPosition:ccp(-9999,0)];
	} else if (cur_health < 8) {
		[_background setPosition:ccp(-((8-cur_health)*20),0)];
	} else {
		[_background setPosition:ccp(0,0)];
	}
	
	if (g.player.shared_params.get_current_health<=8) {
		[_background setScaleX:0.6];
		[_background setScaleY:0.4];
	} else {
		[_background setScale:0.6];
	}
	
	int i = 1;
	UIHealthHeart *rtv;
	for (;i<g.player.shared_params.get_current_health+1 && i<_fill_spr.count+1;i++) {
		UIHealthHeart *itr = _fill_spr[i-1];
		if (i <= floor(g.player.shared_params.get_current_health)) {
			itr._h0.textureRect = r_i[0];
			itr._h1.textureRect = r_i[1];
			itr._h2.textureRect = r_i[2];
			itr._h3.textureRect = r_i[3];
		} else {
			float pct = (g.player.shared_params.get_current_health - floor(g.player.shared_params.get_current_health));
			itr._h0.textureRect = pct > 0 ? r_i[0] : CGRectZero;
			itr._h1.textureRect = pct > 0.25 ? r_i[1] : CGRectZero;
			itr._h2.textureRect = pct > 0.5 ? r_i[2] : CGRectZero;
			itr._h3.textureRect = pct > 0.75 ? r_i[3] : CGRectZero;
		}
		rtv = itr;
		[itr setVisible:YES];
	}
	for (;i<g.player.shared_params.get_max_health+1 && i<_fill_spr.count+1;i++) {
		UIHealthHeart *itr = _fill_spr[i-1];
		itr._h0.textureRect = itr._h1.textureRect = itr._h2.textureRect = itr._h3.textureRect = CGRectZero;
		[itr setVisible:NO];
	}
	return rtv;
}

-(void)pulse_heart_lastfill {
	_pulse_add_scale = 1;
}

-(void)i_update:(GameEngineScene*)g {
	UIHealthHeart *last_filled = [self update_health:g];
	_anim_theta += 0.1 * dt_scale_get();
	_pulse_add_scale = MAX(0,_pulse_add_scale-0.05*dt_scale_get());
	for (UIHealthHeart *itr in _fill_spr) [itr setScale:[self imgscale]];
	[last_filled setScale:(1+0.2+0.2*sin(_anim_theta)+_pulse_add_scale)*[self imgscale]];
}

@end
