//
//  SwordSlashParticle.h
//  hanokam
//
//  Created by spotco on 07/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Particle.h"

@interface SwordSlashParticle : Particle

+(SwordSlashParticle*)cons_pos:(CGPoint)pos dir:(Vec3D)dir;
-(SwordSlashParticle*)show_blood;
@end
