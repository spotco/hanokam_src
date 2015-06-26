//
//  EnemyBulletProjectile.h
//  hanokam
//
//  Created by spotco on 25/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EnemyProjectile.h"

@interface EnemyBulletProjectile : EnemyProjectile

+(EnemyBulletProjectile*)cons_pos:(CGPoint)pos vel:(Vec3D)vel g:(GameEngineScene*)g;

@end
