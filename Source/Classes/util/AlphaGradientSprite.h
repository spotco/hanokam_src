#import "CCNode.h"
#import "Common.h"

@interface AlphaGradientSprite : CCSprite
+(AlphaGradientSprite*)cons_tex:(CCTexture*)tex texrect:(CGRect)texrect size:(CGSize)size anchorPoint:(CGPoint)anchorpt alphaX:(CGRange)alphaX alphaY:(CGRange)alphaY;
@end