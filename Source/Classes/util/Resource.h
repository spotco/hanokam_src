#import "cocos2d.h"

@interface Resource : NSObject

+(void)load_all;
+(CCTexture*)get_tex:(NSString*)key;

#define TEX_BLANK @"blank"

#define TEX_BG_SPRITESHEET_1 @"bg_spritesheet_1"
#define TEX_BG_UNDERWATER_SPRITESHEET @"underwater_spritesheet"
#define TEX_BG_SKY_SPRITESHEET @"sky_spritesheet"
#define TEX_BG_WATER_ELEMENT_FADE @"bg_water_element_fade"

#define TEX_BG_WATER_TOP_BELOWLINE @"bg_water_top_belowline"
#define TEX_BG_WATER_TOP_WATERLINE @"bg_water_top_waterline"
#define TEX_BG_WATER_TOP_WATERLINEGRAD @"bg_water_top_waterlinegrad"
#define TEX_BG_WATER_BOTTOM_SURFACEGRAD @"bg_water_bottom_surfacegrad"

#define TEX_TEST_BG_TILE_SKY @"bg_test_tile_sky"
#define TEX_TEST_BG_TILE_WATER @"bg_test_tile_water"
#define TEX_TEST_BG_UNDERWATER_SURFACE_GRADIENT @"bg_underwater_surface_gradient"

//#define TEX_SPRITER_CHAR_HANOKA_V2 @"hanokav2"

#define TEX_SPRITER_CHAR_OLDMAN @"Oldman"
#define TEX_SPRITER_CHAR_VILLAGER_FISHWOMAN @"villager_fishwoman"
#define TEX_SPRITER_CHAR_FISHGIRL @"Fishgirl"

#define TEX_SPRITER_CHAR_HANOKA_PLAYER @"hanoka_player"
#define TEX_SPRITER_CHAR_HANOKA_PLAYER_REDGARB @"hanoka_player_redgarb"
#define TEX_SPRITER_CHAR_HANOKA_SWORD @"hanoka_sword"
#define TEX_SPRITER_CHAR_HANOKA_BOW @"hanoka_bow"

#define TEX_ENEMY_PUFFER @"puffer_enemy_ss"
#define TEX_SPRITER_TEST @"spriter_test"

#define TEX_PARTICLES_SPRITESHEET @"particles_spritesheet"

#define TEX_EFFECTS_ENEMY @"effects_enemy_ss"
#define TEX_EFFECTS_HANOKA @"effects_hanoka_ss"

#define TEX_DIALOGUE_FONT @"1hoonwhayang"

#define TEX_UI_DIALOGUE_SPRITESHEET @"dialog_ui_ss"
#define TEX_UI_DIALOGUE_HEADICONS @"headicons_ss"

#define TEX_RIPPLE @"ripple"
#define TEX_HUD_SPRITESHEET @"hud_spritesheet"
#define TEX_GAMEPLAY_ELEMENTS @"gameplay_elements_ss"

@end
