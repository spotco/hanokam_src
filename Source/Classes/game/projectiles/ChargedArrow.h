//
//  ChargedArrow.h
//  hanokam
//
//  Created by spotco on 08/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerProjectile.h"

@interface ChargedArrow : PlayerProjectile
+(ChargedArrow*)cons_pos:(CGPoint)pos dir:(Vec3D)dir;
@end
