#import "CCNode.h"

@interface HealthBar : CCNode
+(HealthBar*)cons_pooled_size:(CGSize)size anchor:(CGPoint)anchor;
-(void)set_pct:(float)pct;
-(void)repool;
@end
