#import <Foundation/Foundation.h>
@class CCShader;

#define SHADER_RIPPLE_FX @"ripple_effect"
#define SHADER_REFLECTION_AM_DOWN @"reflection_am_down"
#define SHADER_ABOVEWATER_AM_UP @"abovewater_am_up"
#define SHADER_CHARGE_CIRCLE @"charge_circle"
#define SHADER_ALPHA_GRADIENT @"alpha_gradient" 

@interface ShaderManager : NSObject
+(void)load_all;
+(CCShader*)get_shader:(NSString*)key;
@end
