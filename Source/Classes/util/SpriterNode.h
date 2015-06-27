#import "CCNode.h"
@class SpriterData;
@interface SpriterNode : CCNode
+(SpriterNode*)nodeFromData:(SpriterData*)data render_size:(CGPoint)pt;
-(void)playAnim:(NSString*)anim repeat:(BOOL)repeat;
-(BOOL)current_anim_repeating;
-(BOOL)current_anim_finished;
-(void)set_render_placement:(CGPoint)placement;

-(void)p_play_anim:(NSString*)anim repeat:(BOOL)repeat;
-(void)p_play_anim:(NSString*)anim1 on_finish_anim:(NSString*)anim2;
@end
