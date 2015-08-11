//
//  SPStrokeNumberLabel.h
//  hanokam
//
//  Created by spotco on 16/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface SPLabelStyle : NSObject
@property(readwrite,assign) GLKVector4 _stroke, _fill, _shadow;
@property(readwrite,assign) float _amplitude, _time_incr;
+(SPLabelStyle*)cons;
-(SPLabelStyle*)set_fill:(ccColor4F)fillcolor stroke:(ccColor4F)strokecolor shadow:(ccColor4F)shadowcolor;
@end

@interface SPLabel : CCNode

+(SPLabel*)cons_texkey:(NSString*)texkey;
-(SPLabel*)set_default_fill:(ccColor4F)fillcolor stroke:(ccColor4F)strokecolor shadow:(ccColor4F)shadowcolor;
-(void)set_default_style:(SPLabelStyle*)style;
-(void)add_style:(SPLabelStyle*)style name:(NSString*)name;
-(SPLabel*)set_string:(NSString*)markup_string;

-(void)animate_text_in_speed:(float)speed;
-(void)animate_text_in_force_finish;
-(BOOL)animate_text_in_is_finished;

@end

