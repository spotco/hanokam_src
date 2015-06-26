//
//  EnemyProjectile.m
//  hanokam
//
//  Created by spotco on 25/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EnemyProjectile.h"

@implementation EnemyProjectile
-(HitRect)get_hit_rect { return hitrect_cons_xy_widhei(self.position.x, self.position.y, 1, 1); }
-(void)get_sat_poly:(SATPoly *)in_poly { SAT_cons_quad_buf(in_poly, CGPointZero, CGPointZero, CGPointZero, CGPointZero); }
@end
