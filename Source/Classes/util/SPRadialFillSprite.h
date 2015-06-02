//
//  SPRadialFillSprite.h
//  hanokam
//
//  Created by spotco on 01/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Common.h" 

@interface SPRadialFillSprite : CCSprite

+(SPRadialFillSprite*)cons_tex:(CCTexture*)texture rect:(CGRect)rect norm_start:(CGPoint)norm_start dir:(float)dir;
-(SPRadialFillSprite*)set_pct:(float)pct;
-(float)get_pct;
-(Vec3D)get_target_direction;
-(CGPoint)get_center;
-(void)set_start_dir:(CGPoint)norm_start;

@end
