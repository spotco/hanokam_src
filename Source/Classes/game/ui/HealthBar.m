#import "HealthBar.h"
#import "Resource.h"
#import "FileCache.h" 
#import "Common.h"
#import "ObjectPool.h"

@implementation HealthBar {
	CCSprite *_hpbar_back;
	CCSprite *_hpbar_fill;
	CGSize _size;
	float _alpha_back;
	float _alpha_fill;
}
+(HealthBar*)cons_pooled_size:(CGSize)size anchor:(CGPoint)anchor {
	return [[ObjectPool depool:[HealthBar class]] cons_size:size anchor:anchor];
}
+(HealthBar*)cons_size:(CGSize)size anchor:(CGPoint)anchor {
	return [[HealthBar node] cons_size:size anchor:anchor];
}
-(HealthBar*)cons_size:(CGSize)size anchor:(CGPoint)anchor {
	_size = size;
	
	if (_hpbar_back == NULL) {
		_hpbar_back = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BLANK]];
		[self addChild:_hpbar_back];
		_hpbar_fill = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BLANK]];
		[_hpbar_back addChild:_hpbar_fill];
	}
	
	[self set_alpha_back:0.25 fill:0.5];
	
	[_hpbar_back setTextureRect:CGRectMake(0, 0, size.width, size.height)];
	[_hpbar_back setColor:[CCColor colorWithCcColor4f:ccc4f(0.0, 0.0, 0.0, 1.0)]];
	[_hpbar_back setAnchorPoint:anchor];
	
	[_hpbar_fill setColor:[CCColor colorWithCcColor4f:ccc4f(1.0, 0.0, 0.0, 1.0)]];
	[_hpbar_fill setAnchorPoint:CGPointZero];
	
	[self set_pct:1.0];
	return self;
}

-(void)set_color_back:(ccColor4F)back fill:(ccColor4F)fill {
	[_hpbar_back setColor4f:back];
	[_hpbar_fill setColor4f:fill];
	[self setOpacity:self.opacity];
}
-(void)set_alpha_back:(float)back fill:(float)fill {
	_alpha_back = back;
	_alpha_fill = fill;
	[self setOpacity:self.opacity];
}
-(void)setOpacity:(CGFloat)opacity {
	[_hpbar_back setOpacity:_alpha_back*opacity];
	[_hpbar_fill setOpacity:_alpha_fill*opacity];
	[super setOpacity:opacity];
}

-(void)set_pct:(float)pct {
	[_hpbar_fill setTextureRect:CGRectMake(0, 0, _size.width*pct, _size.height)];
}
-(void)repool {
	[ObjectPool repool:self class:[HealthBar class]];
}
@end
