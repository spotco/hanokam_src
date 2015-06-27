#import "CCNode.h"

@interface HealthBar : CCNode
+(HealthBar*)cons_pooled_size:(CGSize)size anchor:(CGPoint)anchor;
+(HealthBar*)cons_size:(CGSize)size anchor:(CGPoint)anchor;
-(void)set_pct:(float)pct;
-(void)set_color_back:(ccColor4F)back fill:(ccColor4F)fill;
-(void)set_alpha_back:(float)back fill:(float)fill;
-(void)repool;
@end
