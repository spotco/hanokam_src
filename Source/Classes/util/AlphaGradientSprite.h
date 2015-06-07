#import "CCNode.h"
#import "Common.h"

@interface AlphaGradientSprite : CCSprite
+(AlphaGradientSprite*)cons_tex:(CCTexture*)tex texrect:(CGRect)texrect size:(CGSize)size anchorPoint:(CGPoint)anchorpt color:(CCColor*)color alphaX:(CGRange)alphaX alphaY:(CGRange)alphaY;
-(void)set_height:(float)val;
@end