//
//  EnemyProjectile.h
//  hanokam
//
//  Created by spotco on 25/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Particle.h"
#import "Particle.h"
#import "Vec3D.h"
#import "PolyLib.h"

@class GameEngineScene;

@interface EnemyProjectile : Particle <SATPolyHitOwner>

-(HitRect)get_hit_rect;
-(void)get_sat_poly:(SATPoly *)in_poly;

@end
